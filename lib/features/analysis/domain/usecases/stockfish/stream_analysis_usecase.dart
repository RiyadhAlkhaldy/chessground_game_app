import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for streaming real-time analysis
/// حالة استخدام لدفق التحليل في الوقت الفعلي
class StreamAnalysisUseCase
    implements StreamUseCase<EngineEvaluationEntity, StreamAnalysisParams> {
  final StockfishRepository repository;

  StreamAnalysisUseCase(this.repository);

  @override
  Stream<Either<Failure, EngineEvaluationEntity>> call(
    StreamAnalysisParams params,
  ) {
    try {
      AppLogger.info(
        'UseCase: Starting analysis stream',
        tag: 'StreamAnalysisUseCase',
      );

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Stream.value(
          Left(ValidationFailure(message: 'FEN cannot be empty')),
        );
      }

      return repository.streamAnalysis(
        fen: params.fen,
        maxDepth: params.maxDepth,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Failed to start analysis stream',
        error: e,
        stackTrace: stackTrace,
        tag: 'StreamAnalysisUseCase',
      );

      return Stream.value(
        Left(
          DatabaseFailure(
            message: 'Failed to start analysis stream: ${e.toString()}',
          ),
        ),
      );
    }
  }
}

class StreamAnalysisParams extends Equatable {
  final String fen;
  final int maxDepth;

  const StreamAnalysisParams({required this.fen, this.maxDepth = 25});

  @override
  List<Object?> get props => [fen, maxDepth];
}
