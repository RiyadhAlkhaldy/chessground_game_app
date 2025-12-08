// lib/features/analysis/domain/usecases/game_analysis/get_all_analyses_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/utils/logger.dart';

/// Use case for getting all game analyses
/// حالة استخدام للحصول على جميع تحليلات الألعاب
class GetAllAnalysesUseCase
    implements NoParamsUseCase<List<GameAnalysisEntity>> {
  final GameAnalysisRepository repository;

  GetAllAnalysesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GameAnalysisEntity>>> call() async {
    try {
      AppLogger.info(
        'UseCase: Getting all analyses',
        tag: 'GetAllAnalysesUseCase',
      );

      final result = await repository.getAllAnalyses();

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get analyses - ${failure.message}',
          tag: 'GetAllAnalysesUseCase',
        ),
        (analyses) => AppLogger.info(
          'UseCase: Retrieved ${analyses.length} analyses',
          tag: 'GetAllAnalysesUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetAllAnalysesUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to get analyses: ${e.toString()}'),
      );
    }
  }
}
