import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/data/models/extended_evaluation.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/get_storage_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/setup_game_vs_ai_mixin.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish/stockfish.dart';

class GameComputerController extends BaseGameController
    with StorageFeatures, SetupGameVsAiMixin, WidgetsBindingObserver {
  // Computer-specific dependencies
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storage = Get.find<GetStorageControllerImp>();
  final SideChoosingController choosingCtrl;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  final StockfishDataSource dataSource;

  // Computer-specific properties
  Side humanSide = Side.white;
  // int thinkingTimeForAI = 2000; // default 2 seconds

  final random = Random();
  RxDouble score = 0.0.obs;
  Rx<ExtendedEvaluation?> evaluation = null.obs;

  // Constructor - call super with required parameters
  GameComputerController({
    required this.choosingCtrl,
    required this.dataSource,
    required super.plySound,
    required SaveGameUseCase saveGameUseCase,
    required CacheGameStateUseCase cacheGameStateUseCase,
    required GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase,
  }) {
    this.saveGameUseCase = saveGameUseCase;
    this.cacheGameStateUseCase = cacheGameStateUseCase;
    this.getOrCreateGuestPlayerUseCase = getOrCreateGuestPlayerUseCase;
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    startNewGame(
      whitePlayerName: uuidKeyForUser,
      blackPlayerName: uuidKeyForAI,
    ).then((value) {
      currentFen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      listenToGameStatus();
      plySound.executeDongSound();
      AppLogger.info('GameController initialized', tag: 'GameController');

      // Set board orientation based on player's side choice
      if (choosingCtrl.playerColor.value == SideChoosing.black) {
        playerSide = PlayerSide.black;
        ctrlBoardSettings.orientation.value = Side.black;
      } else if (choosingCtrl.playerColor.value == SideChoosing.white) {
        playerSide = PlayerSide.white;
        ctrlBoardSettings.orientation.value = Side.white;
      } else {
        // Random was chosen, determine based on playerSide after it's set
        ctrlBoardSettings.orientation.value = playerSide == PlayerSide.black
            ? Side.black
            : Side.white;
      }

      dataSource.initialize().then((_) {
        applyStockfishSettings();
        // dataSource.setPosition(fen: currentFen); // Not needed with direct move calls
        stockfishState.value = StockfishState.ready;
        // if the player is black, let the AI play the first move
        playerSide == PlayerSide.black ? playAiMove() : null;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      dataSource.dispose();
    }
  }

  Future<void> _startStockfishIfNecessary() async {
    final isReady = await dataSource.isReady();
    if (!isReady) {
      await dataSource.initialize();
      stockfishState.value = StockfishState.ready;
      update();
    }
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
      final bestMove = await dataSource.getBestMoveWithTime(
        fen: currentFen,
        timeMilliseconds: thinkingTimeForAI,
      );
      makeMoveAi(bestMove);
    }
  }

  ///reset - override to add Stockfish reset
  @override
  void reset() {
    debugPrint('reset to $currentFen');
    dataSource.uciNewGame();
    super.reset();
  }

  @override
  void onUserMove(NormalMove move, {bool? isDrop, bool? isPremove}) async {
    super.onUserMove(move);
    await playAiMove();
    tryPlayPremove();
  }

  void makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    final bestMove = NormalMove.fromUci(best);
    if (gameState.position.isLegal(bestMove) == false) return;

    if (gameState.position.isLegal(bestMove)) {
      // Use base class applyMove
      applyMove(bestMove);

      // Update Stockfish position - not needed if using getBestMove with FEN
      // engineService.setPosition(fen: currentFen);

      update();
      tryPlayPremove();
    }
  }

  @override
  void undoMove() {
    if (canUndo.value) {
      super.undoMove();
      // engineService.setPosition(fen: currentFen);
    }
  }

  @override
  void redoMove() {
    if (canRedo.value) {
      super.redoMove();
      // engineService.setPosition(fen: currentFen);
    }
  }

  // Method to apply the settings from SideChoosingController
  void applyStockfishSettings() {
    final skillLevel = choosingCtrl.skillLevel.value;
    final uciLimitStrength = choosingCtrl.uciLimitStrength.value;
    final uciElo = choosingCtrl.uciElo.value;
    thinkingTimeForAI = choosingCtrl.thinkingTimeForAI.value;

    // Apply UCI_Elo if UCI_LimitStrength is enabled
    if (uciLimitStrength) {
      // Apply UCI_LimitStrength option
      dataSource.setOption('UCI_LimitStrength', uciLimitStrength);
      dataSource.setOption('UCI_Elo', uciElo);
      // Optional: Set depth to a low value as it's not the primary control
      // when UCI_LimitStrength is true
      dataSource.setOption(
        'Skill Level',
        20,
      ); // Setting a high skill level by default
    } else {
      // Use Skill Level and Depth if UCI_LimitStrength is disabled
      dataSource.setOption('Skill Level', skillLevel);
      // Depth is used in search, not as option usually, but maybe for some configs?
      // dataSource.setOption('Depth', depth);
      // NOTE: Stockfish doesn't usually have a 'Depth' option, it's a command parameter.
      // But keeping it if it was there (maybe for some variant?)
      // Actually standard Stockfish UCI options don't include Depth.
      // But I will keep it commented or passing if user insists.
      // 'go depth X' is how depth is used.
    }

    // Always apply Move Time - this is property on controller, used in playAiMove
    // engineService.setOption('Move Time', thinkingTimeForAI); // 'Move Time' is not a standard UCI option usually?
    // 'Move Overhead'? No.
    // I will rely on passing thinkingTimeForAI to getBestMoveWithTime.

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
    dataSource.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    dataSource.dispose();
    super.onClose();
  }
}
