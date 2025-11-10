// lib/domain/usecases/game/get_recent_games_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/chess_game_entity.dart';
import '../repositories/chess_game_repository.dart';
import 'usecase.dart';

/// Use case for retrieving recent games
/// حالة استخدام لاسترجاع الألعاب الأخيرة
class GetRecentGamesUseCase
    implements UseCase<List<ChessGameEntity>, GetRecentGamesParams> {
  final ChessGameRepository repository;

  GetRecentGamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChessGameEntity>>> call(
    GetRecentGamesParams params,
  ) async {
    try {
      AppLogger.info(
        'Fetching recent games (limit: ${params.limit})',
        tag: 'GetRecentGamesUseCase',
      );

      final result = await repository.getRecentGames(limit: params.limit);

      result.fold(
        (failure) => AppLogger.error(
          'Failed to fetch recent games: ${failure.message}',
          tag: 'GetRecentGamesUseCase',
        ),
        (games) => AppLogger.info(
          'Fetched ${games.length} recent games',
          tag: 'GetRecentGamesUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetRecentGamesUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetRecentGamesUseCase',
      );
      return Left(
        DatabaseFailure(
          message: 'Failed to fetch recent games: ${e.toString()}',
        ),
      );
    }
  }
}

class GetRecentGamesParams extends Equatable {
  final int limit;

  const GetRecentGamesParams({this.limit = 20});

  @override
  List<Object?> get props => [limit];
}
