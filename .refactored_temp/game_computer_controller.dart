import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/models/extended_evaluation.dart';
import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/stockfish_engine_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/init_chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/get_storage_controller.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/utils/dialog/game_result_dialog.dart';
import 'package:chessground_game_app/core/utils/dialog/game_status.dart';
import 'package:chessground_game_app/core/utils/dialog/status_l10n.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

class GameComputerController extends BaseGameController
    with WidgetsBindingObserver {
  // Computer-specific dependencies
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storage = Get.find<GetStorageControllerImp>();
  final SideChoosingController choosingCtrl;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  final StockfishEngineService engineService;
  
  // Computer-specific properties
  Side humanS Side = Side.white;
  int thinkingTimeForAI = 2000; // default 2 seconds

  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  // Constructor - call super with required parameters
  GameComputerController(
    this.choosingCtrl,
    this.engineService,
    PlaySoundUseCase plySound,
    InitChessGame initChessGame,
  ) : super(plySound: plySound, initChessGame: initChessGame);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegal

Moves(gameState.position);
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
      //if (ev != null) {
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
        state == AppLifecycle State.detached) {
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
      await createOrGetGustPlayer().then(
        (value) => whitePlayer.value = value,
      );
      await createOrGetGustPlayer(
        uuidKeyForAI,
      ).then((value) => blackPlayer.value = value);
    } else if (choosingCtrl.playerColor.value == SideChoosing.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      await createOrGetGustPlayer(
        uuidKeyForAI,
      ).then((value) => whitePlayer.value = value);

      await createOrGetGustPlayer().then(
        (value) => blackPlayer.value = value,
      );
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
    _headers['White'] = whitePlayer.value?.name ?? 'White';
    _headers['Black'] = blackPlayer.value?.name ?? 'Black';
    _headers['ECO'] = 'C77';
    _headers['WhiteElo'] = whitePlayer.value?.playerRating.toString() ?? '1500';
    _headers['BlackElo'] = blackPlayer.value?.playerRating.toString() ?? '1500';
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
      white: whitePlayer.value?.toCollection() ?? Player(),
      black: blackPlayer.value?.toCollection() ?? Player(),
      headers: _headers,
    );
  }

  /// حفظ اللعبة الحالية في Isar
  Future<void> saveCurrentGame() async {
    // _headers['Result'] = getResult.name;
    _headers['EventDate'] = DateTime.now().toIso8601String().split('T').first;
    _headers['WhiteElo'] = whitePlayer.value?.playerRating.toString() ?? '1500';
    _headers['BlackElo'] = blackPlayer.value?.playerRating.toString() ?? '1500';
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
      ..whitePlayer.value = whitePlayer.value?.toCollection() ?? Player()
      ..blackPlayer.value = blackPlayer.value?.toCollection() ?? Player()
      ..moves;

    await _gameStorageService.saveGame(
      chessGame,
      whitePlayer.value?.toCollection() ?? Player(),
      blackPlayer.value?.toCollection() ?? Player(),
    );
  }

  Future<void> playAiMove() async {
    await Future.delayed(const Duration(milliseconds: 100));
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
          movesData: gameState.getMoveTokens
              .map((e) => e.toCollection())
              .toList(),
          headers: _headers,
        );
      }
    });
  }

  /// User move against AI - calls inherited onUserMove
  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    if (isPromotionPawnMove(move)) {
      promotionMove.value = move;
      update();
    } else if (gameState.position.isLegal(move)) {
      // Use base class applyMove and then add Stockfish-specific logic
      applyMove(move);
      validMoves = ValidMoves(const {});
      promotionMove.value = null;
      
      // Update Stockfish position after move
      engineService.setPosition(fen: fen);
      
      update();

      await playAiMove();
      update();
    }
    tryPlayPremove();
  }

  void _makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    final bestMove = NormalMove.fromUci(best);
    if (gameState.position.isLegal(bestMove) == false) return;

    if (gameState.position.isLegal(bestMove)) {
      // Use base class applyMove and then add Stockfish-specific logic
      applyMove(bestMove);
      
      // Update Stockfish position after move
      engineService.setPosition(fen: fen);
      
      update();
      tryPlayPremove();
    }
  }

  @override
  void reset() {
    super.reset();
    debugPrint('reset to $fen');
    engineService.ucinewgame();
  }

  @override
  void undoMove() {
    if (canUndo.value) {
      super.undoMove();
      engineService.setPosition(fen: fen);
    }
  }

  @override
  void redoMove() {
    if (canRedo.value) {
      super.redoMove();
      engineService.setPosition(fen: fen);
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
