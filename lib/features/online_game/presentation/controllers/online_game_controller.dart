import 'package:chessground_game_app/features/online_game/domain/usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/online_game/presentation/controllers/online_features.dart';
import 'package:dartchess/dartchess.dart';

class OnlineGameController extends BaseGameController
    implements OnlineFeatures {
  final PlayMove playMoveUsecase;

  OnlineGameController({
    required super.plySound,
    required this.playMoveUsecase,
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
