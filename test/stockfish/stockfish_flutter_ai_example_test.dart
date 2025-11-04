import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

/// كائن يعرض نتيجة تقييم من Stockfish (مقتطف من سطر "info ...")
class Evaluation {
  final int depth;
  final int? cp; // centipawns
  final int? mate; // mate in N (positive or negative)
  final String pv; // principal variation (أفضل خط)

  Evaluation({required this.depth, this.cp, this.mate, this.pv = ''});

  @override
  String toString() {
    if (mate != null) return 'depth:$depth mate:$mate pv:$pv';
    if (cp != null) return 'depth:$depth cp:$cp pv:$pv';
    return 'depth:$depth pv:$pv';
  }
}

/// حالة اللعبة المستخلصة محليًا (نستخدم dartchess للتحقق)
enum GameResult { ongoing, checkmate, stalemate, draw }

/// طبقة البيانات: تغليف مباشر لمحرّك Stockfish عبر الحزمة stockfish_chess_engine
class EngineService {
  final Stockfish _stockfish = Stockfish();
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final StreamController<String> _raw = StreamController.broadcast();
  final StreamController<Evaluation> _eval = StreamController.broadcast();
  final StreamController<String> _bestmove = StreamController.broadcast();

  Stream<String> get raw => _raw.stream;
  Stream<Evaluation> get evaluations => _eval.stream;
  Stream<String> get bestmoves => _bestmove.stream;

  Future<void> start({
    Duration waitBeforeUci = const Duration(milliseconds: 1500),
  }) async {
    // _stockfish = Stockfish();

    _stdoutSub = _stockfish.stdout.listen((line) {
      debugPrint('stdout line $line...');

      _raw.add(line);
      _handleLine(line);
    });

    _stderrSub = _stockfish.stderr.listen((err) {
      debugPrint('stderr $err...');

      _raw.add('ERR: $err');
    });

    await Future.delayed(waitBeforeUci);

    _stockfish.stdin = 'uci';
    debugPrint(' befor _waitFor...');

    await _waitFor((l) => l.contains('uciok'), Duration(seconds: 5));

    await isReady();
  }

  Future<void> _waitFor(
    bool Function(String) predicate,
    Duration timeout,
  ) async {
    debugPrint(' _waitFor...');

    await raw.firstWhere(predicate).timeout(timeout);
  }

  Future<void> isReady() async {
    _stockfish.stdin = 'isready';
    await _waitFor((l) => l.contains('readyok'), Duration(seconds: 5));
  }

  Future<void> ucinewgame() async {
    _stockfish.stdin = 'ucinewgame';
    await isReady();
  }

  void setPosition({String? fen, List<String>? moves}) {
    var cmd = fen != null ? 'position fen $fen' : 'position startpos';
    if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
    _stockfish.stdin = cmd;
  }

  Future<String> goDepth(
    int depth, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    _stockfish.stdin = 'go depth $depth';
    final line = await raw
        .firstWhere((l) => l.startsWith('bestmove'))
        .timeout(timeout);
    return _parseBestmove(line);
  }

  Future<String> goMovetime(
    int ms, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    _stockfish.stdin = 'go movetime $ms';
    final line = await raw
        .firstWhere((l) => l.startsWith('bestmove'))
        .timeout(timeout);
    return _parseBestmove(line);
  }

  void stop() {
    _stockfish.stdin = 'stop';
  }

  String _parseBestmove(String line) {
    final parts = line.split(RegExp(r"\s+"));
    if (parts.length >= 2) {
      final bm = parts[1].trim();
      _bestmove.add(bm);
      return bm;
    }
    return '';
  }

  void _handleLine(String line) {
    debugPrint('_handleLine: $line');

    if (line.startsWith('info')) {
      final eval = _parseInfoLine(line);
      if (eval != null) _eval.add(eval);
    } else if (line.startsWith('bestmove')) {
      _parseBestmove(line);
    }
  }

  Evaluation? _parseInfoLine(String line) {
    try {
      final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
      final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;

      final cpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);
      final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);

