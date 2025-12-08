// lib/features/analysis/data/repositories/game_analysis_repository_impl.dart

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
  Future<Either<Failure, GameAnalysisEntity>> saveAnalysis(
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

      return Right(analysis);
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
  Future<Either<Failure, List<GameAnalysisEntity>>> getAllAnalyses() async {
    try {
      AppLogger.info(
        'Repository: Getting all analyses',
        tag: 'GameAnalysisRepository',
      );

      final models = await localDataSource.getAllAnalyses();
      final entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Error getting all analyses',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get analyses: ${e.toString()}',
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

///}}Implementation of GameAnalysisRepository
/// تنفيذ مستودع تحليل الألعاب
// class GameAnalysisRepositoryImpll implements GameAnalysisRepository {
//   final GameAnalysisDataSource dataSource;

//   GameAnalysisRepositoryImpll({required this.dataSource});

//   @override
//   Future<Either<Failure, GameAnalysisEntity>> saveAnalysis(
//     GameAnalysisEntity analysis,
//   ) async {
//     try {
//       AppLogger.info(
//         'Repository: Saving game analysis',
//         tag: 'GameAnalysisRepository',
//       );

//       final model = analysis.toModel();
//       final saved = await dataSource.saveAnalysis(model);

//       AppLogger.info(
//         'Repository: Analysis saved successfully',
//         tag: 'GameAnalysisRepository',
//       );

//       return Right(saved.toEntity());
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Repository: Error saving analysis',
//         error: e,
//         stackTrace: stackTrace,
//         tag: 'GameAnalysisRepository',
//       );

//       return Left(
//         DatabaseFailure(
//           message: 'Failed to save analysis: ${e.toString()}',
//           details: e,
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, GameAnalysisEntity?>> getAnalysisByGameUuid(
//     String gameUuid,
//   ) async {
//     try {
//       AppLogger.info(
//         'Repository: Getting analysis for game: $gameUuid',
//         tag: 'GameAnalysisRepository',
//       );

//       final model = await dataSource.getAnalysisByGameUuid(gameUuid);

//       if (model == null) {
//         return const Right(null);
//       }

//       return Right(model.toEntity());
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Repository: Error getting analysis',
//         error: e,
//         stackTrace: stackTrace,
//         tag: 'GameAnalysisRepository',
//       );

//       return Left(
//         DatabaseFailure(
//           message: 'Failed to get analysis: ${e.toString()}',
//           details: e,
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, List<GameAnalysisEntity>>> getAllAnalyses() async {
//     try {
//       AppLogger.info(
//         'Repository: Getting all analyses',
//         tag: 'GameAnalysisRepository',
//       );

//       final models = await dataSource.getAllAnalyses();
//       final entities = models.map((m) => m.toEntity()).toList();

//       return Right(entities);
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Repository: Error getting all analyses',
//         error: e,
//         stackTrace: stackTrace,
//         tag: 'GameAnalysisRepository',
//       );

//       return Left(
//         DatabaseFailure(
//           message: 'Failed to get analyses: ${e.toString()}',
//           details: e,
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteAnalysis(String gameUuid) async {
//     try {
//       AppLogger.info(
//         'Repository: Deleting analysis for game: $gameUuid',
//         tag: 'GameAnalysisRepository',
//       );

//       await dataSource.deleteAnalysis(gameUuid);

//       AppLogger.info(
//         'Repository: Analysis deleted successfully',
//         tag: 'GameAnalysisRepository',
//       );

//       return const Right(null);
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Repository: Error deleting analysis',
//         error: e,
//         stackTrace: stackTrace,
//         tag: 'GameAnalysisRepository',
//       );

//       return Left(
//         DatabaseFailure(
//           message: 'Failed to delete analysis: ${e.toString()}',
//           details: e,
//         ),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> hasAnalysis(String gameUuid) async {
//     try {
//       final exists = await dataSource.hasAnalysis(gameUuid);
//       return Right(exists);
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Repository: Error checking analysis existence',
//         error: e,
//         stackTrace: stackTrace,
//         tag: 'GameAnalysisRepository',
//       );

//       return Left(
//         DatabaseFailure(
//           message: 'Failed to check analysis: ${e.toString()}',
//           details: e,
//         ),
//       );
//     }
//   }
// }
