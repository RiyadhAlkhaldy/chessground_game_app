// 2.4 محرك بحث موحّد (PVS + TT + ID + Aspiration + Quiescence + Null + LMR + Extensions + Futility)
// lib/engine/search.dart
import 'dart:math';

import 'package:dartchess/dartchess.dart';

import 'evaluation.dart';
import 'move_ordering.dart';
import 'movegen.dart';
import 'tt.dart';
import 'zobrist.dart';

class SearchLimits {
  final int maxDepth; // عمق أقصى
  final Duration? moveTime; // ميزانية الوقت لهذه النقلة
  final DateTime? deadline; // إن حُددت، تتقدّم على moveTime
  const SearchLimits({this.maxDepth = 6, this.moveTime, this.deadline});
}

class SearchStats {
  int nodes = 0, qnodes = 0, tthit = 0, cut = 0, nullCut = 0, lmr = 0;
}

class BestMoveResult {
  final Move? best;
  final int score;
  final List<Move> pv;
  final SearchStats stats;
  BestMoveResult(this.best, this.score, this.pv, this.stats);
}

class SearchEngine {
  final Evaluation eval;
  final TranspositionTable tt;
  final Zobrist zob;
  final KillerTable killers;
  final HistoryHeuristic history;
  final SearchStats stats = SearchStats();

  DateTime? _deadline;
  int _seldepth = 0; // أقصى عمق فعلي

  SearchEngine({required this.eval, int ttSize = 1 << 20, int maxDepth = 64})
    : tt = TranspositionTable(ttSize),
      zob = Zobrist(),
      killers = KillerTable(maxDepth),
      history = HistoryHeuristic();

  bool _timeUp() => _deadline != null && DateTime.now().isAfter(_deadline!);

  BestMoveResult search(Position root, SearchLimits lim) {
    tt.newSearch();
    _deadline =
        lim.deadline ??
        (lim.moveTime != null ? DateTime.now().add(lim.moveTime!) : null);
    _seldepth = 0;

    Move? best;
    int bestScore = -0x3fffffff;
    List<Move> bestPV = [];
    int lastScore = 0; // لأجل Aspiration

    for (int depth = 1; depth <= lim.maxDepth; depth++) {
      int alpha = -30000, beta = 30000;
      // Aspiration حول نتيجة التكرار السابق
      if (depth > 2) {
        int asp = 50;
        alpha = lastScore - asp;
        beta = lastScore + asp;
      }

      while (true) {
        final (m, s, pv) = _pvsRoot(root, depth, alpha, beta);
        if (_timeUp()) break;
        if (s <= alpha) {
          alpha -= 80;
          continue;
        } // فشل منخفض: وسّع النافذة لأسفل
        if (s >= beta) {
          beta += 80;
          continue;
        } // فشل مرتفع: وسّع للأعلى
        best = m;
        bestScore = s;
        bestPV = pv;
        lastScore = s;
        break;
      }
      if (_timeUp()) break;
    }
    return BestMoveResult(best, bestScore, bestPV, stats);
  }

