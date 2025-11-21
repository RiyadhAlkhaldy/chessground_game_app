// lib/domain/usecases/game_state/remove_cached_game_state_usecase.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_state_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
 
/// Use case for removing cached game state
/// حالة استخدام لإزالة حالة اللعبة من الذاكرة المؤقتة
class RemoveCachedGameStateUseCase
    implements UseCase<void, RemoveCachedGameStateParams> {
  final GameStateRepository repository;

  RemoveCachedGameStateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveCachedGameStateParams params) async {
    try {
      AppLogger.debug(
        'Removing cached game state: ${params.gameUuid}',
        tag: 'RemoveCachedGameStateUseCase',
      );

      final result = await repository.removeCachedGameState(params.gameUuid);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to remove cached game state: ${failure.message}',
          tag: 'RemoveCachedGameStateUseCase',
        ),
        (_) => AppLogger.debug(
          'Game state removed from cache: ${params.gameUuid}',
          tag: 'RemoveCachedGameStateUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in RemoveCachedGameStateUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'RemoveCachedGameStateUseCase',
      );
      return Left(
        CacheFailure(
          message: 'Failed to remove cached game state: ${e.toString()}',
        ),
      );
    }
  }
}

class RemoveCachedGameStateParams extends Equatable {
  final String gameUuid;

  const RemoveCachedGameStateParams({required this.gameUuid});

  @override
  List<Object?> get props => [gameUuid];
}
