// import 'package:dartchess/dartchess.dart';

// enum TranspositionNodeType { exact, lowerBound, upperBound }

// class Transposition {
//   final int depth;
//   final int score;
//   final TranspositionNodeType type;
//   final Move? bestMove;

//   Transposition(this.depth, this.score, this.type, this.bestMove);
// }

// class AlphaBeta {
//   Chess game;
//   final Map<String, Transposition> _transpositionTable = {};
//   Move? _bestMove;
//   int _maxDepth = 0;

//   static const pawnTable = [
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     50,
//     50,
//     50,
//     50,
//     50,
//     50,
//     50,
//     50,
//     10,
//     10,
//     20,
//     30,
//     30,
//     20,
//     10,
//     10,
//     5,
//     5,
//     10,
//     25,
//     25,
//     10,
//     5,
//     5,
//     0,
//     0,
//     0,
//     20,
//     20,
//     0,
//     0,
//     0,
//     5,
//     -5,
//     -10,
//     0,
//     0,
//     -10,
//     -5,
//     5,
//     5,
//     10,
//     10,
//     -20,
//     -20,
//     10,
//     10,
//     5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//   ];

//   static const knightTable = [
//     -50,
//     -40,
//     -30,
//     -30,
//     -30,
//     -30,
//     -40,
//     -50,
//     -40,
//     -20,
//     0,
//     0,
//     0,
//     0,
//     -20,
//     -40,
//     -30,
//     0,
//     10,
//     15,
//     15,
//     10,
//     0,
//     -30,
//     -30,
//     5,
//     15,
//     20,
//     20,
//     15,
//     5,
//     -30,
//     -30,
//     0,
//     15,
//     20,
//     20,
//     15,
//     0,
//     -30,
//     -30,
//     5,
//     10,
//     15,
//     15,
//     10,
//     5,
//     -30,
//     -40,
//     -20,
//     0,
//     5,
//     5,
//     0,
//     -20,
//     -40,
//     -50,
//     -40,
//     -30,
//     -30,
//     -30,
//     -30,
//     -40,
//     -50,
//   ];

//   static const bishopTable = [
//     -20,
//     -10,
//     -10,
//     -10,
//     -10,
//     -10,
//     -10,
//     -20,
//     -10,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -10,
//     -10,
//     0,
//     5,
//     10,
//     10,
//     5,
//     0,
//     -10,
//     -10,
//     5,
//     5,
//     10,
//     10,
//     5,
//     5,
//     -10,
//     -10,
//     0,
//     10,
//     10,
//     10,
//     10,
//     0,
//     -10,
//     -10,
//     10,
//     10,
//     10,
//     10,
//     10,
//     10,
//     -10,
//     -10,
//     5,
//     0,
//     0,
//     0,
//     0,
//     5,
//     -10,
//     -20,
//     -10,
//     -10,
//     -10,
//     -10,
//     -10,
//     -10,
//     -20,
//   ];

//   static const rookTable = [
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     5,
//     10,
//     10,
//     10,
//     10,
//     10,
//     10,
//     5,
//     -5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -5,
//     -5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -5,
//     -5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -5,
//     -5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -5,
//     -5,
//     0,
//     0,
//     0,
//     0,
//     0,
//     0,
//     -5,
//     0,
//     0,
//     0,
//     5,
//     5,
//     0,
//     0,
//     0,
//   ];

//   AlphaBeta(this.game);

//   Move? findBestMove(int maxDepth) {
//     _bestMove = null;
//     _maxDepth = maxDepth;
//     for (int depth = 1; depth <= maxDepth; depth++) {
//       _alphaBeta(depth, -99999, 99999, false);
//     }
//     return _bestMove;
//   }

//   int _alphaBeta(int depth, int alpha, int beta, bool allowNullMove) {
//     final originalAlpha = alpha;
//     final fen = game.fen;
//     if (_transpositionTable.containsKey(fen)) {
//       final entry = _transpositionTable[fen]!;
//       if (entry.depth >= depth) {
//         if (entry.type == TranspositionNodeType.exact) {
//           if (entry.bestMove != null && depth == _maxDepth) {
//             _bestMove = entry.bestMove;
//           }
//           return entry.score;
//         } else if (entry.type == TranspositionNodeType.lowerBound) {
//           alpha = alpha > entry.score ? alpha : entry.score;
//         } else if (entry.type == TranspositionNodeType.upperBound) {
//           beta = beta < entry.score ? beta : entry.score;
//         }
//         if (alpha >= beta) {
//           if (entry.bestMove != null && depth == _maxDepth) {
//             _bestMove = entry.bestMove;
//           }
//           return entry.score;
//         }
//       }
//     }

