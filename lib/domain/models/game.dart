// models/game.dart
import 'package:isar/isar.dart';

import 'move.dart';
import 'player.dart';

part 'game.g.dart';

@Collection()
class GameModel {
  Id id = Isar.autoIncrement;

  /// تخزين PGN كامل (يمكن نسخه/لصقه)
  late String pgn;

  /// نتيجة نصية مثل "1-0", "0-1", "1/2-1/2"
  @Index(caseSensitive: false)
  late String result;

  /// White player link (1:1)
  final IsarLink<Player> whitePlayer = IsarLink<Player>();

  /// Black player link (1:1)
  final IsarLink<Player> blackPlayer = IsarLink<Player>();

  /// العلاقة العكسية: كل الحركات المرتبطة بهذه اللعبة
  // @Backlink('game')
  @Backlink(to: 'game')
  final IsarLinks<MoveModel> moves = IsarLinks<MoveModel>();

  /// وقت البدء والانتهاء
  DateTime startedAt = DateTime.now();
  DateTime? endedAt;

  /// وقت اللعب كـ نص (مثال: "3+2" أو "5|0")
  String? timeControl;

  /// تعليق أو ميتاداتا إضافية
  String? metadata;
  GameModel({
    required this.pgn,
    required this.result,
    this.timeControl,
    this.metadata,
  });

  @override
  String toString() =>
      "GameModel{id:$id, pgn:$pgn, result:$result, startedAt:$startedAt, endedAt:$endedAt, timeControl:$timeControl, whitePlayer:$whitePlayer, blackPlayer:$blackPlayer, moves:$moves }";
}
