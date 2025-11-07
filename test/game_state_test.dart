import 'package:chessground_game_app/domain/services/game_state/game_state.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState', () {
    // ======================================================
    // 1. ✅ Initialization
    // ======================================================
    group('Initialization', () {
      test('Starts with default initial position', () {
        final gs = GameState();
        expect(gs.position.fen, equals(Chess.initial.fen));
        expect(gs.positionHistory.length, equals(1));
      });

      test('Starts with custom FEN', () {
        const fen =
            'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2';
        final gs = GameState(initial: Chess.fromSetup(Setup.parseFen(fen)));
        expect(gs.position.fen, equals(fen));
      });
    });

    // ======================================================
    // 2. ♟️ Move Playing
    // ======================================================
    group('Move Playing', () {
      test('Play normal move', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        expect(gs.position.turn, equals(Side.black));
        expect(gs.hasMoves, isTrue);
      });

      test('Play capture move', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen(
              'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
            ),
          ),
        );
        gs.play(Move.parse('e4d5')!);
        expect(gs.lastMoveMeta!.wasCapture, isTrue);
      });

      test('Play promotion move', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('8/P7/8/k7/8/8/8/K7 w - - 0 1'),
          ),
        );
        gs.play(Move.parse('a7a8q')!);
        expect(gs.lastMoveMeta!.wasPromotion, isTrue);
      });

      test('Play castling move', () {
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen(
              'r3k2r/pppp1ppp/8/8/8/8/PPPP1PPP/R3K2R w KQkq - 0 1',
            ),
          ),
        );
        gs.play(Move.parse('e1g1')!); // O-O
        expect(
          gs.position.fen,
          equals('r3k2r/pppp1ppp/8/8/8/8/PPPP1PPP/R4RK1 b kq - 1 1'),
        );
      });
    });

    // ======================================================
    // 3. 🔁 Undo / Redo
    // ======================================================
    group('Undo / Redo', () {
      test('Undo returns to previous position', () {
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
        final realMateFen =
            'rnb1kbnr/pppp1ppp/8/4p3/5PPq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3';
        final gs = GameState(
          initial: Chess.fromSetup(Setup.parseFen(realMateFen)),
        );
        expect(gs.isCheckmate, isTrue);
        expect(gs.isMate, isTrue);
      });

      test('Detect stalemate', () {
        final stalemateFen = '7k/5Q2/8/8/8/8/8/6K1 b - - 0 1';
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
        // A sequence of moves to create repetition
        gs.play(Move.parse('g1f3')!);
        gs.play(Move.parse('g8f6')!);
        gs.play(Move.parse('f3g1')!);
        gs.play(Move.parse('f6g8')!); // position 1
        gs.play(Move.parse('g1f3')!);
        gs.play(Move.parse('g8f6')!);
        gs.play(Move.parse('f3g1')!);
        gs.play(Move.parse('f6g8')!); // position 2
        gs.play(Move.parse('g1f3')!);
        gs.play(Move.parse('g8f6')!);
        gs.play(Move.parse('f3g1')!);
        gs.play(Move.parse('f6g8')!); // position 3
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
        expect(result, equals('1. e4 e5'));
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
            Setup.parseFen(
              'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
            ),
          ),
        );
        gs.play(Move.parse('e4d5')!);
        final unicode = gs.capturedPiecesAsUnicode(Side.white);
        expect(unicode, equals('♟×1'));
      });

      test('getCapturedPiecesList ordered correctly', () {
        // A very simple scenario: White pawn captures a black bishop.
        final gs = GameState(
          initial: Chess.fromSetup(
            Setup.parseFen('k7/8/8/8/4b3/3P4/8/K7 w - - 0 1'),
          ),
        );

        // White pawn on d3 captures black bishop on e4.
        gs.play(gs.position.parseSan('dxe4')!);

        final whiteCaptures = gs.getCapturedPiecesList(Side.white);
        final blackCaptures = gs.getCapturedPiecesList(Side.black);

        // White captured one black bishop.
        expect(whiteCaptures, equals([Role.bishop]));
        // Black has captured nothing.
        expect(blackCaptures, isEmpty);
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
        expect(
          norm,
          equals('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -'),
        );
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
        copy.clear();
        expect(gs.getMoveObjectsCopy().length, equals(1));
      });

      test('getMoveTokens includes move numbers', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        gs.play(Move.parse('e7e5')!);
        final tokens = gs.getMoveTokens;
        expect(tokens.first.moveNumber, equals(1));
        expect(tokens.last.moveNumber, equals(2));
        expect(tokens.last.san, equals('e5'));
      });
      test('getMoveTokens includes move numbers part 2', () {
        final gs = GameState();
        gs.play(Move.parse('e2e4')!);
        gs.play(Move.parse('e7e5')!);
        gs.play(Move.parse('f2f4')!);
        gs.play(Move.parse('f7f5')!);

        final tokens = gs.getMoveTokens;
        expect(tokens.first.moveNumber, equals(1));
        expect(tokens.last.moveNumber, equals(3));
        expect(tokens.last.san, equals('f5'));
      });
    });
  });
}
