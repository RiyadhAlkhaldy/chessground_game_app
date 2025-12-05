// 📝 C. Game Analysis Model
// lib/features/analysis/data/models/game_analysis_model.dart

import 'dart:convert';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_analysis_model.freezed.dart';
part 'game_analysis_model.g.dart';

@freezed
class GameAnalysisModel with _$GameAnalysisModel {
  const factory GameAnalysisModel({
    int? id,
    required String gameUuid,
    required String moveEvaluationsJson,
    double? whiteAccuracy,
    double? blackAccuracy,
    @Default(0) int whiteBlunders,
    @Default(0) int blackBlunders,
    @Default(0) int whiteMistakes,
    @Default(0) int blackMistakes,
    @Default(0) int whiteInaccuracies,
    @Default(0) int blackInaccuracies,
    String? openingName,
    String? eco,
    @Default(0.0) double completionPercentage,
    required DateTime analyzedAt,
  }) = _GameAnalysisModel;

  factory GameAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$GameAnalysisModelFromJson(json);
}

extension GameAnalysisModelMapper on GameAnalysisModel {
  GameAnalysisEntity toEntity() {
    // Parse move evaluations from JSON
    final Map<int, EngineEvaluationEntity> evaluations = {};

    try {
      final decoded = jsonDecode(moveEvaluationsJson) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        final index = int.parse(key);
        evaluations[index] = EngineEvaluationEntity(
          centipawns: value['centipawns'] as int?,
          mate: value['mate'] as int?,
          depth: value['depth'] as int,
          nodes: value['nodes'] as int?,
          bestMove: value['bestMove'] as String,
          pv: (value['pv'] as List<dynamic>?)?.cast<String>() ?? [],
          time: value['time'] as int?,
        );
      });
    } catch (e) {
      // Handle JSON parse error
    }

    return GameAnalysisEntity(
      gameUuid: gameUuid,
      moveEvaluations: evaluations,
      whiteAccuracy: whiteAccuracy,
      blackAccuracy: blackAccuracy,
      whiteBlunders: whiteBlunders,
      blackBlunders: blackBlunders,
      whiteMistakes: whiteMistakes,
      blackMistakes: blackMistakes,
      whiteInaccuracies: whiteInaccuracies,
      blackInaccuracies: blackInaccuracies,
      openingName: openingName,
      eco: eco,
      completionPercentage: completionPercentage,
      analyzedAt: analyzedAt,
    );
  }
}

extension GameAnalysisEntityToModelMapper on GameAnalysisEntity {
  GameAnalysisModel toModel() {
    // Serialize move evaluations to JSON
    final Map<String, dynamic> evaluationsMap = {};

    moveEvaluations.forEach((index, evaluation) {
      evaluationsMap[index.toString()] = {
        'centipawns': evaluation.centipawns,
        'mate': evaluation.mate,
        'depth': evaluation.depth,
        'nodes': evaluation.nodes,
        'bestMove': evaluation.bestMove,
        'pv': evaluation.pv,
        'time': evaluation.time,
      };
    });

    return GameAnalysisModel(
      gameUuid: gameUuid,
      moveEvaluationsJson: jsonEncode(evaluationsMap),
      whiteAccuracy: whiteAccuracy,
      blackAccuracy: blackAccuracy,
      whiteBlunders: whiteBlunders,
      blackBlunders: blackBlunders,
      whiteMistakes: whiteMistakes,
      blackMistakes: blackMistakes,
      whiteInaccuracies: whiteInaccuracies,
      blackInaccuracies: blackInaccuracies,
      openingName: openingName,
      eco: eco,
      completionPercentage: completionPercentage,
      analyzedAt: analyzedAt,
    );
  }
}
