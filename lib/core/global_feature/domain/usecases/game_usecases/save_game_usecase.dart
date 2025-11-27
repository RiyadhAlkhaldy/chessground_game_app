// lib/domain/usecases/game/save_game_usecase.dart
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/chess_game_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for saving a chess game
/// حالة استخدام لحفظ لعبة شطرنج
class SaveGameUseCase implements UseCase<ChessGameEntity, SaveGameParams> {
  final ChessGameRepository repository;

  SaveGameUseCase(this.repository);

  @override
  Future<Either<Failure, ChessGameEntity>> call(SaveGameParams params) async {
    try {
      AppLogger.info('Saving game: ${params.game.uuid}', tag: 'SaveGameUseCase');

      // Validate game entity before saving
      final validation = _validateGame(params.game);
      if (validation != null) {
        AppLogger.error('Game validation failed: $validation', tag: 'SaveGameUseCase');
        return Left(ValidationFailure(message: validation));
      }

      final result = await repository.saveGame(params.game);

      // result.fold(
      //   (failure) => AppLogger.error(
      //     'Failed to save game: ${failure.message}',
      //     tag: 'SaveGameUseCase',
      //   ),
      //   (game) => AppLogger.info(
      //     'Game saved successfully: ${game.uuid}',
      //     tag: 'SaveGameUseCase',
      //   ),
      // );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in SaveGameUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'SaveGameUseCase',
      );
      return Left(DatabaseFailure(message: 'Failed to save game: ${e.toString()}'));
    }
  }

  /// Validate game entity
  /// التحقق من صحة كيان اللعبة
  String? _validateGame(ChessGameEntity game) {
    if (game.uuid.isEmpty) {
      return 'Game UUID cannot be empty';
    }

    if (game.whitePlayer.uuid.isEmpty) {
      return 'White player UUID cannot be empty';
    }

    if (game.blackPlayer.uuid.isEmpty) {
      return 'Black player UUID cannot be empty';
    }

    if (game.whitePlayer.name.isEmpty) {
      return 'White player name cannot be empty';
    }

    if (game.blackPlayer.name.isEmpty) {
      return 'Black player name cannot be empty';
    }

    return null;
  }
}

/// Parameters for SaveGameUseCase
/// معاملات حالة استخدام حفظ اللعبة
class SaveGameParams extends Equatable {
  final ChessGameEntity game;

  const SaveGameParams({required this.game});

  @override
  List<Object?> get props => [game];
}
