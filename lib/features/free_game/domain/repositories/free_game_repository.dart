import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/utils/dialog/game_status.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

abstract class FreeGameRepository {
  Future<Either<Failure, ChessGame>> createNewGame();

  Stream<Either<Failure, GameStatus>> get gameStatus;

  Either<Failure, Move> get moves;

  void play(Move move, {String? comment, List<int>? nags});
  Future<Either<Failure, ChessGameEntity>> loadGame(String uuid);
  Future<Either<Failure, ChessGameEntity>> saveGame(ChessGameEntity game);
  Future<Either<Failure, ChessGameEntity>> saveGameStateFromGameState(String uuid, GameState state);
  Stream<ChessGameEntity> watchGame(String uuid);
  Future<Either<Failure, String>> analyzeWithStockfish(String fen, int depth);
}
