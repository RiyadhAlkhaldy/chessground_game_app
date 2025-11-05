import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../core/game_termination_enum.dart';
import '../models/chess_game_model.dart';
import 'move_data.dart';
import 'player.dart';

part 'chess_game.g.dart';

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
  List<MoveData> moves = [];

  // تتبع المستخدم/المصدر
  String? userId;

  @override
  String toString() =>
      "ChessGame{id:$id, uuid:$uuid, whitePlayer:$whitePlayer, blackPlayer:$blackPlayer, result:$result, termination:$termination, moves:$moves, fullPgn:$fullPgn }";
}

extension ChessGameMapper on ChessGame {
  // تحويل إلى نموذج بيانات
  ChessGameModel toModel() {
    return ChessGameModel(
      id: id,
      uuid: uuid,
      event: event,
      site: site,
      date: date,
      round: round,
      whitePlayer: whitePlayer.value!.toModel(),
      blackPlayer: blackPlayer.value!.toModel(),
      result: result ?? "",
      termination: termination,
      eco: eco,
      whiteElo: whiteElo,
      blackElo: blackElo,
      timeControl: timeControl,
      startingFen: startingFen,
      fullPgn: fullPgn,
      movesCount: movesCount,
      moves: moves.map((move) => move.toModel()).toList(),
    );
  }
}
