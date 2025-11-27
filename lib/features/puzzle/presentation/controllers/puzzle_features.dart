import 'package:dartchess/dartchess.dart';

abstract class PuzzleFeatures {
  Future<void> loadPuzzle(String puzzleId);
  Future<bool> checkSolution(List<String> moves);
  Future<String> getHint();
  Future<void> showSolution();
  String getPgnString();
  List<Role> getCapturedPieces(Side side);
  int getMaterialOnBoard(Side side);
}
