// Utilities: a thin GameState wrapper to maintain history, detect threefold/fifty-move,
// record PGN moves and handle agreement/resign/timeout.
//
// Depends on package:dartchess
// Add to package exports if you want it public: `export 'src/game_state/game_state.dart';`

import 'dart:async';

import 'package:chessground_game_app/core/utils/dialog/game_status.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

import '../../../data/models/move_data_model.dart';

/// A lightweight mutable controller for a game built on top of dartchess immutable Position.
/// - Keeps fenHistory and fenCounts for repetition detection.
/// - Records moves to a PGN tree (PgnNode/PgnChildNode).
/// - Provides game-level actions: agreement draw, resign, timeout.
class GameState {
  final StreamController<GameStatus> _gameStatus = StreamController.broadcast();
  Stream<GameStatus> get gameStatus => _gameStatus.stream;

  void dispose() {
    _gameStatus.close();
  }

  GameStatus status() {
    if (isGameOverExtended) {
      if (isMate) {
        if (isCheckmate) {
          return GameStatus.checkmate;
        }
        if (isTimeout()) {
          return GameStatus.timeout;
        }
        if (isResigned()) {
          return GameStatus.resign;
        }
      } else if (isDraw) {
        if (isFiftyMoveRule()) {
          return GameStatus.fiftyMoveRule;
        }
        if (isStalemate) {
          return GameStatus.stalemate;
        }
        if (isInsufficientMaterial) {
          return GameStatus.insufficientMaterialClaim;
        }
        if (isThreefoldRepetition()) {
          return GameStatus.threefoldRepetition;
        }
        if (isAgreedDraw()) {
          return GameStatus.agreement;
        }
      }
    }

    return GameStatus.ongoing;
  }

  /// Current immutable position.
  Position _pos;

  /// Full Position history (one entry per position after each move, includes initial).
  final List<Position> positionHistory = [];
  final List<Position> _redoPositonStack = [];

  /// Normalized FEN → count (normalized = board + turn + castling + ep)
  final Map<String, int> fenCounts = {};

  /// PGN moves as a mutable tree.
  // final PgnNode<PgnNodeData> pgnRoot = PgnNode<PgnNodeData>();
  // Linear move list (no variations). Each entry stores SAN, optional comment and NAGs.
  final List<MoveDataModel> _moves = [];
  final List<MoveDataModel> allMoves = [];

  // redo stacks
  final List<MoveDataModel> _redoMoveStack = [];

  /// last move metadata (used by controller to decide which sound to play, UI badges, etc.)
  MoveDataModel? _lastMoveMeta;
  MoveDataModel? get lastMoveMeta => _lastMoveMeta;
  final List<Move> _moveObjects = [];
  final List<Move> _redoMoveObjStack = [];

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
    _gameStatus.add(GameStatus.ongoing);

    _pushPosition(_pos);
    if (_pos.isGameOver) {
      result = _pos.outcome;
    }
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

  /// Static helper: normalize a PGN string by removing all variations wrapped in parentheses.
  /// Removes nested variations as well by repeatedly stripping innermost "(...)" groups.
  /// Useful when a PGN producer inserts variations but you want a flat linear PGN.
  static String normalizePgn(String pgn) {
    // Remove any parentheses groups iteratively from innermost to outermost.
    var output = pgn;
    final re = RegExp(r'\([^()]*\)');
    while (re.hasMatch(output)) {
      output = output.replaceAll(re, '');
    }
    // Collapse multiple spaces produced by removals, then trim.
    output = output.replaceAll(RegExp(r'\s+'), ' ').trim();
    return output;
  }

  void _pushPosition(Position pos) {
    positionHistory.add(pos);
    debugPrint("normalizeFen: ${pos.fen}");

    final key = GameState.normalizeFen(pos.fen);
    debugPrint("normalizeFen: $key");
    fenCounts[key] = (fenCounts[key] ?? 0) + 1;
  }

