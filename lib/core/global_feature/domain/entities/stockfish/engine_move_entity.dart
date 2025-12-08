
import 'package:equatable/equatable.dart';

/// Entity representing a move suggested by engine
/// كيان يمثل حركة مقترحة من المحرك
class EngineMoveEntity extends Equatable {
  /// Move in UCI format (e.g., "e2e4")
  /// الحركة بصيغة UCI
  final String uci;

  /// Move in SAN format (e.g., "e4")
  /// الحركة بصيغة SAN
  final String? san;

  /// Evaluation after this move
  /// التقييم بعد هذه الحركة
  final int? evaluation;

  /// Whether this is the best move
  /// ما إذا كانت هذه أفضل حركة
  final bool isBestMove;

  /// Rank among suggested moves (1 = best)
  /// الترتيب بين الحركات المقترحة (1 = الأفضل)
  final int rank;

  const EngineMoveEntity({
    required this.uci,
    this.san,
    this.evaluation,
    this.isBestMove = false,
    this.rank = 1,
  });

  @override
  List<Object?> get props => [uci, san, evaluation, isBestMove, rank];

  EngineMoveEntity copyWith({
    String? uci,
    String? san,
    int? evaluation,
    bool? isBestMove,
    int? rank,
  }) {
    return EngineMoveEntity(
      uci: uci ?? this.uci,
      san: san ?? this.san,
      evaluation: evaluation ?? this.evaluation,
      isBestMove: isBestMove ?? this.isBestMove,
      rank: rank ?? this.rank,
    );
  }
}
