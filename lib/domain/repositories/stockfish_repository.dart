// // lib/domain/repositories/stockfish_repository.dart
// // العقدة (abstract) لتعامل الطبقة العليا (Domain) مع Stockfish / مصدر الصوت
// // import 'package:dartz/dartz.dart';

// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

// import '../../core/const.dart';

// abstract class StockfishRepository {
//   late Stockfish stockfish;
//   String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
//   late StreamSubscription stockfishOutputSubsciption;
//   late StreamSubscription stockfishErrorSubsciption;
//   int timeMs = defaultThinkingTimeMs;
//   final String nextMove = '';
//   String stockfishOutputText = '';
//   Future<void> startEngine();
//   Future<void> startStockfishIfNecessary();
//   Future<void> stopEngine(BuildContext context);
//   void setPositionFen(String fen);
//   void makeMove(String move);
//   void makeMoves(String moves);
//   StockfishState getState();
//   Future<void> getBestMove();
//   // Stream<String> outputStream(); // لإيصال مخرجات المحرك (logs/analysis)
//   void updateThinkingTime(int newValue);
// }
