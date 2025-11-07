// lib/domain/repositories/game_repository.dart

import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../core/params/params.dart';
import '../entities/chess_game_entity.dart';
import '../services/game_state/game_state.dart';

abstract class GameRepository {
  Future<Either<Failure, ChessGameEntity>> initGameModel(InitChessGameParams chessGameEntity);
  Future<Either<Failure, ChessGameEntity>> loadGameByUuid(String uuid);
  Future<Either<Failure, ChessGameEntity>> saveGameEntity(ChessGameEntity game);

  /// حفظ حالة GameState كاملة (يحول داخل الـ repo إلى ChessGameEntity ثم يحفظ)
  Future<Either<Failure, ChessGameEntity>> persistGameState(
    String uuid,
    GameState state,
  );
  Future<Either<Failure, String>> analyzeFen(String fen, {int depth});
  Stream<ChessGameEntity> watchGame(String uuid);
}