      final pvMatch = RegExp(r'pv\s+(.+)\$').firstMatch(line);
      final pv = pvMatch != null ? pvMatch.group(1)!.trim() : '';

      if (cpMatch != null) {
        final cp = int.parse(cpMatch.group(1)!);
        return Evaluation(depth: depth, cp: cp, pv: pv);
      }
      if (mateMatch != null) {
        final mate = int.parse(mateMatch.group(1)!);
        return Evaluation(depth: depth, mate: mate, pv: pv);
      }
      return Evaluation(depth: depth, pv: pv);
    } catch (e) {
      return null;
    }
  }

  Future<void> dispose() async {
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    try {
      _stockfish.stdin = 'quit';
    } catch (e) {
      debugPrint('Error sending quit to Stockfish: $e');
    }
    try {
      _stockfish.dispose();
    } catch (e) {
      debugPrint('Error disposing Stockfish: $e');
    }
    await _raw.close();
    await _eval.close();
    await _bestmove.close();
  }
}

/// StockfishChessGameController باستخدام dartchess
class StockfishChessGameController {
  final EngineService engine;
  Position _pos = Chess.initial;
  final List<String> _moves = [];

  StockfishChessGameController(this.engine);

  Future<void> newGame() async {
    _pos = Chess.initial;
    _moves.clear();
    await engine.ucinewgame();
    engine.setPosition();
  }

  Future<String> playerMove(String uciMove, {int aiMoveTimeMs = 1000}) async {
    final moveObj = _uciToMoveObject(uciMove);
    // ignore: unused_local_variable
    final legalMoves = _pos.legalMoves;

    // if (!legalMoves.contains(moveObj)) {
    //   throw Exception('Illegal move: $uciMove');
    // }

    _pos = _pos.play(moveObj);
    _moves.add(uciMove);
    engine.setPosition(moves: _moves);

    final best = await engine.goMovetime(aiMoveTimeMs);

    final aiMoveObj = _uciToMoveObject(best);
    // if (!_pos.legalMoves.contains(aiMoveObj)) {
    //   throw Exception('Engine returned illegal move: $best');
    // }

    _pos = _pos.play(aiMoveObj);
    _moves.add(best);
    engine.setPosition(moves: _moves);

    return best;
  }

  Move _uciToMoveObject(String uci) {
    final fromSq = Square.fromName(uci.substring(0, 2));
    final toSq = Square.fromName(uci.substring(2, 4));
    final promo = uci.length == 5 ? Piece.fromChar(uci[4]) : null;
    return NormalMove(from: fromSq, to: toSq, promotion: promo!.role);
  }

  GameResult getResult() {
    if (_pos.isCheckmate) return GameResult.checkmate;
    if (_pos.isStalemate) return GameResult.stalemate;
    if (_pos.isInsufficientMaterial || _pos.isVariantEnd) {
      return GameResult.draw;
    }
    return GameResult.ongoing;
  }

  String get fen => _pos.fen;
  List<String> get moves => List.unmodifiable(_moves);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  test('stockfish flutter ai example test', () async {
    final engine = EngineService();
    debugPrint('Starting Stockfish...');
    await engine.start();
    debugPrint('Stockfish started and ready.');

    engine.evaluations.listen((ev) {
      debugPrint('EVAL -> $ev');
    });

    final game = StockfishChessGameController(engine);
    await game.newGame();
    debugPrint('New game started. FEN: ${game.fen}');

    try {
      debugPrint('Player -> e2e4');
      final aiMove = await game.playerMove('e2e4', aiMoveTimeMs: 1500);
      debugPrint('AI -> $aiMove');

      debugPrint('Player -> d2d4');
      final aiMove2 = await game.playerMove('d2d4', aiMoveTimeMs: 1000);
      debugPrint('AI -> $aiMove2');

      debugPrint('Moves so far: ${game.moves.join(' ')}');
      debugPrint('Current FEN: ${game.fen}');
      debugPrint('Game result: ${game.getResult()}');
    } catch (e, st) {
      debugPrint('Error during play: $e\n$st');
    }

    await engine.dispose();
    debugPrint('Engine disposed.');
  });
}
