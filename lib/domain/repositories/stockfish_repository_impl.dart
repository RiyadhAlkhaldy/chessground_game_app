// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

// import '../../core/const.dart';
// import '../../core/fen_validation.dart';
// import 'stockfish_repository.dart';

// class StockfishRepositoryImpl implements StockfishRepository {
//   @override
//   late Stockfish stockfish;
//   @override
//   String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
//   @override
//   late StreamSubscription stockfishOutputSubsciption;
//   @override
//   late StreamSubscription stockfishErrorSubsciption;
//   @override
//   int timeMs = defaultThinkingTimeMs;
//   @override
//   String nextMove = '';
//   @override
//   String stockfishOutputText = '';

//   void readStockfishOutput(String output) {
//     debugPrint("### $output ###");
//     // At least now, stockfish is ready : update UI.
//     stockfishOutputText += "$output\n";
//     if (output.startsWith('bestmove')) {
//       final parts = output.split(' ');

//       nextMove = parts[1];
//     }
//   }

//   void readStockfishError(String error) {
//     // At least now, stockfish is ready : update UI.
//     debugPrint("@@@$error@@@");
//   }

//   @override
//   void updateThinkingTime(int newValue) {
//     timeMs = newValue;
//   }

//   Future<void> _computeNextMove() async {
//     if (!isStrictlyValidFEN(fen)) {
//       final message = "Illegal position: '$fen' !\n";
//       stockfishOutputText = message;
//       return;
//     }
//     stockfishOutputText = '';
//     // stockfish.stdin = 'position fen $fen';
//     stockfish.stdin = 'go movetime $timeMs';
//     await Future.delayed(Duration(milliseconds: timeMs));
//     stockfish.stdin = 'stop';
//   }

//   Future<void> _stopStockfish(BuildContext context) async {
//     if (stockfish.state.value == StockfishState.disposed ||
//         stockfish.state.value == StockfishState.error) {
//       return;
//     }
//     stockfishErrorSubsciption.cancel();
//     stockfishOutputSubsciption.cancel();
//     stockfish.dispose();
//     // await Future.delayed(const Duration(milliseconds: 1200));
//     if (!context.mounted) return;
//   }

//   Future<void> _doStartStockfish() async {
//     debugPrint("_doStartStockfish");
//     stockfish = Stockfish();
//     stockfishOutputSubsciption = stockfish.stdout.listen(readStockfishOutput);
//     stockfishOutputText = '';

//     stockfishErrorSubsciption = stockfish.stderr.listen(readStockfishError);
//     await Future.delayed(const Duration(milliseconds: 1500));
//     stockfish.stdin = 'uci';
//     stockfish.stdin = 'ucinewgame';
//     await Future.delayed(const Duration(milliseconds: 3000));
//     stockfish.stdin = 'isready';
//     debugPrint("isready _doStartStockfish");
//   }

//   @override
//   Future<void> startStockfishIfNecessary() async {
//     if (stockfish.state.value == StockfishState.ready ||
//         stockfish.state.value == StockfishState.starting) {
//       debugPrint("startStockfishIfNecessary");
//       return;
//     }
//     await _doStartStockfish();
//   }

//   // @override
//   // Stream<String> outputStream() {
//   //   throw UnimplementedError();
//   // }

//   @override
//   void setPositionFen(String fen) {
//     final initialFen = isStrictlyValidFEN(fen)
//         ? fen
//         : 'RNBQKBNR/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
//     if (isStrictlyValidFEN(initialFen)) {
//       this.fen = initialFen;
//     } else {
//       debugPrint("Invalid FEN: $fen");
//     }
//   }

//   @override
//   Future<void> startEngine() async {
//     await _doStartStockfish();
//   }

//   @override
//   Future<void> stopEngine(BuildContext context) async {
//     await _stopStockfish(context);
//   }

//   @override
//   Future<void> getBestMove() async {
//     await _computeNextMove();
//   }

//   @override
//   void makeMove(String move) {
//     stockfish.stdin = 'position startpos move $move';
//     stockfish.stdin = 'd';
//   }

//   @override
//   void makeMoves(String moves) {
//     stockfish.stdin = 'position startpos moves $moves';
//   }

//   @override
//   StockfishState getState() => stockfish.state.value;

//   // //
//   //   Icon getStockfishStatusIcon() {
//   //     Color color;
//   //     switch (stockfish.state.value) {
//   //       case StockfishState.ready:
//   //         color = Colors.green;
//   //         break;
//   //       case StockfishState.disposed:
//   //       case StockfishState.error:
//   //         color = Colors.red;
//   //         break;
//   //       case StockfishState.starting:
//   //         color = Colors.orange;
//   //     }
//   //     return Icon(MdiIcons.circle, color: color);
//   //   }
// }
