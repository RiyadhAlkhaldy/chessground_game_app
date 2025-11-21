import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';


abstract class GamesRepository {
  Future<void> clearAllData();

  Future<List<ChessGame>>? getAllGames();

  Future<ChessGame?> getGameByUuid(String uuid);

  Future<List<ChessGame>> getRecentGames({int page = 0, int pageSize = 20});

  Future<void> insertMockDataIfEmpty();

  ChessGameStorageService get storageService => throw UnimplementedError();

  Stream<List<ChessGame>> watchRecentGames();
}
