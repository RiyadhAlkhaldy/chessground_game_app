import 'package:isar/isar.dart';

import 'player.dart';

part 'chess_game.g.dart';

enum GameTermination {
  checkmate,
  stalemate,
  timeout,
  // halfmoveClock,
  resignation,
  agreement,
  threefoldRepetition,
  fiftyMoveRule,
  insufficientMaterial,
}

@Collection()
class ChessGame {
  Id id = Isar.autoIncrement;

  // Seven Tag Roster + إضافات
  @Index(type: IndexType.value)
  String? event;
  String? site;
  DateTime? date;
  String? round;
  // String? whitePlayer;
  // String? blackPlayer;
  // روابط للاعبين (1:1 لكل دور)
  final whitePlayer = IsarLink<Player>();
  final blackPlayer = IsarLink<Player>();
  @Index()
  String? result; // "1-0", "0-1", "1/2-1/2", "*"
  @enumerated
  late GameTermination termination;
  // إضافات تحليلية ووصفية
  String? eco;
  int? whiteElo;
  int? blackElo;
  String? timeControl;
  String? startingFen; // للـ non-standard start
  String? fullPgn; // النص الكامل للمباراة (مصدر)
  int movesCount =
      0; // عدد الحركات (half-moves or SAN entries — نستخدم SAN entries)

  // قائمة حركات مضمنة
  // @Embedded()
  List<MoveData> moves = [];

  // تتبع المستخدم/المصدر
  String? userId;
}

@Embedded()
class MoveData {
  String? san; // e.g. "Nf3", "exd5", "O-O"
  String? lan; // e.g. "g1f3", "e4d5"
  String? comment; // نص التعليق من { ... }
  String? nag; // نمط "$2" الخ
  String? fenAfter; // FEN بعد تنفيذ الحركة
  List<String>?
  variations; // نص المتغيرات (يمكن أن نخزنها كنصوص خام أو تبني هيكل شجري)
}

// @collection
// class ChessGame {
//   // 1. المفتاح الأساسي
//   Id id = Isar.autoIncrement;

//   // 2. ترويسة الحدث الأساسية (Seven Tag Roster - STR)

//   @Index(type: IndexType.value)
//   String? event; // [Event "World Championship"]
//   String? site; // [Site "New York, USA"]
//   DateTime? date; // [Date "2024.10.05"] (يتم تحويلها من String إلى DateTime)
//   String? round; // [Round "1"]
//   String? whitePlayer; // [White "Kasparov, Garry"]
//   String? blackPlayer; // [Black "Karpov, Anatoly"]

//   @Index()
//   String? result; // [Result "1-0"] - مهم للفلترة (فوز، تعادل)

//   // 3. البيانات الوصفية والتحليلية الإضافية (للتخزين السهل)
//   String? eco; // [ECO "D02"] - كود الافتتاحية
//   int? whiteElo; // [WhiteElo "2750"]
//   int? blackElo; // [BlackElo "2680"]
//   String? timeControl; // [TimeControl "5+0"]

//   // 4. تمثيل حالة اللعبة (FEN + Raw PGN)
//   String? startingFen; // [FEN ...] - لتسجيل وضع البداية غير القياسي
//   String? fullPgn; // السلسلة النصية الكاملة للمباراة (للعرض والتحليل التفصيلي)

//   // 5. التمثيل الهيكلي للحركات (للتنقل والتحليل السريع)
//   List<MoveData>? moves; // قائمة بكائنات صغيرة لتخزين كل حركة وبياناتها

//   // 6. بيانات المشغل (اختياري: لتتبع المستخدم المحلي)
//   String? userId; // لتتبع المستخدم الذي لعب/حلل المباراة.
// }

// @embedded
// class MoveData {
//   String? san; // الحركة بصيغة SAN (مثال: Nf3, Nxe5#)
//   String? lan; // الحركة بصيغة LAN (مثال: g1f3, f3e5)
//   String? comment; // التعليقات المرفقة بالحركة {مثل هذا التعليق}
//   String? nag; // رمز التقييم الرقمي للحركة (مثال: $2)
//   String? fenAfter; // وضع FEN بعد هذه الحركة (مهم للاسترجاع السريع للوضع)
//   List<String>?
//   variations; // المتغيرات النصية (القوسين) لهذا الدور (مثال: [ "1... c5 {الدفاع الصقلي}" ] )
// }
