// lib/models/player.dart
import 'package:isar/isar.dart';

part 'player.g.dart';

@Collection()
class Player {
  Id id = Isar.autoIncrement;

  /// UUID ثابت للتعرّف على اللاعب محلياً
  late String uuid;

  /// اسم اللاعب
  late String name;

  /// نوع اللاعب: guest / human / computer / registered
  @Index(caseSensitive: false)
  late String type;

  String? email;
  String? image;
  DateTime createdAt = DateTime.now();

  /// تصنيف افتراضي (لو لم يُمرَّر)
  int playerRating = 1200;

  Player({
    required this.uuid,
    required this.name,
    required this.type,
    this.playerRating = 1200,
    this.email,
    this.image,
  });

  @override
  String toString() =>
      "Player{id:$id, uuid:$uuid, name:$name, type:$type, rating:$playerRating}";
}

// import 'package:isar/isar.dart';

// part 'player.g.dart';

// @Collection()
// class Player {
//   Id id = Isar.autoIncrement; // مفتاح تلقائي
//   late String uuid; // لتعريف فريد

//   /// اسم اللاعب (مثلاً "Riyadh" أو "Stockfish-17.1")
//   late String name;

//   /// نوع اللاعب: "human" أو "computer"
//   @Index(caseSensitive: false)
//   late String type;

//   String? email;
//   String? image;
//   DateTime createdAt = DateTime.now();
//   int playerRating;
//   // تعليق: يمكن إضافة حقول إضافية مثل elo, profileUrl لاحقًا.
//   Player({required this.name, required this.type, required this.playerRating});
//   @override
//   String toString() => "Player{id:$id, name:$name, type:$type, uuid:$uuid }";
// }
