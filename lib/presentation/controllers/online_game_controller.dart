import 'package:dartchess/dartchess.dart';

import 'base_game_controller.dart';
import 'online_features.dart';

class OnlineGameController extends BaseGameController implements OnlineFeatures {
  OnlineGameController({
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
  Future<void> startNewGame({required String whitePlayerName, required String blackPlayerName, String? event, String? site, String? timeControl}) {
    throw UnimplementedError();
  }
}
