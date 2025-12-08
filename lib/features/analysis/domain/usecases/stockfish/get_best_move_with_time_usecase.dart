import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/engine_move_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for getting best move for a position with time limit
/// حالة استخدام للحصول على أفضل حركة لموضع مع حد زمني
class GetBestMoveWithTimeUseCase
    implements UseCase<EngineMoveEntity, GetBestMoveWithTimeParams> {
  final StockfishRepository repository;

  GetBestMoveWithTimeUseCase(this.repository);

  @override
  Future<Either<Failure, EngineMoveEntity>> call(
    GetBestMoveWithTimeParams params,
  ) async {
    try {
      AppLogger.info(
        'UseCase: Getting best move with time limit: ${params.timeMilliseconds}ms',
        tag: 'GetBestMoveWithTimeUseCase',
      );

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Left(ValidationFailure(message: 'FEN cannot be empty'));
      }

      // Validate time limit
      if (params.timeMilliseconds <= 0) {
        return Left(ValidationFailure(message: 'Time limit must be positive'));
      }

      final result = await repository.getBestMoveWithTime(
        fen: params.fen,
        timeMilliseconds: params.timeMilliseconds,
      );

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get best move with time - ${failure.message}',
          tag: 'GetBestMoveWithTimeUseCase',
        ),
        (move) => AppLogger.info(
          'UseCase: Best move retrieved (time-based) - ${move.uci}',
          tag: 'GetBestMoveWithTimeUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetBestMoveWithTimeUseCase',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get best move with time: ${e.toString()}',
        ),
      );
    }
  }
}

class GetBestMoveWithTimeParams extends Equatable {
  final String fen;
  final int timeMilliseconds;

  const GetBestMoveWithTimeParams({
    required this.fen,
    required this.timeMilliseconds,
  });

  @override
  List<Object?> get props => [fen, timeMilliseconds];
}
