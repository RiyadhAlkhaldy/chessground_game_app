// lib/domain/usecases/player/update_player_rating_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/player_entity.dart';
import '../repositories/player_repository.dart';
import 'usecase.dart';

/// Use case for updating player rating
/// حالة استخدام لتحديث تصنيف اللاعب
class UpdatePlayerRatingUseCase
    implements UseCase<PlayerEntity, UpdatePlayerRatingParams> {
  final PlayerRepository repository;

  UpdatePlayerRatingUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerEntity>> call(
    UpdatePlayerRatingParams params,
  ) async {
    try {
      AppLogger.info(
        'Updating player rating: ${params.playerUuid} -> ${params.newRating}',
        tag: 'UpdatePlayerRatingUseCase',
      );

      // Validate rating
      if (params.newRating < 0 || params.newRating > 3500) {
        return Left(
          ValidationFailure(
            message: 'Invalid rating value: ${params.newRating}',
          ),
        );
      }

      final result = await repository.updatePlayerRating(
        params.playerUuid,
        params.newRating,
      );

      result.fold(
        (failure) => AppLogger.error(
          'Failed to update player rating: ${failure.message}',
          tag: 'UpdatePlayerRatingUseCase',
        ),
        (player) => AppLogger.info(
          'Player rating updated: ${player.name} = ${player.playerRating}',
          tag: 'UpdatePlayerRatingUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in UpdatePlayerRatingUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'UpdatePlayerRatingUseCase',
      );
      return Left(
        DatabaseFailure(
          message: 'Failed to update player rating: ${e.toString()}',
        ),
      );
    }
  }
}

class UpdatePlayerRatingParams extends Equatable {
  final String playerUuid;
  final int newRating;

  const UpdatePlayerRatingParams({
    required this.playerUuid,
    required this.newRating,
  });

  @override
  List<Object?> get props => [playerUuid, newRating];
}
