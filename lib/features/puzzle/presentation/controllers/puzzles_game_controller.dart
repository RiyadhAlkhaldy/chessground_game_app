import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/puzzle/presentation/controllers/puzzle_features.dart';
import 'package:dartchess/dartchess.dart';

class PuzzlesGameController extends BaseGameController
    implements PuzzleFeatures {
  PuzzlesGameController({required super.plySound});

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

  @override
  agreeDraw() {
    // TODO: implement agreeDraw
    throw UnimplementedError();
  }

  @override
  checkMate() {
    // TODO: implement checkMate
    throw UnimplementedError();
  }

  @override
  draw() {
    // TODO: implement draw
    throw UnimplementedError();
  }

  @override
  fiftyMoveRule() {
    // TODO: implement fiftyMoveRule
    throw UnimplementedError();
  }

  @override
  insufficientMaterial() {
    // TODO: implement insufficientMaterial
    throw UnimplementedError();
  }

  @override
  staleMate() {
    // TODO: implement staleMate
    throw UnimplementedError();
  }

  @override
  threefoldRepetition() {
    // TODO: implement threefoldRepetition
    throw UnimplementedError();
  }

  @override
  timeOut() {
    // TODO: implement timeOut
    throw UnimplementedError();
  }
}
