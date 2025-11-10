// lib/domain/usecases/player/get_or_create_guest_player_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/player_entity.dart';
import '../repositories/player_repository.dart';
import 'usecase.dart';

/// Use case for getting or creating a guest player
/// حالة استخدام للحصول على لاعب ضيف أو إنشائه
class GetOrCreateGuestPlayerUseCase
    implements UseCase<PlayerEntity, GetOrCreateGuestPlayerParams> {
  final PlayerRepository repository;

  GetOrCreateGuestPlayerUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerEntity>> call(
    GetOrCreateGuestPlayerParams params,
  ) async {
    try {
      AppLogger.info(
        'Getting or creating guest player: ${params.name}',
        tag: 'GetOrCreateGuestPlayerUseCase',
      );

      if (params.name.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Guest player name cannot be empty'),
        );
      }

      final result = await repository.getOrCreateGuestPlayer(params.name);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to get/create guest player: ${failure.message}',
          tag: 'GetOrCreateGuestPlayerUseCase',
        ),
        (player) => AppLogger.info(
          'Guest player ready: ${player.name}',
          tag: 'GetOrCreateGuestPlayerUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetOrCreateGuestPlayerUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetOrCreateGuestPlayerUseCase',
      );
      return Left(
        DatabaseFailure(
          message: 'Failed to get/create guest player: ${e.toString()}',
        ),
      );
    }
  }
}

class GetOrCreateGuestPlayerParams extends Equatable {
  final String name;

  const GetOrCreateGuestPlayerParams({required this.name});

  @override
  List<Object?> get props => [name];
}
