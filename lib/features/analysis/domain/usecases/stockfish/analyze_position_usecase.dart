import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for analyzing a chess position
/// حالة استخدام لتحليل موضع شطرنج
class AnalyzePositionUseCase
    implements UseCase<EngineEvaluationEntity, AnalyzePositionParams> {
  final StockfishRepository repository;

  AnalyzePositionUseCase(this.repository);

  @override
  Future<Either<Failure, EngineEvaluationEntity>> call(
    AnalyzePositionParams params,
  ) async {
    try {
      AppLogger.info(
        'UseCase: Analyzing position',
        tag: 'AnalyzePositionUseCase',
      );

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Left(ValidationFailure(message: 'FEN cannot be empty'));
      }

      // Validate depth
      if (params.depth < 1 || params.depth > 50) {
        return Left(
          ValidationFailure(message: 'Depth must be between 1 and 50'),
        );
      }

      final result = await repository.analyzePosition(
        fen: params.fen,
        depth: params.depth,
        timeLimit: params.timeLimit,
      );

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Analysis failed - ${failure.message}',
          tag: 'AnalyzePositionUseCase',
        ),
        (evaluation) => AppLogger.info(
          'UseCase: Analysis complete - ${evaluation.evaluationString}',
          tag: 'AnalyzePositionUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'AnalyzePositionUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to analyze position: ${e.toString()}'),
      );
    }
  }
}

class AnalyzePositionParams extends Equatable {
  final String fen;
  final int depth;
  final int? timeLimit;

  const AnalyzePositionParams({
    required this.fen,
    this.depth = 20,
    this.timeLimit,
  });

  @override
  List<Object?> get props => [fen, depth, timeLimit];
}
