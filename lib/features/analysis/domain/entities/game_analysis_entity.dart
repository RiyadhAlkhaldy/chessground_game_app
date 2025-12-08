// 💾 الخطوة المقترحة 3: حفظ التحليلات مع الألعاب
// 📝 A. إضافة Game Analysis Entity
// lib/features/analysis/domain/entities/game_analysis_entity.dart

import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_evaluation_entity.dart';
import 'package:equatable/equatable.dart'; 

/// Entity representing saved game analysis
/// كيان يمثل تحليل اللعبة المحفوظ
class GameAnalysisEntity extends Equatable {
  /// UUID of the game being analyzed
  final String gameUuid;

  /// Move evaluations (moveIndex -> evaluation)
  final Map<int, EngineEvaluationEntity> moveEvaluations;

  /// Overall game accuracy for white (0-100)
  final double? whiteAccuracy;

  /// Overall game accuracy for black (0-100)
  final double? blackAccuracy;

  /// Number of blunders by white
  final int whiteBlunders;

  /// Number of blunders by black
  final int blackBlunders;

  /// Number of mistakes by white
  final int whiteMistakes;

  /// Number of mistakes by black
  final int blackMistakes;

  /// Number of inaccuracies by white
  final int whiteInaccuracies;

  /// Number of inaccuracies by black
  final int blackInaccuracies;

  /// Opening classification
  final String? openingName;

  /// ECO code
  final String? eco;

  /// Analysis completion percentage
  final double completionPercentage;

  /// Timestamp when analysis was performed
  final DateTime analyzedAt;

  const GameAnalysisEntity({
    required this.gameUuid,
    required this.moveEvaluations,
    this.whiteAccuracy,
    this.blackAccuracy,
    this.whiteBlunders = 0,
    this.blackBlunders = 0,
    this.whiteMistakes = 0,
    this.blackMistakes = 0,
    this.whiteInaccuracies = 0,
    this.blackInaccuracies = 0,
    this.openingName,
    this.eco,
    this.completionPercentage = 0.0,
    required this.analyzedAt,
  });

  @override
  List<Object?> get props => [
    gameUuid,
    moveEvaluations,
    whiteAccuracy,
    blackAccuracy,
    whiteBlunders,
    blackBlunders,
    whiteMistakes,
    blackMistakes,
    whiteInaccuracies,
    blackInaccuracies,
    openingName,
    eco,
    completionPercentage,
    analyzedAt,
  ];

  GameAnalysisEntity copyWith({
    String? gameUuid,
    Map<int, EngineEvaluationEntity>? moveEvaluations,
    double? whiteAccuracy,
    double? blackAccuracy,
    int? whiteBlunders,
    int? blackBlunders,
    int? whiteMistakes,
    int? blackMistakes,
    int? whiteInaccuracies,
    int? blackInaccuracies,
    String? openingName,
    String? eco,
    double? completionPercentage,
    DateTime? analyzedAt,
  }) {
    return GameAnalysisEntity(
      gameUuid: gameUuid ?? this.gameUuid,
      moveEvaluations: moveEvaluations ?? this.moveEvaluations,
      whiteAccuracy: whiteAccuracy ?? this.whiteAccuracy,
      blackAccuracy: blackAccuracy ?? this.blackAccuracy,
      whiteBlunders: whiteBlunders ?? this.whiteBlunders,
      blackBlunders: blackBlunders ?? this.blackBlunders,
      whiteMistakes: whiteMistakes ?? this.whiteMistakes,
      blackMistakes: blackMistakes ?? this.blackMistakes,
      whiteInaccuracies: whiteInaccuracies ?? this.whiteInaccuracies,
      blackInaccuracies: blackInaccuracies ?? this.blackInaccuracies,
      openingName: openingName ?? this.openingName,
      eco: eco ?? this.eco,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }
}
