// lib/domain/usecases/player/get_player_by_uuid_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/player_entity.dart';
import '../repositories/player_repository.dart';
import 'usecase.dart';

/// Use case for retrieving a player by UUID
/// حالة استخدام لاسترجاع لاعب باستخدام UUID
class GetPlayerByUuidUseCase
    implements UseCase<PlayerEntity, GetPlayerByUuidParams> {
  final PlayerRepository repository;

  GetPlayerByUuidUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerEntity>> call(
    GetPlayerByUuidParams params,
  ) async {
    try {
      AppLogger.info(
        'Fetching player: ${params.uuid}',
        tag: 'GetPlayerByUuidUseCase',
      );

      if (params.uuid.isEmpty) {
        return Left(ValidationFailure(message: 'Player UUID cannot be empty'));
      }

      final result = await repository.getPlayerByUuid(params.uuid);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to fetch player: ${failure.message}',
          tag: 'GetPlayerByUuidUseCase',
        ),
        (player) => AppLogger.info(
          'Player fetched successfully: ${player.name}',
          tag: 'GetPlayerByUuidUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetPlayerByUuidUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetPlayerByUuidUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to fetch player: ${e.toString()}'),
      );
    }
  }
}

class GetPlayerByUuidParams extends Equatable {
  final String uuid;

  const GetPlayerByUuidParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
