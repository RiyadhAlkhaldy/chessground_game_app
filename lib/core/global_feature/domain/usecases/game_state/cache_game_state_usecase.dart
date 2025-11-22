// lib/domain/usecases/game_state/cache_game_state_usecase.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/game_state_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_state_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; 
/// Use case for caching game state
/// حالة استخدام لحفظ حالة اللعبة في الذاكرة المؤقتة
class CacheGameStateUseCase implements UseCase<void, CacheGameStateParams> {
  final GameStateRepository repository;

  CacheGameStateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CacheGameStateParams params) async {
    try {
      AppLogger.debug(
        'Caching game state: ${params.state.gameUuid}',
        tag: 'CacheGameStateUseCase',
      );

      final result = await repository.cacheGameState(params.state);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to cache game state: ${failure.message}',
          tag: 'CacheGameStateUseCase',
        ),
        (_) => AppLogger.debug(
          'Game state cached: ${params.state.gameUuid}',
          tag: 'CacheGameStateUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in CacheGameStateUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'CacheGameStateUseCase',
      );
      return Left(
        CacheFailure(message: 'Failed to cache game state: ${e.toString()}'),
      );
    }
  }
}

class CacheGameStateParams extends Equatable {
  final GameStateEntity state;

  const CacheGameStateParams({required this.state});

  @override
  List<Object?> get props => [state];
}