  (Move?, int, List<Move>) _pvsRoot(
    Position root,
    int depth,
    int alpha,
    int beta,
  ) {
    Move? best;
    int bestScore = -0x3fffffff;
    List<Move> pv = [];
    final moves = orderMoves(
      root,
      generateLegalMoves(root).toList(),
      ttMove: tt.probe(zob.hash(root))?.best,
      killers: killers,
      history: history,
      depth: 0,
    );

    int idx = 0;
    for (final m in moves) {
      if (_timeUp()) break;
      final next = root.play(m);
      int score;
      if (idx == 0) {
        score = -_pvs(next, depth - 1, -beta, -alpha, true, 1);
      } else {
        // PVS: نافذة صفرية ثم إعادة بحث إن لزم
        score = -_pvs(next, depth - 1, -alpha - 1, -alpha, true, 1);
        if (score > alpha && score < beta) {
          score = -_pvs(next, depth - 1, -beta, -alpha, true, 1);
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = m;
      }
      if (bestScore > alpha) {
        alpha = bestScore;
        pv = [m, ..._extractPV(next, depth - 1)];
      }
      if (alpha >= beta) break;
      idx++;
    }
    return (best, bestScore, pv);
  }

  List<Move> _extractPV(Position pos, int depth) {
    final pv = <Move>[];
    var p = pos;
    var d = depth;
    while (d > 0) {
      final e = tt.probe(zob.hash(p));
      if (e == null || e.best == null) break;
      pv.add(e.best!);
      p = p.play(e.best!);
      d--;
    }
    return pv;
  }

  int _pvs(
    Position pos,
    int depth,
    int alpha,
    int beta,
    bool allowNull,
    int ply,
  ) {
    if (_timeUp()) return 0; // أوقف سريعاً
    stats.nodes++;
    _seldepth = max(_seldepth, ply);

    // TT probe
    final key = zob.hash(pos);
    final hit = tt.probe(key);
    if (hit != null && hit.depth >= depth) {
      stats.tthit++;
      final s = hit.score;
      if (hit.bound == Bound.exact) return s;
      if (hit.bound == Bound.lower && s >= beta) return s;
      if (hit.bound == Bound.upper && s <= alpha) return s;
    }

    if (depth <= 0) return _quiescence(pos, alpha, beta, ply);

    if (pos.isGameOver) return eval.evaluatePosition(pos);

    // Null-move pruning
    if (allowNull && depth >= 3 && !pos.isCheck) {
      final nullPos = pos.copyWith(turn: pos.turn.opposite, epSquare: null);
      final R = 2 + (depth > 6 ? 1 : 0);
      final score = -_pvs(
        nullPos,
        depth - 1 - R,
        -beta,
        -beta + 1,
        false,
        ply + 1,
      );
      if (score >= beta) {
        stats.nullCut++;
        return beta;
      }
    }

    // توليد وترتيب النقلات
    final l = generateLegalMoves(pos).toList();
    if (l.isEmpty) return eval.evaluatePosition(pos); // مات/تعادل
    final ttMove = hit?.best;
    final moves = orderMoves(
      pos,
      l,
      ttMove: ttMove,
      killers: killers,
      history: history,
      depth: ply,
    );

    int bestScore = -0x3fffffff;
    Move? bestMove;
    int moveIndex = 0;

    // Futility pruning (شبه-آمن على الأعماق الصغيرة)
    final staticEval = eval.evaluatePosition(pos);

    for (final m in moves) {
      if (_timeUp()) break;
      final givesChk = givesCheck(pos, m);

      // Extensions
      int ext = 0;
      if (givesChk) ext = 1;
      if ((m as NormalMove).promotion != null) ext = max(ext, 1);

      int newDepth = depth - 1 + ext;

      // LMR: خفض العمق للحركات الهادئة المتأخرة
      bool quiet = !isCapture(pos, m) && !givesChk && m.promotion == null;
      int reduction = 0;
      if (quiet && newDepth >= 3 && moveIndex >= 4) {
        reduction = 1 + (newDepth >= 5 ? 1 : 0) + (moveIndex >= 8 ? 1 : 0);
      }

      int score;
      if (moveIndex == 0) {
        score = -_pvs(pos.play(m), newDepth, -beta, -alpha, true, ply + 1);
      } else {
        // نافذة صفرية + LMR
        score = -_pvs(
          pos.play(m),
          newDepth - reduction,
          -alpha - 1,
          -alpha,
          true,
          ply + 1,
        );
        if (reduction > 0 && score > alpha) {
          // إعادة بحث إذا تحسّن
          score = -_pvs(
            pos.play(m),
            newDepth,
            -alpha - 1,
            -alpha,
            true,
            ply + 1,
          );
        }
        if (score > alpha && score < beta) {
          score = -_pvs(pos.play(m), newDepth, -beta, -alpha, true, ply + 1);
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = m;
      }
      if (bestScore > alpha) {
        alpha = bestScore;
        tt.store(key, depth, bestScore, Bound.exact, bestMove);
      }
      if (alpha >= beta) {
        stats.cut++;
        // Killer + History
        if (quiet) {
          killers.push(ply, m);
          history.bump(m, depth);
        }
        tt.store(key, depth, alpha, Bound.lower, bestMove);
        break;
      }

      // Futility: عند عمق 1 وحركة هادئة جداً ولا يوجد كيش
      if (depth == 1 && quiet && !givesChk) {
        if (staticEval + 100 <= alpha) {
          // لا حاجة لتجربة نقلات أضعف بكثير
          break;
        }
      }

      moveIndex++;
    }

    if (bestMove == null) {
      // كل النقلات سيئة؟
      tt.store(key, depth, bestScore, Bound.upper, null);
      return bestScore;
    }

    return bestScore;
  }

  int _quiescence(Position pos, int alpha, int beta, int ply) {
    stats.qnodes++;
    final stand = eval.evaluatePosition(pos);
    if (stand >= beta) return stand;
    if (stand > alpha) alpha = stand;

    // توسّع فقط في Captures + Checks (هدوء)
    final caps = <Move>[];
    for (final m in generateLegalMoves(pos)) {
      if (isCapture(pos, m) || givesCheck(pos, m) || m.promotion != null) {
        caps.add(m);
      }
    }

    // MVV-LVA طبيعي بالـ orderMoves
    final moves = orderMoves(
      pos,
      caps,
      ttMove: null,
      killers: killers,
      history: history,
      depth: ply,
    );

    for (final m in moves) {
      if (_timeUp()) break;
      final score = -_quiescence(pos.play(m), -beta, -alpha, ply + 1);
      if (score >= beta) return score;
      if (score > alpha) alpha = score;
    }

    return alpha;
  }
}
