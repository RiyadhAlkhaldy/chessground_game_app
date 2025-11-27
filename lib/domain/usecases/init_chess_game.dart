import 'package:chessground_game_app/core/errors/failure.dart';
import 'package:chessground_game_app/domain/entities/chess_game_entity.dart';
import 'package:dartz/dartz.dart';

import '../../core/params/params.dart';
import '../repositories/game_repository.dart';

class InitChessGame {
  final GameRepository repository;
  InitChessGame(this.repository);
  Future<Either<Failure, ChessGameEntity>> call(
    InitChessGameParams chessGameEntity,
  ) async {
    final response = repository.initGameModel(chessGameEntity);

    return response;
  }
}
