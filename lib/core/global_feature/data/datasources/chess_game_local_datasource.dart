// lib/data/datasources/local/chess_game_local_datasource.dart

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/models/chess_game_model.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:isar/isar.dart';

/// Local data source for chess game operations using Isar
/// مصدر البيانات المحلي لعمليات لعبة الشطرنج باستخدام Isar
abstract class ChessGameLocalDataSource {
  Future<ChessGameModel> saveGame(ChessGameModel game);
  Future<ChessGameModel> updateGame(ChessGameModel game);
  Future<ChessGameModel> getGameByUuid(String uuid);
  Future<ChessGameModel> getGameById(int id);
  Future<List<ChessGameModel>> getAllGames();
  Future<List<ChessGameModel>> getGamesByPlayer(String playerUuid);
  Future<List<ChessGameModel>> getRecentGames({int limit = 20});
  Future<List<ChessGameModel>> getOngoingGames();
  Future<List<ChessGameModel>> getCompletedGames();
  Future<bool> deleteGame(String uuid);
  Future<bool> deleteAllGames();
  Future<List<ChessGameModel>> searchGames({
    String? event,
    String? playerName,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? result,
  });
  Future<int> getGamesCount();
  Stream<ChessGameModel?> watchGame(String uuid);
  Stream<List<ChessGameModel>> watchAllGames();
}

/// Implementation of ChessGameLocalDataSource
/// تنفيذ مصدر البيانات المحلي للعبة الشطرنج
class ChessGameLocalDataSourceImpl implements ChessGameLocalDataSource {
  final Isar isar;

  ChessGameLocalDataSourceImpl({required this.isar});

