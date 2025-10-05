// import 'package:chessground_game_app/domain/models/game.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

// import '../models/player.dart';

// class UserService {
//   static final UserService _instance = UserService._internal();
//   factory UserService() => _instance;
//   UserService._internal();

//   static late Isar _dbFuture;
//   Isar get _db => _dbFuture;

//   Future<void> init() async {
//     _dbFuture = await _open();
//   }

//   Future<Isar> _open() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return await Isar.open([PlayerSchema], directory: dir.path);
//   }

//   /// إنشاء Guest User عند أول تشغيل
//   Future<Player> createGuestIfNeeded() async {
//     final isar = _db;

//     // هل فيه لاعب موجود؟
//     final existing = await isar.players.where().findFirst();
//     if (existing != null) {
//       return existing;
//     }

//     // توليد UUID
//     final uuid = const Uuid().v4();

//     // اسم guest افتراضي
//     final guestName = "Guest-${uuid.substring(0, 6)}";

//     final guest = Player(uuid: uuid, name: guestName, type: 'guest');

//     await isar.writeTxn(() async {
//       await isar.players.put(guest);
//     });

//     return guest;
//   }

//   /// جلب المستخدم الحالي
//   Future<Player?> getCurrentUser() async {
//     final isar = _db;
//     return await isar.players.where().findFirst();
//   }

//   /// تحديث بيانات المستخدم (مثلاً عند تسجيل الدخول)
//   Future<void> updateUser(Player updated) async {
//     final isar = _db;
//     await isar.writeTxn(() async {
//       await isar.players.put(updated);
//     });
//   }

//   Future<GameModel> createNewGame(Player currentUser) async {
//     final isar = UserService()._db;

//     final game = GameModel()..startedAt = DateTime.now();

//     // هنا نفترض اللاعب الحالي هو الأبيض
//     game.whitePlayer.value = currentUser;

//     await isar.writeTxn(() async {
//       await isar.gameModels.put(game);
//       await game.whitePlayer.save();
//     });

//     return game;
//   }

//   // Future<void> addMove(
//   //   GameModel game,
//   //   String uci,
//   //   String fen,
//   //   int moveNumber,
//   // ) async {
//   //   final isar = UserService()._db;

//   //   final move =
//   //       MoveModel(uci: uci, fen: fen)
//   //         ..uci = uci
//   //         ..fen = fen
//   //         ..moveNumber = moveNumber
//   //         ..game.value = game;

//   //   await isar.writeTxn(() async {
//   //     await isar.moveModels.put(move);
//   //     await move.game.save();
//   //   });
//   // }
// }
