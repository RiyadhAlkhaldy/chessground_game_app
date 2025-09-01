// // في SearchStats (nodes, qnodes, tthit, …). لتوليد مقارنة:
// // lib/bench/bench.dart
// import 'package:chessground_game_app/data/engine/alphabeta.dart';
// import 'package:chessground_game_app/data/engine/eval.dart';
// import 'package:chessground_game_app/data/engine/minimax.dart';
// import 'package:chessground_game_app/data/engine/search.dart';
// import 'package:dartchess/dartchess.dart';
// import 'package:flutter_test/flutter_test.dart';

// final fens = [
//   kInitialFEN,
//   'r1bqkbnr/ppp2Qpp/2np4/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4',
//   'r2q1rk1/pp1n1ppp/2pbpn2/3p4/3P1B2/2N1PN2/PPQ1BPPP/R3K2R w KQ - 0 10',
// ];

// void main() {
//   test('description', () {
//     final eval = Evaluator();
//     final mm = MiniMax(eval);
//     final ab = AlphaBeta(eval);
//     final eng = SearchEngine(eval: eval);

//     for (final fen in fens) {
//       final pos = Chess.fromSetup(Setup.parseFen(fen));
//       final r1 = mm.bestMove(pos, 3);
//       final r2 = ab.bestMove(pos, 5);
//       final r3 = eng.search(
//         pos,
//         const SearchLimits(maxDepth: 6, moveTime: Duration(milliseconds: 1500)),
//       );
//       print('FEN: $fen');
//       print('  Minimax d3 => ${r1.$2}');
//       print('  AlphaBeta d5 => ${r2.$2}');
//       print(
//         '  Engine d<=6 => score ${r3.score}, nodes ${eng.stats.nodes}, tthit ${eng.stats.tthit}',
//       );
//     }
//   });
// }
