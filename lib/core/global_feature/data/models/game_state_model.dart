// lib/data/models/game_state_model.dart

import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/data/models/mappers/entities_mapper.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/game_state_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

/// Model representing game state for data layer
/// نموذج يمثل حالة اللعبة في طبقة البيانات
@freezed
class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required String gameUuid,
    required String currentFen,
    required List<String> fenHistory,
    required Map<String, int> fenCounts,
    required List<MoveDataModel> moves,
    @Default(0) int currentHalfmoveIndex,
    String? result,
    @Default(GameTermination.ongoing) GameTermination termination,
    String? resignationSide,
    String? timeoutSide,
    @Default(false) bool agreementDraw,
    @Default(0) int halfmoveClock,
    @Default(0) int materialEvaluation,
    required DateTime lastUpdated,
  }) = _GameStateModel;

  factory GameStateModel.fromJson(Map<String, dynamic> json) => _$GameStateModelFromJson(json);
}

/// Extension for converting between Model and Entity
/// امتداد للتحويل بين النموذج والكيان
extension GameStateModelMapper on GameStateModel {
  /// Convert GameStateModel to GameStateEntity
  /// تحويل GameStateModel إلى GameStateEntity
  GameStateEntity toEntity() {
    return GameStateEntity(
      gameUuid: gameUuid,
      currentFen: currentFen,
      fenHistory: fenHistory,
      fenCounts: fenCounts,
      moves: moves.map((m) => m.toEntity()).toList(),
      currentHalfmoveIndex: currentHalfmoveIndex,
      result: result,
      termination: termination,
      resignationSide: resignationSide,
      timeoutSide: timeoutSide,
      agreementDraw: agreementDraw,
      halfmoveClock: halfmoveClock,
      materialEvaluation: materialEvaluation,
      lastUpdated: lastUpdated,
    );
  }
}

/// Extension for converting Entity to Model
/// امتداد لتحويل الكيان إلى النموذج
extension GameStateEntityToModelMapper on GameStateEntity {
  /// Convert GameStateEntity to GameStateModel
  /// تحويل GameStateEntity إلى GameStateModel
  GameStateModel toModel() {
    return GameStateModel(
      gameUuid: gameUuid,
      currentFen: currentFen,
      fenHistory: fenHistory,
      fenCounts: fenCounts,
      moves: moves.map((m) => m.toModel()).toList(),
      currentHalfmoveIndex: currentHalfmoveIndex,
      result: result,
      termination: termination,
      resignationSide: resignationSide,
      timeoutSide: timeoutSide,
      agreementDraw: agreementDraw,
      halfmoveClock: halfmoveClock,
      materialEvaluation: materialEvaluation,
      lastUpdated: lastUpdated,
    );
  }
}
