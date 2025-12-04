import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/puzzle/presentation/controllers/puzzle_features.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class PuzzlesGameController extends BaseGameController
    implements PuzzleFeatures {
  PuzzlesGameController({required super.plySound});

  // TODO: When implementing puzzle features, consider setting board orientation
  // based on puzzle requirements (e.g., if puzzle shows black to move, flip board).
  // Use ChessBoardSettingsController to set orientation in loadPuzzle method.

  @override
  int getMaterialOnBoard(Side side) {
    return gameState.materialOnBoard(side);
  }

  @override
  List<Role> getCapturedPieces(Side side) {
    return gameState.getCapturedPiecesList(side);
  }

  @override
  String getPgnString() {
    return gameState.pgnString();
  }

  @override
  Future<bool> checkSolution(List<String> moves) {
    // TODO: Implement puzzle solution checking
    throw UnimplementedError();
  }

  @override
  Future<String> getHint() {
    // TODO: Implement hint system
    throw UnimplementedError();
  }

  @override
  Future<void> loadPuzzle(String puzzleId) {
    // TODO: Implement puzzle loading
    throw UnimplementedError();
  }

  @override
  Future<void> showSolution() {
    // TODO: Implement solution display
    throw UnimplementedError();
  }

  @override
  Future<void> agreeDraw() async {
    // Puzzles don't have draws
    AppLogger.debug('agreeDraw called in puzzle mode - ignoring');
  }

  @override
  Future<void> checkMate() async {
    try {
      AppLogger.gameEvent('PuzzleCheckmate');

      // In puzzle mode, checkmate means puzzle solved!
      Get.snackbar(
        'Puzzle Solved!',
        'Congratulations! You found the checkmate!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in checkMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'PuzzlesGameController',
      );
    }
  }

  @override
  Future<void> draw() async {
    // Puzzles don't typically end in draws
    AppLogger.debug('draw called in puzzle mode - ignoring');
  }

  @override
  Future<void> fiftyMoveRule() async {
    // Not applicable in puzzle mode
    AppLogger.debug('fiftyMoveRule called in puzzle mode - ignoring');
  }

  @override
  Future<void> insufficientMaterial() async {
    // Not applicable in puzzle mode
    AppLogger.debug('insufficientMaterial called in puzzle mode - ignoring');
  }

  @override
  Future<void> staleMate() async {
    try {
      AppLogger.gameEvent('PuzzleStalemate');

      // In puzzle mode, stalemate usually means wrong solution
      Get.snackbar(
        'Incorrect!',
        'Stalemate is not the solution. Try again!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in staleMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'PuzzlesGameController',
      );
    }
  }

  @override
  Future<void> threefoldRepetition() async {
    // Not applicable in puzzle mode
    AppLogger.debug('threefoldRepetition called in puzzle mode - ignoring');
  }
}
