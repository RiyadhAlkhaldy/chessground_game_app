// lib/src/game_state/game_state.dart
// Utilities: a thin GameState wrapper to maintain history, detect threefold/fifty-move,
// record PGN moves and handle agreement/resign/timeout.
//
// Depends on package:dartchess
// Add to package exports if you want it public: `export 'src/game_state/game_state.dart';`

import 'package:dartchess/dartchess.dart';

/// A lightweight mutable controller for a game built on top of dartchess immutable Position.
/// - Keeps fenHistory and fenCounts for repetition detection.
/// - Records moves to a PGN tree (PgnNode/PgnChildNode).
/// - Provides game-level actions: agreement draw, resign, timeout.
class GameState {
  /// Current immutable position.
  Position _pos;

  /// Full FEN history (one entry per position after each move, includes initial).
  final List<String> fenHistory = [];

  /// Normalized FEN → count (normalized = board + turn + castling + ep)
  final Map<String, int> fenCounts = {};

  /// PGN moves as a mutable tree.
  final PgnNode<PgnNodeData> pgnRoot = PgnNode<PgnNodeData>();

  /// Result/outcome of the game (null if not finished).
  Outcome? result;

  /// If non-null, this side resigned.
  Side? resignationSide;

  /// Whether players agreed to a draw.
  bool agreementFlag = false;

  /// If non-null, this side timed out.
  Side? timeoutSide;

  /// Create GameState with an initial Position (defaults to standard initial).
  GameState({Position? initial}) : _pos = initial ?? Chess.initial {
    _pushPosition(_pos);
  }

  /// Current position (immutable).
  Position get position => _pos;

  Side get turn => _pos.turn;

  /// Normalize FEN for repetition: keep board, turn, castling, en-passant only.
  // ignore: unintended_html_in_doc_comment
  /// FEN format: "<board> <turn> <castling> <ep> <halfmoves> <fullmoves>"
  static String normalizeFen(String fen) {
    final parts = fen.split(' ');
    if (parts.length < 4) return fen;
    return '${parts[0]} ${parts[1]} ${parts[2]} ${parts[3]}';
  }

  void _pushPosition(Position pos) {
    final fen = pos.fen;
    fenHistory.add(fen);
    final key = GameState.normalizeFen(fen);
    fenCounts[key] = (fenCounts[key] ?? 0) + 1;
  }

  /// Play a move (use Position.parseSan / makeSan / play).
  /// This method uses `makeSan` to compute SAN and updated position atomically.
  /// Note: makeSan returns a Dart record `(Position, String)`.
  ///
  /// Example usage:
  ///   final mv = game.position.parseSan('e4')!;
  ///   game.play(mv);
  void play(Move move) {
    // makeSan returns (Position newPos, String san)
    final record = _pos.makeSan(move);
    // destructure record (Dart 3 records)
    final Position newPos = record.$1;
    final String san = record.$2;
    _pos = newPos;
    // result = _pos.outcome;
    _pushPosition(_pos);
    pgnRoot.children.add(PgnChildNode<PgnNodeData>(PgnNodeData(san: san)));
  }

  /// Return true if current position has occurred 3 or more times.
  bool isThreefoldRepetition() {
    // 1. EndGame  isThreefoldRepetition
    final key = GameState.normalizeFen(_pos.fen);
    final cnt = fenCounts[key] ?? 0;
    return cnt >= 3;
  }

  /// Getter for half-move clock (since last pawn move or capture).
  /// Uses the immutable position's value (accurate to the current position).
  int get halfmoveClock => _pos.halfmoves; // 2. EndGame  halfmoveClock

  /// Fifty-move rule: 100 halfmoves (50 full moves) since capture/pawn move.
  bool isFiftyMoveRule() {
    // 2. EndGame  isFiftyMoveRule
    return halfmoveClock >= 100;
  }

  /// Agreement draw: set result to draw.
  void setAgreementDraw() {
    agreementFlag = true;
    result = Outcome.draw;
  }

  bool isAgreedDraw() => agreementFlag; // 3. EndGame  isAgreedDraw

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) {
    resignationSide = side;
    final winner = side == Side.white ? Side.black : Side.white;
    result = Outcome(winner: winner);
  }

  bool isResigned() => resignationSide != null; // 4. EndGame  isResigned

  /// Timeout: side timed out; winner is other side (caller handles tournament rules).
  void timeout(Side side) {
    timeoutSide = side;
    final winner = side == Side.white ? Side.black : Side.white;
    result = Outcome(winner: winner);
  }

  bool isTimeout() => timeoutSide != null; // 5. EndGame  isTimeout

  bool get isInsufficientMaterial =>
      _pos.isInsufficientMaterial; // 6. EndGame  isInsufficientMaterial

  bool get isStalemate => _pos.isStalemate; // 7. EndGame  isStalemate

  bool get isCheck => _pos.isCheck;

  bool get isGameOver => _pos.isGameOver; //

  bool get isCheckmate => _pos.isCheckmate; // 8. EndGame  isCheckmate

  // bool hasInsufficientMaterial(Side side) {
  //   return _pos.hasInsufficientMaterial(side);
  // }

  /// Returns map of pieces captured *by* [side] (i.e., opponent lost these).
  /// Map<Role,int> where Role is the dartchess Role enum.
  Map<Role, int> getCapturedPieces(Side side) {
    final opposite = side == Side.white ? Side.black : Side.white;
    final opponentCounts = _pos.board.materialCount(opposite);
    // initial counts for a standard chess side
    final Map<Role, int> initial = {
      Role.pawn: 8,
      Role.knight: 2,
      Role.bishop: 2,
      Role.rook: 2,
      Role.queen: 1,
      Role.king: 1,
    };
    final Map<Role, int> captured = {};
    for (final r in initial.keys) {
      captured[r] = (initial[r] ?? 0) - (opponentCounts[r] ?? 0);
    }
    return captured;
  }

  /// Human-readable representation for captured pieces (e.g. "pawn x1, rook x1").
  String capturedPiecesAsString(Side side) {
    final caps = getCapturedPieces(side);
    final List<String> parts = [];
    caps.forEach((role, cnt) {
      if (cnt > 0) parts.add('${role.name} x$cnt');
    });
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  /// Simple material evaluation in centipawns (White minus Black).
  /// Weights used: pawn=100, knight=300, bishop=300, rook=500, queen=900.
  int materialEvaluationCentipawns() {
    final weights = {
      Role.pawn: 100,
      Role.knight: 300,
      Role.bishop: 300,
      Role.rook: 500,
      Role.queen: 900,
      Role.king: 0,
    };
    final whiteCounts = _pos.board.materialCount(Side.white);
    final blackCounts = _pos.board.materialCount(Side.black);
    int wsum = 0, bsum = 0;
    for (final r in weights.keys) {
      final w = weights[r]!;
      wsum += (whiteCounts[r] ?? 0) * w;
      bsum += (blackCounts[r] ?? 0) * w;
    }
    return wsum - bsum;
  }

  /// Build PGN string using PgnGame and the recorded moves.
  /// You can pass custom headers (Event, White, Black, Date, ...).
  String pgnString({Map<String, String>? headers}) {
    final baseHeaders = PgnGame.defaultHeaders();
    if (headers != null) baseHeaders.addAll(headers);
    // update Result in headers if we have a result
    baseHeaders['Result'] = Outcome.toPgnString(result);
    final game = PgnGame<PgnNodeData>(
      headers: baseHeaders,
      moves: pgnRoot,
      comments: [],
    );
    return game.makePgn();
  }
}
