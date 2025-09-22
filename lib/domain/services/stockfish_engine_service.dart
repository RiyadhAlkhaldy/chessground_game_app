import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../entities/extended_evaluation.dart';

/// حالة اللعبة المستخلصة محليًا (نستخدم dartchess للتحقق)
enum GameResult { ongoing, checkmate, stalemate, draw }

/// طبقة البيانات: تغليف مباشر لمحرّك Stockfish عبر الحزمة stockfish_chess_engine
class StockfishEngineService {
  late Stockfish _stockfish;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final StreamController<String> _raw = StreamController.broadcast();
  final StreamController<ExtendedEvaluation> _eval =
      StreamController.broadcast();
  final StreamController<String> _bestmove = StreamController.broadcast();

  Stream<String> get raw => _raw.stream;
  Stream<ExtendedEvaluation?> get evaluations => _eval.stream;
  Stream<String> get bestmoves => _bestmove.stream;

  Future<void> start({
    Duration waitBeforeUci = const Duration(milliseconds: 2000),
    int? skill,
    bool uciLimitStrength = false,
    int uciElo = 1320,
  }) async {
    _stockfish = Stockfish();

    _stdoutSub = _stockfish.stdout.listen((line) {
      // debugPrint('###stdout line $line ###');

      _raw.add(line);
      _handleLine(line);
    });

    _stderrSub = _stockfish.stderr.listen((err) {
      // debugPrint('*** stderr line $err ***');

      _raw.add('ERR: $err');
    });

    await Future.delayed(waitBeforeUci);

    _stockfish.stdin = 'uci';

    // await _waitFor((l) => l.contains('uciok'), Duration(seconds: 3));

    // _stockfish.stdin = "setoption name UCI_ShowWDL value true";

    if (skill != null && !uciLimitStrength) {
      // debugPrint('skill = $skill');
      _stockfish.stdin = 'setoption name Skill Level value $skill';
      _stockfish.stdin = 'setoption name Hash value 32';
    }

    if (uciLimitStrength) {
      //المدى: 1320 → 3190 Elo (يعتمد على نسخة Stockfish).
      // UCI_Elo 1350 = يلعب بمستوى مبتدئ.
      // UCI_Elo 2000 = مستوى لاعب نادي.
      // UCI_Elo 2800 = مستوى أبطال العالم.
      _stockfish.stdin = "setoption name UCI_LimitStrength value true";
      _stockfish.stdin = "setoption name UCI_Elo value $uciElo";
      // debugPrint("uciElo: $uciElo");
    }
    // عدد الـ CPU threads المستعملة.
    //     1 = أضعف (يستخدم نواة واحدة فقط).
    // 4 أو أكثر = أقوى (يستفيد من تعدد الأنوية).
    // setoption name Threads value 1

    // حجم ذاكرة الـ Hash Table (بالـ MB).
    //     16 MB = أضعف.
    // 1024 MB أو أكثر = أقوى.
    // setoption name Hash value 16

    // خيار يحدد “درجة عداء” المحرك للتعادل.
    // 0 = محايد.
    // قيمة موجبة = يفضل الفوز على التعادل.
    // قيمة سالبة = يقبل التعادلات بسهولة.
    // setoption name Contempt value 0

    //مثال 3: محرك بأقصى قوة
    // setoption name Skill Level value 20
    // setoption name UCI_LimitStrength value false
    // setoption name Threads value 8
    // setoption name Hash value 1024

    await isReady();
  }

  bool get startStockfishIfNecessary {
    if (_stockfish.state.value == StockfishState.ready ||
        _stockfish.state.value == StockfishState.starting) {
      return false;
    }
    return true;
  }

  Future<void> _waitFor(
    bool Function(String) predicate,
    Duration timeout,
  ) async {
    // debugPrint(' _waitFor...');
    await raw
        .firstWhere(predicate)
        .timeout(
          timeout,
          // onTimeout: () {
          //   return '';
          // },
        );
  }

  Future<void> isReady() async {
    _stockfish.stdin = 'isready';
    await _waitFor((l) => l.contains('readyok'), Duration(seconds: 1));
  }

  Future<void> ucinewgame() async {
    _stockfish.stdin = 'ucinewgame';
    await isReady();
  }

  void setPosition({String? fen, List<String>? moves}) {
    var cmd = fen != null ? 'position fen $fen' : 'position startpos';
    if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
    // debugPrint("Move: $cmd  ");
    _stockfish.stdin = cmd;
  }

  Future<String> goDepth(
    int depth, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    _stockfish.stdin = 'go depth $depth';
    final line = await raw
        .firstWhere((l) => l.startsWith('bestmove'))
        .timeout(timeout);
    return _parseBestmove(line);
  }

  void goMovetime(
    int ms, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    _stockfish.stdin = 'go movetime $ms';
    // final line = await raw
    //     .firstWhere((l) => l.startsWith('bestmove'))
    //     .timeout(timeout);
    // return _parseBestmove(line);
  }

  Future<void> stop() async {
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
    // debugPrint('_handleLine: $line');

    if (line.startsWith('info')) {
      final eval = _parseInfoLine(line);
      if (eval != null) _eval.add(eval);
    } else if (line.startsWith('bestmove')) {
      _parseBestmove(line);
    }
  }

  ExtendedEvaluation? _parseInfoLine(String line) {
    try {
      final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
      final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;

      final cpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);

      final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);

      final pvMatch = RegExp(r'pv\s+(.+)$').firstMatch(line);

      final String pv = pvMatch != null ? pvMatch.group(1)!.trim() : '';

      final wdlMatch = RegExp(r'wdl\s+(\d+)\s+(\d+)\s+(\d+)').firstMatch(line);

      final int? cp = cpMatch != null ? int.parse(cpMatch.group(1)!) : null;
      final int? mate = mateMatch != null
          ? int.parse(mateMatch.group(1)!)
          : null;

      ///
      final int? wdlWin = wdlMatch != null
          ? int.parse(wdlMatch.group(1)!)
          : null;
      final int? wdlDraw = wdlMatch != null
          ? int.parse(wdlMatch.group(2)!)
          : null;
      final int? wdlLoss = wdlMatch != null
          ? int.parse(wdlMatch.group(3)!)
          : null;

      debugPrint(
        "pv:$pv , pvMatch:$pvMatch , depth:$depth  , cpMatch:$cp , mateMatch:$mateMatch",
      );
      return ExtendedEvaluation(
        depth: depth,
        pv: pv,
        cp: cp,
        mate: mate,
        wdlWin: wdlWin,
        wdlDraw: wdlDraw,
        wdlLoss: wdlLoss,
      );
    } catch (e) {
      debugPrint("error _parseInfoLine $e");
      return null;
    }
  }

  Future<void> stopStockfish() async {
    if (_stockfish.state.value == StockfishState.disposed ||
        _stockfish.state.value == StockfishState.error) {
      return;
    }
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    _stockfish.dispose();
    await Future.delayed(const Duration(milliseconds: 1200));
    // if (Get.context!.mounted) return;
  }

  Future<void> dispose() async {
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    try {
      _stockfish.dispose();
    } catch (e) {
      debugPrint("error dispose $e");
    }
    await _raw.close();
    await _eval.close();
    await _bestmove.close();
  }
}
