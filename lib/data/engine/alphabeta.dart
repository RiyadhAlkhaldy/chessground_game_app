// lib/engine/alphabeta.dart
import 'package:dartchess/dartchess.dart';
import 'eval.dart';
import 'movegen.dart';


class AlphaBeta {
final Evaluator eval;
AlphaBeta(this.eval);


(Move?, int) bestMove(Position root, int depth) {
int alpha = -0x3fffffff, beta = 0x3fffffff;
Move? best;
for (final m in generateLegalMoves(root)) {
final sc = -_search(root.play(m), depth - 1, -beta, -alpha);
if (sc > alpha) { alpha = sc; best = m; }
}
return (best, alpha);
}


int _search(Position pos, int depth, int alpha, int beta) {
if (depth <= 0 || pos.isGameOver) return eval.evaluate(pos);
int best = -0x3fffffff;
for (final m in generateLegalMoves(pos)) {
final sc = -_search(pos.play(m), depth - 1, -beta, -alpha);
if (sc > best) best = sc;
if (best > alpha) alpha = best;
if (alpha >= beta) break; // cut
}
return best;
}
}