  void _popPosition(Position pos) {
    // current position fen removed
    _redoPositonStack.add(positionHistory.removeLast());
    final fen = pos.fen;
    final key = GameState.normalizeFen(fen);
    // decrement fenCounts for removed fen
    final prevCount = (fenCounts[key] ?? 1) - 1;
    if (prevCount <= 0) {
      fenCounts.remove(key);
    } else {
      fenCounts[key] = prevCount;
    }
  }

  /// Play a move and optionally attach a comment and NAGs.
  ///
  /// - [move]: a Move object parsed from SAN or generated by the API.
  /// - [comment]: optional PGN comment string (will be wrapped with `{ }` in PGN).
  /// - [nags]: optional list of NAG numbers (e.g. [1, 3] will be rendered as `$1 $3` after SAN).
  ///
  /// Note: uses Position.makeSan(move) -> (Position, String) record to compute SAN and new position.
  void play(Move move, {String? comment, List<int>? nags}) {
    // material counts before
    final beforeCounts = _pos.board.materialCount(Side.white);
    final beforeBlackCounts = _pos.board.materialCount(Side.black);

    final record = _pos.makeSan(move);
    final Position newPos = record.$1;
    final String san = record.$2;

    // when playing a new move after undo, clear redo stacks
    if (_redoPositonStack.isNotEmpty ||
        _redoMoveStack.isNotEmpty ||
        _redoMoveObjStack.isNotEmpty) {
      _redoPositonStack.clear();
      _redoMoveStack.clear();
      _redoMoveObjStack.clear();
    }

    _pos = newPos;
    _pushPosition(_pos);

    if (_pos.isGameOver) {
      result = _pos.outcome;
    }
    // compute metadata about move
    final afterWhiteCounts = _pos.board.materialCount(Side.white);
    final afterBlackCounts = _pos.board.materialCount(Side.black);

    bool wasCapture = false;
    // simple detection: any role count decreased for the side that lost material
    // determine which side lost material by comparing totals
    for (final r in [
      Role.pawn,
      Role.knight,
      Role.bishop,
      Role.rook,
      Role.queen,
    ]) {
      final beforeW = beforeCounts[r] ?? 0;
      final afterW = afterWhiteCounts[r] ?? 0;
      final beforeB = beforeBlackCounts[r] ?? 0;
      final afterB = afterBlackCounts[r] ?? 0;
      if (afterW < beforeW || afterB < beforeB) {
        wasCapture = true;
        break;
      }
    }

    final wasPromotion =
        (move as NormalMove).promotion != null ||
        (_pos.board.roleAt((move).to) != Role.pawn && (move).promotion != null);

    final wasCheck = _pos.isCheck;
    final wasCheckmate = _pos.isCheckmate;

    int moveNumber = int.parse(_pos.fen.split(' ').last);
    debugPrint("moveNumber $moveNumber");

    /// last move metadata (used by controller to decide which sound to play, UI badges, etc.)
    _lastMoveMeta = MoveDataModel(
      moveNumber: moveNumber,
      san: san,
      comment: comment,
      nags: nags ?? [],
      fenAfter: _pos.fen,
      isWhiteMove: _pos.turn == Side.white ? false : true,
      halfmoveIndex: allMoves.length,
      wasCapture: wasCapture,
      wasPromotion: wasPromotion,
      wasCheck: wasCheck,
      wasCheckmate: wasCheckmate,
      variations: [],
      lan: move.uci,
    );

    _moves.add(_lastMoveMeta!);
    allMoves.add(_lastMoveMeta!);
    _moveObjects.add(move);
    _gameStatus.add(status());
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
    _gameStatus.add(status());
  }

