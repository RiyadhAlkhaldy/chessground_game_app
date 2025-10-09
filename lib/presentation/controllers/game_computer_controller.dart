import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/presentation/controllers/game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../core/helper/helper_methodes.dart';
import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/entities/extended_evaluation.dart';
import '../../domain/models/chess_game.dart';
import '../../domain/models/player.dart';
import '../../domain/services/chess_clock_service.dart';
import '../../domain/services/chess_game_storage_service.dart';
import '../../domain/services/stockfish_engine_service.dart';
import 'abstract_game_controller.dart';
import 'chess_board_settings_controller.dart';
import 'get_storage_controller.dart';
import 'side_choosing_controller.dart';

part 'game_computer_with_time_controller.dart';

abstract class GameAiController extends AbstractGameController
    with WidgetsBindingObserver {
  final GetStorageControllerImp storage = Get.find<GetStorageControllerImp>();
  Rx<Player> whitePlayer = Player(uuid: '', name: '', type: '').obs;
  Rx<Player> blackPlayer = Player(uuid: '', name: '', type: '').obs;
  final PlaySoundUseCase plySound;
  final SideChoosingController choosingCtrl;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  final StockfishEngineService engineService;
  GameAiController(this.choosingCtrl, this.engineService, this.plySound);
  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.none;
  Side humanSide = Side.white;
  int thinkingTimeForAI = 2000; // default 2 seconds

  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  Future<void> onstartVsEngine() async {
    if (playerSide == PlayerSide.white) {
      await createPlayerIfNotExists(storage).then((value) {
        debugPrint("createPlayerIfNotExists");
        debugPrint(value.toString());
        whitePlayer.value = value!;
      });
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!);
    } else {
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => whitePlayer.value = value!);

      await createPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!);
    }
  }

  /// save game to isar
  ChessGame chessGame = ChessGame();

  final ChessGameStorageService _gameStorageService = ChessGameStorageService();

  //the header of the pgn
  final PgnHeaders _headers = PgnGame.defaultHeaders();

  ///
  void _storageStartNewGame() {
    _headers['Event'] = 'Casual Game';
    _headers['Site'] = 'FlutterApp';
    _headers['Date'] = DateTime.now().toIso8601String().split('T').first;
    _headers['Round'] = '1';
    _headers['Result'] = '*';
    _headers['EventDate'] = DateTime.now().toIso8601String().split('T').first;
    _headers['White'] = whitePlayer.value.name;
    _headers['Black'] = blackPlayer.value.name;
    _headers['ECO'] = 'C77';
    _headers['WhiteElo'] = whitePlayer.value.playerRating.toString();
    _headers['BlackElo'] = blackPlayer.value.playerRating.toString();
    _headers['PlyCount'] = pastMoves.length.toString();
    _headers['Termination'] = 'Normal';
    _headers['Opening'] = "Ruy Lopez, Closed, Breyer Defense";
    _headers['Variant'] = "Standard";
    _headers['Annotator'] = "ChessGround Game App";
    _headers['Source'] = "ChessGround Game App";
    _headers['SourceDate'] = DateTime.now().toIso8601String();
    _gameStorageService.startNewGame(
      chessGame: chessGame,
      startFEN: fen,
      white: whitePlayer.value,
      black: blackPlayer.value,
      headers: _headers,
    );
  }

  /// حفظ اللعبة الحالية في Isar
  Future<void> saveCurrentGame() async {
    _headers['Result'] = getResult.name;
    _headers['EventDate'] = DateTime.now().toIso8601String().split('T').first;
    _headers['WhiteElo'] = whitePlayer.value.playerRating.toString();
    _headers['BlackElo'] = blackPlayer.value.playerRating.toString();
    _headers['PlyCount'] = pastMoves.length.toString();
    _headers['Termination'] = gameTermination.name;

    final root = PgnNode<PgnNodeData>();
    for (final move in pastMoves) {
      root.children.add(PgnChildNode<PgnNodeData>(PgnNodeData(san: move.san!)));
    }
    final pgnGame = PgnGame<PgnNodeData>(
      headers: _headers,
      moves: root,
      comments: [],
    );
    final pgnText = pgnGame.makePgn();

    chessGame =
        chessGame
          ..fullPgn = pgnText
          ..movesCount = pastMoves.length
          ..event = _headers['Event']
          ..site = _headers['Site']
          ..date = DateTime.now()
          ..round = _headers['Round']
          ..result = _headers['Result']
          ..whitePlayer.value = whitePlayer.value
          ..blackPlayer.value = blackPlayer.value
          ..moves;

    await _gameStorageService.saveGame(
      chessGame,
      whitePlayer.value,
      blackPlayer.value,
    );
  }

  ///
  // // النسخة المعدلة من getResult
  GameResult get getResult {
    if (position.value.isCheckmate) return GameResult.checkmate;
    if (position.value.isStalemate) return GameResult.stalemate;
    if (position.value.isInsufficientMaterial || position.value.isVariantEnd
    // || position.value.isFiftyMoveRule ||     // <-- إضافة جديدة
    // position.value.isThreefoldRepetition
    ) {
      // <-- إضافة جديدة
      return GameResult.draw;
    }
    return GameResult.ongoing;
  }

  @override
  void undoMove() {
    super.undoMove();
    engineService.setPosition(fen: fen);
  }

  @override
  void redoMove() {
    super.redoMove();
    engineService.setPosition(fen: fen);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    engineService.stopStockfish();

    super.dispose();
  }

  @override
  void onClose() {
    engineService.stopStockfish();
    super.onClose();
  }

  GameTermination get gameTermination {
    // إذا كانت الـ Position (من dartchess) تعطي هذه القيم — نستخدمها مباشرة
    final pos = position.value;

    if (pos.isCheckmate) return GameTermination.checkmate;
    if (pos.isStalemate) return GameTermination.stalemate;

    // insufficient material و variant end
    if (pos.isInsufficientMaterial) {
      return GameTermination.insufficientMaterial;
    }

    // fifty-move rule (إذا دعمتها المكتبة)
    // في dartchess عادة يوجد عداد halfmoveClock ضمن FEN أو property مثل pos.halfMoveClock
    // try {
    //   // إذا كانت مكتبة dartchess توفر isFiftyMoveRule أو halfmove clock:
    //   if (pos.halfmoveClock != null && pos.halfmoveClock >= 100) {
    //     // 100 half-moves == 50 full moves
    // return GameTermination.halfmoveClock;
    //   }
    // } catch (_) {}

    // threefold repetition: بعض إصدارات المكتبة توفر isThreefoldRepetition/outcome
    // if (pos.isThreefoldRepetition) return GameResult.threefoldRepetition;

    // حالة انتهاء الوقت تتمّ عبر ChessClockService وليس عبر Position

    return GameTermination.agreement;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      engineService.stopStockfish();
    }
  }

  void _startStockfishIfNecessary() {
    engineService.startStockfishIfNecessary
        ? engineService.start().then((_) {
          stockfishState.value = StockfishState.ready;
          update();
        })
        : null;
  }

  ///reset
  void reset() {
    past.clear();
    future.clear();
    pastMoves.clear();
    futureMoves.clear();
    position.value = Chess.initial;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    engineService.ucinewgame();
    promotionMove = null;
    debugPrint('reset to $fen');
  }

  void tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        onUserMoveAgainstAI(premove!, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    debugPrint("onSetPremove $move");
    premove = move;
    update();
  }

  void onPromotionSelection(Role? role) {
    debugPrint('onPromotionSelection: $role');
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove != null) {
      debugPrint('promotionMove != null');
      onUserMoveAgainstAI(promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove = null;
    update();
  }

  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    if (isPromotionPawnMove(move)) {
      promotionMove = move;
      update();
    } else if (position.value.isLegal(move)) {
      _applyMove(move);
      validMoves = IMap(const {});
      promotionMove = null;
      update();
      await playAiMove();
    }
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) {
    debugPrint("fen: $fen");
    debugPrint("move.uci: ${move.uci}");
    // 2. أضف الوضع الجديد إلى سجل التاريخ
    past.add(position.value);
    // 3. امسح سجل الـ Redo لأننا بدأنا مسارًا جديدًا للحركات
    future.clear();
    // 1. قم بتطبيق النقلة على الوضع الحالي
    final res = position.value.makeSan(move);
    position.value = res.$1;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    engineService.setPosition(fen: position.value.fen);
    pastMoves.add(
      MoveData()
        ..san = res.$2
        ..fenAfter = res.$1.fen
        ..lan = move.uci,
    );
    debugPrint(
      'SAN Move: ${res.$2} ${pastMoves[pastMoves.length - 1].fenAfter} ${pastMoves[pastMoves.length - 1].lan}',
    );
    // plySound.executeMoveSound();
  }

  void _makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    var bestMove = NormalMove.fromUci(best);
    if (position.value.isLegal(bestMove) == false) return;

    if (position.value.isLegal(bestMove)) {
      _applyMove(bestMove);
      update();
      tryPlayPremove();
    }
    updateTextState();
  }

  Future<void> playAiMove() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (position.value.isGameOver) return;

    final allMoves = [
      for (final entry in position.value.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];

    if (allMoves.isNotEmpty) {
      engineService.goMovetime(thinkingTimeForAI);
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

  void _setPlayerSide() {
    if (choosingCtrl.playerColor.value == SideChoosing.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
    } else if (choosingCtrl.playerColor.value == SideChoosing.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
    }
  }
}

class GameComputerController extends GameAiController {
  ///constructer
  GameComputerController(
    super.choosingCtrl,
    super.engineService,
    super.plySound,
  );

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // debugPrint(position.value.fen);
    // debugPrint(fen);
    _setPlayerSide();
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    // storage new game
    _storageStartNewGame();
    engineService.start().then((_) {
      _applyStockfishSettings();
      engineService.setPosition(fen: fen);
      stockfishState.value = StockfishState.ready;
      // if the player is black, let the AI play the first move
      playerSide == PlayerSide.black ? playAiMove() : null;
    });
    //
    engineService.evaluations.listen((ev) {
      // debugPrint(ev.toString());
      // if (ev != null) {
      // evaluation.value = ev;
      // score.value = evaluation.value!.whiteWinPercent();
      // }
    });
    engineService.bestmoves.listen((event) {
      debugPrint('bestmoves: $event');
      _makeMoveAi(event);
    });
    ever(position, (_) {
      if (position.value.isGameOver) {
        _gameStorageService.endGame(
          chessGame,
          result: position.value.turn == Side.white ? '1-0' : '0-1',
          movesData: pastMoves,
          headers: _headers,
        );
      }
    });
  }

  // Method to apply the settings from SideChoosingController
  void _applyStockfishSettings() {
    final skillLevel = choosingCtrl.skillLevel.value;
    final depth = choosingCtrl.depth.value;
    final uciLimitStrength = choosingCtrl.uciLimitStrength.value;
    final uciElo = choosingCtrl.uciElo.value;
    thinkingTimeForAI = choosingCtrl.thinkingTimeForAI.value;

    // Apply UCI_Elo if UCI_LimitStrength is enabled
    if (uciLimitStrength) {
      // Apply UCI_LimitStrength option
      engineService.setOption('UCI_LimitStrength', uciLimitStrength);
      engineService.setOption('UCI_Elo', uciElo);
      // Optional: Set depth to a low value as it's not the primary control
      // when UCI_LimitStrength is true
      engineService.setOption(
        'Skill Level',
        20,
      ); // Setting a high skill level by default
    } else {
      // Use Skill Level and Depth if UCI_LimitStrength is disabled
      engineService.setOption('Skill Level', skillLevel);
      engineService.setOption('Depth', depth);
    }

    // Always apply Move Time
    engineService.setOption('Move Time', thinkingTimeForAI);

    // Now, let's log the settings to confirm they are applied
    _logAppliedSettings();
  }

  // Helper method to log the settings
  void _logAppliedSettings() {
    debugPrint('Stockfish Settings Applied:');
    debugPrint('  UCI_LimitStrength: ${choosingCtrl.uciLimitStrength.value}');
    if (choosingCtrl.uciLimitStrength.value) {
      debugPrint('  UCI_Elo: ${choosingCtrl.uciElo.value}');
    } else {
      debugPrint('  Skill Level: ${choosingCtrl.skillLevel.value}');
      debugPrint('  Depth: ${choosingCtrl.depth.value}');
    }
    debugPrint(
      'Thinking Time for AI (ms): ${choosingCtrl.thinkingTimeForAI.value}',
    );
  }
}
