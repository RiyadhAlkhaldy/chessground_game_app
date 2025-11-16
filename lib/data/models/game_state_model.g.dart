// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateModelImpl _$$GameStateModelImplFromJson(Map<String, dynamic> json) =>
    _$GameStateModelImpl(
      gameUuid: json['gameUuid'] as String,
      currentFen: json['currentFen'] as String,
      fenHistory: (json['fenHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      fenCounts: Map<String, int>.from(json['fenCounts'] as Map),
      moves: (json['moves'] as List<dynamic>)
          .map((e) => MoveDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentHalfmoveIndex:
          (json['currentHalfmoveIndex'] as num?)?.toInt() ?? 0,
      result: json['result'] as String?,
      termination:
          $enumDecodeNullable(_$GameTerminationEnumMap, json['termination']) ??
          GameTermination.ongoing,
      resignationSide: json['resignationSide'] as String?,
      timeoutSide: json['timeoutSide'] as String?,
      agreementDraw: json['agreementDraw'] as bool? ?? false,
      halfmoveClock: (json['halfmoveClock'] as num?)?.toInt() ?? 0,
      materialEvaluation: (json['materialEvaluation'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$GameStateModelImplToJson(
  _$GameStateModelImpl instance,
) => <String, dynamic>{
  'gameUuid': instance.gameUuid,
  'currentFen': instance.currentFen,
  'fenHistory': instance.fenHistory,
  'fenCounts': instance.fenCounts,
  'moves': instance.moves,
  'currentHalfmoveIndex': instance.currentHalfmoveIndex,
  'result': instance.result,
  'termination': _$GameTerminationEnumMap[instance.termination]!,
  'resignationSide': instance.resignationSide,
  'timeoutSide': instance.timeoutSide,
  'agreementDraw': instance.agreementDraw,
  'halfmoveClock': instance.halfmoveClock,
  'materialEvaluation': instance.materialEvaluation,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};

const _$GameTerminationEnumMap = {
  GameTermination.checkmate: 'checkmate',
  GameTermination.stalemate: 'stalemate',
  GameTermination.timeout: 'timeout',
  GameTermination.resignation: 'resignation',
  GameTermination.agreement: 'agreement',
  GameTermination.threefoldRepetition: 'threefoldRepetition',
  GameTermination.fiftyMoveRule: 'fiftyMoveRule',
  GameTermination.insufficientMaterial: 'insufficientMaterial',
  GameTermination.ongoing: 'ongoing',
};
