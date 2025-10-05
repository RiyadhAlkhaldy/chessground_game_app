// // lib/services/game_storage_service.dart
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

// import '../models/game.dart';
// import '../models/player.dart';
// import 'stockfish_engine_service.dart';

// class GameStorageService {
//   GameStorageService._private();
//   static final GameStorageService I = GameStorageService._private();

//   late Future<Isar> _dbFuture;
//   Future<Isar> get _db => _dbFuture;

//   void init() {
//     _dbFuture = _open();
//   }

//   Future<Isar> _open() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return await Isar.open([
//       PlayerSchema,
//       GameModelSchema,
//     ], directory: dir.path);
//   }

//   // -----------------------
//   // Player helpers
//   // -----------------------
//   Future<Player?> getPlayerByUuid(String uuid) async {
//     final isar = await _db;
//     return await isar.players.filter().uuidEqualTo(uuid).findFirst();
//   }

//   Future<Player?> getPlayerByNameAndType(String name, String type) async {
//     final isar = await _db;
//     return await isar.players
//         .filter()
//         .nameEqualTo(name)
//         .typeEqualTo(type)
//         .findFirst();
//   }

//   Future<Player> createPlayer({
//     required String name,
//     required String type,
//     int rating = 1200,
//     String? email,
//     String? image,
//     String? uuidOverride,
//   }) async {
//     final isar = await _db;
//     final uuid = uuidOverride ?? const Uuid().v4();
//     final player = Player(
//       uuid: uuid,
//       name: name,
//       type: type,
//       playerRating: rating,
//       email: email,
//       image: image,
//     );

//     await isar.writeTxn(() async {
//       await isar.players.put(player);
//     });

//     return player;
//   }

//   /// إذا وُجِد لاعب بنفس الاسم والنوع يعيده، وإلا ينشئه.
//   Future<Player> getOrCreateComputerPlayer(
//     String name, {
//     int rating = 2400,
//   }) async {
//     final isar = await _db;
//     final existing =
//         await isar.players
//             .filter()
//             .nameEqualTo(name)
//             .typeEqualTo('computer')
//             .findFirst();
//     if (existing != null) return existing;
//     return await createPlayer(name: name, type: 'computer', rating: rating);
//   }

//   /// Guest محلي (لو لم يوجد) — يعيد أول لاعب مسجّل أو ينشئ Guest جديد
//   Future<Player> getOrCreateGuest({int rating = 1200}) async {
//     final isar = await _db;
//     final existing = await isar.players.where().findFirst();
//     if (existing != null) return existing;

//     final uuid = const Uuid().v4();
//     final guest = Player(
//       uuid: uuid,
//       name: 'Guest-${uuid.substring(0, 6)}',
//       type: 'guest',
//       playerRating: rating,
//     );

//     await isar.writeTxn(() async {
//       await isar.players.put(guest);
//     });
//     return guest;
//   }

//   // -----------------------
//   // Games helpers
//   // -----------------------

//   /// إنشاء لعبة مع opponent واضح (قد يكون Player أو مجرد اسم لمحرك)
//   Future<GameModel> createGameWithOpponent({
//     required String ownerUuid,
//     required bool ownerIsWhite,
//     Player? opponentPlayer, // إذا مرّرت Player نستخدمه
//     String? opponentName, // بديل: اسم الـ opponent (مثال: "Stockfish-17.1")
//     bool opponentIsComputer = false,
//     int opponentRating = 1200,
//     String? whitesTime,
//     String? blacksTime,
//   }) async {
//     final isar = await _db;

//     // جلب أو إنشاء owner
//     Player? owner = await getPlayerByUuid(ownerUuid);
//     owner ??= await createPlayer(
//       name: 'Guest-${ownerUuid.substring(0, 6)}',
//       type: 'guest',
//       uuidOverride: ownerUuid,
//     );

