import 'package:chessground_game_app/presentation/controllers/base_game_controller.dart';
import 'package:chessground_game_app/presentation/controllers/puzzle_features.dart';
import 'package:dartchess/dartchess.dart';

class PuzzlesGameController extends BaseGameController implements PuzzleFeatures {
  PuzzlesGameController({
    required super.plySound,
    required super.playMoveUsecase,
    required super.initChessGame,
  });

  @override
  int getMaterialOnBoard(Side side) {
    throw UnimplementedError();
  }

  @override
  List<Role> getCapturedPieces(Side side) {
    throw UnimplementedError();
  }

  @override
  String getPgnString() {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkSolution(List<String> moves) {
    throw UnimplementedError();
  }

  @override
  Future<String> getHint() {
    throw UnimplementedError();
  }

  @override
  Future<void> loadPuzzle(String puzzleId) {
    throw UnimplementedError();
  }

  @override
  Future<void> showSolution() {
    throw UnimplementedError();
  }
}
