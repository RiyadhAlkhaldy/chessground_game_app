// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoveDataModelImpl _$$MoveDataModelImplFromJson(Map<String, dynamic> json) =>
    _$MoveDataModelImpl(
      san: json['san'] as String?,
      lan: json['lan'] as String?,
      comment: json['comment'] as String?,
      nags: (json['nags'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      fenAfter: json['fenAfter'] as String?,
      variations: (json['variations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      wasCapture: json['wasCapture'] as bool? ?? false,
      wasCheck: json['wasCheck'] as bool? ?? false,
      wasCheckmate: json['wasCheckmate'] as bool? ?? false,
      wasPromotion: json['wasPromotion'] as bool? ?? false,
      isWhiteMove: json['isWhiteMove'] as bool?,
      halfmoveIndex: (json['halfmoveIndex'] as num?)?.toInt(),
      moveNumber: (json['moveNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MoveDataModelImplToJson(_$MoveDataModelImpl instance) =>
    <String, dynamic>{
      'san': instance.san,
      'lan': instance.lan,
      'comment': instance.comment,
      'nags': instance.nags,
      'fenAfter': instance.fenAfter,
      'variations': instance.variations,
      'wasCapture': instance.wasCapture,
      'wasCheck': instance.wasCheck,
      'wasCheckmate': instance.wasCheckmate,
      'wasPromotion': instance.wasPromotion,
      'isWhiteMove': instance.isWhiteMove,
      'halfmoveIndex': instance.halfmoveIndex,
      'moveNumber': instance.moveNumber,
    };
