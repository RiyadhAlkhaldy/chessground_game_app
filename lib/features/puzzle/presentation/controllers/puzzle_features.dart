import 'package:chessground_game_app/core/global_feature/presentaion/controllers/interfaces/end_game_interfaces.dart';
import 'package:dartchess/dartchess.dart';

abstract class PuzzleFeatures
    implements
        CheckMateInterface,
        StaleMateInterface,
        DrawInterface,
        ResignInterface,
        AgreeDrawInterface,
        InsufficientMaterialInterface,
        ThreefoldRepetitionInterface,
        FiftyMoveRuleInterface {
  Future<void> loadPuzzle(String puzzleId);
  Future<bool> checkSolution(List<String> moves);
  Future<String> getHint();
  Future<void> showSolution();
  String getPgnString();
  List<Role> getCapturedPieces(Side side);
  int getMaterialOnBoard(Side side);
}
