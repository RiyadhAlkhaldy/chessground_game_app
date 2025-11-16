// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

void main() {
  group('stockfish test sd', () {
    test("stockfish chess engine test", () async {
      final stockfish = Stockfish();
      //  stockfish
      debugPrint(stockfish.state.value.toString());
      debugPrint("message");
    });
    test("stockfish2 testing s2a", () async {
      final stockfish = Stockfish();
      debugPrint("message");

      // Create a subscribtion on stdout : subscription that you'll have to cancel before disposing Stockfish.
      final stockfishSubscription = stockfish.stdout.listen((message) {
        debugPrint(message);
      });
      debugPrint("message");

      // Create a subscribtion on stderr : subscription that you'll have to cancel before disposing Stockfish.
      final stockfishErrorsSubscription = stockfish.stderr.listen((message) {
        debugPrint(message);
      });
      debugPrint("message last");
      debugPrint(stockfish.state.value.toString());
      final x = await stockfish.stdout.single.then((v) => v);
      debugPrint(x);
      await Future.delayed(const Duration(seconds: 2));
      debugPrint(stockfish.state.value.toString());
      // stockfish

      // Send you commands to Stockfish stdin
      stockfish.stdin = 'position startpos'; // set up start position
      stockfish.stdin =
          'position fen rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'; // set up custom position
      stockfish.stdin = 'go movetime 1500'; // search move for at most 1500ms

      // Don't remember to dispose Stockfish when you're done.
      stockfishErrorsSubscription.cancel();
      stockfishSubscription.cancel();
      stockfish.dispose();
    });
  });
}
