// // lib/data/repositories/game_repository_impl.dart
// import 'package:chessground_game_app/core/errors/expentions.dart';
// import 'package:chessground_game_app/core/errors/failures.dart';
// import 'package:chessground_game_app/core/global_feature/data/datasources/local_datasource.dart';
// import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/chess_game_model.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/mappers/entities_mapper.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
// import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
// import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
// import 'package:chessground_game_app/core/global_feature/domain/repositories/game_repository.dart';
// import 'package:chessground_game_app/core/params/params.dart';
// import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
// import 'package:dartz/dartz.dart';

// class GameRepositoryImpl implements GameRepository {
//   final LocalDataSource local;
//   final StockfishDataSource stockfish;

//   GameRepositoryImpl({required this.local, required this.stockfish});

//   @override
//   Future<Either<Failure, ChessGameEntity>> initGameModel(
//     InitChessGameParams chessGameEntity,
//   ) async {
//     try {
//       final model = await local.initGameModel(chessGameEntity);

//       return Right(model.toEntity());
//     } on IsarException catch (e) {
//       return Left(IsarCacheFailure(message: e.toString()));
//     } catch (e) {
//       return Left(UnknownFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, ChessGameEntity>> loadGameByUuid(String uuid) async {
//     try {
//       final model = await local.getGameModelByUuid(uuid);
//       if (model == null) {
//         return Left(IsarCacheFailure(message: 'Game not found'));
//       }
//       return Right(model.toEntity());
//     } on IsarException catch (e) {
//       return Left(IsarCacheFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, ChessGameEntity>> saveGameEntity(ChessGameEntity game) async {
//     try {
//       await local.saveChessGameModel(game.toModel());
//       return Right(game);
//     } on IsarException catch (e) {
//       return Left(IsarCacheFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, ChessGameEntity>> persistGameState(
//     ChessGameEntity chessGameEntity,
//     GameState state,
//   ) async {
//     try {
//       // تحويل GameState إلى ChessGameEntity
//       chessGameEntity = _gameStateToEntity(chessGameEntity, state);
//       final r = await saveGameEntity(chessGameEntity);
//       return r;
//     } on IsarException catch (e) {
//       return Left(IsarCacheFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String>> analyzeFen(String fen, {int depth = 15}) async {
//     try {
//       stockfish.setPosition(fen: fen);
//       late String bestMove;
//       await stockfish.bestmoves.listen((best) {
//         bestMove = best;
//         // return Right(best);
//       }).asFuture();
//       return Right(bestMove);
//     } on EngineException catch (e) {
//       return Left(EngineFailure(message: e.toString()));
//     }
//   }

//   @override
//   Stream<ChessGameEntity> watchGame(String uuid) =>
//       local.watchGameModel(uuid).map((m) => m.toEntity());

//   // ---------- helper ----------
//   ChessGameEntity _gameStateToEntity(ChessGameEntity chessGameEntity, GameState state) {
//     // Use GameState.public API to extract PGN, moves, fen, result...
//     final fullPgn = state.pgnString();
//     final startingFen = state.position.fen; // careful
//     final movesModels = state.getMoveTokens.map((m) => m.toEntity()).toList();

//     return ChessGameEntity(
//       uuid: chessGameEntity.uuid,
//       // players: not available here — caller should have attached players in state/entity
//       whitePlayer: chessGameEntity.whitePlayer,
//       blackPlayer: chessGameEntity.blackPlayer,
//       fullPgn: fullPgn,
//       startingFen: startingFen,
//       moves: movesModels,
//       movesCount: state.getMoveTokens.length,
//       result: state.resultToPgnString(state.result), // Note: maybe expose public method
//       // termination: map from state.result/status
//     );
//   }

//   PlayerEntity stateInitialPlayerToEntity(GameState state, bool white) {
//     // implement mapping: if GameState holds players metadata, use it.
//     return PlayerEntity(
//       id: null,
//       uuid: white ? 'white-uuid' : 'black-uuid',
//       name: white ? 'White' : 'Black',
//       type: 'human',
//       createdAt: DateTime.now(),
//     );
//   }
// }
