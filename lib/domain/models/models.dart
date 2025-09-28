// import 'package:isar/isar.dart';

// // import 'package:uuid/uuid.dart';

// part 'models.g.dart';

// @Collection()
// class Player {
//   Id id = Isar.autoIncrement; // مفتاح محلي في Isar
//   @Index(unique: true)
//   late String uuid; // UUID المزامن مع backend

//   @Index(unique: true)
//   late String username;

//   String? displayName;
//   late String type; // 'human','engine','guest'
//   String? gender;
//   String? profileJson; // بيانات مرنة محفوظة كسلسلة JSON
//   int? rating;
//   bool isDeleted = false;
//   late DateTime createdAt;
//   late DateTime updatedAt;
// }

// @Collection()
// class Engine {
//   Id id = Isar.autoIncrement;
//   @Index(unique: true)
//   late String uuid;
//   late String name;
//   String? version;
//   String? settingsJson;
//   bool isActive = true;
//   late DateTime createdAt;
//   late DateTime updatedAt;
// }

// @Collection()
// class Game {
//   Id id = Isar.autoIncrement;
//   @Index(unique: true)
//   late String uuid;
//   late String publicUuid;
//   String initialFen = 'startpos';
//   String? pgn;
//   late String status; // pending,running,finished,aborted
//   late String result; // white,black,draw,undecided
//   String? resultReason;
//   String? winnerUuid; // UUID للاعب الفائز
//   String? timeControlJson; // JSON كسلسلة أو استخدم Embedded
//   int movesCount = 0;
//   String? lastFen;
//   String? engineUuid;
//   bool isDeleted = false;
//   late DateTime createdAt;
//   late DateTime updatedAt;
// }

// @Collection()
// class GamePlayer {
//   Id id = Isar.autoIncrement;
//   @Index()
//   late String uuid;
//   @Index()
//   late String gameUuid;
//   String? playerUuid;
//   late String side; // white,black,spectator
//   int? rating;
//   bool isHost = false;
//   String? connectionInfoJson;
//   late DateTime joinedAt;
// }

// @Collection()
// class Move {
//   Id id = Isar.autoIncrement;
//   @Index()
//   late String uuid;
//   @Index()
//   late String gameUuid;
//   int ply = 0;
//   int moveNumber = 0;
//   late String side; // white/black
//   String? san;
//   String? uci;
//   String? fromSq;
//   String? toSq;
//   String? piece; // 'P','N',...
//   String? promotion;
//   String? fenAfter;
//   late DateTime timestamp;
//   int? engineEval;
//   int? engineDepth;
//   bool isCapture = false;
//   bool isCheck = false;
//   bool isCheckmate = false;
//   String? extraJson;
// }
