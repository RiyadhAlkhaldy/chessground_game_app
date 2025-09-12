// import 'dart:async';
// import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

// // (توضيح بالعربية): هذا الكلاس هو المسؤول المباشر عن التعامل مع حزمة Stockfish.
// // It acts as a direct interface to the engine, hiding the package's implementation details.
// class StockfishEngineService {
//   final _stockfish = Stockfish();
//   StreamSubscription<String>? _outputSubscription;
//   Completer<String>? _bestMoveCompleter;

//   // Initializes the engine and starts listening to its output.
//   // (توضيح بالعربية): تهيئة المحرك والبدء في الاستماع لمخرجاته.
//   Future<void> initialize() async {
//     _outputSubscription = _stockfish.stdout.listen(_handleEngineOutput);
//   }

//   // Parses the engine's output to find the "bestmove".
//   // (توضيح بالعربية): تحليل مخرجات المحرك للعثور على أفضل نقلة.
//   void _handleEngineOutput(String output) {
//     if (output.startsWith('bestmove')) {
//       final bestMove = output.split(' ')[1];
//       if (_bestMoveCompleter != null && !_bestMoveCompleter!.isCompleted) {
//         _bestMoveCompleter!.complete(bestMove);
//       }
//     }
//   }

//   // Sends commands to find the best move for a given position (FEN).
//   // (توضيح بالعربية): إرسال أوامر للمحرك لإيجاد أفضل نقلة لوضع معين.
//   Future<String> getBestMove(String fen, int skillLevel) async {
//     _bestMoveCompleter = Completer<String>();
    
//     // Skill level can be mapped to depth.
//     // This is a simple mapping, you can create a more complex one.
//     // (توضيح بالعربية): يمكننا ربط مستوى المهارة بعمق البحث في المحرك.
//     final depth = (skillLevel * 2).clamp(1, 20);

//     _stockfish.stdin = 'position fen $fen';
//     _stockfish.stdin = 'go depth $depth';

//     return _bestMoveCompleter!.future;
//   }

//   // Disposes of the engine and stream subscription to prevent memory leaks.
//   // (توضيح بالعربية): التخلص من المحرك والموارد لتجنب تسرب الذاكرة.
//   void dispose() {
//     _outputSubscription?.cancel();
//     _stockfish.dispose();
//   }
// }