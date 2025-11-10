// lib/domain/usecases/game/update_game_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/chess_game_entity.dart';
import '../repositories/chess_game_repository.dart';
import 'usecase.dart';

/// Use case for updating an existing chess game
/// حالة استخدام لتحديث لعبة شطرنج موجودة
class UpdateGameUseCase implements UseCase<ChessGameEntity, UpdateGameParams> {
  final ChessGameRepository repository;

  UpdateGameUseCase(this.repository);

  @override
  Future<Either<Failure, ChessGameEntity>> call(UpdateGameParams params) async {
    try {
      AppLogger.info(
        'Updating game: ${params.game.uuid}',
        tag: 'UpdateGameUseCase',
      );

      final result = await repository.updateGame(params.game);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to update game: ${failure.message}',
          tag: 'UpdateGameUseCase',
        ),
        (game) {
          AppLogger.info(
            'Game updated successfully: ${game.uuid}',
            tag: 'UpdateGameUseCase',
          );
          AppLogger.gameEvent(
            'GameUpdated',
            data: {
              'uuid': game.uuid,
              'movesCount': game.movesCount,
              'result': game.result,
            },
          );
        },
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in UpdateGameUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'UpdateGameUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to update game: ${e.toString()}'),
      );
    }
  }
}

/// Parameters for UpdateGameUseCase
class UpdateGameParams extends Equatable {
  final ChessGameEntity game;

  const UpdateGameParams({required this.game});

  @override
  List<Object?> get props => [game];
}
