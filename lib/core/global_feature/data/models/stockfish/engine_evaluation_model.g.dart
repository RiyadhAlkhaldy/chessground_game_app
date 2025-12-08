// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engine_evaluation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EngineEvaluationModelImpl _$$EngineEvaluationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EngineEvaluationModelImpl(
      centipawns: (json['centipawns'] as num?)?.toInt(),
      mate: (json['mate'] as num?)?.toInt(),
      depth: (json['depth'] as num).toInt(),
      nodes: (json['nodes'] as num?)?.toInt(),
      bestMove: json['bestMove'] as String,
      pv: (json['pv'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      time: (json['time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EngineEvaluationModelImplToJson(
        _$EngineEvaluationModelImpl instance) =>
    <String, dynamic>{
      'centipawns': instance.centipawns,
      'mate': instance.mate,
      'depth': instance.depth,
      'nodes': instance.nodes,
      'bestMove': instance.bestMove,
      'pv': instance.pv,
      'time': instance.time,
    };
