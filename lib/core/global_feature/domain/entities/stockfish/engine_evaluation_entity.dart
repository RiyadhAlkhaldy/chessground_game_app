// lib/features/analysis/domain/entities/engine_evaluation_entity.dart

import 'package:equatable/equatable.dart';

/// Entity representing Stockfish evaluation of a position
/// كيان يمثل تقييم Stockfish لموضع
class EngineEvaluationEntity extends Equatable {
  /// Evaluation score in centipawns (positive = white advantage)
  /// التقييم بالسنتي-بيدق (موجب = ميزة للأبيض)
  final int? centipawns;

  /// Mate in X moves (positive = white mates, negative = black mates)
  /// كش مات في X حركة (موجب = أبيض يكش، سالب = أسود يكش)
  final int? mate;

  /// Depth of analysis (number of plies/half-moves)
  /// عمق التحليل (عدد الأنصاف-حركات)
  final int depth;

  /// Number of nodes analyzed
  /// عدد العقد المحللة
  final int? nodes;

  /// Best move found by engine
  /// أفضل حركة وجدها المحرك
  final String bestMove;

  /// Principal variation (sequence of best moves)
  /// الخط الرئيسي (تسلسل أفضل الحركات)
  final List<String> pv;

  /// Time taken for analysis (milliseconds)
  /// الوقت المستغرق للتحليل (مللي ثانية)
  final int? time;

  const EngineEvaluationEntity({
    this.centipawns,
    this.mate,
    required this.depth,
    this.nodes,
    required this.bestMove,
    this.pv = const [],
    this.time,
  });

  /// Check if position is a forced mate
  /// التحقق من كون الموضع كش مات محتوم
  bool get isMate => mate != null;

  /// Get human-readable evaluation string
  /// الحصول على نص تقييم مقروء
  String get evaluationString {
    if (mate != null) {
      return mate! > 0 ? 'M$mate' : 'M${-mate!}';
    }
    final pawns = (centipawns ?? 0) / 100.0;
    return pawns >= 0
        ? '+${pawns.toStringAsFixed(2)}'
        : pawns.toStringAsFixed(2);
  }

  @override
  List<Object?> get props => [
    centipawns,
    mate,
    depth,
    nodes,
    bestMove,
    pv,
    time,
  ];

  EngineEvaluationEntity copyWith({
    int? centipawns,
    int? mate,
    int? depth,
    int? nodes,
    String? bestMove,
    List<String>? pv,
    int? time,
  }) {
    return EngineEvaluationEntity(
      centipawns: centipawns ?? this.centipawns,
      mate: mate ?? this.mate,
      depth: depth ?? this.depth,
      nodes: nodes ?? this.nodes,
      bestMove: bestMove ?? this.bestMove,
      pv: pv ?? this.pv,
      time: time ?? this.time,
    );
  }
}
