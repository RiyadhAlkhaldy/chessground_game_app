import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

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
  ongoing,
}

@Collection()
class ChessGame {
  Id id = Isar.autoIncrement;
  String uuid = Uuid().v4();

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
  GameTermination termination = GameTermination.ongoing;
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

  @override
  String toString() =>
      "ChessGame{id:$id, uuid:$uuid, whitePlayer:$whitePlayer, blackPlayer:$blackPlayer, result:$result, termination:$termination, moves:$moves, fullPgn:$fullPgn }";
}

@Embedded()
class MoveData {
  String? san; // e.g. "Nf3", "exd5", "O-O"
  String? lan; // e.g. "g1f3", "e4d5"
  String? comment; // نص التعليق من { ... }
  List<int>? nags;
  String? fenAfter; // FEN بعد تنفيذ الحركة
  List<String>?
  variations; // نص المتغيرات (يمكن أن نخزنها كنصوص خام أو تبني هيكل شجري)
  bool wasCapture = false;
  bool wasCheck = false;
  bool wasCheckmate = false;
  bool wasPromotion = false;
  bool? isWhiteMove;
  int? halfmoveIndex;
  int? moveNumber;

  @override
  String toString() =>
      "MoveData{san:$san, lan:$lan, nags:$nags, comment:$comment, fenAfter:$fenAfter }";
}
