import 'package:dartchess/dartchess.dart';

abstract class OfflineFeatures {
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  });

  Future<void> loadGame(String gameUuid);

  Future<void> saveGame();

  Future<void> undoMove();

  Future<void> redoMove();

  Future<void> resign(Side side);

  Future<void> agreeDrawn();

  String getPgnString();

  List<Role> getCapturedPieces(Side side);

  int getMaterialOnBoard(Side side);
}
