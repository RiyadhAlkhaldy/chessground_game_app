// lib/domain/usecases/game/get_all_games_usecase.dart

import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/logger.dart';
import '../entities/chess_game_entity.dart';
import '../repositories/chess_game_repository.dart';
import 'usecase.dart';

/// Use case for retrieving all games
/// حالة استخدام لاسترجاع جميع الألعاب
class GetAllGamesUseCase implements NoParamsUseCase<List<ChessGameEntity>> {
  final ChessGameRepository repository;

  GetAllGamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChessGameEntity>>> call() async {
    try {
      AppLogger.info('Fetching all games', tag: 'GetAllGamesUseCase');

      final result = await repository.getAllGames();

      result.fold(
        (failure) => AppLogger.error(
          'Failed to fetch games: ${failure.message}',
          tag: 'GetAllGamesUseCase',
        ),
        (games) => AppLogger.info(
          'Fetched ${games.length} games',
          tag: 'GetAllGamesUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in GetAllGamesUseCase',
        error: e,
        stackTrace: stackTrace,
        tag: 'GetAllGamesUseCase',
      );
      return Left(
        DatabaseFailure(message: 'Failed to fetch games: ${e.toString()}'),
      );
    }
  }
}
