
import 'package:dartchess/dartchess.dart';

import 'base_game_controller.dart';
import 'puzzle_features.dart';

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
  
  
}
