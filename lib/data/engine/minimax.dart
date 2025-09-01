// lib/engine/minimax.dart
import 'package:dartchess/dartchess.dart';
import 'eval.dart';
import 'movegen.dart';


class MiniMax {
final Evaluator eval;
MiniMax(this.eval);


(Move?, int) bestMove(Position root, int depth) {
int bestScore = -0x3fffffff;
Move? best;
for (final m in generateLegalMoves(root)) {
final next = root.play(m);
final sc = -_minimax(next, depth - 1);
if (sc > bestScore) { bestScore = sc; best = m; }
}
return (best, bestScore);
}


int _minimax(Position pos, int depth) {
if (depth <= 0 || pos.isGameOver) return eval.evaluate(pos);
int best = -0x3fffffff;
for (final m in generateLegalMoves(pos)) {
final sc = -_minimax(pos.play(m), depth - 1);
if (sc > best) best = sc;
}
return best;
}
}