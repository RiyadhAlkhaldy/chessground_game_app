import 'dart:async';

import 'package:chessground_game_app/core/global_feature/data/models/extended_evaluation.dart';
import 'package:flutter/material.dart';
import 'package:multistockfish/multistockfish.dart'; 

/// طبقة البيانات: تغليف مباشر لمحرّك Stockfish عبر الحزمة stockfish_chess_engine
class StockfishDataSource {
  static Stockfish? _stockfish;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final StreamController<String> _raw = StreamController.broadcast();
  final StreamController<ExtendedEvaluation> _eval = StreamController.broadcast();
  final StreamController<String> _bestmove = StreamController.broadcast();

  Stream<String> get raw => _raw.stream;
  Stream<ExtendedEvaluation?> get evaluations => _eval.stream;
  Stream<String> get bestmoves => _bestmove.stream;

  Future<void> start({Duration waitBeforeUci = const Duration(milliseconds: 2000)}) async {
    if (_stockfish != null && !startStockfishIfNecessary) {
      return;
    }
    _stockfish = Stockfish();

    _stdoutSub = _stockfish?.stdout.listen((line) {
      _raw.add(line);
      _handleLine(line);
    });

    // _stderrSub = _stockfish?.stderr.listen((err) {
    //   _raw.add('ERR: $err');
    // });

    await Future.delayed(waitBeforeUci);

    _stockfish?.stdin = 'uci';

    await _waitFor((l) => l.contains('uciok'), const Duration(seconds: 3));

    await isReady();
  }

  bool get startStockfishIfNecessary {
    if (_stockfish?.state.value == StockfishState.ready ||
        _stockfish?.state.value == StockfishState.starting) {
      return false;
    }
    return true;
  }

  Future<void> _waitFor(bool Function(String) predicate, Duration timeout) async {
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
    _stockfish?.stdin = 'isready';
    await _waitFor((l) => l.contains('readyok'), const Duration(seconds: 1));
  }

  Future<void> ucinewgame() async {
    _stockfish?.stdin = 'ucinewgame';
    await isReady();
  }

  void setOption(String name, dynamic value) =>
      _stockfish?.stdin = 'setoption name $name value $value';

  ///
  void setPosition({String? fen, List<String>? moves}) {
    var cmd = fen != null ? 'position fen $fen' : 'position startpos';
    if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
    // debugPrint("Move: $cmd  ");
    _stockfish?.stdin = cmd;
  }

  Future<String> goDepth(int depth, {Duration timeout = const Duration(seconds: 2)}) async {
    _stockfish?.stdin = 'go depth $depth';
    final line = await raw.firstWhere((l) => l.startsWith('bestmove')).timeout(timeout);
    return _parseBestmove(line);
  }

  void goMovetime(int ms, {Duration timeout = const Duration(seconds: 2)}) async {
    _stockfish?.stdin = 'go movetime $ms';
    // final line = await raw
    //     .firstWhere((l) => l.startsWith('bestmove'))
    //     .timeout(timeout);
    // return _parseBestmove(line);
  }

  Future<void> stop() async {
    _stockfish?.stdin = 'stop';
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
      final int? mate = mateMatch != null ? int.parse(mateMatch.group(1)!) : null;

      ///
      final int? wdlWin = wdlMatch != null ? int.parse(wdlMatch.group(1)!) : null;
      final int? wdlDraw = wdlMatch != null ? int.parse(wdlMatch.group(2)!) : null;
      final int? wdlLoss = wdlMatch != null ? int.parse(wdlMatch.group(3)!) : null;

      // debugPrint(
      //   "pv:$pv , pvMatch:$pvMatch , depth:$depth  , cpMatch:$cp , mateMatch:$mateMatch",
      // );
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

  ///
  Future<void> stopStockfish() async {
    if (_stockfish?.state.value == StockfishState.disposed ||
        _stockfish?.state.value == StockfishState.error) {
      return;
    }
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    _stockfish?.dispose();
    await Future.delayed(const Duration(milliseconds: 1200));
    // if (Get.context!.mounted) return;
  }

  Future<void> dispose() async {
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    try {
      _stockfish?.dispose();
    } catch (e) {
      debugPrint("error dispose $e");
    }
    await _raw.close();
    await _eval.close();
    await _bestmove.close();
  }
}