//     // جلب/إنشاء opponent
//     Player opponent;
//     if (opponentPlayer != null) {
//       opponent = opponentPlayer;
//     } else if (opponentName != null && opponentIsComputer) {
//       opponent = await getOrCreateComputerPlayer(
//         opponentName,
//         rating: opponentRating,
//       );
//     } else if (opponentName != null) {
//       // إنسان: حاول البحث بالاسم أولًا ثم أنشئ
//       final existing = await getPlayerByNameAndType(opponentName, 'human');
//       if (existing != null) {
//         opponent = existing;
//       } else {
//         opponent = await createPlayer(
//           name: opponentName,
//           type: 'human',
//           rating: opponentRating,
//         );
//       }
//     } else {
//       // افتراض: إنّ خصم غير محدد → أنشئ Guest opponent
//       final uuid = const Uuid().v4();
//       opponent = await createPlayer(
//         name: 'Guest-${uuid.substring(0, 6)}',
//         type: 'guest',
//       );
//     }

//     // أنشئ الـ GameModel وحدد اللاعبين بالألوان حسب ownerIsWhite
//     final gm =
//         GameModel()
//           ..ownerUuid = ownerUuid
//           ..ownerIsWhite = ownerIsWhite
//           ..startedAt = DateTime.now()
//           ..whitesTime = whitesTime
//           ..blacksTime = blacksTime;

//     if (ownerIsWhite) {
//       gm.whitePlayer.value = owner;
//       gm.blackPlayer.value = opponent;
//     } else {
//       gm.whitePlayer.value = opponent;
//       gm.blackPlayer.value = owner;
//     }

//     await isar.writeTxn(() async {
//       await isar.gameModels.put(gm);
//       await gm.whitePlayer.save();
//       await gm.blackPlayer.save();
//     });

//     return gm;
//   }

//   Future<void> addMove(
//     GameModel game, {
//     required String uci,
//     String? fen,
//     String? san,
//   }) async {
//     final isar = await _db;
//     await isar.writeTxn(() async {
//       final g = await isar.gameModels.get(game.id);
//       if (g == null) return;
//       g.movesUci.add(uci);
//       if (san != null) g.moves.add(san);
//       if (fen != null) g.fens.add(fen);
//       await isar.gameModels.put(g);
//     });
//   }

//   Future<void> saveGameSnapshot(GameModel game) async {
//     final isar = await _db;
//     await isar.writeTxn(() async {
//       final g = await isar.gameModels.get(game.id);
//       if (g == null) {
//         await isar.gameModels.put(game);
//       } else {
//         g.moves = game.moves;
//         g.movesUci = game.movesUci;
//         g.fens = game.fens;
//         g.pgn = game.pgn;
//         g.whitesTime = game.whitesTime;
//         g.blacksTime = game.blacksTime;
//         g.endedAt = game.endedAt;
//         g.isGameOver = game.isGameOver;
//         g.result = game.result;
//         await isar.gameModels.put(g);
//       }
//     });
//   }

//   Future<void> finishGame(
//     GameModel game, {
//     required GameResult result,
//     String? pgn,
//   }) async {
//     final isar = await _db;
//     await isar.writeTxn(() async {
//       final g = await isar.gameModels.get(game.id) ?? game;
//       g.isGameOver = true;
//       g.endedAt = DateTime.now();
//       g.result = result;
//       if (pgn != null) g.pgn = pgn;
//       await isar.gameModels.put(g);
//     });
//   }

//   Future<GameModel?> getLastUnfinishedGameForOwner(String ownerUuid) async {
//     final isar = await _db;
//     return await isar.gameModels
//         .filter()
//         .ownerUuidEqualTo(ownerUuid)
//         // .endTimeIsNull()
//         .findFirst();
//   }

//   Future<List<GameModel>> getAllGamesForOwner(String ownerUuid) async {
//     final isar = await _db;
//     return await isar.gameModels.filter().ownerUuidEqualTo(ownerUuid).findAll();
//   }
// }
