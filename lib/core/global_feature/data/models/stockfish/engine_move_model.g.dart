// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engine_move_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EngineMoveModelImpl _$$EngineMoveModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EngineMoveModelImpl(
      uci: json['uci'] as String,
      san: json['san'] as String?,
      evaluation: (json['evaluation'] as num?)?.toInt(),
      isBestMove: json['isBestMove'] as bool? ?? false,
      rank: (json['rank'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$EngineMoveModelImplToJson(
        _$EngineMoveModelImpl instance) =>
    <String, dynamic>{
      'uci': instance.uci,
      'san': instance.san,
      'evaluation': instance.evaluation,
      'isBestMove': instance.isBestMove,
      'rank': instance.rank,
    };
