// lib/domain/usecases/game/delete_game_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../repositories/chess_game_repository.dart' show ChessGameRepository;
import 'usecase.dart';

/// Use case for deleting a game
/// حالة استخدام لحذف لعبة
class DeleteGameUseCase implements UseCase<bool, DeleteGameParams> {
  final ChessGameRepository repository;

  DeleteGameUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteGameParams params) async {
    try {
      AppLogger.info('Deleting game: ${params.uuid}', tag: 'DeleteGameUseCase');

      if (params.uuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      final result = await repository.deleteGame(params.uuid);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to delete game: ${failure.message}',
          tag: 'DeleteGameUseCase',
        ),
        (success) => AppLogger.info(
          'Game deleted successfully: ${params.uuid}',
          tag: 'DeleteGameUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in DeleteGameUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'DeleteGameUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to delete game: ${e.toString()}'),
      );
    }
  }
}

class DeleteGameParams extends Equatable {
  final String uuid;

  const DeleteGameParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
