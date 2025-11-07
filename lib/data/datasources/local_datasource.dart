// lib/data/datasources/local_datasource.dart
import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/data/collections/chess_game.dart';
import 'package:chessground_game_app/data/collections/player.dart';
import 'package:chessground_game_app/data/models/mappers/entities_mapper.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../core/params/params.dart';
import '../../core/utils/helper/helper_methodes.dart';
import '../../presentation/controllers/get_storage_controller.dart';
import '../models/chess_game_model.dart';
import '../models/player_model.dart';

abstract class LocalDataSource {
  Future<ChessGameModel> initGameModel(InitChessGameParams initChessGameParams);
  Future<ChessGameModel?> getGameModelByUuid(String uuid);
  Future<void> saveChessGameModel(ChessGameModel model);
  Stream<ChessGameModel> watchGameModel(String uuid);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Isar isar;
  GetStorageControllerImp storage;
  LocalDataSourceImpl(this.isar, this.storage);
  @override
  Future<ChessGameModel> initGameModel(
    InitChessGameParams initChessGameParams,
  ) async {
    PlayerModel? whitePlayer;
    PlayerModel? blackPlayer;
    if (initChessGameParams.whitePlayer == null) {
      final wPlayer = await createPlayerIfNotExists(storage);
      whitePlayer = wPlayer!.toModel();
    } else {
      whitePlayer = initChessGameParams.whitePlayer!.toModel();
    }
    if (initChessGameParams.blackPlayer == null) {
      final bPlayer = await createPlayerIfNotExists(storage, 'ai_user_uuid');
      blackPlayer = bPlayer!.toModel();
    } else {
      blackPlayer = initChessGameParams.blackPlayer!.toModel();
    }
    final model = ChessGameModel(
      id: Isar.autoIncrement,
      uuid: Uuid().v4(),
      event: initChessGameParams.event ?? '',
      site: initChessGameParams.site ?? '',
      date: initChessGameParams.date ?? DateTime.now(),
      round: '',
      whitePlayer: whitePlayer,
      blackPlayer: blackPlayer,
      result: '',
      termination: GameTermination.ongoing,
      eco: '',
      whiteElo: 0,
      blackElo: 0,
      timeControl: '',
      startingFen: '',
      fullPgn: '',
      movesCount: 0,
      moves: [],
    );
    await isar.writeTxn(() async {
      await isar.chessGames.put(model.toCollection());
    });
    return model;
  }

  @override
  Future<ChessGameModel?> getGameModelByUuid(String uuid) async {
    final q = await isar.chessGames.filter().uuidEqualTo(uuid).findFirst();
    return q?.toModel(); // 注意: toModel موجود داخل extension في collection
  }

  @override
  Future<void> saveChessGameModel(ChessGameModel model) async {
    await isar.writeTxn(() async {
      final coll = model.toCollection();
      await isar.chessGames.put(coll);
      // ensure players saved as well
      if (coll.whitePlayer.value != null) {
        await isar.players.put(coll.whitePlayer.value!);
      }
      if (coll.blackPlayer.value != null) {
        await isar.players.put(coll.blackPlayer.value!);
      }
    });
  }

  @override
  Stream<ChessGameModel> watchGameModel(String uuid) {
    // watch for changes to the game entity in Isar
    return isar.chessGames
        .filter()
        .uuidEqualTo(uuid)
        .watch(fireImmediately: true)
        .map((colls) {
          final c = colls.isNotEmpty ? colls.first : null;
          return c?.toModel() ?? (throw Exception('No game'));
        });
  }
}
