// lib/domain/usecases/play_move.dart
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../repositories/game_repository.dart';
import '../services/game_state/game_state.dart';

class PlayMove {
  final GameRepository repository;
  PlayMove(this.repository);

  /// يلعب الحركة داخلياً على GameState ثم يحفظ الحالة في الـ repository
  Future<Either<Failure, void>> call({
    required String gameUuid,
    required GameState state,
    required Move move, // dartchess Move object
    String? comment,
    List<int>? nags,
    bool persist = true,
  }) async {
    try {
      state.play(move, comment: comment, nags: nags);
      if (persist) {
        final saved = repository.persistGameState(gameUuid, state);
        return saved;
      } else {
        return Right(null);
      }
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
