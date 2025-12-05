
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'engine_evaluation_model.freezed.dart';
part 'engine_evaluation_model.g.dart';

@freezed
class EngineEvaluationModel with _$EngineEvaluationModel {
  const factory EngineEvaluationModel({
    int? centipawns,
    int? mate,
    required int depth,
    int? nodes,
    required String bestMove,
    @Default([]) List<String> pv,
    int? time,
  }) = _EngineEvaluationModel;

  factory EngineEvaluationModel.fromJson(Map<String, dynamic> json) =>
      _$EngineEvaluationModelFromJson(json);
}

/// Extension for converting Model to Entity
extension EngineEvaluationModelMapper on EngineEvaluationModel {
  EngineEvaluationEntity toEntity() {
    return EngineEvaluationEntity(
      centipawns: centipawns,
      mate: mate,
      depth: depth,
      nodes: nodes,
      bestMove: bestMove,
      pv: pv,
      time: time,
    );
  }
}

/// Extension for converting Entity to Model
extension EngineEvaluationEntityToModelMapper on EngineEvaluationEntity {
  EngineEvaluationModel toModel() {
    return EngineEvaluationModel(
      centipawns: centipawns,
      mate: mate,
      depth: depth,
      nodes: nodes,
      bestMove: bestMove,
      pv: pv,
      time: time,
    );
  }
}
