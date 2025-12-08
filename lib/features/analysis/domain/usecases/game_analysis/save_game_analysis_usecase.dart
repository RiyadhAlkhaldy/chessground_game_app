// lib/features/analysis/domain/usecases/game_analysis/save_game_analysis_usecase.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for saving game analysis
/// حالة استخدام لحفظ تحليل اللعبة
class SaveGameAnalysisUseCase
    implements UseCase<GameAnalysisEntity, SaveGameAnalysisParams> {
  final GameAnalysisRepository repository;

  SaveGameAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, GameAnalysisEntity>> call(
    SaveGameAnalysisParams params,
  ) async {
    try {
      AppLogger.info(
        'UseCase: Saving game analysis',
        tag: 'SaveGameAnalysisUseCase',
      );

      // Validate
      if (params.analysis.gameUuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      if (params.analysis.moveEvaluations.isEmpty) {
        return Left(ValidationFailure(message: 'No evaluations to save'));
      }

      final result = await repository.saveAnalysis(params.analysis);

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to save analysis - ${failure.message}',
          tag: 'SaveGameAnalysisUseCase',
        ),
        (analysis) => AppLogger.info(
          'UseCase: Analysis saved successfully',
          tag: 'SaveGameAnalysisUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'SaveGameAnalysisUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to save analysis: ${e.toString()}'),
      );
    }
  }
}

class SaveGameAnalysisParams extends Equatable {
  final GameAnalysisEntity analysis;

  const SaveGameAnalysisParams({required this.analysis});

  @override
  List<Object?> get props => [analysis];
}
