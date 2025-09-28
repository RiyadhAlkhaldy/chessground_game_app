// models/move.dart
import 'package:isar/isar.dart';

import 'game.dart';

part 'move.g.dart';

@Collection()
class MoveModel {
  Id id = Isar.autoIncrement;

  /// UCI representation: e2e4, e7e8q etc.
  late String uci;

  /// FEN after the move (snapshot)
  late String fen;

  /// رقم النقلة (moveNumber) — نصف حركة أو حركة كاملة حسب حاجتك
  int? moveNumber;

  /// SAN / CI أو تعليق للنقلة (اختياري)
  String? comment;

  /// الربط إلى الـ Game الأب (to-one)
  final IsarLink<GameModel> game = IsarLink<GameModel>();

  MoveModel({
    required this.uci,
    required this.fen,
    this.moveNumber,
    this.comment,
  });

  @override
  String toString() =>
      "MoveModel{id:$id, uci:$uci, moveNumber:$moveNumber, comment:$comment, fen:$fen, game:$game }";
}
