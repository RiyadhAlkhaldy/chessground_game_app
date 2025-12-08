// lib/features/analysis/domain/usecases/game_analysis/delete_game_analysis_usecase.dart

import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/utils/logger.dart';

/// Use case for deleting game analysis
/// حالة استخدام لحذف تحليل اللعبة
class DeleteGameAnalysisUseCase
    implements UseCase<void, DeleteGameAnalysisParams> {
  final GameAnalysisRepository repository;

  DeleteGameAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteGameAnalysisParams params) async {
    try {
      AppLogger.info(
        'UseCase: Deleting analysis for game: ${params.gameUuid}',
        tag: 'DeleteGameAnalysisUseCase',
      );

      // Validate
      if (params.gameUuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      final result = await repository.deleteAnalysis(params.gameUuid);

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to delete analysis - ${failure.message}',
          tag: 'DeleteGameAnalysisUseCase',
        ),
        (_) => AppLogger.info(
          'UseCase: Analysis deleted successfully',
          tag: 'DeleteGameAnalysisUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'DeleteGameAnalysisUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to delete analysis: ${e.toString()}'),
      );
    }
  }
}

class DeleteGameAnalysisParams extends Equatable {
  final String gameUuid;

  const DeleteGameAnalysisParams({required this.gameUuid});

  @override
  List<Object?> get props => [gameUuid];
}
