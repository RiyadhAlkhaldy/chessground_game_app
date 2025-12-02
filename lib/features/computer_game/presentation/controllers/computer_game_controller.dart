import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

/// Controller for playing against computer
/// المتحكم في اللعب ضد الكمبيوتر
class ComputerGameController extends GameComputerController {
  final StockfishController stockfishController;

  /// Player side (white or black)
  // final Rx<Side> playerSide = Side.white.obs;
  // Side get playerSide => playerSide;
  // set playerSide(Side value) => playerSide = value;

  /// Computer is thinking
  final RxBool _computerThinking = false.obs;
  bool get computerThinking => _computerThinking.value;

  /// Computer difficulty level (0-20)
  final RxInt _difficulty = 10.obs;
  int get difficulty => _difficulty.value;
  set difficulty(int value) => _difficulty.value = value;

  ComputerGameController({
    required this.stockfishController,
    required super.engineService,
    required super.plySound,
    required super.saveGameUseCase,
    required super.cacheGameStateUseCase,
    required super.getOrCreateGuestPlayerUseCase,
    required super.choosingCtrl,
  });

  //     super(
  //       saveGameUseCase: saveGameUseCase,
  //       updateGameUseCase: updateGameUseCase,
  //       getGameByUuidUseCase: getGameByUuidUseCase,
  //       cacheGameStateUseCase: cacheGameStateUseCase,
  //       getCachedGameStateUseCase: getCachedGameStateUseCase,
  //       savePlayerUseCase: savePlayerUseCase,
  //       getOrCreateGuestPlayerUseCase: getOrCreateGuestPlayerUseCase,
  //     );

  /// Start new game against computer
  /// بدء لعبة جديدة ضد الكمبيوتر
  Future<void> startComputerGame({
    required String playerName,
    required Side playerSide,
    int difficulty = 10,
  }) async {
    try {
      playerSide = playerSide;
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
        whitePlayerName: playerSide == Side.white ? playerName : 'Stockfish',
        blackPlayerName: playerSide == Side.black ? playerName : 'Stockfish',
        event: 'Computer Game',
        site: 'Local',
      );

      // If computer plays white, make first move
      if (playerSide == Side.black) {
        await _makeComputerMove();
      }
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
  // @override
  // Future<void> onUserMove(
  //   NormalMove move, {
  //   bool? isDrop,
  //   bool? isPremove,
  // }) async {
  //   // Execute player's move
  //   super.onUserMove(move, isDrop: isDrop, isPremove: isPremove);

  //   // Check if game is over
  //   if (isGameOver) return;

  //   // Check if it's computer's turn
  //   if (currentTurn != playerSide) {
  //     await _makeComputerMove();
  //   }
  // }

  /// Make computer move
  /// تنفيذ حركة الكمبيوتر
  Future<void> _makeComputerMove() async {
    try {
      if (isGameOver) return;

      _computerThinking.value = true;

      AppLogger.info('Computer is thinking...', tag: 'ComputerGameController');

      // Add small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Get best move from Stockfish
      await stockfishController.getBestMove(
        currentFen,
        depth: _getDepthForDifficulty(difficulty),
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
  //   if (!canUndo.value) return;

  //   // Undo player's move
  //   super.undoMove();

  //   // If it's still computer's turn, undo computer's move too
  //   if (currentTurn != playerSide && canUndo.value) {
  //     super.undoMove();
  //   }
  // }
}
