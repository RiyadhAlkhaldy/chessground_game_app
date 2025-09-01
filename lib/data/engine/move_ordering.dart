// 2.3 ترتيب النقلات (MVV-LVA + Killer + History)
// lib/engine/move_ordering.dart
import 'package:dartchess/dartchess.dart';

import 'movegen.dart';

class KillerTable {
  final List<List<Move?>> killers; // depth × 2
  KillerTable(int maxDepth)
    : killers = List.generate(maxDepth + 5, (_) => List.filled(2, null));
  void push(int depth, Move m) {
    if (killers[depth][0] != m) {
      killers[depth][1] = killers[depth][0];
      killers[depth][0] = m;
    }
  }
}

class HistoryHeuristic {
  final Map<(int, int), int> hist = {}; // (fromIndex,toIndex) -> score
  void bump(Move m, int depth) {
    final nm = (m as NormalMove);
    final k = (nm.from.value, nm.to.value);
    hist[k] = (hist[k] ?? 0) + depth * depth;
  }

  int value(Move m) {
    final nm = (m as NormalMove);
    return hist[(nm.from.value, nm.to.value)] ?? 0;
  }
}

int mvvLvaScore(Position pos, Move m) {
  const v = {
    Role.pawn: 100,
    Role.knight: 320,
    Role.bishop: 330,
    Role.rook: 500,
    Role.queen: 900,
    Role.king: 20000,
  };
  final nm = (m as NormalMove);
  final fromPiece = pos.board.pieceAt(nm.from);
  final toPiece = pos.board.pieceAt(nm.to);
  final victim = toPiece?.role;
  final attacker = fromPiece?.role;
  if (victim == null) return 0; // قد تكون En passant معالجة خارجية
  return (v[victim]! * 16) - (v[attacker] ?? 0);
}

List<Move> orderMoves(
  Position pos,
  List<Move> moves, {
  Move? ttMove,
  required KillerTable killers,
  required HistoryHeuristic history,
  required int depth,
}) {
  final scored = <(Move, int)>[];
  for (final m in moves) {
    int s = 0;
    if (ttMove != null && _sameMove(ttMove, m)) s += 1 << 30; // TT أولاً
    if (isCapture(pos, m)) s += (1 << 20) + mvvLvaScore(pos, m);
    final k0 = killers.killers[depth][0];
    final k1 = killers.killers[depth][1];
    if (k0 != null && _sameMove(k0, m)) s += 1 << 18;
    if (k1 != null && _sameMove(k1, m)) s += 1 << 17;
    if ((m as NormalMove).promotion != null) s += 1 << 16;
    s += history.value(m) & 0xffff; // History
    scored.add((m, s));
  }
  scored.sort((a, b) => b.$2.compareTo(a.$2));
  return [for (final e in scored) e.$1];
}

bool _sameMove(Move a, Move b) {
  final na = (a as NormalMove);
  final nb = (b as NormalMove);
  return na.from == nb.from && na.to == nb.to && na.promotion == nb.promotion;
}
