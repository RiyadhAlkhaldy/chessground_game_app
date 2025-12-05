// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameAnalysisModelImpl _$$GameAnalysisModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GameAnalysisModelImpl(
      id: (json['id'] as num?)?.toInt(),
      gameUuid: json['gameUuid'] as String,
      moveEvaluationsJson: json['moveEvaluationsJson'] as String,
      whiteAccuracy: (json['whiteAccuracy'] as num?)?.toDouble(),
      blackAccuracy: (json['blackAccuracy'] as num?)?.toDouble(),
      whiteBlunders: (json['whiteBlunders'] as num?)?.toInt() ?? 0,
      blackBlunders: (json['blackBlunders'] as num?)?.toInt() ?? 0,
      whiteMistakes: (json['whiteMistakes'] as num?)?.toInt() ?? 0,
      blackMistakes: (json['blackMistakes'] as num?)?.toInt() ?? 0,
      whiteInaccuracies: (json['whiteInaccuracies'] as num?)?.toInt() ?? 0,
      blackInaccuracies: (json['blackInaccuracies'] as num?)?.toInt() ?? 0,
      openingName: json['openingName'] as String?,
      eco: json['eco'] as String?,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
    );

Map<String, dynamic> _$$GameAnalysisModelImplToJson(
        _$GameAnalysisModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameUuid': instance.gameUuid,
      'moveEvaluationsJson': instance.moveEvaluationsJson,
      'whiteAccuracy': instance.whiteAccuracy,
      'blackAccuracy': instance.blackAccuracy,
      'whiteBlunders': instance.whiteBlunders,
      'blackBlunders': instance.blackBlunders,
      'whiteMistakes': instance.whiteMistakes,
      'blackMistakes': instance.blackMistakes,
      'whiteInaccuracies': instance.whiteInaccuracies,
      'blackInaccuracies': instance.blackInaccuracies,
      'openingName': instance.openingName,
      'eco': instance.eco,
      'completionPercentage': instance.completionPercentage,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
    };
