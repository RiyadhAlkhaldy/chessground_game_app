import 'package:dartchess/dartchess.dart';

const pieceValues = {
  Role.pawn: 100,
  Role.knight: 320,
  Role.bishop: 330,
  Role.rook: 500,
  Role.queen: 900,
  Role.king: 20000,
};

int evaluate(Chess pos) {
  int score = 0;
  for (final sq in Square.values) {
    final pc = pos.board.pieceAt(sq);
    if (pc == null) continue;
    final sgn = pc.color == Side.white ? 1 : -1;
    score += sgn * pieceValues[pc.role]!;
  }
  // mobility (simplified)
  int mobility = 0;
  for (final e in pos.legalMoves.entries) mobility += e.value.squares.length;
  score += (pos.turn == Side.white ? 1 : -1) * mobility;
  return score;
}

class SearchStats {
  int nodes = 0;
}

class BasicSearch {
  final SearchStats stats = SearchStats();
  final int maxDepth;
  BasicSearch({this.maxDepth = 4});

  int negamax(Chess pos, int depth) {
    stats.nodes++;
    if (depth == 0 || pos.isGameOver) {
      return evaluate(pos); // موجبة = أفضل للأبيض
    }

    int best = -0x3fffffff;
    // توليد النقلات القانونية
    for (final move in _generateMoves(pos)) {
      final next = pos.play(move) as Chess;
      final score = -negamax(next, depth - 1);
      if (score > best) best = score;
    }
    return best;
  }

  Move? bestMove(Position pos) {
    Move? best;
    int bestScore = -0x3fffffff;
    for (final move in _generateMoves(pos)) {
      final score = -negamax(pos.play(move) as Chess, maxDepth - 1);
      if (score > bestScore) {
        bestScore = score;
        best = move;
      }
    }
    return best;
  }

  Iterable<Move> _generateMoves(Position pos) sync* {
    // legalMoves: IMap<Square, SquareSet>
    for (final entry in pos.legalMoves.entries) {
      final from = entry.key;
      for (final to in entry.value.squares) {
        // نُطبِّع الحركة لضمان التمثيل الصحيح (التبييت/الترقية…)
        yield pos.normalizeMove(NormalMove(from: from, to: to));
      }
    }
  }
}

// / lib/engine/search.dart (إصدار Alpha-Beta مبسّط)
class AlphaBetaBasic {
  final SearchStats stats = SearchStats();
  final int maxDepth;
  AlphaBetaBasic({this.maxDepth = 10});

  int negamax(Chess pos, int depth, int alpha, int beta) {
    stats.nodes++;
    if (depth == 0 || pos.isGameOver) return evaluate(pos);

    int a = alpha;
    int best = -0x3fffffff;

    for (final move in _generateMoves(pos)) {
      final score = -negamax(pos.play(move) as Chess, depth - 1, -beta, -a);
      if (score > best) best = score;
      if (best > a) a = best; // تحديث alpha
      if (a >= beta) break; // تقليم Beta
    }
    return best;
  }

  Move? bestMove(Chess pos) {
    Move? best;
    int alpha = -0x3fffffff, beta = 0x3fffffff;
    int bestScore = -0x3fffffff;

    for (final move in _generateMoves(pos)) {
      final score = -negamax(
        pos.play(move) as Chess,
        maxDepth - 1,
        -beta,
        -alpha,
      );
      if (score > bestScore) {
        bestScore = score;
        best = move;
      }
      if (bestScore > alpha) alpha = bestScore;
    }
    return best;
  }

  Iterable<Move> _generateMoves(Chess pos) sync* {
    for (final entry in pos.legalMoves.entries) {
      final from = entry.key;
      for (final to in entry.value.squares) {
        yield pos.normalizeMove(NormalMove(from: from, to: to));
      }
    }
  }
}
