import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_move_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'engine_move_model.freezed.dart';
part 'engine_move_model.g.dart';

@freezed
class EngineMoveModel with _$EngineMoveModel {
  const factory EngineMoveModel({
    required String uci,
    String? san,
    int? evaluation,
    @Default(false) bool isBestMove,
    @Default(1) int rank,
  }) = _EngineMoveModel;

  factory EngineMoveModel.fromJson(Map<String, dynamic> json) =>
      _$EngineMoveModelFromJson(json);
}

extension EngineMoveModelMapper on EngineMoveModel {
  EngineMoveEntity toEntity() {
    return EngineMoveEntity(
      uci: uci,
      san: san,
      evaluation: evaluation,
      isBestMove: isBestMove,
      rank: rank,
    );
  }
}

extension EngineMoveEntityToModelMapper on EngineMoveEntity {
  EngineMoveModel toModel() {
    return EngineMoveModel(
      uci: uci,
      san: san,
      evaluation: evaluation,
      isBestMove: isBestMove,
      rank: rank,
    );
  }
}
