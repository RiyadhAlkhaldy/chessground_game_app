import 'dart:math';
import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for games against the computer (Stockfish AI)
/// كنترولر للعب ضد الكمبيوتر (ذكاء اصطناعي Stockfish)
class ComputerGameController extends BaseGameController
    with StorageFeatures, WidgetsBindingObserver {
  /// Computer is thinking
  final RxBool _computerThinking = false.obs;
  bool get computerThinking => _computerThinking.value;

  /// Computer difficulty level (0-20)
  final RxInt _difficulty = 10.obs;
  int get difficulty => _difficulty.value;
  set difficulty(int value) => _difficulty.value = value;

  /// Show move hints
  final RxBool showMoveHints = false.obs;

  final StockfishController stockfishController;

  /// Check if Stockfish is ready
  bool get isStockfishReady => stockfishController.isInitializedRx.value;

  ComputerGameController({
    required super.plySound,
    required this.stockfishController,
  });

  /// Player name
  String _playerName = 'Guest';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      _playerName = args['playerName'] as String;
      final playerSide = args['playerSide'] as PlayerSide;
      final difficulty = args['difficulty'] as int;
      final showHints = args['showMoveHints'] as bool? ?? false;

      // Start game automatically with provided arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startComputerGame(
          playerName: _playerName,
          playerSide: playerSide,
          difficulty: difficulty,
          showMoveHints: showHints,
        );
      });
    }
  }

  /// Retry game start
  /// إعادة محاولة بدء اللعبة
  Future<void> retryGame() async {
    // Retry engine initialization if needed
    if (!isStockfishReady) {
      await stockfishController.retryInitialization();
    }

    // Restart game setup
    await _startComputerGame(
      playerName: _playerName,
      playerSide: playerSide,
      difficulty: difficulty,
      showMoveHints: showMoveHints.value,
    );
  }

  /// Start new game against computer
  /// بدء لعبة جديدة ضد الكمبيوتر
  Future<void> _startComputerGame({
    required String playerName,
    required PlayerSide playerSide,
    int difficulty = 10,
    bool showMoveHints = false,
  }) async {
    try {
      isLoading = true;
      this.playerSide = playerSide;
      _difficulty.value = difficulty;
      this.showMoveHints.value = showMoveHints;

      // Wait for engine initialization if needed
      if (!isStockfishReady) {
        AppLogger.info(
          'Waiting for Stockfish initialization...',
          tag: 'ComputerGameController',
        );

        // Wait up to 5 seconds for initialization
        int retries = 0;
        while (!isStockfishReady && retries < 50) {
          if (stockfishController.errorMessage.isNotEmpty) {
            throw Exception(stockfishController.errorMessage);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          retries++;
        }

        if (!isStockfishReady) {
          throw Exception('Timeout waiting for Stockfish initialization');
        }
      }

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
        if (isStockfishReady) {
          // Delay slightly so user perceives the board before move
          await Future.delayed(const Duration(milliseconds: 500));
          await _makeComputerMove();
        } else {
          // Wait for initialization then move
          once(stockfishController.isInitializedRx, (isReady) async {
            if (isReady && !isGameOver) {
              await Future.delayed(const Duration(milliseconds: 500));
              await _makeComputerMove();
            }
          });
        }
      }

      // Show board immediately after setup is done
      isLoading = false;

      currentFen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);

      debugPrint('Computer game started');
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

    // Auto-save if enabled
    if (autoSaveEnabled) {
      await autoSaveGame();
    }

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
}
