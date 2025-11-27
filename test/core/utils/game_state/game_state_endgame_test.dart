import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState Endgame & Promotion & PGN Tests', () {
    // 🏁 Checkmate
    test('Detect checkmate correctly', () {
      final mateFen =
          'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKB1R w KQkq - 1 3';
      final gs = GameState(initial: Chess.fromSetup(Setup.parseFen(mateFen)));
      debugPrint(humanReadableBoard(gs.position.board));

      expect(gs.isCheckmate, isTrue);
      expect(gs.isMate, isTrue);
      expect(gs.isGameOver, isTrue);
    });

    // 🤝 Stalemate
    test('Detect stalemate correctly', () {
      final stalemateFen = '7k/5Q2/6K1/8/8/8/8/8 b - - 0 1';
      final gs = GameState(
        initial: Chess.fromSetup(Setup.parseFen(stalemateFen)),
      );
      expect(gs.isStalemate, isTrue);
      expect(gs.isDraw, isTrue);
      expect(gs.isGameOver, isTrue);
    });

    // 🪶 Insufficient material
    test('Detect insufficient material', () {
      final pos = Chess.fromSetup(
        Setup.parseFen('8/8/8/8/8/8/8/K6k w - - 0 1'),
      );
      final gs = GameState(initial: pos);
      expect(gs.isInsufficientMaterial, isTrue);
      expect(gs.isDraw, isTrue);
    });

    // ⏱️ Fifty-move rule
    test('Detect fifty-move rule', () {
      final gs = GameState(
        initial: Chess.fromSetup(
          Setup.parseFen('8/8/8/8/8/8/8/K6k w - - 100 1'),
        ),
      );
      expect(gs.isFiftyMoveRule(), isTrue);
    });

    // 🔁 Threefold repetition
    test('Detect threefold repetition', () {
      final gs = GameState();
      for (int i = 0; i < 3; i++) {
        gs.play(Move.parse('g1f3')!);
        gs.play(Move.parse('g8f6')!);
        gs.play(Move.parse('f3g1')!);
        gs.play(Move.parse('f6g8')!);
      }
      expect(gs.isThreefoldRepetition(), isTrue);
    });

    // 🏳️ Resignation
    test('Detect resignation and set correct winner', () {
      final gs = GameState();
      gs.resign(Side.white);
      expect(gs.isResigned(), isTrue);
      expect(gs.result!.winner, equals(Side.black));
      expect(gs.isGameOver, isTrue);
    });

    // ⌛ Timeout
    test('Detect timeout and set correct winner', () {
      final gs = GameState();
      gs.timeout(Side.black);
      expect(gs.isTimeout(), isTrue);
      expect(gs.result!.winner, equals(Side.white));
    });

    // 🤝 Agreement draw
    test('Detect agreement draw', () {
      final gs = GameState();
      gs.setAgreementDraw();
      expect(gs.isAgreedDraw(), isTrue);
      expect(gs.result, equals(Outcome.draw));
    });

    // ♟️ Pawn promotion to Queen
    test('Promotion to queen updates board correctly', () {
      final gs = GameState(
        initial: Chess.fromSetup(
          Setup.parseFen('8/P7/8/8/8/8/8/k6K w - - 0 1'),
        ),
      );
      gs.play(Move.parse('a7a8q')!);
      expect(gs.lastMoveMeta!.wasPromotion, isTrue);
      final piece = gs.position.board.pieceAt(Square.fromName('a8'));
      expect(piece!.role, equals(Role.queen));
      expect(piece.color, equals(Side.white));
    });

    // ♞ Pawn promotion to Knight
    test('Promotion to knight updates board correctly', () {
      final gs = GameState(
        initial: Chess.fromSetup(
          Setup.parseFen('8/P7/8/8/8/8/8/k6K w - - 0 1'),
        ),
      );
      gs.play(Move.parse('a7a8n')!);
      expect(gs.lastMoveMeta!.wasPromotion, isTrue);
      final piece = gs.position.board.pieceAt(Square.fromName('a8'));
      expect(piece!.role, equals(Role.knight));
    });

    // 🧾 PGN basic
    test('PGN basic after one move', () {
      final gs = GameState();
      gs.play(Move.parse('e2e4')!);
      final pgn = gs.pgnString();
      expect(pgn.contains('1. e4'), isTrue);
      expect(pgn.endsWith('*'), isTrue);
    });

    // 🧾 PGN with result after resign
    test('PGN after resign shows correct result', () {
      final gs = GameState();
      gs.resign(Side.black);
      final pgn = gs.pgnString();
      expect(pgn.endsWith('1-0'), isTrue);
    });

    // 🧾 PGN with comments and NAGs
    test('PGN with comment and NAGs', () {
      final gs = GameState();
      gs.play(Move.parse('e2e4')!, comment: 'good move', nags: [1, 3]);
      final pgn = gs.pgnString();
      expect(pgn.contains('{ good move }'), isTrue);
      expect(pgn.contains('\$1'), isTrue);
      expect(pgn.contains('\$3'), isTrue);
    });

    // 🧾 Normalize PGN
    test('Normalize PGN removes nested parentheses', () {
      const messy = '1. e4 (1. d4 (1. Nf3)) e5 (1... c5)';
      final clean = GameState.normalizePgn(messy);
      expect(clean.contains('('), isFalse);
    });
  });
}
