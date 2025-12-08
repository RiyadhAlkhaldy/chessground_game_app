// lib/features/analysis/domain/usecases/game_analysis/get_game_analysis_usecase.dart

import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/utils/logger.dart';

/// Use case for getting game analysis
/// حالة استخدام للحصول على تحليل اللعبة
class GetGameAnalysisUseCase
    implements UseCase<GameAnalysisEntity?, GetGameAnalysisParams> {
  final GameAnalysisRepository repository;

  GetGameAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, GameAnalysisEntity?>> call(
    GetGameAnalysisParams params,
  ) async {
    try {
      AppLogger.info(
        'UseCase: Getting analysis for game: ${params.gameUuid}',
        tag: 'GetGameAnalysisUseCase',
      );

      // Validate
      if (params.gameUuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      final result = await repository.getAnalysisByGameUuid(params.gameUuid);

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get analysis - ${failure.message}',
          tag: 'GetGameAnalysisUseCase',
        ),
        (analysis) => AppLogger.info(
          'UseCase: Analysis retrieved - ${analysis != null ? "found" : "not found"}',
          tag: 'GetGameAnalysisUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetGameAnalysisUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to get analysis: ${e.toString()}'),
      );
    }
  }
}

class GetGameAnalysisParams extends Equatable {
  final String gameUuid;

  const GetGameAnalysisParams({required this.gameUuid});

  @override
  List<Object?> get props => [gameUuid];
}
