import 'package:chessground_game_app/data/collections/chess_game.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../../../core/utils/dialog/game_status.dart';
import '../../core/utils/game_state/game_state.dart';
import '../../../../domain/entities/chess_game_entity.dart';

abstract class FreeGameRepository {
  Future<Either<Failure, ChessGame>> createNewGame();

  Stream<Either<Failure, GameStatus>> get gameStatus;

  Either<Failure, Move> get moves;

  void play(Move move, {String? comment, List<int>? nags});
  Future<Either<Failure, ChessGameEntity>> loadGame(String uuid);
  Future<Either<Failure, ChessGameEntity>> saveGame(ChessGameEntity game);
  Future<Either<Failure, ChessGameEntity>> saveGameStateFromGameState(
    String uuid,
    GameState state,
  );
  Stream<ChessGameEntity> watchGame(String uuid);
  Future<Either<Failure, String>> analyzeWithStockfish(String fen, int depth);
}
