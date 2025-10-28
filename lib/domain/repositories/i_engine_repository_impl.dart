import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';

import '../../domain/repositories/i_engine_repository.dart';
import '../models/extended_evaluation.dart';

// هذا هو التنفيذ الفعلي، وهو مقتبس مباشرة من StockfishEngineService الممتاز
// الذي قدمته، مع تعديلات طفيفة لتتناسب مع الواجهة الجديدة.
class StockfishRepositoryImpl implements IEngineRepository {
  late Stockfish _stockfish;
  final _evalController = StreamController<ExtendedEvaluation>.broadcast();

  @override
  Stream<ExtendedEvaluation> get evaluations => _evalController.stream;

  @override
  Future<void> initialize() async {
    _stockfish = Stockfish();
    _stockfish.stdout.listen((line) {
      if (line.startsWith('info')) {
        final eval = _parseInfoLine(line);
        if (eval != null) _evalController.add(eval);
      }
    });

    _stockfish.stdin = 'uci';
    // إعدادات المحرك لتحليل احترافي
    _stockfish.stdin = 'setoption name Skill Level value 20';
    _stockfish.stdin =
        'setoption name Threads value 4'; // يمكن تعديلها حسب الجهاز
    _stockfish.stdin = 'setoption name Hash value 128';
    _stockfish.stdin =
        'setoption name MultiPV value 3'; // للحصول على أفضل 3 نقلات
  }

  @override
  void setPosition({String? fen, List<String>? moves}) {
    var cmd = fen != null ? 'position fen $fen' : 'position startpos';
    if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
    _stockfish.stdin = cmd;
  }

  @override
  Future<void> go() async {
    _stockfish.stdin = 'go depth 18'; // عمق تحليل جيد للتوازن بين السرعة والدقة
  }

  @override
  void stop() {
    _stockfish.stdin = 'stop';
  }

  @override
  void dispose() {
    _stockfish.stdin = 'quit';
    _evalController.close();
    _stockfish.dispose();
  }

  ExtendedEvaluation? _parseInfoLine(String line) {
    try {
      final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
      final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;
      final cpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);
      final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);
      final pvMatch = RegExp(r'pv\s+(.+)').firstMatch(line);
      final pv = pvMatch?.group(1)?.trim() ?? '';

      if (cpMatch != null) {
        final cp = int.parse(cpMatch.group(1)!);
        return ExtendedEvaluation(depth: depth, cp: cp, pv: pv);
      }
      if (mateMatch != null) {
        final mate = int.parse(mateMatch.group(1)!);
        return ExtendedEvaluation(depth: depth, mate: mate, pv: pv);
      }
      return ExtendedEvaluation(depth: depth, pv: pv);
    } catch (e) {
      debugPrint("Error parsing info line: $e");
      return null;
    }
  }
}
