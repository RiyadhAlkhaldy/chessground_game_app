 
// 📝 B. Isar Collection for Game Analysis
// lib/features/analysis/data/collections/game_analysis.dart

import 'package:chessground_game_app/features/analysis/data/models/game_analysis_model.dart';
import 'package:isar/isar.dart'; 

part 'game_analysis.g.dart';

@Collection()
class GameAnalysis {
  Id id = Isar.autoIncrement;

  /// UUID of the associated game
  @Index(unique: true)
  late String gameUuid;

  /// Serialized move evaluations (JSON string)
  late String moveEvaluationsJson;

  /// Overall accuracies
  double? whiteAccuracy;
  double? blackAccuracy;

  /// Move classifications
  int whiteBlunders = 0;
  int blackBlunders = 0;
  int whiteMistakes = 0;
  int blackMistakes = 0;
  int whiteInaccuracies = 0;
  int blackInaccuracies = 0;

  /// Opening info
  String? openingName;
  String? eco;

  /// Analysis metadata
  double completionPercentage = 0.0;
  DateTime analyzedAt = DateTime.now();

  @override
  String toString() => "GameAnalysis{gameUuid:$gameUuid, completion:$completionPercentage%}";
}

extension GameAnalysisMapper on GameAnalysis {
  GameAnalysisModel toModel() {
    return GameAnalysisModel(
      id: id,
      gameUuid: gameUuid,
      moveEvaluationsJson: moveEvaluationsJson,
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