//     if (depth == 0) {
//       return _quiescenceSearch(alpha, beta);
//     }

//     if (allowNullMove && !game.isCheck) {
//       _makeNullMove();
//       final nullMoveScore = -_alphaBeta(depth - 3, -beta, -beta + 1, false);
//       _undoNullMove();
//       if (nullMoveScore >= beta) {
//         return beta;
//       }
//     }

//     final moves = _orderByMoveValue(game.mov);
//     if (moves.isEmpty) {
//       return _evaluate();
//     }

//     Move? bestMoveForThisPosition;
//     for (final move in moves) {
//       game = game.play(move);
//       final score = -_alphaBeta(depth - 1, -beta, -alpha, true);

//       if (score >= beta) {
//         _transpositionTable[fen] = Transposition(
//           depth,
//           beta,
//           TranspositionNodeType.lowerBound,
//           move,
//         );
//         return beta;
//       }
//       if (score > alpha) {
//         alpha = score;
//         bestMoveForThisPosition = move;
//         if (depth == _maxDepth) {
//           _bestMove = move;
//         }
//       }
//     }

//     TranspositionNodeType type;
//     if (alpha <= originalAlpha) {
//       type = TranspositionNodeType.upperBound;
//     } else {
//       type = TranspositionNodeType.exact;
//     }
//     _transpositionTable[fen] = Transposition(
//       depth,
//       alpha,
//       type,
//       bestMoveForThisPosition,
//     );

//     return alpha;
//   }

//   void _makeNullMove() {
//     game.turn = game.turn == Side.white ? Side.black : Side.white;
//   }

//   void _undoNullMove() {
//     game.turn = game.turn == Side.white ? Side.black : Side.white;
//   }

//   int _quiescenceSearch(int alpha, int beta) {
//     int standPat = _evaluate();
//     if (standPat >= beta) {
//       return beta;
//     }
//     if (alpha < standPat) {
//       alpha = standPat;
//     }

//     final moves = _orderByMoveValue(game.moves(capturesOnly: true));
//     for (final move in moves) {
//       game.move(move);
//       final score = -_quiescenceSearch(-beta, -alpha);
//       game.undo();

//       if (score >= beta) {
//         return beta;
//       }
//       if (score > alpha) {
//         alpha = score;
//       }
//     }
//     return alpha;
//   }

//   List<Move> _orderByMoveValue(List<Move> moves) {
//     moves.sort((a, b) {
//       final aIsCapture = a.captured != null;
//       final bIsCapture = b.captured != null;
//       if (aIsCapture && !bIsCapture) {
//         return -1;
//       }
//       if (!aIsCapture && bIsCapture) {
//         return 1;
//       }
//       if (aIsCapture && bIsCapture) {
//         return _getPieceValue(b.captured!) - _getPieceValue(a.captured!);
//       }
//       return 0;
//     });
//     return moves;
//   }

//   int _evaluate() {
//     int score = 0;
//     for (var i = 0; i < 8; i++) {
//       for (var j = 0; j < 8; j++) {
//         final square = Square.fromInts(i, j);
//         final piece = game.get(square);
//         if (piece != null) {
//           score += _getPieceValue(piece);
//           score += _getPiecePositionValue(piece, square);
//         }
//       }
//     }
//     return game.turn == Side.white ? score : -score;
//   }

//   int _getPiecePositionValue(Piece piece, Square square) {
//     final index = square.index;
//     switch (piece.type) {
//       case PieceType.pawn:
//         return pawnTable[index];
//       case PieceType.knight:
//         return knightTable[index];
//       case PieceType.bishop:
//         return bishopTable[index];
//       case PieceType.rook:
//         return rookTable[index];
//       default:
//         return 0;
//     }
//   }

//   int _getPieceValue(Piece piece) {
//     switch (piece.type) {
//       case PieceType.pawn:
//         return 100;
//       case PieceType.knight:
//         return 320;
//       case PieceType.bishop:
//         return 330;
//       case PieceType.rook:
//         return 500;
//       case PieceType.queen:
//         return 900;
//       case PieceType.king:
//         return 20000;
//     }
//   }
// }
