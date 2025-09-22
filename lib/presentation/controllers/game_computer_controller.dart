import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/domain/services/chess_clock_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/entities/extended_evaluation.dart';
import '../../domain/services/stockfish_engine_service.dart';
import 'abstract_game_controller.dart';
import 'chess_board_settings_controller.dart';
import 'side_choosing_controller.dart';

String pieceShiftMethodLabel(PieceShiftMethod method) {
  switch (method) {
    case PieceShiftMethod.drag:
      return 'Drag';
    case PieceShiftMethod.tapTwoSquares:
      return 'Tap two squares';
    case PieceShiftMethod.either:
      return 'Either';
  }
}

enum Mode { botPlay, freePlay }

abstract class GameAiController extends AbstractGameController
    with WidgetsBindingObserver {
  final PlaySoundUseCase plySound;
  final SideChoosingController choosingCtrl;
  ChessClockService? clockCtrl;

  final StockfishEngineService engineService;
  final List<String> _pastMoves = [];
  final List<String> _futureMoves = [];
  int skill = 10;
  int moveTimeMs = 1000;

  GameAiController(this.choosingCtrl, this.engineService, this.plySound);

  Rx<NormalMove?> promotionMove = null.obs;
  Rx<NormalMove>? premove;
  Mode playMode = Mode.botPlay;
  PlayerSide playerSide = PlayerSide.none;
  Side humanSide = Side.white;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  // thinking flag
  // final RxBool isThinking = false.obs;
  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  /// get Result
  GameResult getResult() {
    if (position.value.isCheckmate) return GameResult.checkmate;
    if (position.value.isStalemate) return GameResult.stalemate;
    if (position.value.isInsufficientMaterial || position.value.isVariantEnd) {
      return GameResult.draw;
    }
    return GameResult.ongoing;
  }

  @override
  void undoMove() {
    if (past.isEmpty) return;
    future.add(position.value);
    position.value = past.removeLast();
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    ///
    debugPrint('_pastMoves ${_pastMoves.length}');
    _futureMoves.add(_pastMoves.removeLast());
    debugPrint('_pastMoves ${_pastMoves.length}');

    update();
    engineService.setPosition(moves: _pastMoves);
  }

  @override
  void redoMove() {
    if (future.isEmpty) return;
    past.add(position.value);
    position.value = future.removeLast();
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    ///
    debugPrint('_pastMoves ${_pastMoves.length}');
    _pastMoves.add(_futureMoves.removeLast());
    debugPrint('_pastMoves ${_pastMoves.length}');

    update();
    engineService.setPosition(moves: _pastMoves);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    clockCtrl!.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      engineService.stopStockfish();
    }
  }

  void _startStockfishIfNecessary() {
    engineService.startStockfishIfNecessary
        ? update([
            engineService.start().then((_) {
              stockfishState.value = StockfishState.ready;
            }),
          ])
        : null;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    engineService.dispose();
    clockCtrl!.onClose();
    super.onClose();
  }

  ///reset
  void reset() {
    past.clear();
    future.clear();
    _pastMoves.clear();
    _futureMoves.clear();
    position.value = Chess.initial;
    lastMove = null;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    engineService.ucinewgame();
    promotionMove.value = null;
    clockCtrl!.reset();
    debugPrint('reset to $fen');
  }

  void tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        playMove(premove!.value, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    debugPrint("onSetPremove $move");
    premove?.value = move!;
    update([]);
  }

  void onPromotionSelection(Role? role) {
    debugPrint('onPromotionSelection: $role');
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove.value != null) {
      playMove(promotionMove.value!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove.value = null;
    update([]);
  }

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) async {
    if (isPromotionPawnMove(move)) {
      promotionMove.value = move;
      update();
    } else if (position.value.isLegal(move)) {
      _makeMove(move);
      if (isPremove == true) {
        premove = null;
      }
    }
    updateTextState();

    await playAiMove();
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _makeMove(NormalMove move) {
    _pastMoves.add(move.uci);
    // 2. أضف الوضع الجديد إلى سجل التاريخ
    past.add(position.value);
    // 3. امسح سجل الـ Redo لأننا بدأنا مسارًا جديدًا للحركات
    future.clear();
    // 1. قم بتطبيق النقلة على الوضع الحالي
    position.value = position.value.playUnchecked(move);
    clockCtrl!.switchTurn(position.value.turn);
    lastMove = move;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    engineService.setPosition(moves: _pastMoves);

    promotionMove.value = null;

    // plySound.executeMoveSound();
  }

  void _makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    var bestMove = NormalMove.fromUci(best);
    if (position.value.isLegal(bestMove) == false) return;

    if (isPromotionPawnMove(bestMove)) {
      // TODO solve the promotion pawn with stockfish
      final potentialRoles = Role.values
          .where((role) => role != Role.pawn)
          .toList();
      final role = potentialRoles[random.nextInt(potentialRoles.length)];
      bestMove = bestMove.withPromotion(role);
    } else if (position.value.isLegal(bestMove)) {
      _makeMove(bestMove);
      update();
      tryPlayPremove();
    }

    updateTextState();
  }

  Future<void> playAiMove() async {
    await Future.delayed(Duration(milliseconds: 200));
    if (position.value.isGameOver) return;

    final allMoves = [
      for (final entry in position.value.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];

    if (allMoves.isNotEmpty) {
      engineService.goMovetime(moveTimeMs);
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.value.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.value.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.value.turn == Side.white));
  }

  RxString statusText = "AI chess".obs;
  void updateTextState() {
    if (position.value.isCheckmate) {
      statusText.value = ' - كش موت!';
      switch (position.value.outcome) {
        case Outcome.blackWins:
          statusText.value += ' الفائز: لأسود';
          break;
        case Outcome.whiteWins:
          statusText.value += ' الفائز: لابيض';
          break;
        case Outcome.draw:
          statusText.value = ' - تعادل!';
          break;
      }
      return;
    } else if (position.value.isCheck) {
      statusText.value = '(كش)';
      return;
    } else if (position.value.isInsufficientMaterial) {
      statusText.value = "لا يمكن إنهاء اللعبة";
      return;
    } else if (position.value.isStalemate) {
      statusText.value = ' - طريق مسدود!';
      return;
    } else if (position.value.isGameOver) {
      statusText.value = ' - انتهت اللعبة';
      switch (position.value.outcome) {
        case Outcome.blackWins:
          statusText.value += ' الفائز: لأسود';
          break;
        case Outcome.whiteWins:
          statusText.value += ' الفائز: لابيض';
          break;
        case Outcome.draw:
          statusText.value += ' - تعادل!';
          break;
      }
      return;
    } else if (position.value.turn == Side.white) {
      statusText.value = "دور الأبيض";
      return;
    } else if (position.value.turn == Side.black) {
      statusText.value = "دور الأسود";
      return;
    } else if (position.value.isVariantEnd) {
      statusText.value = ' - انتهت اللعبة';
      return;
    }
  }
}

