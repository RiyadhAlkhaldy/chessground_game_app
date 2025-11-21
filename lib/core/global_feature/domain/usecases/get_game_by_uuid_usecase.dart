// lib/domain/usecases/game/get_game_by_uuid_usecase.dart
 import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/chess_game_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for retrieving a game by UUID
/// حالة استخدام لاسترجاع لعبة باستخدام UUID
class GetGameByUuidUseCase
    implements UseCase<ChessGameEntity, GetGameByUuidParams> {
  final ChessGameRepository repository;

  GetGameByUuidUseCase(this.repository);

  @override
  Future<Either<Failure, ChessGameEntity>> call(
    GetGameByUuidParams params,
  ) async {
    try {
      AppLogger.info(
        'Fetching game: ${params.uuid}',
        tag: 'GetGameByUuidUseCase',
      );

      if (params.uuid.isEmpty) {
        return Left(ValidationFailure(message: 'Game UUID cannot be empty'));
      }

      final result = await repository.getGameByUuid(params.uuid);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to fetch game: ${failure.message}',
          tag: 'GetGameByUuidUseCase',
        ),
        (game) => AppLogger.info(
          'Game fetched successfully: ${game.uuid}',
          tag: 'GetGameByUuidUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetGameByUuidUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetGameByUuidUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to fetch game: ${e.toString()}'),
      );
    }
  }
}

class GetGameByUuidParams extends Equatable {
  final String uuid;

  const GetGameByUuidParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
