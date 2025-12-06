import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for saving game analysis to database
/// حالة استخدام لحفظ تحليل اللعبة في قاعدة البيانات
class SaveGameAnalysisUseCase implements UseCase<void, SaveGameAnalysisParams> {
  final GameAnalysisRepository repository;

  SaveGameAnalysisUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveGameAnalysisParams params) async {
    try {
      AppLogger.info(
        'UseCase: Saving game analysis',
        tag: 'SaveGameAnalysisUseCase',
      );

      // Validation
      if (params.analysis.gameUuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      if (params.analysis.moveEvaluations.isEmpty) {
        return Left(
          ValidationFailure(message: 'Move evaluations cannot be empty'),
        );
      }

      final result = await repository.saveAnalysis(params.analysis);

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to save analysis - ${failure.message}',
          tag: 'SaveGameAnalysisUseCase',
        ),
        (_) => AppLogger.info(
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
        DatabaseFailure(
          message: 'Failed to save game analysis: ${e.toString()}',
        ),
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
