import 'package:chessground_game_app/core/global_feature/presentaion/controllers/interfaces/end_game_interfaces.dart';
import 'package:dartchess/dartchess.dart';

abstract class OnlineFeatures
    implements
        TimeOutInterface,
        CheckMateInterface,
        StaleMateInterface,
        DrawInterface,
        ResignInterface,
        AgreeDrawInterface,
        InsufficientMaterialInterface,
        ThreefoldRepetitionInterface,
        FiftyMoveRuleInterface {
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  });
  Future<void> connectToGame(String gameId);
  Future<void> sendMove(NormalMove move);
  Stream<NormalMove> receiveMoves();
  @override
  Future<void> resign(Side side);
  Future<void> offerDraw();
  Future<void> acceptDraw();
  Future<void> declineDraw();
  String getPgnString();
  List<Role> getCapturedPieces(Side side);
  int getMaterialOnBoard(Side side);
}
