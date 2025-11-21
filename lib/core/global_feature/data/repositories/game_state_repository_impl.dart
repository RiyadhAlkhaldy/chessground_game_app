// lib/data/repositories/game_state_repository_impl.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/game_state_cache_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/models/game_state_model.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/game_state_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_state_repository.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';

/// Implementation of GameStateRepository
/// تنفيذ مستودع حالة اللعبة
class GameStateRepositoryImpl implements GameStateRepository {
  final GameStateCacheDataSource cacheDataSource;

  GameStateRepositoryImpl({required this.cacheDataSource});

  @override
  Future<Either<Failure, void>> cacheGameState(GameStateEntity state) async {
    try {
      AppLogger.debug(
        'Repository: Caching game state ${state.gameUuid}',
        tag: 'GameStateRepository',
      );

      // Convert entity to model
      final model = state.toModel();

      // Cache using data source
      await cacheDataSource.cacheGameState(model);

      AppLogger.debug('Repository: Game state cached successfully', tag: 'GameStateRepository');

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to cache game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      return Left(CacheFailure(message: 'Failed to cache game state: ${e.toString()}', details: e));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity>> getCachedGameState(String gameUuid) async {
    try {
      AppLogger.debug(
        'Repository: Retrieving cached game state $gameUuid',
        tag: 'GameStateRepository',
      );

      // Fetch from cache
      final model = await cacheDataSource.getCachedGameState(gameUuid);

      // Convert to entity
      final entity = model.toEntity();

      AppLogger.debug('Repository: Game state retrieved from cache', tag: 'GameStateRepository');

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to retrieve cached game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      if (e.toString().contains('not found')) {
        return Left(NotFoundFailure(message: 'Game state not found in cache: $gameUuid'));
      }

      return Left(
        CacheFailure(message: 'Failed to retrieve cached game state: ${e.toString()}', details: e),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeCachedGameState(String gameUuid) async {
    try {
      AppLogger.debug(
        'Repository: Removing cached game state $gameUuid',
        tag: 'GameStateRepository',
      );

      await cacheDataSource.removeCachedGameState(gameUuid);

      AppLogger.debug('Repository: Game state removed from cache', tag: 'GameStateRepository');

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to remove cached game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      return Left(
        CacheFailure(message: 'Failed to remove cached game state: ${e.toString()}', details: e),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, GameStateEntity>>> getAllActiveStates() async {
    try {
      AppLogger.debug('Repository: Retrieving all active game states', tag: 'GameStateRepository');

      final modelsMap = await cacheDataSource.getAllActiveStates();

      // Convert all models to entities
      final entitiesMap = modelsMap.map((key, model) => MapEntry(key, model.toEntity()));

      AppLogger.debug(
        'Repository: Retrieved ${entitiesMap.length} active game states',
        tag: 'GameStateRepository',
      );

      return Right(entitiesMap);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to retrieve all active states',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      return Left(
        CacheFailure(message: 'Failed to retrieve active states: ${e.toString()}', details: e),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearAllCachedStates() async {
    try {
      AppLogger.debug('Repository: Clearing all cached game states', tag: 'GameStateRepository');

      await cacheDataSource.clearAllCachedStates();

      AppLogger.debug('Repository: All cached game states cleared', tag: 'GameStateRepository');

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to clear all cached states',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      return Left(
        CacheFailure(message: 'Failed to clear cached states: ${e.toString()}', details: e),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasGameState(String gameUuid) async {
    try {
      final exists = await cacheDataSource.hasGameState(gameUuid);

      AppLogger.debug(
        'Repository: Game state exists in cache: $exists',
        tag: 'GameStateRepository',
      );

      return Right(exists);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to check game state existence',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateRepository',
      );

      return Left(
        CacheFailure(message: 'Failed to check game state existence: ${e.toString()}', details: e),
      );
    }
  }
}
