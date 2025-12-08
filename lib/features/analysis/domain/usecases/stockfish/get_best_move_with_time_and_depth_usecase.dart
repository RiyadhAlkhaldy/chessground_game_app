import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/engine_move_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for getting best move with both time and depth constraints
/// حالة استخدام للحصول على أفضل حركة مع قيود الوقت والعمق
class GetBestMoveWithTimeAndDepthUseCase
    implements UseCase<EngineMoveEntity, GetBestMoveWithTimeAndDepthParams> {
  final StockfishRepository repository;

  GetBestMoveWithTimeAndDepthUseCase(this.repository);

  @override
  Future<Either<Failure, EngineMoveEntity>> call(
    GetBestMoveWithTimeAndDepthParams params,
  ) async {
    try {
      AppLogger.info(
        'UseCase: Getting best move with depth ${params.depth} and time ${params.timeMilliseconds}ms',
        tag: 'GetBestMoveWithTimeAndDepthUseCase',
      );

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Left(ValidationFailure(message: 'FEN cannot be empty'));
      }

      // Validate depth
      if (params.depth <= 0 || params.depth > 100) {
        return Left(
          ValidationFailure(message: 'Depth must be between 1 and 100'),
        );
      }

      // Validate time limit
      if (params.timeMilliseconds <= 0) {
        return Left(ValidationFailure(message: 'Time limit must be positive'));
      }

      final result = await repository.getBestMoveWithTimeAndDepth(
        fen: params.fen,
        depth: params.depth,
        timeMilliseconds: params.timeMilliseconds,
      );

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get best move - ${failure.message}',
          tag: 'GetBestMoveWithTimeAndDepthUseCase',
        ),
        (move) => AppLogger.info(
          'UseCase: Best move retrieved (depth+time) - ${move.uci}',
          tag: 'GetBestMoveWithTimeAndDepthUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetBestMoveWithTimeAndDepthUseCase',
      );

      return Left(
        DatabaseFailure(
          message:
              'Failed to get best move with time and depth: ${e.toString()}',
        ),
      );
    }
  }
}

class GetBestMoveWithTimeAndDepthParams extends Equatable {
  final String fen;
  final int depth;
  final int timeMilliseconds;

  const GetBestMoveWithTimeAndDepthParams({
    required this.fen,
    required this.depth,
    required this.timeMilliseconds,
  });

  @override
  List<Object?> get props => [fen, depth, timeMilliseconds];
}
