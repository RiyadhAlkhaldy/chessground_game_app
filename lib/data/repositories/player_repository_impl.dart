// lib/data/repositories/player_repository_impl.dart

import 'package:chessground_game_app/data/models/mappers/entities_mapper.dart';
import 'package:chessground_game_app/data/models/player_model.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_local_datasource.dart';

/// Implementation of PlayerRepository
/// تنفيذ مستودع اللاعبين
class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerLocalDataSource localDataSource;

  PlayerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PlayerEntity>> savePlayer(PlayerEntity player) async {
    try {
      AppLogger.info(
        'Repository: Saving player ${player.name}',
        tag: 'PlayerRepository',
      );

      final model = player.toModel();
      final savedModel = await localDataSource.savePlayer(model);
      final savedEntity = savedModel.toEntity();

      AppLogger.info(
        'Repository: Player saved successfully',
        tag: 'PlayerRepository',
      );

      return Right(savedEntity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to save player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to save player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> updatePlayer(
    PlayerEntity player,
  ) async {
    try {
      AppLogger.info(
        'Repository: Updating player ${player.name}',
        tag: 'PlayerRepository',
      );

      final model = player.toModel();
      final updatedModel = await localDataSource.updatePlayer(model);
      final updatedEntity = updatedModel.toEntity();

      AppLogger.info(
        'Repository: Player updated successfully',
        tag: 'PlayerRepository',
      );

      return Right(updatedEntity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to update player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to update player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> getPlayerByUuid(String uuid) async {
    try {
      AppLogger.info(
        'Repository: Fetching player $uuid',
        tag: 'PlayerRepository',
      );

      final model = await localDataSource.getPlayerByUuid(uuid);
      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Player fetched successfully',
        tag: 'PlayerRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      if (e.toString().contains('not found')) {
        return Left(
          NotFoundFailure(message: 'Player not found with UUID: $uuid'),
        );
      }

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> getPlayerById(int id) async {
    try {
      AppLogger.info(
        'Repository: Fetching player by ID $id',
        tag: 'PlayerRepository',
      );

      final model = await localDataSource.getPlayerById(id);
      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Player fetched successfully',
        tag: 'PlayerRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch player by ID',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      if (e.toString().contains('not found')) {
        return Left(NotFoundFailure(message: 'Player not found with ID: $id'));
      }

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> getAllPlayers() async {
    try {
      AppLogger.info(
        'Repository: Fetching all players',
        tag: 'PlayerRepository',
      );

      final models = await localDataSource.getAllPlayers();
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} players',
        tag: 'PlayerRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch all players',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch players: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> getPlayersByType(
    String type,
  ) async {
    try {
      AppLogger.info(
        'Repository: Fetching players by type $type',
        tag: 'PlayerRepository',
      );

      final models = await localDataSource.getPlayersByType(type);
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} players',
        tag: 'PlayerRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch players by type',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch players by type: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deletePlayer(String uuid) async {
    try {
      AppLogger.info(
        'Repository: Deleting player $uuid',
        tag: 'PlayerRepository',
      );

      final result = await localDataSource.deletePlayer(uuid);

      AppLogger.info(
        'Repository: Player deletion ${result ? 'successful' : 'failed'}',
        tag: 'PlayerRepository',
      );

      return Right(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to delete player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to delete player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> searchPlayersByName(
    String name,
  ) async {
    try {
      AppLogger.info(
        'Repository: Searching players by name: $name',
        tag: 'PlayerRepository',
      );

      final models = await localDataSource.searchPlayersByName(name);
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Found ${entities.length} players',
        tag: 'PlayerRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to search players',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to search players: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> updatePlayerRating(
    String uuid,
    int newRating,
  ) async {
    try {
      AppLogger.info(
        'Repository: Updating player rating $uuid -> $newRating',
        tag: 'PlayerRepository',
      );

      final model = await localDataSource.updatePlayerRating(uuid, newRating);
      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Player rating updated successfully',
        tag: 'PlayerRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to update player rating',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to update player rating: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> getOrCreateGuestPlayer(
    String name,
  ) async {
    try {
      AppLogger.info(
        'Repository: Getting or creating guest player: $name',
        tag: 'PlayerRepository',
      );

      final model = await localDataSource.getOrCreateGuestPlayer(name);
      final entity = model.toEntity();
      AppLogger.info('Repository: Guest player ready', tag: 'PlayerRepository');

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get/create guest player',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get/create guest player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, PlayerEntity>> watchPlayer(String uuid) {
    try {
      AppLogger.info(
        'Repository: Watching player $uuid',
        tag: 'PlayerRepository',
      );
      return localDataSource.watchPlayer(uuid).map((model) {
        if (model == null) {
          return Left(NotFoundFailure(message: 'Player not found: $uuid'));
        }
        return Right(model.toEntity());
      });
      // .handleError((error, stackTrace) {
      //   AppLogger.error(
      //     'Repository: Error watching player',
      //     error: error,
      //     stackTrace: stackTrace,
      //     tag: 'PlayerRepository',
      //   );
      //   return Left(
      //     DatabaseFailure(
      //       message: 'Failed to watch player: ${error.toString()}',
      //     ),
      //   );
      // });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to setup player watch',
        error: e,
        stackTrace: stackTrace,
        tag: 'PlayerRepository',
      );

      return Stream.value(
        Left(
          DatabaseFailure(message: 'Failed to watch player: ${e.toString()}'),
        ),
      );
    }
  }
}
