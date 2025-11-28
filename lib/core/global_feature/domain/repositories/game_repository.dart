// // lib/domain/repositories/game_repository.dart

// import 'package:chessground_game_app/core/errors/failures.dart';
// import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
// import 'package:chessground_game_app/core/params/params.dart';
// import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
// import 'package:dartz/dartz.dart';

// abstract class GameRepository {
//   Future<Either<Failure, ChessGameEntity>> initGameModel(InitChessGameParams chessGameEntity);
//   Future<Either<Failure, ChessGameEntity>> loadGameByUuid(String uuid);
//   Future<Either<Failure, ChessGameEntity>> saveGameEntity(ChessGameEntity game);

//   /// حفظ حالة GameState كاملة (يحول داخل الـ repo إلى ChessGameEntity ثم يحفظ)
//   Future<Either<Failure, ChessGameEntity>> persistGameState(
//     ChessGameEntity chessGameEntity,
//     GameState state,
//   );
//   Future<Either<Failure, String>> analyzeFen(String fen, {int depth});
//   Stream<ChessGameEntity> watchGame(String uuid);
// }
