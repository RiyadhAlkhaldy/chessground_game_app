// test/game_state_test.dart
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('threefold repetition detection via knight loop', () {
    final g = GameState();
    // sequence: Nf3 Nf6 Ng1 Ng8 Nf3 Nf6 Ng1 Ng8 -> start position repeats 3 times
    final moves = ['Nf3', 'Nf6', 'Ng1', 'Ng8', 'Nf3', 'Nf6', 'Ng1', 'Ng8'];
    for (final san in moves) {
      final m = g.position.parseSan(san)!;
      g.play(m);
    }
    expect(g.isThreefoldRepetition(), isTrue);
  });

  test('fifty-move rule detection via halfmoves value', () {
    // craft a FEN with halfmoves = 100
    final fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 100 50';
    final pos = Chess.fromSetup(Setup.parseFen(fen));
    final g = GameState(initial: pos);
    expect(g.halfmoveClock, equals(100));
    expect(g.isFiftyMoveRule(), isTrue);
  });

  test('agreement draw and resign', () {
    final g = GameState();
    g.setAgreementDraw();
    expect(g.isAgreedDraw(), isTrue);

    final g2 = GameState();
    g2.resign(Side.white);
    expect(g2.isResigned(), isTrue);
    expect(g2.result?.winner, equals(Side.black));
  });

  test('pgn generation for short game', () {
    final g = GameState();
    final moves = ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6'];
    for (final san in moves) {
      final m = g.position.parseSan(san)!;
      g.play(m);
    }
    final pgn = g.pgnString(headers: {'White': 'Alice', 'Black': 'Bob'});
    debugPrint(pgn);
    expect(pgn.contains('1. e4 e5 2. Nf3 Nc6 3. Bb5 a6'), isTrue);
    // expect(
    //   pgn.contains(
    //     '1. e4 ( 1. e5 ) ( 1. Nf3 ) ( 1. Nc6 ) ( 1. Bb5 ) ( 1. a6 ) *',
    //   ),
    //   isTrue,
    // );
  });
  test('pgn generation for short game ..', () {
    final g = GameState();
    final moves = ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6'];
    for (final san in moves) {
      final m = g.position.parseSan(san)!;
      g.play(m); // no comment, no nags
    }
    final pgn = g.pgnString(headers: {'White': 'Alice', 'Black': 'Bob'});
    expect(pgn.contains('1. e4 e5 2. Nf3 Nc6 3. Bb5 a6'), isTrue);
  });
  test('captured pieces and material evaluation', () {
    final g = GameState();
    g.play(g.position.parseSan('e4')!);
    g.play(g.position.parseSan('d5')!);
    g.play(g.position.parseSan('exd5')!);
    final capturedByWhite = g.getCapturedPieces(Side.white);
    expect(capturedByWhite[Role.pawn], equals(1));
    final eval = g.materialEvaluationCentipawns();
    // after capturing one pawn, White should be up about +100
    expect(eval >= 100, isTrue);
  });

  ///new test at 2025/10/16
  ///
  test('threefold repetition detection via knight loop', () {
    final g = GameState();
    // sequence: Nf3 Nf6 Ng1 Ng8 Nf3 Nf6 Ng1 Ng8 -> start position repeats 3 times
    final moves = ['Nf3', 'Nf6', 'Ng1', 'Ng8', 'Nf3', 'Nf6', 'Ng1', 'Ng8'];
    for (final san in moves) {
      final m = g.position.parseSan(san)!;
      g.play(m);
    }
    expect(g.isThreefoldRepetition(), isTrue);
  });

  test('fifty-move rule detection via halfmoves value', () {
    // craft a FEN with halfmoves = 100
    final fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 100 50';
    final pos = Chess.fromSetup(Setup.parseFen(fen));
    final g = GameState(initial: pos);
    expect(g.halfmoveClock, equals(100));
    expect(g.isFiftyMoveRule(), isTrue);
  });

  test('agreement draw and resign', () {
    final g = GameState();
    g.setAgreementDraw();
    expect(g.isAgreedDraw(), isTrue);

    final g2 = GameState();
    g2.resign(Side.white);
    expect(g2.isResigned(), isTrue);
    expect(g2.result?.winner, equals(Side.black));
  });

  test('pgn generation for short game', () {
    final g = GameState();
    final moves = ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6'];
    for (final san in moves) {
      final m = g.position.parseSan(san)!;
      g.play(m); // no comment, no nags
    }
    final pgn = g.pgnString(headers: {'White': 'Alice', 'Black': 'Bob'});
    // Expect linear PGN without variations parentheses:
    expect(pgn.contains('1. e4 e5 2. Nf3 Nc6 3. Bb5 a6'), isTrue);
  });

  test('pgn generation with comments and NAGs', () {
    final g = GameState();
    // add comment and a NAG ($1)
    g.play(g.position.parseSan('e4')!, comment: 'Good central move', nags: [1]);
    g.play(g.position.parseSan('e5')!, comment: 'Mirror reply');
    g.play(g.position.parseSan('Nf3')!, nags: [2]); // $2 = mistake (as example)
    final pgn = g.pgnString(headers: {'White': 'Alice', 'Black': 'Bob'});
    // Expect SAN, NAGs as $n, and comments in { }.
    expect(
      pgn.contains('1. e4 \$1 { Good central move } e5 { Mirror reply }'),
      isTrue,
    );
    expect(pgn.contains('2. Nf3 \$2'), isTrue);
  });

  test('normalizePgn removes parentheses/variations', () {
    final raw =
        '1. e4 ( 1... e5 ) ( 1... d5 ) 1... e5 2. Nf3 ( 2... Nc6 ( 2... Nf6 ) ) 2... Nc6 *';
    final cleaned = GameState.normalizePgn(raw);
    // Should not contain parentheses or parentheses content
    expect(cleaned.contains('('), isFalse);
    expect(cleaned.contains(')'), isFalse);
    // And linear moves should remain in order (some tokens removed)
    expect(cleaned.contains('1. e4'), isTrue);
    expect(cleaned.contains('2. Nf3'), isTrue);
  });

  test('captured pieces and material evaluation', () {
    final g = GameState();
    g.play(g.position.parseSan('e4')!);
    g.play(g.position.parseSan('d5')!);
    g.play(g.position.parseSan('exd5')!);
    final capturedByWhite = g.getCapturedPieces(Side.white);
    expect(capturedByWhite[Role.pawn], equals(1));
    final eval = g.materialEvaluationCentipawns();
    // after capturing one pawn, White should be up about +100
    expect(eval >= 100, isTrue);
  });
}
