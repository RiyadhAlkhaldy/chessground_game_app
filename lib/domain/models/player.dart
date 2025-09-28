// models/player.dart
import 'package:isar/isar.dart';

part 'player.g.dart';

@Collection()
class Player {
  Id id = Isar.autoIncrement; // مفتاح تلقائي

  /// اسم اللاعب (مثلاً "Riyadh" أو "Stockfish-17.1")
  late String name;

  /// نوع اللاعب: "human" أو "computer"
  @Index(caseSensitive: false)
  late String type;

  late String uuid; // لتعريف فريد
  // تعليق: يمكن إضافة حقول إضافية مثل elo, profileUrl لاحقًا.
  Player({required this.name, required this.type});
  @override
  String toString() => "Player{id:$id, name:$name, type:$type, uuid:$uuid }";
}
