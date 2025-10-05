import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/presentation/controllers/game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/entities/extended_evaluation.dart';
import '../../domain/models/chess_game.dart';
import '../../domain/models/game.dart';
import '../../domain/models/player.dart';
import '../../domain/services/chess_clock_service.dart';
import '../../domain/services/chess_game_storage_service.dart';
import '../../domain/services/stockfish_engine_service.dart';
import 'abstract_game_controller.dart';
import 'chess_board_settings_controller.dart';
import 'side_choosing_controller.dart';

part 'game_computer_with_time_controller.dart';

abstract class GameAiController extends AbstractGameController
    with WidgetsBindingObserver {
  final PlaySoundUseCase plySound;
  final SideChoosingController choosingCtrl;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

  GameAiController(this.choosingCtrl, this.plySound);
  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.none;
  Side humanSide = Side.white;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  // thinking flag
  // final RxBool isThinking = false.obs;
  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  Future<void> onstartVsEngine();

  /// save game to isar
  ChessGame chessGame = ChessGame();

  final ChessGameStorageService _gameStorageService = ChessGameStorageService();

  final List<MoveData> movesData = [];
  //the header of the pgn
  final PgnHeaders _headers = PgnGame.defaultHeaders();

  /// حفظ اللعبة الحالية في Isar
  Future<void> saveCurrentGame(Player white, Player black) async {
    _headers['Event'] = 'Casual Game';
    _headers['Site'] = 'FlutterApp';
    _headers['Date'] = DateTime.now().toIso8601String().split('T').first;
    _headers['Round'] = '1';
    _headers['Result'] = '*';
    _headers['EventDate'] = DateTime.now().toIso8601String().split('T').first;
    _headers['White'] = white.name;
    _headers['Black'] = black.name;
    _headers['ECO'] = 'C77';
    _headers['WhiteElo'] = white.playerRating.toString();
    _headers['BlackElo'] = black.playerRating.toString();
    _headers['PlyCount'] = movesData.length.toString();
    _headers['Termination'] = 'Normal';
    _headers['Opening'] = "Ruy Lopez, Closed, Breyer Defense";
    _headers['Variant'] = "Standard";
    _headers['Annotator'] = "ChessGround Game App";
    _headers['Source'] = "ChessGround Game App";
    _headers['SourceDate'] = DateTime.now().toIso8601String();

    final root = PgnNode<PgnNodeData>();
    for (final move in movesData) {
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
          ..movesCount = movesData.length
          ..event = _headers['Event']
          ..site = _headers['Site']
          ..date = DateTime.now()
          ..round = _headers['Round']
          ..result = _headers['Result']
          ..whitePlayer.value = white
          ..blackPlayer.value = black
          ..moves;

    await _gameStorageService.saveGame(chessGame, white, black);
  }

  ///
  // // النسخة المعدلة من getResult
  GameResult getResult() {
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

  // GameResult getResult() {
  //   // إذا كانت الـ Position (من dartchess) تعطي هذه القيم — نستخدمها مباشرة
  //   final pos = position.value;

  //   if (pos.isCheckmate) return GameResult.checkmate;
  //   if (pos.isStalemate) return GameResult.stalemate;

  //   // insufficient material و variant end
  //   if (pos.isInsufficientMaterial || pos.isVariantEnd) {
  //     return GameResult.draw;
  //   }

  //   // fifty-move rule (إذا دعمتها المكتبة)
  //   // في dartchess عادة يوجد عداد halfmoveClock ضمن FEN أو property مثل pos.halfMoveClock
  //   try {
  //     // إذا كانت مكتبة dartchess توفر isFiftyMoveRule أو halfmove clock:
  //     if (pos.halfmoveClock != null && pos.halfmoveClock >= 100) {
  //       // 100 half-moves == 50 full moves
  //       return GameResult.draw;
  //     }
  //   } catch (_) {}

  //   // threefold repetition: بعض إصدارات المكتبة توفر isThreefoldRepetition/outcome
  //   if (pos.isThreefoldRepetition) return GameResult.draw;

  //   // حالة انتهاء الوقت تتمّ عبر ChessClockService وليس عبر Position

  //   return GameResult.ongoing;
  // }

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
        ? update([
          engineService.start().then((_) {
            stockfishState.value = StockfishState.ready;
          }),
        ])
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
    update(promotionMove = null);
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
      debugPrint('onUserMoveAgainstAI $move');
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
    pastMoves.add(move.uci);
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
    movesData.add(
      MoveData()
        ..san = res.$2
        ..fenAfter = res.$1.fen
        ..lan = move.uci,
    );
    debugPrint(
      'SAN Move: ${res.$2} ${movesData[movesData.length - 1].fenAfter} ${movesData[movesData.length - 1].lan}',
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
    await Future.delayed(Duration(milliseconds: 200));
    if (position.value.isGameOver) return;

    final allMoves = [
      for (final entry in position.value.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];

    if (allMoves.isNotEmpty) {
      engineService.goMovetime(choosingCtrl.moveTime.toInt());
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
  // أضف هذه الدالة داخل GameComputerController

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

  // Method to apply the settings from SideChoosingController
  void _applyStockfishSettings() {
    final skillLevel = choosingCtrl.skillLevel.value;
    final depth = choosingCtrl.depth.value;
    final uciLimitStrength = choosingCtrl.uciLimitStrength.value;
    final uciElo = choosingCtrl.uciElo.value;
    final moveTime = choosingCtrl.moveTime.value;

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
    engineService.setOption('Move Time', moveTime);

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
    debugPrint('  Move Time: ${choosingCtrl.moveTime.value}');
  }
}

class GameComputerController extends GameAiController {
  ///constructer
  GameComputerController(super.choosingCtrl, super.plySound);

  @override
  Future<void> onstartVsEngine() async {}

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // debugPrint(position.value.fen);
    // debugPrint(fen);
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    engineService.start().then((_) {
      _applyStockfishSettings();
      engineService.setPosition(fen: fen);
      stockfishState.value = StockfishState.ready;
      _setPlayerSide();
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
    // ever(position, (_) {
    // });
  }
}

class PGNService {
  /// توليد PGN من GameModel
  static String generatePGN(GameModel game) {
    final buffer = StringBuffer();

    // 1. Header metadata
    buffer.writeln('[Event "Casual Game"]');
    buffer.writeln('[Site "MyChessApp"]');
    buffer.writeln(
      '[Date "${DateFormat("yyyy.MM.dd").format(game.startedAt)}"]',
    );
    buffer.writeln('[Round "-"]');
    buffer.writeln('[White "${game.whitePlayer.value?.name ?? "Unknown"}"]');
    buffer.writeln('[Black "${game.blackPlayer.value?.name ?? "Unknown"}"]');
    buffer.writeln('[Result "${_mapResult(game.result)}"]');
    buffer.writeln('');

    // 2. Moves
    for (int i = 0; i < game.moves.length; i++) {
      // اللاعب الأبيض
      if (i % 2 == 0) {
        buffer.write('${(i ~/ 2) + 1}. ${game.moves[i]} ');
      } else {
        // اللاعب الأسود
        buffer.write('${game.moves[i]} ');
      }
    }

    // 3. النتيجة النهائية
    buffer.write(_mapResult(game.result));

    return buffer.toString();
  }

  /// تحويل GameResult إلى صيغة PGN
  static String _mapResult(GameResult result) {
    switch (result) {
      case GameResult.whiteWon:
        return "1-0";
      case GameResult.blackWon:
        return "0-1";
      case GameResult.draw:
        return "1/2-1/2";
      case GameResult.ongoing:
      default:
        return "*";
    }
  }
}
