// lib/data/datasources/local/player_local_datasource.dart

import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:isar/isar.dart';

/// Local data source for player operations using Isar
/// مصدر البيانات المحلي لعمليات اللاعبين باستخدام Isar
abstract class PlayerLocalDataSource {
  Future<PlayerModel> savePlayer(PlayerModel player);
  Future<PlayerModel> updatePlayer(PlayerModel player);
  Future<PlayerModel> getPlayerByUuid(String uuid);
  Future<PlayerModel> getPlayerById(int id);
  Future<List<PlayerModel>> getAllPlayers();
  Future<List<PlayerModel>> getPlayersByType(String type);
  Future<bool> deletePlayer(String uuid);
  Future<List<PlayerModel>> searchPlayersByName(String name);
  Future<PlayerModel> updatePlayerRating(String uuid, int newRating);
  Future<PlayerModel> getOrCreateGuestPlayer(String name);
  Stream<PlayerModel?> watchPlayer(String uuid);
}

/// Implementation of PlayerLocalDataSource
/// تنفيذ مصدر البيانات المحلي للاعبين
class PlayerLocalDataSourceImpl implements PlayerLocalDataSource {
  final Isar isar;

  PlayerLocalDataSourceImpl({required this.isar});

  @override
  Future<PlayerModel> savePlayer(PlayerModel player) async {
    try {
      AppLogger.database('Saving player to Isar: ${player.name}');

      // Convert model to collection
      final collection = player.toCollection();

      // Save to database
      await isar.writeTxn(() async {
        await isar.players.put(collection);
      });

      AppLogger.database('Player saved successfully', result: collection.id);

      // Return saved model with ID
      return player.copyWith(id: collection.id);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving player to Isar',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<PlayerModel> updatePlayer(PlayerModel player) async {
    try {
      AppLogger.database('Updating player in Isar: ${player.name}');

      if (player.id == null) {
        throw Exception('Cannot update player without ID');
      }

      // Convert model to collection
      final collection = player.toCollection();
      collection.id = player.id!;

      // Update in database
      await isar.writeTxn(() async {
        await isar.players.put(collection);
      });

      AppLogger.database('Player updated successfully', result: collection.id);

      return player;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating player in Isar',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<PlayerModel> getPlayerByUuid(String uuid) async {
    try {
      AppLogger.database('Fetching player by UUID: $uuid');

      final collection = await isar.players.filter().uuidEqualTo(uuid).findFirst();

      if (collection == null) {
        throw Exception('Player not found with UUID: $uuid');
      }

      AppLogger.database('Player fetched successfully', result: collection.id);

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching player by UUID',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<PlayerModel> getPlayerById(int id) async {
    try {
      AppLogger.database('Fetching player by ID: $id');

      final collection = await isar.players.get(id);

      if (collection == null) {
        throw Exception('Player not found with ID: $id');
      }

      AppLogger.database('Player fetched successfully', result: collection.id);

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching player by ID',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<PlayerModel>> getAllPlayers() async {
    try {
      AppLogger.database('Fetching all players');

      final collections = await isar.players.where().findAll();

      AppLogger.database('Fetched all players', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching all players',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<PlayerModel>> getPlayersByType(String type) async {
    try {
      AppLogger.database('Fetching players by type: $type');

      final collections = await isar.players
          .filter()
          .typeEqualTo(type, caseSensitive: false)
          .findAll();

      AppLogger.database('Fetched players by type', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching players by type',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> deletePlayer(String uuid) async {
    try {
      AppLogger.database('Deleting player: $uuid');

      final collection = await isar.players.filter().uuidEqualTo(uuid).findFirst();

      if (collection == null) {
        return false;
      }

      await isar.writeTxn(() async {
        await isar.players.delete(collection.id);
      });

      AppLogger.database('Player deleted successfully');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<PlayerModel>> searchPlayersByName(String name) async {
    try {
      AppLogger.database('Searching players by name: $name');

      final collections = await isar.players
          .filter()
          .nameContains(name, caseSensitive: false)
          .findAll();

      AppLogger.database('Found players', result: collections.length);

      return collections.map((c) => c.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error searching players by name',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<PlayerModel> updatePlayerRating(String uuid, int newRating) async {
    try {
      AppLogger.database('Updating player rating: $uuid -> $newRating');

      final collection = await isar.players.filter().uuidEqualTo(uuid).findFirst();

      if (collection == null) {
        throw Exception('Player not found with UUID: $uuid');
      }

      collection.playerRating = newRating;

      await isar.writeTxn(() async {
        await isar.players.put(collection);
      });

      AppLogger.database('Player rating updated successfully');

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating player rating',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<PlayerModel> getOrCreateGuestPlayer(String name) async {
    try {
      AppLogger.database('Getting or creating guest player: $name');
      final player = await createOrGetGustPlayer(name);
      return player!.toModel();
      // Try to find existing guest player with same name
      // final existing = await isar.players
      //     .filter()
      //     .typeEqualTo('guest', caseSensitive: false)
      //     .and()
      //     .nameEqualTo(name)
      //     .findFirst();

      // if (existing != null) {
      //   AppLogger.database('Found existing guest player', result: existing.id);
      //   return existing.toModel();
      // }

      // // Create new guest player
      // final newPlayer = Player(
      //   uuid: const Uuid().v4(),
      //   name: name,
      //   type: 'guest',
      //   playerRating: 1200,
      // );

      // await isar.writeTxn(() async {
      //   await isar.players.put(newPlayer);
      // });

      // AppLogger.database('Created new guest player', result: newPlayer.id);

      // return newPlayer.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting or creating guest player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Stream<PlayerModel?> watchPlayer(String uuid) {
    try {
      AppLogger.database('Watching player: $uuid');

      return isar.players.filter().uuidEqualTo(uuid).watch(fireImmediately: true).map((
        collections,
      ) {
        if (collections.isEmpty) return null;
        return collections.first.toModel();
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error watching player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerLocalDataSource',
      );
      rethrow;
    }
  }
}
