// // test/pgn_model_test.dart

// import 'package:chessground_game_app/domain/pgn_models/pgn_model.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   test('parse headers and moves with comments and variation', () {
//     final raw = '''
// [Event "Live"]
// [Site "Local"]
// [Date "2025.10.07"]
// [Round "1"]
// [White "Player A"]
// [Black "Player B"]
// [Result "1-0"]

// 1. e4 {A common opening} e5 2. Nf3 (2. Nc3 d6) 2... Nc6 3. Bb5 a6 1-0
// ''';

//     final game = PgnParser.parseOne(raw);
//     expect(game.headers['White'], 'Player A');
//     final san = toFlatSanList(game);
//     expect(san, containsAll(['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6']));

//     final out = toPgn(game);
//     expect(out.contains('[White "Player A"]'), isTrue);
//     // roundtrip parse
//     final reparsed = PgnParser.parseOne(out);
//     expect(toFlatSanList(reparsed).length, greaterThan(0));
//   });

//   test('NAG and result parsing', () {
//     final raw = '''[Event "Test"]\n1. e4 \$1 e5 \$2 1-0''';

//     final games = PgnParser.parseMany(raw);
//     expect(games.length, 1);
//     final g = games.first;
//     final flat = toFlatSanList(g);
//     expect(flat.first, 'e4');
//     // Ensure result preserved
//     expect(
//       g.raw.contains('1-0') || (g.result == '1-0' || g.result == null),
//       isTrue,
//     );
//   });

//   test('parse multiple games', () {
//     final raw = '''[Event "A"]\n1. e4 e5 1-0\n\n[Event "B"]\n1. d4 d5 0-1''';
//     final games = PgnParser.parseMany(raw);
//     expect(games.length, 2);
//     expect(games[0].headers['Event'], 'A');
//     expect(games[1].headers['Event'], 'B');
//   });

//   test('FEN header preserved', () {
//     final raw =
//         '''[FEN "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"]\n1. e4 e5 *''';
//     final game = PgnParser.parseOne(raw);
//     expect(game.headers.containsKey('FEN'), isTrue);
//   });

//   test('toPgn roundtrip', () {
//     final raw = '''[Event "Roundtrip"]\n1. e4 e5 2. Nf3 Nc6 1-0''';
//     final game = PgnParser.parseOne(raw);
//     final pgnOut = toPgn(game);
//     final reparsed = PgnParser.parseOne(pgnOut);
//     expect(toFlatSanList(reparsed), toFlatSanList(game));
//   });
// }
