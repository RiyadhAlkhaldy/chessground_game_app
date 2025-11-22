// lib/domain/usecases/game_state/get_cached_game_state_usecase.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/game_state_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_state_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; 

/// Use case for retrieving cached game state
/// حالة استخدام لاسترجاع حالة اللعبة من الذاكرة المؤقتة
class GetCachedGameStateUseCase
    implements UseCase<GameStateEntity, GetCachedGameStateParams> {
  final GameStateRepository repository;

  GetCachedGameStateUseCase(this.repository);

  @override
  Future<Either<Failure, GameStateEntity>> call(
    GetCachedGameStateParams params,
  ) async {
    try {
      AppLogger.debug(
        'Retrieving cached game state: ${params.gameUuid}',
        tag: 'GetCachedGameStateUseCase',
      );

      if (params.gameUuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      final result = await repository.getCachedGameState(params.gameUuid);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to retrieve cached game state: ${failure.message}',
          tag: 'GetCachedGameStateUseCase',
        ),
        (state) => AppLogger.debug(
          'Game state retrieved from cache: ${state.gameUuid}',
          tag: 'GetCachedGameStateUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetCachedGameStateUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetCachedGameStateUseCase',
      );
      return Left(
        CacheFailure(
          message: 'Failed to retrieve cached game state: ${e.toString()}',
        ),
      );
    }
  }
}

class GetCachedGameStateParams extends Equatable {
  final String gameUuid;

  const GetCachedGameStateParams({required this.gameUuid});

  @override
  List<Object?> get props => [gameUuid];
}
