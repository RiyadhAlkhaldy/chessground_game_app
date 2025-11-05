import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/data/collections/player.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../core/utils/dialog/game_result_dialog.dart';
import '../../core/utils/dialog/game_status.dart';
import '../../core/utils/helper/helper_methodes.dart';
import '../../core/utils/dialog/status_l10n.dart';
import '../../data/game_state/game_state.dart';
import '../../data/usecases/play_sound_usecase.dart';
import '../../data/collections/chess_game.dart';
import '../../data/collections/move_data.dart';
import '../../data/models/extended_evaluation.dart';
import '../../data/models/player_model.dart';
import '../../domain/services/chess_game_storage_service.dart';
import '../../domain/services/stockfish_engine_service.dart';
import 'chess_board_settings_controller.dart';
import 'get_storage_controller.dart';
import 'side_choosing_controller.dart';

class GameComputerController extends GetxController
    with WidgetsBindingObserver {
  GameState gameState = GameState();
  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));
  String get _initailLocalFen => Chess.initial.fen;
  // String get _initailLocalFen => "8/P7/8/k7/8/8/8/K7 w - - 0 1";
  late String _fen;

  // ignore: unnecessary_getters_setters
  String get fen => _fen;

  set fen(String value) => _fen = value;

  ValidMoves validMoves = IMap(const {});

  bool get isCheckmate => gameState.isCheckmate;

  Side? get winner {
    return gameState.result?.winner;
  }

  Rx<PlayerModel> whitePlayer = PlayerModel(
    id: 1,
    uuid: 'White_Player',
    name: 'White Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;
  Rx<PlayerModel> blackPlayer = PlayerModel(
    id: 2,
    uuid: 'Black Player',
    name: 'Black Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;
  final PlaySoundUseCase plySound;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storage = Get.find<GetStorageControllerImp>();
  final SideChoosingController choosingCtrl;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  final StockfishEngineService engineService;
  GameComputerController(this.choosingCtrl, this.engineService, this.plySound);
  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.both;
  Side humanSide = Side.white;
  int thinkingTimeForAI = 2000; // default 2 seconds

  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    plySound.executeDongSound();

    onstartVsEngine().then((_) {
      engineService.start().then((_) {
        _applyStockfishSettings();
        engineService.setPosition(fen: fen);
        stockfishState.value = StockfishState.ready;
        // if the player is black, let the AI play the first move
        playerSide == PlayerSide.black ? playAiMove() : null;
      });
    });
    //
    engineService.evaluations.listen((ev) {
      // if (ev != null) {
      // evaluation.value = ev;
      // score.value = evaluation.value!.whiteWinPercent();
      // }
    });
    engineService.bestmoves.listen((event) {
      debugPrint('bestmoves: $event');
      _makeMoveAi(event);
      update();
    });
    update();
    _listenToGameStatus();
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

  Future<void> onstartVsEngine() async {
    await _initPlayers();
    // storage new game
    await _storageStartNewGame();
  }

  Future<void> _initPlayers() async {
    if (choosingCtrl.playerColor.value == SideChoosing.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
      await createPlayerIfNotExists(
        storage,
      ).then((value) => whitePlayer.value = value!.toModel());
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!.toModel());
    } else if (choosingCtrl.playerColor.value == SideChoosing.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => whitePlayer.value = value!.toModel());

      await createPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!.toModel());
    }
  }

  /// save game to isar
  ChessGame chessGame = ChessGame();

  final ChessGameStorageService _gameStorageService = ChessGameStorageService();

  //the header of the pgn
  final PgnHeaders _headers = PgnGame.defaultHeaders();

  ///
  Future<void> _storageStartNewGame() async {
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
    _headers['PlyCount'] = gameState.allMoves.length.toString();
    _headers['Termination'] = 'Normal';
    _headers['Opening'] = "Ruy Lopez, Closed, Breyer Defense";
    _headers['Variant'] = "Standard";
    _headers['Annotator'] = "ChessGround Game App";
    _headers['Source'] = "ChessGround Game App";
    _headers['SourceDate'] = DateTime.now().toIso8601String();
    debugPrint(chessGame.toString());
    _gameStorageService.startNewGame(
      chessGame: chessGame,
      startFEN: fen,
      white: whitePlayer.value.toCollection(),
      black: blackPlayer.value.toCollection(),
      headers: _headers,
    );
  }

  /// حفظ اللعبة الحالية في Isar
  Future<void> saveCurrentGame() async {
    //TODO
    // _headers['Result'] = getResult.name;
    _headers['EventDate'] = DateTime.now().toIso8601String().split('T').first;
    _headers['WhiteElo'] = whitePlayer.value.playerRating.toString();
    _headers['BlackElo'] = blackPlayer.value.playerRating.toString();
    // _headers['PlyCount'] = pastMoves.length.toString();
    // _headers['Termination'] = gameTermination.name;

    final root = PgnNode<PgnNodeData>();
    for (final move in gameState.allMoves) {
      root.children.add(PgnChildNode<PgnNodeData>(PgnNodeData(san: move.san!)));
    }
    final pgnGame = PgnGame<PgnNodeData>(
      headers: _headers,
      moves: root,
      comments: [],
    );
    final pgnText = pgnGame.makePgn();

    chessGame = chessGame
      ..fullPgn = pgnText
      ..movesCount = gameState.allMoves.length
      ..event = _headers['Event']
      ..site = _headers['Site']
      ..date = DateTime.now()
      ..round = _headers['Round']
      ..result = _headers['Result']
      ..whitePlayer.value = whitePlayer.value.toCollection()
      ..blackPlayer.value = blackPlayer.value.toCollection()
      ..moves;

    await _gameStorageService.saveGame(
      chessGame,
      whitePlayer.value.toCollection(),
      blackPlayer.value.toCollection(),
    );
  }

  Future<void> playAiMove() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (gameState.isGameOver) return;

    final allMoves = [
      for (final entry in gameState.position.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];

    if (allMoves.isNotEmpty) {
      engineService.goMovetime(thinkingTimeForAI);
    }
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.result;
  }

  // GameTermination get gameTermination {
  //   // إذا كانت الـ Position (من dartchess) تعطي هذه القيم — نستخدمها مباشرة
  //   final pos = gameState.position;

  //   if (pos.isCheckmate) return GameTermination.checkmate;
  //   if (pos.isStalemate) return GameTermination.stalemate;

  //   // insufficient material و variant end
  //   if (pos.isInsufficientMaterial) {
  //     return GameTermination.insufficientMaterial;
  //   }

  //   return GameTermination.agreement;
  // }
  void _listenToGameStatus() {
    gameState.gameStatus.listen((status) {
      if (gameState.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (gameState.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (gameState.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: gameState.position, winner: gameState.result?.winner, isThreefoldRepetition: gameState.isThreefoldRepetition())} ";
        Get.dialog(
          GameResultDialog(
            gameState: gameState,
            gameStatus: status,
            reset: reset,
          ),
        );
        _gameStorageService.endGame(
          chessGame,
          result: winner == Side.white ? '1-0' : '0-1',
          movesData: gameState.getMoveTokens,
          headers: _headers,
        );
      }
    });
  }

  RxString statusText = "Play vs AI".obs;

  GameStatus get gameStatus => gameState.status();

  /// Agreement draw: set result to draw.
  void setAgreementDraw() {
    gameState.setAgreementDraw();
    update();
  }

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) {
    gameState.resign(side);
    plySound.executeResignSound();
    update();
  }

  ///reset
  void reset() {
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    promotionMove = null;
    debugPrint('reset to $fen');
    engineService.ucinewgame();
    plySound.executeDongSound();
    update();
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
    } else if (gameState.position.isLegal(move)) {
      _applyMove(move);
      validMoves = IMap(const {});
      promotionMove = null;
      update();

      await playAiMove();
      update();
    }
    tryPlayPremove();
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) {
    gameState.play(move);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    engineService.setPosition(fen: fen);
    // decide which sound to play based on metadata
    final meta = gameState.lastMoveMeta;
    if (meta != null) {
      // capture has priority (play capture instead of plain move)
      if (meta.wasCapture) {
        plySound.executeCaptureSound();
      } else {
        plySound.executeMoveSound();
      }
      if (meta.wasPromotion) {
        plySound.executePromoteSound();
      }
      if (meta.wasCheckmate) {
        plySound.executeCheckmateSound();
      } else if (meta.wasCheck) {
        plySound.executeCheckSound();
      }
    } else {
      // fallback
      plySound.executeMoveSound();
    }
    gameStatus;
  }

  void _makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    var bestMove = NormalMove.fromUci(best);
    if (gameState.position.isLegal(bestMove) == false) return;

    if (gameState.position.isLegal(bestMove)) {
      _applyMove(bestMove);
      update();
      tryPlayPremove();
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                gameState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                gameState.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true
  RxBool get canUndo =>
      (!gameState.isGameOverExtended && gameState.canUndo).obs;
  RxBool get canRedo =>
      (!gameState.isGameOverExtended && gameState.canRedo).obs;

  void undoMove() {
    if (canUndo.value) {
      gameState.undoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      // play a feedback sound (optional)
      plySound.executeMoveSound();
      engineService.setPosition(fen: fen);
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.redoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      plySound.executeMoveSound();
      engineService.setPosition(fen: fen);
      update();
    }
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

  /// expose PGN tokens for the UI
  List<MoveData> get pgnTokens => gameState.getMoveTokens;

  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  /// jump to a halfmove index (0-based). This will rebuild the game state up to that halfmove.
  /// Implementation: get a copy of move objects from gameState, construct a fresh GameState
  /// and replay moves up to `index` then replace controller.gameState with rebuilt one.
  void jumpToHalfmove(int index) {
    final allMoves = gameState.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState = newState;
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    update();
  }

  Map<Role, int> get whiteCaptured => gameState.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured => gameState.getCapturedPieces(Side.black);
  String get whiteCapturedText => gameState.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.black);

  ///
  ///

  // في controller أو widget بعد استدعاء setState/update
  List<Role> get whiteCapturedList =>
      gameState.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList =>
      gameState.getCapturedPiecesList(Side.black);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    engineService.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    engineService.dispose();
    super.onClose();
  }
}
