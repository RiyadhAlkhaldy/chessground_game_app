// lib/domain/entities/player_entity.dart
// استخدام 'package:meta/meta.dart' لتحسين الكود، ولكنها ليست إجبارية

class PlayerEntity {
  final int? id; // يمكن أن يكون اختياريًا (nullable)
  final String uuid;
  final String name;
  final String type;
  final int playerRating;
  final String? email;
  final String? image;
  final DateTime createdAt;

  const PlayerEntity({
    this.id,
    required this.uuid,
    required this.name,
    required this.type,
    this.playerRating = 1200, // يمكن تعيين قيمة افتراضية هنا أو في Model
    this.email,
    this.image,
    required this.createdAt,
  });

  // يجب إضافة وظيفة نسخ (copyWith) للمساعدة في تحديث الكيان (Entity)
  PlayerEntity copyWith({
    int? id,
    String? uuid,
    String? name,
    String? type,
    int? playerRating,
    String? email,
    String? image,
    DateTime? createdAt,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      playerRating: playerRating ?? this.playerRating,
      email: email ?? this.email,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
