// // lib/data/datasources/local_datasource.dart
// import 'package:chessground_game_app/core/errors/expentions.dart';
// import 'package:chessground_game_app/core/game_termination_enum.dart';
// import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
// import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/chess_game_model.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/mappers/entities_mapper.dart';
// import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart';
// import 'package:chessground_game_app/core/params/params.dart';
// import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
// import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
// import 'package:chessground_game_app/core/utils/logger.dart';
// import 'package:isar/isar.dart';
// import 'package:uuid/uuid.dart';

// abstract class LocalDataSource {
//   Future<ChessGameModel> initGameModel(InitChessGameParams chessParams);
//   Future<ChessGameModel?> getGameModelByUuid(String uuid);
//   Future<void> saveChessGameModel(ChessGameModel model);
//   Stream<ChessGameModel> watchGameModel(String uuid);
// }

// class LocalDataSourceImpl implements LocalDataSource {
//   final Isar isar;
//   LocalDataSourceImpl(this.isar);
//   @override
//   Future<ChessGameModel> initGameModel(InitChessGameParams chessParams) async {
//     try {
//       PlayerModel? whitePlayer;
//       PlayerModel? blackPlayer;
//       if (chessParams.whitePlayer == null) {
//         final wPlayer = await createOrGetGustPlayer();
//         AppLoggers.info(wPlayer.toString());
//         whitePlayer = wPlayer!.toModel();
//       } else {
//         whitePlayer = chessParams.whitePlayer!.toModel();
//       }
//       if (chessParams.blackPlayer == null) {
//         final bPlayer = await createOrGetGustPlayer(uuidKeyForAI);
//         AppLoggers.info(bPlayer.toString());

//         blackPlayer = bPlayer!.toModel();
//       } else {
//         blackPlayer = chessParams.blackPlayer!.toModel();
//       }
//       final model = ChessGameModel(
//         id: Isar.autoIncrement,
//         uuid: const Uuid().v4(),
//         event: chessParams.event ?? '',
//         site: chessParams.site ?? '',
//         date: chessParams.date ?? DateTime.now(),
//         round: '',
//         whitePlayer: whitePlayer,
//         blackPlayer: blackPlayer,
//         result: '',
//         termination: GameTermination.ongoing,
//         eco: '',
//         whiteElo: 0,
//         blackElo: 0,
//         timeControl: '',
//         startingFen: '',
//         fullPgn: '',
//         movesCount: 0,
//         moves: [],
//       );
//       AppLoggerr.fatal(model.toString());
//       await saveChessGameModel(model);

//       // AppLogger.fatal("result Isar: ${await isar.chessGames.get(model.id!)}");
//       return model;
//     } catch (e) {
//       throw IsarException(errorMessage: 'error isar on init Game Model:$e');
//     }
//   }

//   @override
//   Future<ChessGameModel?> getGameModelByUuid(String uuid) async {
//     try {
//       final q = await isar.chessGames.filter().uuidEqualTo(uuid).findFirst();
//       return q?.toModel(); // 注意: toModel موجود داخل extension في collection
//     } catch (e) {
//       throw IsarException(errorMessage: 'error isar on get Game Model by uuid: $e');
//     }
//   }

//   @override
//   Future<void> saveChessGameModel(ChessGameModel model) async {
//     try {
//       await isar.writeTxn(() async {
//         final coll = model.toCollection();
//         await isar.chessGames.put(coll);
//         // ensure players saved as well
//         if (coll.whitePlayer.value != null) {
//           await isar.players.put(coll.whitePlayer.value!);
//         }
//         if (coll.blackPlayer.value != null) {
//           await isar.players.put(coll.blackPlayer.value!);
//         }
//       });
//     } catch (e) {
//       throw IsarException(errorMessage: 'error isar on save chess Game Model: $e');
//     }
//   }

//   @override
//   Stream<ChessGameModel> watchGameModel(String uuid) {
//     try {
//       // watch for changes to the game entity in Isar
//       return isar.chessGames.filter().uuidEqualTo(uuid).watch(fireImmediately: true).map((colls) {
//         final c = colls.isNotEmpty ? colls.first : null;
//         return c?.toModel() ?? (throw Exception('No game'));
//       });
//     } catch (e) {
//       throw IsarException(errorMessage: 'error isar on watch Game Model: $e');
//     }
//   }
// }
