// lib/domain/usecases/play_move.dart
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/chess_game_entity.dart';
import '../repositories/game_repository.dart';
import '../../core/utils/game_state/game_state.dart';

class PlayMove {
  final GameRepository repository;
  PlayMove(this.repository);

  /// يلعب الحركة داخلياً على GameState ثم يحفظ الحالة في الـ repository
  Future<Either<Failure, ChessGameEntity>> call({
    required ChessGameEntity chessGameEntity,
    required GameState state,
    required Move move, // dartchess Move object
    String? comment,
    List<int>? nags,
    // bool persist = true,
  }) async {
    state.play(move, comment: comment, nags: nags);

    final saved = repository.persistGameState(chessGameEntity, state);
    return saved;
  }
}
