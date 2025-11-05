import 'package:chessground_game_app/data/collections/chess_game.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/dialog/game_status.dart';

abstract class FreeGameRepository {

  Future<Either<Failure, ChessGame>> createNewGame();       


  Stream<Either<Failure, GameStatus>> get gameStatus;

  Either<Failure, Move> get moves;

  void play(Move move, {String? comment, List<int>? nags});
}
