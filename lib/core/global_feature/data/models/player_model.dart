import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart'; // لترميز/فك ترميز JSON

@freezed
abstract class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    // المفتاح المحلي في Isar. يجب أن يكون اختياريًا (nullable) عند الإنشاء.
    required final int? id,

    // UUID ثابت للتعرّف على اللاعب، وهو جزء أساسي من هوية اللاعب.
    required final String uuid,

    // اسم اللاعب
    required final String name,

    // نوع اللاعب (guest/human/computer/registered)
    required final String type,

    // تصنيف اللاعب
    @Default(1200) final int playerRating,

    final String? email,
    final String? image,

    // تاريخ الإنشاء. يجب أن يكون اختياريًا/تلقائيًا.
    required final DateTime createdAt,
  }) = _PlayerModel;

  // مُنشئ المصنع (Factory) لتحويل JSON إلى كائن PlayerModel
  factory PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);
}

// امتداد لتحويل PlayerModel إلى Isar Collection
extension PlayerModelMapper on PlayerModel {
  Player toCollection() {
    final collection = Player(
      uuid: uuid,
      name: name,
      type: type,
      playerRating: playerRating,
      email: email,
      image: image,
    );
    // تعيين الحقول التي لا يتم تمريرها في مُنشئ Isar
    if (id != null) {
      collection.id = id!;
    }
    collection.createdAt = createdAt;
    return collection;
  }

  // ⚠️ الأهم في المعمارية النظيفة: وظيفة التحويل (Mapper)
  // تحويل PlayerModel (البيانات الخارجية) إلى PlayerEntity (الكيان الداخلي)
  PlayerEntity toEntity() {
    return PlayerEntity(
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
