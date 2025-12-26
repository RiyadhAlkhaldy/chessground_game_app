import 'dart:math';
import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ComputerGameController extends BaseGameController
    with StorageFeatures, WidgetsBindingObserver {
  final RxBool _computerThinking = false.obs;
  bool get computerThinking => _computerThinking.value;

  final RxInt _difficulty = 10.obs;
  int get difficulty => _difficulty.value;
  set difficulty(int value) => _difficulty.value = value;

  final RxBool showMoveHints = false.obs;

  final StockfishController stockfishController;

  bool get isStockfishReady => stockfishController.isInitializedRx.value;

  ComputerGameController({
    required super.plySound,
    required this.stockfishController,
  });

  String _playerName = 'Guest';
  String _stockfishName = 'Stockfish';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      _playerName = args['playerName'] as String;
      _stockfishName = args['stockfishName'] as String? ?? 'Stockfish';
      final playerSide = args['playerSide'] as PlayerSide;
      final difficulty = args['difficulty'] as int;
      final showHints = args['showMoveHints'] as bool? ?? false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startComputerGame(
          playerName: _playerName,
          stockfishName: _stockfishName,
          playerSide: playerSide,
          difficulty: difficulty,
          showMoveHints: showHints,
        );
      });
    }
  }

  Future<void> retryGame() async {
    if (!isStockfishReady) {
      await stockfishController.retryInitialization();
    }

    await _startComputerGame(
      playerName: _playerName,
      stockfishName: _stockfishName,
      playerSide: playerSide,
      difficulty: difficulty,
      showMoveHints: showMoveHints.value,
    );
  }

  Future<void> _startComputerGame({
    required String playerName,
    required String stockfishName,
    required PlayerSide playerSide,
    int difficulty = 10,
    bool showMoveHints = false,
  }) async {
    try {
      isLoading = true;
      this.playerSide = playerSide;
      _difficulty.value = difficulty;
      this.showMoveHints.value = showMoveHints;

      if (!isStockfishReady) {
        AppLogger.info('Waiting for Stockfish initialization...', tag: 'ComputerGameController');
        int retries = 0;
        while (!isStockfishReady && retries < 50) {
          if (stockfishController.errorMessage.isNotEmpty) {
            throw Exception(stockfishController.errorMessage);
          }
          await Future.delayed(const Duration(milliseconds: 100));
          retries++;
        }
        if (!isStockfishReady) {
          setError("timeoutStockfish");
          isLoading = false;
          return;
        }
      }

      await stockfishController.setSkillLevel(difficulty);

      await startNewGame(
        whitePlayerName: playerSide == PlayerSide.white ? playerName : stockfishName,
        blackPlayerName: playerSide == PlayerSide.black ? playerName : stockfishName,
        event: 'Computer Game',
        site: 'Local',
      );

      if (playerSide == PlayerSide.black) {
        if (isStockfishReady) {
          await Future.delayed(const Duration(milliseconds: 500));
          await _makeComputerMove();
        } else {
          once(stockfishController.isInitializedRx, (isReady) async {
            if (isReady == true && !isGameOver) {
              await Future.delayed(const Duration(milliseconds: 500));
              await _makeComputerMove();
            }
          });
        }
      }

      isLoading = false;
      updateReactiveState();
    } catch (e, stackTrace) {
      AppLogger.error('Error starting computer game', error: e, stackTrace: stackTrace, tag: 'ComputerGameController');
      setError(e.toString());
      isLoading = false;
    }
  }

  @override
  Future<void> onUserMove(NormalMove move, {bool? isDrop, bool? isPremove}) async {
    super.onUserMove(move, isDrop: isDrop, isPremove: isPremove);
    if (autoSaveEnabled) await autoSaveGame();
    if (isGameOver) return;
    if (currentTurn.name != playerSide.name) {
      await _makeComputerMove();
    }
  }

  Future<void> _makeComputerMove() async {
    try {
      if (isGameOver) return;
      _computerThinking.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      final randomTime = Random().nextInt(3000) + 2000;
      await stockfishController.getBestMoveWithTimeAndDepth(
        currentFen,
        depth: _getDepthForDifficulty(difficulty),
        timeMilliseconds: randomTime,
      );
      final bestMoveResult = stockfishController.bestMove;

      if (bestMoveResult != null) {
        final move = Move.parse(bestMoveResult.uci);
        if (move is NormalMove) {
          super.onUserMove(move);
        }
      }
      _computerThinking.value = false;
    } catch (e, stackTrace) {
      AppLogger.error('Error making computer move', error: e, stackTrace: stackTrace, tag: 'ComputerGameController');
      _computerThinking.value = false;
    }
  }

  int _getDepthForDifficulty(int difficulty) {
    if (difficulty < 7) return 8;
    if (difficulty < 14) return 15;
    return 20;
  }
}