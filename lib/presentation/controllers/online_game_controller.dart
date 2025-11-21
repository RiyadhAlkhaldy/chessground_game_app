import 'package:chessground_game_app/presentation/controllers/base_game_controller.dart';
import 'package:chessground_game_app/presentation/controllers/online_features.dart';
import 'package:dartchess/dartchess.dart';

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
  Future<void> acceptDraw() {
    throw UnimplementedError();
  }

  @override
  Future<void> connectToGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<void> declineDraw() {
    throw UnimplementedError();
  }

  @override
  Future<void> offerDraw() {
    throw UnimplementedError();
  }

  @override
  Stream<NormalMove> receiveMoves() {
    throw UnimplementedError();
  }

  @override
  Future<void> resign(Side side) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMove(NormalMove move) {
    throw UnimplementedError();
  }

  @override
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) {
    throw UnimplementedError();
  }
}
