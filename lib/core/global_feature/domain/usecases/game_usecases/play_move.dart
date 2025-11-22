// lib/domain/usecases/play_move.dart
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_repository.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

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
