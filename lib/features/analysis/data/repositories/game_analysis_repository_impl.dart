import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/data/datasources/game_analysis_local_datasource.dart';
import 'package:chessground_game_app/features/analysis/data/models/game_analysis_model.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of GameAnalysisRepository
/// تنفيذ مستودع تحليل اللعبة
class GameAnalysisRepositoryImpl implements GameAnalysisRepository {
  final GameAnalysisLocalDataSource localDataSource;

  GameAnalysisRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveAnalysis(
    GameAnalysisEntity analysis,
  ) async {
    try {
      AppLogger.info(
        'Repository: Saving game analysis',
        tag: 'GameAnalysisRepository',
      );

      // Convert entity to model
      final model = analysis.toModel();

      await localDataSource.saveAnalysis(model);

      AppLogger.info(
        'Repository: Game analysis saved successfully',
        tag: 'GameAnalysisRepository',
      );

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to save game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to save game analysis: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, GameAnalysisEntity>> getAnalysisByGameUuid(
    String gameUuid,
  ) async {
    try {
      AppLogger.info(
        'Repository: Fetching analysis for game: $gameUuid',
        tag: 'GameAnalysisRepository',
      );

      final model = await localDataSource.getAnalysisByGameUuid(gameUuid);

      if (model == null) {
        return Left(
          NotFoundFailure(message: 'No analysis found for game: $gameUuid'),
        );
      }

      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Analysis retrieved successfully',
        tag: 'GameAnalysisRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to fetch game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to fetch game analysis: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnalysis(String gameUuid) async {
    try {
      AppLogger.info(
        'Repository: Deleting analysis for game: $gameUuid',
        tag: 'GameAnalysisRepository',
      );

      await localDataSource.deleteAnalysis(gameUuid);

      AppLogger.info(
        'Repository: Analysis deleted successfully',
        tag: 'GameAnalysisRepository',
      );

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to delete game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to delete game analysis: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasAnalysis(String gameUuid) async {
    try {
      final exists = await localDataSource.hasAnalysis(gameUuid);
      return Right(exists);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to check if analysis exists',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to check if analysis exists: ${e.toString()}',
          details: e,
        ),
      );
    }
  }
}
