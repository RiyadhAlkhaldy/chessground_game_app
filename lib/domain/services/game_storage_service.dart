// services/game_storage_service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/game.dart';
import '../models/move.dart';
import '../models/player.dart';

class GameStorageService {
  static final GameStorageService _instance = GameStorageService._internal();
  factory GameStorageService() => _instance;
  GameStorageService._internal();

  static late Isar _dbFuture;
  Isar get _db => _dbFuture;

  Future<void> init() async {
    _dbFuture = await _open();
  }

  Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([
      PlayerSchema,
      GameModelSchema,
      MoveModelSchema,
    ], directory: dir.path);
  }

  /// Save finished game (atomic): يحفظ الـ Game والـ Players وMoves.
  Future<int> saveFinishedGame({
    required String pgn,
    required String result,
    required DateTime startedAt,
    required DateTime endedAt,
    String? timeControl,
    String? metadata,
    required String whiteName,
    required String blackName,
    required List<MoveModel> moves,
  }) async {
    final isar = _db;
    final game =
        GameModel(
            pgn: pgn,
            result: result,

            timeControl: timeControl,
            metadata: metadata,
          )
          ..endedAt = endedAt
          ..startedAt = startedAt;

    final white = Player(
      name: whiteName,
      type: 'human',
    ); // or detect from params
    final black = Player(name: blackName, type: 'computer');

    return await isar.writeTxn<int>(() async {
      // save players
      final whiteId = await isar.players.put(white);
      final blackId = await isar.players.put(black);

      // link players
      game.whitePlayer.value = white;
      game.blackPlayer.value = black;
      await game.whitePlayer.save();
      await game.blackPlayer.save();

      // save game
      final gameId = await isar.gameModels.put(game);

      // save moves and link to game
      for (final m in moves) {
        m.game.value = game;
        await isar.moveModels.put(m);
        await m.game.save();
      }
      return gameId;
    });
  }

  /// استرجاع لعبة واحدة مع الحركات واللاعبين
  Future<GameModel?> getGameWithMoves(int id) async {
    final isar = _db;
    final game = await isar.gameModels.get(id);
    if (game == null) return null;
    await game.moves.load(); // load backlink moves
    await game.whitePlayer.load();
    await game.blackPlayer.load();
    return game;
  }

  /// تصدير PGN للعبة
  Future<String?> exportPgnForGame(int id) async {
    final game = await getGameWithMoves(id);
    return game?.pgn;
  }

  /// استيراد/لصق PGN — يفترض أن لديك parser خارجي (dartchess يوفر PGN parser)
  Future<int> importPgnAndSave({
    required String pgn,
    required DateTime startedAt,
    String whiteName = 'White',
    String blackName = 'Black',
    String? timeControl,
  }) async {
    // parsing PGN إلى حركات / استخراج النتيجة ممكن عبر dartchess PGN parser
    // هنا أضع منطق تجريبي بسيط — في المشروع الحقيقي استعمل dartchess.PgnReader
    // مثال: final book = Pgn.parse(pgn); ... ثم بناء قائمة MoveModel
    // لأغراض المثال، نقوم بحفظ الـ PGN كما هو:
    final moves = <MoveModel>[]; // عليك أن تملأها من الـ PGN parser
    return saveFinishedGame(
      pgn: pgn,
      result: '1/2-1/2',
      startedAt: startedAt,
      endedAt: DateTime.now(),
      whiteName: whiteName,
      blackName: blackName,
      moves: moves,
    );
  }
}
