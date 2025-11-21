// lib/models/player.dart
import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart';
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
  String toString() => "Player{id:$id, uuid:$uuid, name:$name, type:$type, rating:$playerRating}";
}

// امتداد لتحويل Isar Collection إلى PlayerModel
extension PlayerMapper on Player {
  PlayerModel toModel() {
    return PlayerModel(
      id: id,
      uuid: uuid,
      name: name,
      type: type,
      playerRating: playerRating,
      email: email,
      image: image,
      createdAt: createdAt,
    );
  }
}
