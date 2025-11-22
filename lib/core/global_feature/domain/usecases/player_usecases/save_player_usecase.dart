// lib/domain/usecases/player/save_player_usecase.dart
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/player_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for saving a player
/// حالة استخدام لحفظ لاعب
class SavePlayerUseCase implements UseCase<PlayerEntity, SavePlayerParams> {
  final PlayerRepository repository;

  SavePlayerUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerEntity>> call(SavePlayerParams params) async {
    try {
      AppLogger.info('Saving player: ${params.player.name}', tag: 'SavePlayerUseCase');

      // Validate player entity
      final validation = _validatePlayer(params.player);
      if (validation != null) {
        AppLogger.error('Player validation failed: $validation', tag: 'SavePlayerUseCase');
        return Left(ValidationFailure(message: validation));
      }

      final result = await repository.savePlayer(params.player);

      result.fold(
        (failure) =>
            AppLogger.error('Failed to save player: ${failure.message}', tag: 'SavePlayerUseCase'),
        (player) =>
            AppLogger.info('Player saved successfully: ${player.name}', tag: 'SavePlayerUseCase'),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in SavePlayerUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'SavePlayerUseCase',
      );
      return Left(DatabaseFailure(message: 'Failed to save player: ${e.toString()}'));
    }
  }

  /// Validate player entity
  /// التحقق من صحة كيان اللاعب
  String? _validatePlayer(PlayerEntity player) {
    if (player.uuid.isEmpty) {
      return 'Player UUID cannot be empty';
    }

    if (player.name.trim().isEmpty) {
      return 'Player name cannot be empty';
    }

    if (player.type.isEmpty) {
      return 'Player type cannot be empty';
    }

    final validTypes = ['guest', 'human', 'computer', 'registered'];
    if (!validTypes.contains(player.type.toLowerCase())) {
      return 'Invalid player type: ${player.type}';
    }

    if (player.playerRating < 0 || player.playerRating > 3500) {
      return 'Invalid player rating: ${player.playerRating}';
    }

    return null;
  }
}

class SavePlayerParams extends Equatable {
  final PlayerEntity player;

  const SavePlayerParams({required this.player});

  @override
  List<Object?> get props => [player];
}
