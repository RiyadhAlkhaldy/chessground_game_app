import 'package:chessground_game_app/core/global_feature/presentaion/controllers/interfaces/end_game_interfaces.dart';
import 'package:dartchess/dartchess.dart';

abstract class OfflineFeatures
    implements
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

  Future<void> loadGame(String gameUuid);

  Future<void> saveGame();

  Future<void> agreeDrawn();

  String getPgnString();

  List<Role> getCapturedPieces(Side side);

  int getMaterialOnBoard(Side side);
}