  @override
  Future<ChessGameModel> saveGame(ChessGameModel game) async {
    try {
      AppLogger.database('Saving game to Isar: ${game.uuid}');
      AppLogger.database('Saving game to Isar: $game');

      // Convert model to collection
      final chessGame = game.toCollection();
      // Save to database

      await isar.writeTxn(() async {
        await isar.chessGames.put(chessGame);

        // Save players first
        if (chessGame.whitePlayer.value != null) {
          await isar.players.put(chessGame.whitePlayer.value!);
          await chessGame.whitePlayer.save();
        }
        if (chessGame.blackPlayer.value != null) {
          await isar.players.put(chessGame.blackPlayer.value!);
          await chessGame.blackPlayer.save();
        }
      });

      AppLogger.database('Game saved successfully', result: chessGame.id);

      // Return saved model with ID
      return game.copyWith(id: chessGame.id);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving game to Isar',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<ChessGameModel> updateGame(ChessGameModel game) async {
    try {
      AppLogger.database('Updating game in Isar: ${game.uuid}');

      if (game.id == null) {
        throw Exception('Cannot update game without ID');
      }

      // Convert model to collection
      final collection = game.toCollection();
      collection.id = game.id!;

      // Update in database
      await isar.writeTxn(() async {
        await isar.chessGames.put(collection);

        // Update players if modified
        if (collection.whitePlayer.value != null) {
          await isar.players.put(collection.whitePlayer.value!);
          collection.whitePlayer.save();
        }
        if (collection.blackPlayer.value != null) {
          await isar.players.put(collection.blackPlayer.value!);
          collection.blackPlayer.save();
        }

        // Update game
      });

      AppLogger.database('Game updated successfully', result: collection.id);

      return game;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating game in Isar',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<ChessGameModel> getGameByUuid(String uuid) async {
    try {
      AppLogger.database('Fetching game by UUID: $uuid');

      final collection = await isar.chessGames
          .filter()
          .uuidEqualTo(uuid)
          .findFirst();

      if (collection == null) {
        throw Exception('Game not found with UUID: $uuid');
      }

      // Load relationships
      await collection.whitePlayer.load();
      await collection.blackPlayer.load();

      AppLogger.database('Game fetched successfully', result: collection.id);

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching game by UUID',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<ChessGameModel> getGameById(int id) async {
    try {
      AppLogger.database('Fetching game by ID: $id');

      final collection = await isar.chessGames.get(id);

      if (collection == null) {
        throw Exception('Game not found with ID: $id');
      }

      // Load relationships
      await collection.whitePlayer.load();
      await collection.blackPlayer.load();

      AppLogger.database('Game fetched successfully', result: collection.id);

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching game by ID',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> getAllGames() async {
    try {
      AppLogger.database('Fetching all games');

      final collections = await isar.chessGames.where().findAll();

      // Load relationships for all games
      for (final collection in collections) {
        await collection.whitePlayer.load();
        await collection.blackPlayer.load();
      }

      AppLogger.database('Fetched all games', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching all games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> getGamesByPlayer(String playerUuid) async {
    try {
      AppLogger.database('Fetching games for player: $playerUuid');

      // Find player first
      final player = await isar.players
          .filter()
          .uuidEqualTo(playerUuid)
          .findFirst();

      if (player == null) {
        return [];
      }

      // Find all games where player is white or black
      final collections = await isar.chessGames.where().findAll();

      final playerGames = <ChessGame>[];
      for (final game in collections) {
        await game.whitePlayer.load();
        await game.blackPlayer.load();

        if (game.whitePlayer.value?.uuid == playerUuid ||
            game.blackPlayer.value?.uuid == playerUuid) {
          playerGames.add(game);
        }
      }

      AppLogger.database(
        'Fetched games for player',
        result: playerGames.length,
      );

      return playerGames.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching games by player',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> getRecentGames({int limit = 20}) async {
    try {
      AppLogger.database('Fetching recent games (limit: $limit)');

      final collections = await isar.chessGames
          .where()
          .sortByDateDesc()
          .limit(limit)
          .findAll();

      // Load relationships
      for (final collection in collections) {
        await collection.whitePlayer.load();
        await collection.blackPlayer.load();
      }

      AppLogger.database('Fetched recent games', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching recent games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> getOngoingGames() async {
    try {
      AppLogger.database('Fetching ongoing games');

      final collections = await isar.chessGames
          .filter()
          .resultEqualTo('*')
          .findAll();

      // Load relationships
      for (final collection in collections) {
        await collection.whitePlayer.load();
        await collection.blackPlayer.load();
      }

      AppLogger.database('Fetched ongoing games', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching ongoing games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> getCompletedGames() async {
    try {
      AppLogger.database('Fetching completed games');

      final collections = await isar.chessGames
          .filter()
          .not()
          .resultEqualTo('*')
          .findAll();

      // Load relationships
      for (final collection in collections) {
        await collection.whitePlayer.load();
        await collection.blackPlayer.load();
      }

      AppLogger.database('Fetched completed games', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching completed games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> deleteGame(String uuid) async {
    try {
      AppLogger.database('Deleting game: $uuid');

      final collection = await isar.chessGames
          .filter()
          .uuidEqualTo(uuid)
          .findFirst();

      if (collection == null) {
        return false;
      }

      await isar.writeTxn(() async {
        await isar.chessGames.delete(collection.id);
      });

      AppLogger.database('Game deleted successfully');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> deleteAllGames() async {
    try {
      AppLogger.database('Deleting all games');

      await isar.writeTxn(() async {
        await isar.chessGames.clear();
      });

      AppLogger.database('All games deleted successfully');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting all games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<ChessGameModel>> searchGames({
    String? event,
    String? playerName,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? result,
  }) async {
    try {
      AppLogger.database('Searching games with filters');

      var query = isar.chessGames.filter();

      if (event != null && event.isNotEmpty) {
        query = query.eventContains(event, caseSensitive: false);
      }

      if (dateFrom != null) {
        query = query.dateGreaterThan(dateFrom);
      }

      if (dateTo != null) {
        query = query.dateLessThan(dateTo);
      }

      if (result != null && result.isNotEmpty) {
        query = query.resultEqualTo(result);
      }
      //TODO
      var collections = await query.eventEqualTo(event).findAll();

      // Filter by player name if provided
      if (playerName != null && playerName.isNotEmpty) {
        final filteredCollections = <ChessGame>[];
        for (final game in collections) {
          await game.whitePlayer.load();
          await game.blackPlayer.load();

          final whiteName = game.whitePlayer.value?.name ?? '';
          final blackName = game.blackPlayer.value?.name ?? '';

          if (whiteName.toLowerCase().contains(playerName.toLowerCase()) ||
              blackName.toLowerCase().contains(playerName.toLowerCase())) {
            filteredCollections.add(game);
          }
        }
        collections = filteredCollections;
      } else {
        // Load relationships for remaining games
        for (final collection in collections) {
          await collection.whitePlayer.load();
          await collection.blackPlayer.load();
        }
      }

      AppLogger.database('Search completed', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error searching games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<int> getGamesCount() async {
    try {
      final count = await isar.chessGames.count();
      AppLogger.database('Total games count', result: count);
      return count;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting games count',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Stream<ChessGameModel?> watchGame(String uuid) {
    try {
      AppLogger.database('Watching game: $uuid');

      return isar.chessGames
          .filter()
          .uuidEqualTo(uuid)
          .watch(fireImmediately: true)
          .asyncMap((collections) async {
            if (collections.isEmpty) return null;

            final collection = collections.first;
            await collection.whitePlayer.load();
            await collection.blackPlayer.load();

            return collection.toModel();
          });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error watching game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Stream<List<ChessGameModel>> watchAllGames() {
    try {
      AppLogger.database('Watching all games');

      return isar.chessGames.where().watch(fireImmediately: true).asyncMap((
        collections,
      ) async {
        // Load relationships
        for (final collection in collections) {
          await collection.whitePlayer.load();
          await collection.blackPlayer.load();
        }

        return collections.map((c) => c.toModel()).toList();
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error watching all games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameLocalDataSource',
      );
      rethrow;
    }
  }
}
