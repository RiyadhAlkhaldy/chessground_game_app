import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/engine_move_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for getting best move for a position
/// حالة استخدام للحصول على أفضل حركة لموضع
class GetBestMoveUseCase
    implements UseCase<EngineMoveEntity, GetBestMoveParams> {
  final StockfishRepository repository;

  GetBestMoveUseCase(this.repository);

  @override
  Future<Either<Failure, EngineMoveEntity>> call(
    GetBestMoveParams params,
  ) async {
    try {
      AppLogger.info('UseCase: Getting best move', tag: 'GetBestMoveUseCase');

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Left(ValidationFailure(message: 'FEN cannot be empty'));
      }

      final result = await repository.getBestMove(
        fen: params.fen,
        depth: params.depth,
      );

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get best move - ${failure.message}',
          tag: 'GetBestMoveUseCase',
        ),
        (move) => AppLogger.info(
          'UseCase: Best move retrieved - ${move.uci}',
          tag: 'GetBestMoveUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetBestMoveUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to get best move: ${e.toString()}'),
      );
    }
  }
}

class GetBestMoveParams extends Equatable {
  final String fen;
  final int depth;

  const GetBestMoveParams({required this.fen, this.depth = 20});

  @override
  List<Object?> get props => [fen, depth];
}