  bool isAgreedDraw() => agreementFlag; // 3. EndGame  isAgreedDraw

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) {
    resignationSide = side;
    final winner = side == Side.white ? Side.black : Side.white;
    result = Outcome(winner: winner);
    _gameStatus.add(status());
  }

  bool isResigned() => resignationSide != null; // 4. EndGame  isResigned

  /// Timeout: side timed out; winner is other side (caller handles tournament rules).
  void timeout(Side side) {
    timeoutSide = side;
    final winner = side == Side.white ? Side.black : Side.white;
    result = Outcome(winner: winner);
    _gameStatus.add(status());
  }

  bool isTimeout() => timeoutSide != null; // 5. EndGame  isTimeout

  bool get isInsufficientMaterial =>
      _pos.isInsufficientMaterial; // 6. EndGame  isInsufficientMaterial

  bool get isStalemate => _pos.isStalemate; // 7. EndGame  isStalemate

  bool get isCheck => _pos.isCheck;

  bool get isCheckmate => _pos.isCheckmate; // 8. EndGame  isCheckmate

  bool get isGameOver => _pos.isGameOver || isMate || isDraw;

  ///
  bool get isGameOverExtended => isMate || isDraw;

  ///
  bool get isDraw =>
      isFiftyMoveRule() ||
      isThreefoldRepetition() ||
      isAgreedDraw() ||
      isStalemate ||
      isInsufficientMaterial;

  ///
  bool get isMate => isCheckmate || isResigned() || isTimeout();

  // bool hasInsufficientMaterial(Side side) {
  //   return _pos.hasInsufficientMaterial(side);
  // }

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

  // ----------------------------
  // PGN building
  /// Build PGN string manually (linear moves), including NAGs and comments.
  /// headers: map of PGN headers (Event, Site, Date, White, Black, Result, ...).
  /// The Result header is filled from current result if present.
  // ----------------------------
  String pgnString({Map<String, String>? headers}) {
    final Map<String, String> baseHeaders = {
      'Event': 'Casual Game',
      'Site': '?',
      'Date': _todayDateString(),
      'Round': '?',
      'White': 'White',
      'Black': 'Black',
      'Result': resultToPgnString(result),
    };
    if (headers != null) baseHeaders.addAll(headers);

    final sb = StringBuffer();
    baseHeaders.forEach((k, v) {
      sb.writeln('[$k "$v"]');
    });
    sb.writeln();

    // build move text
    final List<String> tokens = [];
    for (var i = 0; i < _moves.length; i++) {
      final move = _moves[i];
      final isWhite = (i % 2 == 0);
      if (isWhite) {
        final moveNumber = (i ~/ 2) + 1;
        tokens.add('$moveNumber.');
      }
      // SAN
      final List<String> pieceTokens = [];
      pieceTokens.add(move.san!);
      // NAGs as $n
      if (move.nags.isNotEmpty) {
        pieceTokens.addAll(move.nags.map((n) => '\$$n'));
      }
      // comment as { ... }
      if (move.comment != null && move.comment!.isNotEmpty) {
        pieceTokens.add('{ ${_escapeComment(move.comment!)} }');
      }
      tokens.add(pieceTokens.join(' '));
    }

    sb.writeln(tokens.join(' '));
    // ensure result appended (if null -> *)
    sb.write(baseHeaders['Result']);
    return sb.toString();
  }

  String _todayDateString() {
    final d = DateTime.now().toUtc();
    return '${d.year.toString().padLeft(4, '0')}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }

  String _escapeComment(String c) {
    // minimal escaping: replace '}' with '\}' to avoid closing comment early.
    return c.replaceAll('}', '\\}');
  }

  /// material score in pawns (centipawns / 100) as double (positive = White advantage).
  double materialScore() => materialEvaluationCentipawns() / 100.0;

  String resultToPgnString(Outcome? r) {
    if (r == null) return '*';

    if (r == Outcome.draw) return '1/2-1/2';
    final w = r.winner;
    if (w == Side.white) return '1-0';
    if (w == Side.black) return '0-1';
    return '*';
  }

  bool get canUndo => _moves.isNotEmpty || !(positionHistory.length <= 1);

  // ----------------------------
  // Undo / Redo
  // ----------------------------
  /// Undo the last move. Returns true if undone.
  bool undoMove() {
    if (!canUndo) return false;
    // pop last move and fen
    final lastMove = _moves.removeLast();
    final lastMoveObj = _moveObjects.removeLast();

    // push to redo stacks so we can redo later
    _redoMoveStack.add(lastMove);
    _redoMoveObjStack.add(lastMoveObj);

    _popPosition(_pos);
    // set position to new last fen (previous position)
    _pos = positionHistory.last;

    // clear result/resignation/timeout if any (because we rolled back)
    result = null;
    resignationSide = null;
    timeoutSide = null;
    agreementFlag = false;
    _lastMoveMeta = null;

    return true;
  }

  bool get canRedo => _redoPositonStack.isNotEmpty || _redoMoveStack.isNotEmpty;

  /// Redo previously undone move. Returns true if redone.
  bool redoMove() {
    if (!canRedo) return false;
    final move = _redoMoveStack.removeLast();
    final moveObj = _redoMoveObjStack.removeLast();

    _moves.add(move);
    _moveObjects.add(moveObj);
    // apply fen and move into history
    // restore position
    _pos = _redoPositonStack.removeLast();

    _pushPosition(_pos);

    // if position is terminal, set result
    if (_pos.isGameOver) {
      result = _pos.outcome;
    }
    // lastMoveMeta not reconstructed here — caller can inspect position if needed
    _lastMoveMeta = null;
    return true;
  }

  void replayToHalfmove(
    int halfmoveIndex, {
    Position? initial,
    List<Move>? moves,
  }) {
    final start = initial ?? Chess.initial;

    _pos = start;
    positionHistory.clear();
    fenCounts.clear();
    _pushPosition(_pos);
    _moves.clear();
    _moveObjects.clear();
    _redoPositonStack.clear();
    _redoMoveStack.clear();
    _redoMoveObjStack.clear();
    result = null;
    resignationSide = null;
    timeoutSide = null;
    agreementFlag = false;
    _lastMoveMeta = null;

    if (halfmoveIndex < 0 || moves == null || moves.isEmpty) return;

    final upto = (halfmoveIndex < moves.length)
        ? halfmoveIndex
        : moves.length - 1;

    for (int i = 0; i <= upto; i++) {
      play(moves[i]);
    }
  }

  /// Return a copy of the internal Move objects (for replay).
  List<Move> getMoveObjectsCopy() => List<Move>.from(_moveObjects);

  /// Provide tokens for PGN horizontal display. Each token corresponds to a half-move.
  List<MoveDataModel> get getMoveTokens => allMoves;

  int get currentHalfmoveIndex => _moveObjects.length - 1;

  bool get hasMoves => _moveObjects.isNotEmpty;

  /// Human-readable representation for captured pieces (e.g. "pawn x1, rook x1").
  /// If none captured returns '-'.
  String capturedPiecesAsString(Side side) {
    final caps = getCapturedPieces(side);
    final List<String> parts = [];
    caps.forEach((role, cnt) {
      if (cnt > 0) parts.add('${_roleName(role)} x$cnt');
    });
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  /// Return a compact unicode string of captured pieces for UI (e.g. "♟♟ ♜").
  /// Format: symbol repeated count times (or symbol+count) — choose according to UI needs.
  String capturedPiecesAsUnicode(Side side, {bool repeatSymbols = false}) {
    final caps = getCapturedPieces(side);
    final List<String> parts = [];
    caps.forEach((role, cnt) {
      if (cnt <= 0) return;
      final sym = roleUnicode(role, isWhite: side != Side.white);
      if (repeatSymbols) {
        parts.add(List.filled(cnt, sym).join());
      } else {
        parts.add('$sym×$cnt');
      }
    });
    return parts.isEmpty ? '-' : parts.join(' ');
  }

  /// Helper: produce readable english/arabic short name (you can localize)
  String _roleName(Role r) {
    switch (r) {
      case Role.pawn:
        return 'pawn';
      case Role.knight:
        return 'knight';
      case Role.bishop:
        return 'bishop';
      case Role.rook:
        return 'rook';
      case Role.queen:
        return 'queen';
      case Role.king:
        return 'king';
    }
  }

  // القيم المادية لكل دور (pawn=1, knight=3, bishop=3, rook=5, queen=9)
  int _roleValue(Role role) {
    switch (role) {
      case Role.pawn:
        return 1;
      case Role.knight:
        return 3;
      case Role.bishop:
        return 3;
      case Role.rook:
        return 5;
      case Role.queen:
        return 9;
      case Role.king:
        return 0;
    }
  }

  /// Helper: unicode symbol for role (white/black)
  String roleUnicode(Role r, {required bool isWhite}) {
    // white pieces: ♙ ♘ ♗ ♖ ♕ ♔
    // black pieces: ♟ ♞ ♝ ♜ ♛ ♚
    const whiteMap = {
      Role.pawn: '♙',
      Role.knight: '♘',
      Role.bishop: '♗',
      Role.rook: '♖',
      Role.queen: '♕',
      Role.king: '♔',
    };
    const blackMap = {
      Role.pawn: '♟',
      Role.knight: '♞',
      Role.bishop: '♝',
      Role.rook: '♜',
      Role.queen: '♛',
      Role.king: '♚',
    };
    return isWhite ? (whiteMap[r] ?? '') : (blackMap[r] ?? '');
  }

  /// عدد كل دور مأخوذ *بواسطة* [side] (أي opponent فقد هذه القطع).
  Map<Role, int> getCapturedPieces(Side side) {
    final opponent = side == Side.white ? Side.black : Side.white;

    // Get the material count for the opponent at the start of the game.
    final initialCounts = positionHistory.first.board.materialCount(opponent);

    // Get the material count for the opponent in the current position.
    final currentCounts = positionHistory.last.board.materialCount(opponent);

    final Map<Role, int> captured = {};
    // Iterate over all piece roles to see what has been captured.
    for (final r in Role.values) {
      final initialCount = initialCounts[r] ?? 0;
      final currentCount = currentCounts[r] ?? 0;
      final taken = initialCount - currentCount;
      if (taken > 0) {
        captured[r] = taken;
      }
    }
    return captured;
  }

  /// Returns an expanded list of Roles for captured pieces by [side].
  /// Example: {pawn:2, rook:1} -> [Role.pawn, Role.pawn, Role.rook]
  List<Role> getCapturedPiecesList(Side side) {
    final map = getCapturedPieces(side);
    final List<Role> list = [];
    // order like lichess: pawn, knight, bishop, rook, queen (you can change order)
    final order = [Role.pawn, Role.knight, Role.bishop, Role.rook, Role.queen];
    for (final r in order) {
      final cnt = map[r] ?? 0;
      for (int i = 0; i < cnt; i++) {
        list.add(r);
      }
    }
    return list;
  }

  /// مجموع القيمة المادية للقطع **على اللوحة** لجهة [side].
  int materialOnBoard(Side side) {
    final counts = positionHistory.isNotEmpty
        ? positionHistory.last.board.materialCount(side)
        : _pos.board.materialCount(side);

    int total = 0;
    counts.forEach((role, cnt) {
      total += cnt * _roleValue(role);
    });
    return total;
  }

  /// مجموع القيمة المادية للقطع **التي أخذها** [side] (sum of values of captured pieces by side).
  int capturedValue(Side side) {
    final map = getCapturedPieces(side);
    int total = 0;
    map.forEach((role, cnt) {
      total += (cnt) * _roleValue(role);
    });
    return total;
  }

  int get getMaterialAdvantageSignedForWhite =>
      materialOnBoard(Side.white) - materialOnBoard(Side.black);

  int get getMaterialAdvantageSignedForBlack =>
      materialOnBoard(Side.black) - materialOnBoard(Side.white);
}
