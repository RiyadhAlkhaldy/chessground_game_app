// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extended_evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtendedEvaluationImpl _$$ExtendedEvaluationImplFromJson(
  Map<String, dynamic> json,
) => _$ExtendedEvaluationImpl(
  depth: (json['depth'] as num).toInt(),
  cp: (json['cp'] as num?)?.toInt(),
  mate: (json['mate'] as num?)?.toInt(),
  pv: json['pv'] as String? ?? '',
  wdlWin: (json['wdlWin'] as num?)?.toInt(),
  wdlDraw: (json['wdlDraw'] as num?)?.toInt(),
  wdlLoss: (json['wdlLoss'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ExtendedEvaluationImplToJson(
  _$ExtendedEvaluationImpl instance,
) => <String, dynamic>{
  'depth': instance.depth,
  'cp': instance.cp,
  'mate': instance.mate,
  'pv': instance.pv,
  'wdlWin': instance.wdlWin,
  'wdlDraw': instance.wdlDraw,
  'wdlLoss': instance.wdlLoss,
};
