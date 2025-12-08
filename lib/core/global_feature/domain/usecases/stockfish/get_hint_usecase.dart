import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_move_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for getting a hint (best move suggestion)
/// حالة استخدام للحصول على تلميح (اقتراح أفضل حركة)
class GetHintUseCase implements UseCase<EngineMoveEntity, GetHintParams> {
  final StockfishRepository repository;

  GetHintUseCase(this.repository);

  @override
  Future<Either<Failure, EngineMoveEntity>> call(GetHintParams params) async {
    try {
      AppLogger.info(
        'UseCase: Getting hint for position',
        tag: 'GetHintUseCase',
      );

      // Validate FEN
      if (params.fen.trim().isEmpty) {
        return Left(ValidationFailure(message: 'FEN cannot be empty'));
      }

      // Use lower depth for hints (faster)
      final result = await repository.getBestMove(
        fen: params.fen,
        depth: params.depth,
      );

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to get hint - ${failure.message}',
          tag: 'GetHintUseCase',
        ),
        (move) => AppLogger.info(
          'UseCase: Hint retrieved - ${move.uci}',
          tag: 'GetHintUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetHintUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to get hint: ${e.toString()}'),
      );
    }
  }
}

class GetHintParams extends Equatable {
  final String fen;
  final int depth;

  const GetHintParams({
    required this.fen,
    this.depth = 15, // Lower depth for faster hints
  });

  @override
  List<Object?> get props => [fen, depth];
}
