// test/game_state_test.dart
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState Tests', () {
    // ======================================================
    // ✅ 1. Initialization
    // ======================================================
    group('Initialization', () {
      test('Default initialization uses standard chess position', () {
        final gs = GameState();
        expect(gs.position.fen, equals(Chess.initial.fen));
        expect(gs.positionHistory.length, equals(1));
        expect(gs.fenCounts.isNotEmpty, isTrue);
      });

      test('Custom initialization with specific FEN', () {
        final pos = Chess.fromSetup(
          Setup.parseFen('8/8/8/8/4k3/8/8/4K3 w - - 0 1'),
        );
        final gs = GameState(initial: pos);
        expect(gs.position.fen, equals(pos.fen));
        expect(gs.positionHistory.first.fen, equals(pos.fen));
      });
    });

    // ======================================================
    // ♟️ 2. Move Playing
    // ======================================================
    group('Move Playing', () {
      test('Normal move updates position and metadata', () {
        final gs = GameState();
        final move = Move.parse('e2e4');
        gs.play(move!);

        expect(gs.position.turn, equals(Side.black));
        expect(gs.lastMoveMeta, isNotNull);
        expect(gs.lastMoveMeta!.wasCapture, isFalse);
        expect(gs.fenCounts.isNotEmpty, isTrue);
      });

      test('Capture move sets wasCapture = true', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen(
              'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
            ),
          ),
        );
        final move = Move.parse('d7d5');
        gs.play(move!);
        gs.play(Move.parse('e4d5')!);
        expect(gs.lastMoveMeta!.wasCapture, isTrue);
      });

      test('Promotion move sets wasPromotion = true', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('8/P7/8/8/8/8/8/k6K w - - 0 1'),
          ),
        );
        gs.play(Move.parse('a7a8q')!);
        expect(gs.lastMoveMeta!.wasPromotion, isTrue);
      });

      test('Castling move updates fen correctly', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1'),
          ),
        );
        gs.play(Move.parse('e1g1')!); // short castle
        expect(gs.position.fen.contains('KQ'), isFalse);
      });
    });

    // ======================================================
    // 🔁 3. Undo / Redo
    // ======================================================
    group('Undo / Redo', () {
      test('Undo removes last move and restores position', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        final oldFen = gs.positionHistory.first.fen;
        gs.undoMove();
        expect(gs.position.fen, equals(oldFen));
        expect(gs.canRedo, isTrue);
      });

      test('Redo reapplies undone move', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        gs.undoMove();
        gs.redoMove();
        expect(gs.hasMoves, isTrue);
      });

      test('Redo stacks are cleared when new move is played', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        gs.undoMove();
        expect(gs.canRedo, isTrue);
        gs.play(Move.parse('d2d4')!);
        expect(gs.canRedo, isFalse);
      });
    });

    // ======================================================
    // 🏁 4. Endgame Conditions
    // ======================================================
    group('Endgame Conditions', () {
      test('Detect checkmate', () {
        final mateFen =
            'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKB1R w KQkq - 1 3';
        final gs = GameState(initial: Chess.fromSetup(Setup.parseFen(mateFen)));
        expect(gs.isCheckmate, isTrue);
        expect(gs.isGameOver, isTrue);
        expect(gs.isMate, isTrue);
      });

      test('Detect stalemate', () {
        final stalemateFen = '7k/5Q2/6K1/8/8/8/8/8 b - - 0 1';
        final gs = GameState(
          initial: Chess.fromSetup(Setup.parseFen(stalemateFen)),
        );
        expect(gs.isStalemate, isTrue);
        expect(gs.isDraw, isTrue);
      });

      test('Detect insufficient material', () {
        final pos = Chess.fromSetup(
          Setup.parseFen('8/8/8/8/8/8/8/K6k w - - 0 1'),
        );
        final gs = GameState(initial: pos);
        expect(gs.isInsufficientMaterial, isTrue);
      });

      test('Detect fifty-move rule', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('8/8/8/8/8/8/8/K6k w - - 100 1'),
          ),
        );
        expect(gs.isFiftyMoveRule(), isTrue);
      });

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

      test('Resign sets result to opposite side', () {
        final gs = GameState();
        gs.resign(Side.white);
        expect(gs.result!.winner, equals(Side.black));
        expect(gs.isResigned(), isTrue);
      });

      test('Timeout sets result to opposite side', () {
        final gs = GameState();
        gs.timeout(Side.black);
        expect(gs.result!.winner, equals(Side.white));
        expect(gs.isTimeout(), isTrue);
      });

      test('Agreement draw sets result to draw', () {
        final gs = GameState();
        gs.setAgreementDraw();
        expect(gs.result, equals(Outcome.draw));
        expect(gs.isAgreedDraw(), isTrue);
      });
    });

    // ======================================================
    // 🧾 5. PGN
    // ======================================================
    group('PGN', () {
      test('Build PGN with default headers', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        final pgn = gs.pgnString();
        expect(pgn.contains('[Event "Casual Game"]'), isTrue);
        expect(pgn.endsWith('*'), isTrue);
      });

      test('Build PGN with comments and NAGs', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!, comment: 'good move', nags: [1, 3]);
        final pgn = gs.pgnString();
        expect(pgn.contains('{ good move }'), isTrue);
        expect(pgn.contains('\$1'), isTrue);
      });

      test('Normalize PGN removes nested parentheses', () {
        const messy = '1. e4 (1. d4 (1. Nf3)) e5 (1... c5)';
        final result = GameState.normalizePgn(messy);
        expect(result.contains('('), isFalse);
      });

      test('Result appears correctly in PGN', () {
        final gs = GameState();
        gs.resign(Side.black);
        final pgn = gs.pgnString();
        expect(pgn.endsWith('1-0'), isTrue);
      });
    });

    // ======================================================
    // ⚖️ 6. Material and Captures
    // ======================================================
    group('Material and Captures', () {
      test(
        'materialEvaluationCentipawns difference should be 0 in initial',
        () {
          final gs = GameState();
          expect(gs.materialEvaluationCentipawns(), equals(0));
        },
      );

      test('capturedPiecesAsString returns "-" if none', () {
        final gs = GameState();
        expect(gs.capturedPiecesAsString(Side.white), equals('-'));
      });

      test('capturedPiecesAsUnicode shows symbols when captures exist', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('8/8/8/8/8/8/8/K6k w - - 0 1'),
          ),
        );
        final unicode = gs.capturedPiecesAsUnicode(Side.white);
        expect(unicode, equals('-')); // no captures
      });

      test('getCapturedPiecesList ordered correctly', () {
        final gs = GameState();
        final list = gs.getCapturedPiecesList(Side.white);
        expect(list, isEmpty);
      });
    });

    // ======================================================
    // 🧩 7. Helpers
    // ======================================================
    group('Helpers', () {
      test('normalizeFen keeps first four fields', () {
        const fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
        final norm = GameState.normalizeFen(fen);
        expect(norm.split(' ').length, equals(4));
      });

      test('roleUnicode returns correct symbol', () {
        final gs = GameState();
        expect(gs.roleUnicode(Role.pawn, isWhite: true), equals('♙'));
        expect(gs.roleUnicode(Role.rook, isWhite: false), equals('♜'));
      });

      test('getMoveObjectsCopy returns deep copy', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        final copy = gs.getMoveObjectsCopy();
        expect(copy.length, equals(1));
      });

      test('getMoveTokens includes move numbers', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        final tokens = gs.getMoveTokens;
        expect(tokens.first.moveNumber, equals(1));
      });
    });
  });
}
