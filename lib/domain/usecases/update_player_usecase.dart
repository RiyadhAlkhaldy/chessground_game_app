// lib/domain/usecases/player/update_player_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/player_entity.dart';
import '../repositories/player_repository.dart';
import 'usecase.dart';

/// Use case for updating a player
/// حالة استخدام لتحديث لاعب
class UpdatePlayerUseCase implements UseCase<PlayerEntity, UpdatePlayerParams> {
  final PlayerRepository repository;

  UpdatePlayerUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerEntity>> call(UpdatePlayerParams params) async {
    try {
      AppLogger.info(
        'Updating player: ${params.player.name}',
        tag: 'UpdatePlayerUseCase',
      );

      final result = await repository.updatePlayer(params.player);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to update player: ${failure.message}',
          tag: 'UpdatePlayerUseCase',
        ),
        (player) => AppLogger.info(
          'Player updated successfully: ${player.name}',
          tag: 'UpdatePlayerUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in UpdatePlayerUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'UpdatePlayerUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to update player: ${e.toString()}'),
      );
    }
  }
}

class UpdatePlayerParams extends Equatable {
  final PlayerEntity player;

  const UpdatePlayerParams({required this.player});

  @override
  List<Object?> get props => [player];
}
