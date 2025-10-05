// // file: domain/services/game_history_service.dart

// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import '../entities/game_record.dart';

// class GameHistoryService {
//   late Future<Isar> _db;

//   GameHistoryService() {
//     _db = _openDB();
//   }

//   Future<Isar> _openDB() async {
//     if (Isar.instanceNames.isEmpty) {
//       final dir = await getApplicationDocumentsDirectory();
//       return await Isar.open(
//         [GameRecordSchema], // إضافة الـ Schema هنا
//         directory: dir.path,
//         inspector: true, // للـ Debugging
//       );
//     }
//     return Future.value(Isar.getInstance());
//   }

//   Future<void> saveGame(GameRecord game) async {
//     final isar = await _db;
//     await isar.writeTxn(() async {
//       await isar.gameRecords.put(game);
//     });
//   }

//   Future<List<GameRecord>> getAllGames() async {
//     final isar = await _db;
//     // ترتيب الألعاب من الأحدث إلى الأقدم
//     return await isar.gameRecords.where().sortByDateDesc().findAll();
//   }

//   Future<GameRecord?> getGame(int id) async {
//     final isar = await _db;
//     return await isar.gameRecords.get(id);
//   }

//   Future<bool> deleteGame(int id) async {
//     final isar = await _db;
//     return await isar.writeTxn(() async {
//       return await isar.gameRecords.delete(id);
//     });
//   }
// }