class GameComputerController extends GameAiController {
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

  GameComputerController(
    super.choosingCtrl,
    super.engineService,
    super.plySound,
  );

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    debugPrint(position.value.fen);
    debugPrint(fen);
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    skill = choosingCtrl.aiDepth.value;
    moveTimeMs = choosingCtrl.timeMs.toInt();
    clockCtrl = Get.put(
      ChessClockService(
        initialTimeMs: (0.5 * 60 * 1000).toInt(),
        incrementMs: 1000,
        onTimeout: (player) {
          print('time over the ${player.opposite.name} player is winner');
        },
      ),
    );
    clockCtrl!.start();
    engineService
        .start(
          skill: skill,
          uciLimitStrength: true,
          uciElo: choosingCtrl.uciElo.toInt(),
        )
        .then((_) {
          engineService.setPosition(fen: fen);
          stockfishState.value = StockfishState.ready;
          _setPlayerSide();
          // _handleAiTurn();
        });
    engineService.evaluations.listen((ev) {
      debugPrint(ev.toString());
      // if (ev != null) {
      // evaluation.value = ev;
      // score.value = evaluation.value!.whiteWinPercent();
      // }
    });
    engineService.bestmoves.listen((event) {
      debugPrint('bestmoves: $event');
      _makeMoveAi(event);
    });
    // ever(position, (_) {
    // });
  }

  void _setPlayerSide() {
    if (choosingCtrl.choseColor.value == SideChoosing.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
    } else if (choosingCtrl.choseColor.value == SideChoosing.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      playAiMove();
    }
  }
}
