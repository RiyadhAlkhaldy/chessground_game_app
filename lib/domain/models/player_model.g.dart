// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    _$PlayerModelImpl(
      id: (json['id'] as num?)?.toInt(),
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      playerRating: (json['playerRating'] as num?)?.toInt() ?? 1200,
      email: json['email'] as String?,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'type': instance.type,
      'playerRating': instance.playerRating,
      'email': instance.email,
      'image': instance.image,
      'createdAt': instance.createdAt.toIso8601String(),
    };
