// lib/engine/movegen.dart
import 'package:dartchess/dartchess.dart';

/// يحوّل legalMoves (IMap<Square, SquareSet>) إلى قائمة Move
Iterable<NormalMove> generateLegalMoves(Position pos) sync* {
  final lm = pos.legalMoves; // IMap<Square, SquareSet>
  for (final entry in lm.entries) {
    final from = entry.key; // Square
    final dests = entry.value; // SquareSet
    for (final to in dests.squares) {
      // Promotions: إذا كان بيدق يصل للترقية، أنشئ 4 نقلات
      final piece = pos.board.pieceAt(from);
      final isPawn = piece?.role == Role.pawn;
      final toRank = to.rank.value; // 0..7
      final promoteToLastRank = isPawn && (toRank == 0 || toRank == 7);
      if (promoteToLastRank) {
        for (final pr in [Role.queen, Role.rook, Role.bishop, Role.knight]) {
          final nm = NormalMove(from: from, to: to, promotion: pr);
          // yield pos.normalizeMove(nm);
          yield nm;
        }
      } else {
        // yield pos.normalizeMove(NormalMove(from: from, to: to));

        yield NormalMove(from: from, to: to);
      }
    }
  }
}

bool isCapture(Position pos, Move m) {
  final from = (m as NormalMove).from;
  final to = m.to;
  final targetBefore = pos.board.pieceAt(to);
  if (targetBefore != null) return true; // اصطياد عادي
  // En passant: بيدق يتحرك قطريًا إلى مربع فارغ يساوي epSquare
  final mover = pos.board.pieceAt(from);
  final isPawn = mover?.role == Role.pawn;
  return isPawn && pos.epSquare != null && to == pos.epSquare;
}

/// هل النقلة تعطي كيش بعد تنفيذها؟
bool givesCheck(Position pos, Move m) {
  final next = pos.play(m);
  return next
      .isCheck; // بعد اللعب، الدور ينتقل للخصم؛ إذا كان isCheck=true فالموقف "يعطي كيش"
}
