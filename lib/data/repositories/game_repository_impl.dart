// lib/data/repositories/game_repository_impl.dart
import 'package:chessground_game_app/data/models/mappers/entities_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../core/params/params.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/services/game_state/game_state.dart';
import '../datasources/local_datasource.dart';
import '../datasources/stockfish_datasource.dart';
import '../models/chess_game_model.dart';
import '../models/move_data_model.dart';

class GameRepositoryImpl implements GameRepository {
  final LocalDataSource local;
  final StockfishDataSource stockfish;

  GameRepositoryImpl({required this.local, required this.stockfish});

  @override
  Future<Either<Failure, ChessGameEntity>> initGameModel(
    InitChessGameParams chessGameEntity,
  ) async {
    try {
      final model = await local.initGameModel(chessGameEntity);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> loadGameByUuid(String uuid) async {
    try {
      final model = await local.getGameModelByUuid(uuid);
      if (model == null) return Left(Failure(errMessage: 'Game not found'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> saveGameEntity(
    ChessGameEntity game,
  ) async {
    try {
      final model = ChessGameModel(
        id: game.id,
        uuid: game.uuid,
        event: game.event,
        site: game.site,
        date: game.date,
        round: game.round,
        whitePlayer: game.whitePlayer.toModel(),
        blackPlayer: game.blackPlayer.toModel(),
        result: game.result,
        termination: game.termination,
        eco: game.eco,
        whiteElo: game.whiteElo,
        blackElo: game.blackElo,
        timeControl: game.timeControl,
        startingFen: game.startingFen,
        fullPgn: game.fullPgn,
        movesCount: game.movesCount,
        moves: game.moves.map((m) => m.toModel()).toList(),
      );
      await local.saveChessGameModel(model);
      return Right(game);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChessGameEntity>> persistGameState(
    String uuid,
    GameState state,
  ) async {
    try {
      // تحويل GameState إلى ChessGameEntity
      final entity = _gameStateToEntity(uuid, state);
      final r = await saveGameEntity(entity);
      return r;
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> analyzeFen(
    String fen, {
    int depth = 15,
  }) async {
    try {
      stockfish.setPosition(fen: fen);
      late String bestMove;
      await stockfish.bestmoves.listen((best) {
        bestMove = best;
        // return Right(best);
      }).asFuture();
      return Right(bestMove);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Stream<ChessGameEntity> watchGame(String uuid) =>
      local.watchGameModel(uuid).map((m) => m.toEntity());

  // ---------- helper ----------
  ChessGameEntity _gameStateToEntity(String uuid, GameState state) {
    // Use GameState.public API to extract PGN, moves, fen, result...
    final fullPgn = state.pgnString();
    final startingFen = state.position.fen; // careful
    final movesModels = state.getMoveTokens.map((m) => m.toEntity()).toList();

    return ChessGameEntity(
      uuid: uuid,
      // players: not available here — caller should have attached players in state/entity
      whitePlayer: stateInitialPlayerToEntity(state, true),
      blackPlayer: stateInitialPlayerToEntity(state, false),
      fullPgn: fullPgn,
      startingFen: startingFen,
      moves: movesModels,
      movesCount: state.getMoveTokens.length,
      result: state.resultToPgnString(
        state.result,
      ), // Note: maybe expose public method
      // termination: map from state.result/status
    );
  }

  PlayerEntity stateInitialPlayerToEntity(GameState state, bool white) {
    // implement mapping: if GameState holds players metadata, use it.
    return PlayerEntity(
      id: null,
      uuid: white ? 'white-uuid' : 'black-uuid',
      name: white ? 'White' : 'Black',
      type: 'human',
      createdAt: DateTime.now(),
    );
  }
}
