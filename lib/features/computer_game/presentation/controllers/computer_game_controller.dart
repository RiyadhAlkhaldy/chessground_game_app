import 'dart:math';
import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComputerGameController extends BaseGameController
    with StorageFeatures, WidgetsBindingObserver {
  /// Player side (white or black)
  // final Rx<PlayerSide> playerSide = PlayerSide.white.obs;
  // PlayerSide get playerSide => playerSide;
  // set playerSide(PlayerSide value) => playerSide = value;

  /// Computer is thinking
  final RxBool _computerThinking = false.obs;
  bool get computerThinking => _computerThinking.value;

  // / Computer difficulty level (0-20)
  final RxInt _difficulty = 10.obs;
  int get difficulty => _difficulty.value;
  set difficulty(int value) => _difficulty.value = value;

  final UpdateGameUseCase updateGameUseCase;
  final GetGameByUuidUseCase getGameByUuidUseCase;
  final GetCachedGameStateUseCase getCachedGameStateUseCase;
  final SavePlayerUseCase savePlayerUseCase;
  final StockfishController stockfishController;
  ComputerGameController({
    required super.plySound,
    required this.updateGameUseCase,
    required this.getGameByUuidUseCase,
    required this.getCachedGameStateUseCase,
    required this.savePlayerUseCase,
    required this.stockfishController,
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
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final playerName = args['playerName'] as String;
      final playerSide = args['playerSide'] as PlayerSide;
      final difficulty = args['difficulty'] as int;

      // Start game automatically with provided arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startComputerGame(
          playerName: playerName,
          playerSide: playerSide,
          difficulty: difficulty,
        );
      });
    }
  }

  /// Start new game against computer
  /// بدء لعبة جديدة ضد الكمبيوتر
  Future<void> _startComputerGame({
    required String playerName,
    required PlayerSide playerSide,
    int difficulty = 10,
  }) async {
    try {
      this.playerSide = playerSide;
      _difficulty.value = difficulty;

      // Set computer skill level
      await stockfishController.setSkillLevel(difficulty);

      AppLogger.gameEvent(
        'StartComputerGame',
        data: {
          'playerName': playerName,
          'playerSide': playerSide.name,
          'difficulty': difficulty,
        },
      );

      // Start game with player and computer
      await startNewGame(
        whitePlayerName: playerSide == PlayerSide.white
            ? playerName
            : 'Stockfish',
        blackPlayerName: playerSide == PlayerSide.black
            ? playerName
            : 'Stockfish',
        event: 'Computer Game',
        site: 'Local',
      );

      // If computer plays white, make first move
      if (playerSide == PlayerSide.black) {
        await _makeComputerMove();
      }
      currentFen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);

      isLoading = false;
      debugPrint('Computer game started');
      debugPrint('setError($errorMessage)');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting computer game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ComputerGameController',
      );
    }
  }

  /// Override onUserMove to trigger computer response
  /// تجاوز onUserMove لتشغيل استجابة الكمبيوتر
  @override
  Future<void> onUserMove(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    // Execute player's move
    super.onUserMove(move, isDrop: isDrop, isPremove: isPremove);

    // Check if game is over
    if (isGameOver) return;

    // Check if it's computer's turn
    if (currentTurn.name != playerSide.name) {
      await _makeComputerMove();
    }
  }

  /// Make computer move
  /// تنفيذ حركة الكمبيوتر
  Future<void> _makeComputerMove() async {
    try {
      if (isGameOver) return;

      _computerThinking.value = true;

      AppLogger.info('Computer is thinking...', tag: 'ComputerGameController');

      // Add small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      final randomTime = Random().nextInt(3000) + 2000; // 2000ms to 5000ms
      await stockfishController.getBestMoveWithTimeAndDepth(
        currentFen,
        depth: _getDepthForDifficulty(difficulty),
        timeMilliseconds: randomTime,
      );
      final bestMoveResult = stockfishController.bestMove;
      if (bestMoveResult == null) {
        AppLogger.error(
          'Computer failed to find move',
          tag: 'ComputerGameController',
        );
        _computerThinking.value = false;
        return;
      }

      // Parse and execute move
      final moveUci = bestMoveResult.uci;
      final move = Move.parse(moveUci);

      if (move is NormalMove) {
        AppLogger.info(
          'Computer plays: $moveUci',
          tag: 'ComputerGameController',
        );

        // Execute move without triggering another computer move
        super.onUserMove(move);

        // Play sound
        // TODO: Add sound feedback
      }

      _computerThinking.value = false;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error making computer move',
        error: e,
        stackTrace: stackTrace,
        tag: 'ComputerGameController',
      );
      _computerThinking.value = false;
    }
  }

  /// Get analysis depth based on difficulty
  /// الحصول على عمق التحليل بناءً على الصعوبة
  int _getDepthForDifficulty(int difficulty) {
    // Easy: 5-8, Medium: 10-15, Hard: 18-22
    if (difficulty < 7) return 8;
    if (difficulty < 14) return 15;
    return 20;
  }

  /// Override undo to also undo computer's move
  /// تجاوز التراجع للتراجع عن حركة الكمبيوتر أيضاً
  // @override
  // Future<void> undoMove() async {
  //   if (!canUndo) return;

  //   // Undo player's move
  //    super.undoMove();

  //   // If it's still computer's turn, undo computer's move too
  //   if (currentTurn != playerSide && canUndo) {
  //      super.undoMove();
  //   }
  // }
}
