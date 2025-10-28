// // lib/models/game.dart
// import 'package:isar/isar.dart';

// import '../services/stockfish_engine_service.dart';
// import 'player.dart';

// part 'game.g.dart';

// @Collection()
// class GameModel {
//   Id id = Isar.autoIncrement;

//   /// PGN كامل (قد يكون فارغًا أثناء اللعب)
//   String? pgn;

//   /// نتيجة اللعبة
//   @Index(caseSensitive: false)
//   @enumerated
//   GameResult result = GameResult.ongoing;

//   /// الحركات بصيغ مختلفة
//   List<String> moves = []; // SAN أو نصوص تشرح النقلة
//   List<String> movesUci = []; // UCI مثل e2e4
//   List<String> fens = []; // FEN بعد كل نقلة (مهم للتحقق من التكرار الثلاثي)

//   /// روابط للاعبين
//   final IsarLink<Player> whitePlayer = IsarLink<Player>();
//   final IsarLink<Player> blackPlayer = IsarLink<Player>();

//   /// مالك هذه اللعبة محليًا (uuid) لتسهيل البحث
//   String? ownerUuid;

//   /// هل الـ owner يلعب بالأبيض؟
//   bool ownerIsWhite = true;

//   DateTime startedAt = DateTime.now();
//   DateTime? endedAt;

//   String? whitesTime;
//   String? blacksTime;

//   bool isGameOver = false;

//   GameModel copyWith({
//     String? pgn,
//     String? ownerUuid,
//     bool? ownerIsWhite,
//     GameResult? result,
//     List<String>? moves,
//     List<String>? movesUci,
//     List<String>? fens,
//   }) {
//     final game = GameModel();
//     game
//       ..pgn = pgn ?? this.pgn
//       ..ownerUuid = ownerUuid ?? this.ownerUuid
//       ..ownerIsWhite = ownerIsWhite ?? this.ownerIsWhite
//       ..result = result ?? this.result
//       ..moves = moves ?? this.moves
//       ..movesUci = movesUci ?? this.movesUci
//       ..fens = fens ?? this.fens;
//     return game;
//   }

//   GameModel();
//   factory GameModel.create({
//     String? pgn,
//     String? ownerUuid,
//     bool? ownerIsWhite,
//     GameResult? result,

//     List<String>? moves,
//     List<String>? movesUci,
//     List<String>? fens,
//   }) {
//     final game = GameModel();
//     game
//       ..pgn = pgn
//       ..ownerUuid = ownerUuid
//       ..ownerIsWhite = ownerIsWhite!
//       ..result = result!
//       ..moves = moves!
//       ..movesUci = movesUci!
//       ..fens = fens!;
//     return game;
//   }
//   @override
//   String toString() =>
//       "GameModel{id:$id, owner:$ownerUuid, ownerIsWhite:$ownerIsWhite, result:$result, }";
// }

// // import 'package:isar/isar.dart';

// // import '../services/stockfish_engine_service.dart';
// // import 'player.dart';

// // part 'game.g.dart';

// // @Collection()
// // class GameModel {
// //   Id id = Isar.autoIncrement;

// //   /// تخزين PGN كامل (يمكن نسخه/لصقه)
// //   late String pgn;

// //   /// نتيجة نصية مثل "1-0", "0-1", "1/2-1/2"
// //   @Index(caseSensitive: false)
// //   @enumerated
// //   GameResult result = GameResult.ongoing;
// //   List<String> moves = [];
// //   List<String> movesUci = []; // قائمة الحركات UCI

// //   /// White player link (1:1)
// //   final IsarLink<Player> whitePlayer = IsarLink<Player>();

// //   /// Black player link (1:1)
// //   final IsarLink<Player> blackPlayer = IsarLink<Player>();

// //   /// وقت البدء والانتهاء
// //   DateTime startedAt = DateTime.now();
// //   DateTime? endedAt;

// //   /// وقت اللعب كـ نص (مثال: "3+2" أو "5|0")

// //   String? whitesTime;
// //   String? blacksTime;

// //   bool isGameOver = false;

// //   GameModel({required this.pgn, this.endedAt});

// //   @override
// //   String toString() =>
// //       "GameModel{id:$id, pgn:$pgn, result:$result, startedAt:$startedAt, endedAt:$endedAt, whitePlayer:$whitePlayer, blackPlayer:$blackPlayer, moves:$moves }";
// // }
