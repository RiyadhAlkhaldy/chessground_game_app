// lib/data/repositories/chess_game_repository_impl.dart

import 'package:chessground_game_app/data/models/chess_game_model.dart';
import 'package:chessground_game_app/data/models/mappers/entities_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../../domain/repositories/chess_game_repository.dart';
import '../datasources/chess_game_local_datasource.dart';

/// Implementation of ChessGameRepository
/// تنفيذ مستودع لعبة الشطرنج
class ChessGameRepositoryImpl implements ChessGameRepository {
  final ChessGameLocalDataSource localDataSource;

  ChessGameRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ChessGameEntity>> saveGame(
    ChessGameEntity game,
  ) async {
    try {
      AppLogger.info(
        'Repository: Saving game ${game.uuid}',
        tag: 'ChessGameRepository',
      );

      // Convert entity to model
      final model = game.toModel();

      // Save using data source
      final savedModel = await localDataSource.saveGame(model);

      // Convert back to entity
      final savedEntity = savedModel.toEntity();

      AppLogger.info(
        'Repository: Game saved successfully',
        tag: 'ChessGameRepository',
      );

      return Right(savedEntity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to save game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to save game: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> updateGame(
    ChessGameEntity game,
  ) async {
    try {
      AppLogger.info(
        'Repository: Updating game ${game.uuid}',
        tag: 'ChessGameRepository',
      );

      // Convert entity to model
      final model = game.toModel();

      // Update using data source
      final updatedModel = await localDataSource.updateGame(model);

      // Convert back to entity
      final updatedEntity = updatedModel.toEntity();

      AppLogger.info(
        'Repository: Game updated successfully',
        tag: 'ChessGameRepository',
      );

      return Right(updatedEntity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to update game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to update game: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> getGameByUuid(String uuid) async {
    try {
      AppLogger.info(
        'Repository: Fetching game $uuid',
        tag: 'ChessGameRepository',
      );

      // Fetch using data source
      final model = await localDataSource.getGameByUuid(uuid);

      // Convert to entity
      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Game fetched successfully',
        tag: 'ChessGameRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      if (e.toString().contains('not found')) {
        return Left(
          NotFoundFailure(message: 'Game not found with UUID: $uuid'),
        );
      }

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch game: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> getGameById(int id) async {
    try {
      AppLogger.info(
        'Repository: Fetching game by ID $id',
        tag: 'ChessGameRepository',
      );

      final model = await localDataSource.getGameById(id);
      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Game fetched successfully',
        tag: 'ChessGameRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch game by ID',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      if (e.toString().contains('not found')) {
        return Left(NotFoundFailure(message: 'Game not found with ID: $id'));
      }

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch game: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> getAllGames() async {
    try {
      AppLogger.info(
        'Repository: Fetching all games',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.getAllGames();
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} games',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch all games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> getGamesByPlayer(
    String playerUuid,
  ) async {
    try {
      AppLogger.info(
        'Repository: Fetching games for player $playerUuid',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.getGamesByPlayer(playerUuid);
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} games for player',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch games by player',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch games for player: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> getRecentGames({
    int limit = 20,
  }) async {
    try {
      AppLogger.info(
        'Repository: Fetching recent games (limit: $limit)',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.getRecentGames(limit: limit);
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} recent games',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch recent games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch recent games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> getOngoingGames() async {
    try {
      AppLogger.info(
        'Repository: Fetching ongoing games',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.getOngoingGames();
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} ongoing games',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch ongoing games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch ongoing games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> getCompletedGames() async {
    try {
      AppLogger.info(
        'Repository: Fetching completed games',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.getCompletedGames();
      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Fetched ${entities.length} completed games',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch completed games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch completed games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteGame(String uuid) async {
    try {
      AppLogger.info(
        'Repository: Deleting game $uuid',
        tag: 'ChessGameRepository',
      );

      final result = await localDataSource.deleteGame(uuid);

      AppLogger.info(
        'Repository: Game deletion ${result ? 'successful' : 'failed'}',
        tag: 'ChessGameRepository',
      );

      return Right(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to delete game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to delete game: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAllGames() async {
    try {
      AppLogger.info(
        'Repository: Deleting all games',
        tag: 'ChessGameRepository',
      );

      final result = await localDataSource.deleteAllGames();

      AppLogger.info(
        'Repository: All games deletion successful',
        tag: 'ChessGameRepository',
      );

      return Right(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to delete all games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to delete all games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ChessGameEntity>>> searchGames({
    String? event,
    String? playerName,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? result,
  }) async {
    try {
      AppLogger.info(
        'Repository: Searching games with filters',
        tag: 'ChessGameRepository',
      );

      final models = await localDataSource.searchGames(
        event: event,
        playerName: playerName,
        dateFrom: dateFrom,
        dateTo: dateTo,
        result: result,
      );

      final entities = models.map((m) => m.toEntity()).toList();

      AppLogger.info(
        'Repository: Found ${entities.length} games',
        tag: 'ChessGameRepository',
      );

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to search games',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to search games: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getGamesCount() async {
    try {
      final count = await localDataSource.getGamesCount();

      AppLogger.info(
        'Repository: Total games count: $count',
        tag: 'ChessGameRepository',
      );

      return Right(count);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get games count',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get games count: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, ChessGameEntity>> watchGame(String uuid) async* {
    try {
      AppLogger.info(
        'Repository: Watching game $uuid',
        tag: 'ChessGameRepository',
      );

      yield* localDataSource.watchGame(uuid).map((model) {
        if (model == null) {
          return Left(NotFoundFailure(message: 'Game not found: $uuid'));
        }
        return Right(model.toEntity());
      });
      // .handleError((error)   {
      //   AppLogger.error(
      //     'Repository: Error watching game',
      //     error: error,
      //     stackTrace: stackTrace,
      //     tag: 'ChessGameRepository',
      //   );
      //   return Left(
      //     DatabaseFailure(
      //       message: 'Failed to watch game: ${error.toString()}',
      //     ),
      //   );
      // });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to setup game watch',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      yield* Stream.value(
        Left(DatabaseFailure(message: 'Failed to watch game: ${e.toString()}')),
      );
    }
  }

  @override
  Stream<Either<Failure, List<ChessGameEntity>>> watchAllGames() async* {
    try {
      AppLogger.info(
        'Repository: Watching all games',
        tag: 'ChessGameRepository',
      );

      yield* localDataSource.watchAllGames().map((models) {
        final entities = models.map((m) => m.toEntity()).toList();
        return Right(entities);
      });
      // .handleError((error, stackTrace) {
      //   AppLogger.error(
      //     'Repository: Error watching all games',
      //     error: error,
      //     stackTrace: stackTrace,
      //     tag: 'ChessGameRepository',
      //   );
      //   return Left(
      //     DatabaseFailure(
      //       message: 'Failed to watch games: ${error.toString()}',
      //     ),
      //   );
      // });
      // yield* data;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to setup all games watch',
        error: e,
        stackTrace: stackTrace,
        tag: 'ChessGameRepository',
      );

      yield* Stream.value(
        Left(
          DatabaseFailure(message: 'Failed to watch games: ${e.toString()}'),
        ),
      );
    }
  }
}
