import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';

class AiEngine {
  NormalMove? bestMove(Position pos, [int depth = 3]) {
    print('I am test');
    final moves = pos.legalMoves.entries;
    // print(moves);
    NormalMove? bestMove;
    // moves.map((e) {
    //   debugPrint("$e");
    // });
    for (var element in moves) {
      debugPrint("${element.key.value}");
    }
    // moves.forEach((key, value) {
    //   final Move = minimax(pos, depth, true);
    // });

    return bestMove;
  }

  Future<int> minimax(Position pos, int depth, bool isMax) async {
    final moves = pos.legalMoves.entries;
    if (isMax) {
      int best = -10000;
      for (final move in moves) {
        // pos.playUnchecked(NormalMove(from:  move.key, to: move.value));
        await minimax(pos, depth--, !isMax);
      }
      best = max(best, 5);
      return best;
    } else {
      int best = 10000;

      final move = await minimax(pos, depth--, !isMax);
      best = min(best, move);

      return move;
    }
  }
}

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
