// pubspec.yaml:
// dependencies:
//   dartchess: ^0.11.1

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';

/// قيم القطع الأساسية (سنتعامل مع النقاط كوحدات centipawns)
class EvalWeights {
  static const int pawn = 100;
  static const int knight = 320;
  static const int bishop = 330;
  static const int rook = 500;
  static const int queen = 900;
  static const int king = 0; // لا تُستخدم للخامة التقليدية

  // مكافآت/عقوبات عامة
  static const int bishopPair = 30;
  static const int rookOnOpenFile = 18;
  static const int rookOnSemiOpenFile = 9;
  static const int rookOn7th = 12;

  static const int isolatedPawnPenalty = 12;
  static const int doubledPawnPenalty = 16;
  static const int backwardPawnPenalty = 10;
  static const int passedPawnBonusBase = 12; // يتزايد حسب الرتبة

  static const int centerControl = 6; // لكل مربع محتَل أو مُهاجَم في المركز
  static const int mobilityFactor = 2; // لكل نقلة قانونية صافية
  static const int tempoBonus = 8;

  static const int kingRingAttack = 4; // لكل هجوم على حلقة الملك
  static const int pawnShieldBonus = 6; // لكل بيدق ضمن درع الملك

  static const int threatHigherPiece = 10;
  static const int kingTropism = 1; // لكل مربع اقتراب من ملك الخصم (تبسيط)
  static const int spaceAdvantage = 1; // لكل مربع مساحة متقدمة مسيطر عليها

  // معاملات phase (PeSTO مبسطة)
  static const int phaseKnight = 1;
  static const int phaseBishop = 1;
  static const int phaseRook = 2;
  static const int phaseQueen = 4;
  static const int maxPhase =
      phaseKnight * 4 + phaseBishop * 4 + phaseRook * 4 + phaseQueen * 2; // 24
}

/// جداول PST (Opening & Endgame) مبسطة. الفهرس حسب ترتيب LERF لـ Square (0..63).
/// يُفضل توليدها من جداول معروفة (PeSTO)؛ هنا جداول معقولة كمثال يمكن تعديلها/تحسينها.
class PST {
  // ملاحظة: لتقليل الحجم، سنُعرّف دوال توليد PST بسيطة تعطي منحنيات منطقية:
  static List<int> _pawnOpening() => List<int>.generate(64, (sq) {
    final r = Square(sq).rank.value; // 0..7
    return [0, 5, 10, 20, 30, 40, 50, 0][r];
  });

  static List<int> _pawnEndgame() => List<int>.generate(64, (sq) {
    final r = Square(sq).rank.value;
    return [0, 5, 15, 25, 35, 45, 60, 0][r];
  });

  static List<int> _knightOpening() => List<int>.generate(64, (sq) {
    final f = Square(sq).file.value;
    final r = Square(sq).rank.value;
    final distCenter = (f - 3.5).abs() + (r - 3.5).abs();
    return (12 - (distCenter * 4)).round(); // أفضل نحو المركز
  });

  static List<int> _knightEndgame() => List<int>.generate(64, (sq) {
    final f = Square(sq).file.value;
    final r = Square(sq).rank.value;
    final distCenter = (f - 3.5).abs() + (r - 3.5).abs();
    return (8 - (distCenter * 3)).round();
  });

  static List<int> _bishopOpening() => List<int>.generate(64, (sq) {
    // تفضيل الأقطار المفتوحة تقريبًا
    final s = Square(sq);
    final diagBias =
        (s.file.value == s.rank.value || (7 - s.file.value) == s.rank.value)
        ? 8
        : 2;
    return diagBias;
  });

  static List<int> _bishopEndgame() => List<int>.generate(64, (sq) {
    final s = Square(sq);
    final diagBias =
        (s.file.value == s.rank.value || (7 - s.file.value) == s.rank.value)
        ? 10
        : 3;
    return diagBias;
  });

  static List<int> _rookOpening() => List<int>.filled(64, 2);
  static List<int> _rookEndgame() => List<int>.filled(64, 4);

  static List<int> _queenOpening() => List<int>.filled(64, 0);
  static List<int> _queenEndgame() => List<int>.filled(64, 4);

  static List<int> _kingOpening() => List<int>.generate(64, (sq) {
    // الملك آمن في الزوايا/الخلف في الافتتاح
    final r = Square(sq).rank.value;
    return [20, 12, 8, 4, 0, -4, -8, -12][r];
  });

  static List<int> _kingEndgame() => List<int>.generate(64, (sq) {
    // الملك نشِط في النهاية، الأفضل نحو المركز
    final f = Square(sq).file.value;
    final r = Square(sq).rank.value;
    final distCenter = (f - 3.5).abs() + (r - 3.5).abs();
    return (16 - (distCenter * 6)).round();
  });

  static final pawnOp = _pawnOpening();
  static final pawnEg = _pawnEndgame();
  static final knightOp = _knightOpening();
  static final knightEg = _knightEndgame();
  static final bishopOp = _bishopOpening();
  static final bishopEg = _bishopEndgame();
  static final rookOp = _rookOpening();
  static final rookEg = _rookEndgame();
  static final queenOp = _queenOpening();
  static final queenEg = _queenEndgame();
  static final kingOp = _kingOpening();
  static final kingEg = _kingEndgame();
}

/// كاش للتقييم (Evaluation Hashing) باستخدام مفتاح FEN.
/// للإنتاج يُفضل استخدام Zobrist، لكن FEN كافٍ كبداية.
class EvalCache {
  final _map = <String, int>{};

  int? get(String fen) => _map[fen];
  void put(String fen, int score) => _map[fen] = score;
}

/// الدالة الرئيسية للتقييم
class Evaluation {
  final EvalCache _cache = EvalCache();

  int evaluateFEN(String fen) {
    final pos = Chess.fromSetup(Setup.parseFen(fen));
    return evaluatePosition(pos);
  }

  int evaluatePosition(Chess pos) {
    // Hashing سريع
    final cached = _cache.get(pos.fen);
    if (cached != null) return cached;

    // تقييم كسول: ابدأ بالخامة + PST + تمبو
    final (opScore, egScore, phase) = _evaluateTapered(pos);

    // إن كان الفارق كبيرًا بما يكفي، اختصر (lazy)
    final int lazyThreshold = 120; // قابل للضبط
    final blendedBase = _blend(opScore, egScore, phase);
    if (blendedBase.abs() > lazyThreshold) {
      _cache.put(pos.fen, blendedBase);
      return blendedBase;
    }

    // حسابات إضافية
    final mobility = _mobility(pos);
    final kingSafety = _kingSafety(pos);
    final pawnStruct = _pawnStructure(pos);
    final rooksFiles = _rooksOpenFiles(pos);
    final center = _centerControl(pos);
    final threats = _threatsAndAttacks(pos);
    final bishopPair = _bishopPair(pos);
    final tropism = _kingTropism(pos);
    final space = _spaceAdvantage(pos);

    final tempo = (pos.turn == Side.white
        ? EvalWeights.tempoBonus
        : -EvalWeights.tempoBonus);

    final totalOp =
        opScore +
        mobility.op +
        kingSafety.op +
        pawnStruct.op +
        rooksFiles.op +
        center.op +
        threats.op +
        bishopPair.op +
        tropism.op +
        space.op +
        tempo;

    final totalEg =
        egScore +
        mobility.eg +
        kingSafety.eg +
        pawnStruct.eg +
        rooksFiles.eg +
        center.eg +
        threats.eg +
        bishopPair.eg +
        tropism.eg +
        space.eg +
        tempo;

    final score = _blend(totalOp, totalEg, phase);
    _cache.put(pos.fen, score);
    return score;
  }

  // ---------------- core helpers ----------------

  (int op, int eg, int phase) _evaluateTapered(Chess pos) {
    final board = pos.board;
    int op = 0, eg = 0, phase = 0;

    // فرق الخامة + PST
    for (final (sq, piece) in board.pieces) {
      final side = (board.white.has(sq)) ? Side.white : Side.black;
      final sign = (side == Side.white) ? 1 : -1;
      final role = piece.kind.role;

      int mat = 0, pstOp = 0, pstEg = 0, ph = 0;

      switch (role) {
        case Role.pawn:
          mat = EvalWeights.pawn;
          pstOp = PST.pawnOp[sq.value];
          pstEg = PST.pawnEg[sq.value];
          break;
        case Role.knight:
          mat = EvalWeights.knight;
          pstOp = PST.knightOp[sq.value];
          pstEg = PST.knightEg[sq.value];
          ph = EvalWeights.phaseKnight;
          break;
        case Role.bishop:
          mat = EvalWeights.bishop;
          pstOp = PST.bishopOp[sq.value];
          pstEg = PST.bishopEg[sq.value];
          ph = EvalWeights.phaseBishop;
          break;
        case Role.rook:
          mat = EvalWeights.rook;
          pstOp = PST.rookOp[sq.value];
          pstEg = PST.rookEg[sq.value];
          ph = EvalWeights.phaseRook;
          break;
        case Role.queen:
          mat = EvalWeights.queen;
          pstOp = PST.queenOp[sq.value];
          pstEg = PST.queenEg[sq.value];
          ph = EvalWeights.phaseQueen;
          break;
        case Role.king:
          // لا تُحسب في الخامة
          pstOp = PST.kingOp[sq.value];
          pstEg = PST.kingEg[sq.value];
          break;
      }

      op += sign * (mat + pstOp);
      eg += sign * (mat + pstEg);
      phase += ph;
    }

    // Clamp phase إلى [0, maxPhase]
    if (phase > EvalWeights.maxPhase) phase = EvalWeights.maxPhase;
    return (op, eg, phase);
  }

  int _blend(int op, int eg, int phase) {
    final int mp = EvalWeights.maxPhase;
    return ((op * phase) + (eg * (mp - phase))) ~/ mp;
  }

  // ---------------- mobility ----------------
  ({int op, int eg}) _mobility(Chess pos) {
    final whiteMoves = _countMoves(pos, Side.white);
    final blackMoves = _countMoves(pos, Side.black);
    final diff = (whiteMoves - blackMoves) * EvalWeights.mobilityFactor;
    return (op: diff, eg: diff);
  }

  int _countMoves(Chess pos, Side side) {
    // نحتاج حساب الحركات من منظور جانب محدد:
    // أسهل طريقة: لو لم يكن دوره، نبدّل الدور مؤقتًا بنسخة copyWith.
    final Position forSide = (pos.turn == side)
        ? pos
        : pos.copyWith(
            turn: side,
            halfmoves: pos.halfmoves,
            fullmoves: pos.fullmoves,
          );
    // legalMoves: IMap<Square, SquareSet>
    final map = (forSide as Chess).legalMoves;
    int count = 0;
    for (final entry in map.entries) {
      count += entry.value.size;
    }
    return count;
  }

  // ---------------- king safety ----------------
  ({int op, int eg}) _kingSafety(Chess pos) {
    final b = pos.board;
    int scoreOp = 0, scoreEg = 0;

    for (final side in [Side.white, Side.black]) {
      final opp = side == Side.white ? Side.black : Side.white;
      final kingSq = b.kingOf(side);
      if (kingSq == null) continue;

      final sign = side == Side.white ? 1 : -1;

      // درع البيادق (ثلاث خانات أمام الملك)
      final shieldSquares = _kingShieldSquares(kingSq, side);
      int shield = 0;
      for (final s in shieldSquares) {
        final p = b.pieceAt(s);
        if (p != null && p.kind.role == Role.pawn && b.sideAt(s) == side) {
          shield += EvalWeights.pawnShieldBonus;
        }
      }

      // هجمات الخصم على حلقة الملك
      final ring = _kingRing(kingSq);
      int ringPressure = 0;
      for (final s in ring) {
        final attackers = b.attacksTo(s, opp);
        if (attackers.isNotEmpty) ringPressure += EvalWeights.kingRingAttack;
      }

      // الملك في الافتتاح أسوأ إن كان مكشوفًا؛ في النهاية أقل حدة
      scoreOp += sign * (shield - ringPressure);
      scoreEg += sign * ((shield ~/ 2) - (ringPressure ~/ 2));
    }
    return (op: scoreOp, eg: scoreEg);
  }

  Iterable<Square> _kingShieldSquares(Square k, Side side) {
    // نحاول أخذ المربعات أمام الملك وبجواره (من 3 إلى 5 مربعات)
    final int dir = side == Side.white ? 1 : -1;
    final rankForward = k.rank.value + dir;
    if (rankForward < 0 || rankForward > 7) return const <Square>[];
    final file = k.file.value;
    final files = [file, file - 1, file + 1].where((f) => f >= 0 && f < 8);
    return files.map((f) => Square.fromCoords(File(f), Rank(rankForward)));
  }

  Iterable<Square> _kingRing(Square k) {
    final r = k.rank.value, f = k.file.value;
    final res = <Square>[];
    for (int df = -1; df <= 1; df++) {
      for (int dr = -1; dr <= 1; dr++) {
        if (df == 0 && dr == 0) continue;
        final nf = f + df, nr = r + dr;
        if (nf >= 0 && nf < 8 && nr >= 0 && nr < 8) {
          res.add(Square.fromCoords(File(nf), Rank(nr)));
        }
      }
    }
    return res;
  }

  // ---------------- pawn structure ----------------
  ({int op, int eg}) _pawnStructure(Chess pos) {
    final b = pos.board;
    int score = 0;

    for (final side in [Side.white, Side.black]) {
      final sign = side == Side.white ? 1 : -1;
      final pawns = b.pawns.intersect(b.bySide(side)).squares;

      // عدّ البيادق لكل ملف
      final countsByFile = List<int>.filled(8, 0);
      for (final s in pawns) {
        countsByFile[s.file.value]++;
      }

      for (final s in pawns) {
        final f = s.file.value;
        final r = s.rank.value;

        // doubled
        if (countsByFile[f] > 1) score -= sign * EvalWeights.doubledPawnPenalty;

        // isolated
        final left = f - 1, right = f + 1;
        final hasLeft = left >= 0 && countsByFile[left] > 0;
        final hasRight = right < 8 && countsByFile[right] > 0;
        if (!hasLeft && !hasRight)
          score -= sign * EvalWeights.isolatedPawnPenalty;

        // backward (تقريب): لا يوجد بيدق صديق متقدم على نفس الملف لدعمه
        final friendAhead = pawns.any(
          (p) =>
              p.file.value == f &&
              ((side == Side.white && p.rank.value > r) ||
                  (side == Side.black && p.rank.value < r)),
        );
        if (!friendAhead) score -= sign * EvalWeights.backwardPawnPenalty;

        // passed pawn
        if (_isPassedPawn(b, s, side)) {
          final rankProgress = side == Side.white ? r : (7 - r);
          score +=
              sign *
              (EvalWeights.passedPawnBonusBase * (1 + rankProgress ~/ 2));
        }
      }
    }
    // مساهمة هيكل البيادق تُحسب غالبًا بنفس الشدة في المرحلتين
    return (op: score, eg: score + (score ~/ 3));
  }

  bool _isPassedPawn(Board b, Square s, Side side) {
    // لا يوجد بيدق خصم على نفس الملف أو المجاور أمام هذا البيدق حتى التروية
    final opp = side == Side.white ? Side.black : Side.white;
    final oppPawns = b.pawns.intersect(b.bySide(opp)).squares.toSet();
    final f = s.file.value;
    final r = s.rank.value;
    for (final p in oppPawns) {
      final df = (p.file.value - f).abs();
      if (df <= 1) {
        final ahead = side == Side.white
            ? (p.rank.value > r)
            : (p.rank.value < r);
        if (ahead) return false;
      }
    }
    return true;
  }

  // ---------------- bishop pair ----------------
  ({int op, int eg}) _bishopPair(Chess pos) {
    final b = pos.board;
    int score = 0;
    for (final side in [Side.white, Side.black]) {
      final bb = b.bishops.intersect(b.bySide(side));
      if (bb.size >= 2) {
        final s = side == Side.white ? 1 : -1;
        score += s * EvalWeights.bishopPair;
      }
    }
    return (op: score, eg: score);
  }

  // ---------------- rooks & open files ----------------
  ({int op, int eg}) _rooksOpenFiles(Chess pos) {
    final b = pos.board;
    int score = 0;
    for (final side in [Side.white, Side.black]) {
      final sign = side == Side.white ? 1 : -1;
      final rooks = b.rooks.intersect(b.bySide(side)).squares;
      for (final r in rooks) {
        final f = r.file.value;
        final fileSquares = List.generate(
          8,
          (rank) => Square.fromCoords(File(f), Rank(rank)),
        );
        bool hasFriendlyPawn = false, hasEnemyPawn = false;
        for (final sq in fileSquares) {
          final p = b.pieceAt(sq);
          if (p != null && p.kind.role == Role.pawn) {
            if (b.sideAt(sq) == side)
              hasFriendlyPawn = true;
            else
              hasEnemyPawn = true;
          }
        }
        if (!hasFriendlyPawn && !hasEnemyPawn)
          score += sign * EvalWeights.rookOnOpenFile;
        else if (!hasFriendlyPawn && hasEnemyPawn)
          score += sign * EvalWeights.rookOnSemiOpenFile;

        // rook on 7th (منظور أبيض وعلى العكس للأسود)
        if ((side == Side.white && r.rank.value == 6) ||
            (side == Side.black && r.rank.value == 1)) {
          score += sign * EvalWeights.rookOn7th;
        }
      }
    }
    return (op: score, eg: score + (score ~/ 2));
  }

  // ---------------- center control ----------------
  ({int op, int eg}) _centerControl(Chess pos) {
    final b = pos.board;
    // مربعات المركز الكلاسيكية:
    final centers = [
      Square.fromName('d4'),
      Square.fromName('e4'),
      Square.fromName('d5'),
      Square.fromName('e5'),
    ];

    int score = 0;
    for (final c in centers) {
      final piece = b.pieceAt(c);
      if (piece != null) {
        score +=
            (b.sideAt(c) == Side.white ? 1 : -1) * EvalWeights.centerControl;
      }
      // تحكم (مربّع مُهاجَم)
      final wAtk = b.attacksTo(c, Side.white);
      final bAtk = b.attacksTo(c, Side.black);
      score += (wAtk.size - bAtk.size) * (EvalWeights.centerControl ~/ 2);
    }
    return (op: score, eg: score);
  }

  // ---------------- threats & attacks ----------------
  ({int op, int eg}) _threatsAndAttacks(Chess pos) {
    final b = pos.board;
    int score = 0;

    // نبني خريطة مربعات محتلة للسرعة
    final occupied = b.occupied;

    // تفقد كل قطع الخصم: هل تتعرض لهجوم من قطع أعلى قيمة؟
    for (final (sq, piece) in b.pieces) {
      final side = b.sideAt(sq)!;
      final opp = side == Side.white ? Side.black : Side.white;

      final attackers = b.attacksTo(sq, opp);
      if (attackers.isNotEmpty) {
        // لو القطعة المُهدَدة ذات قيمة أعلى من أغلب المُهاجمين، امنح نقاطًا أعلى.
        final victimVal = _pieceValue(piece.kind.role);
        // تقدير بسيط: عدد المهاجمين * جودة التهديد
        score +=
            (opp == Side.white ? 1 : -1) *
            (EvalWeights.threatHigherPiece + victimVal ~/ 100);
      }

      // تهديد الملك مباشرة (هجوم على حلقة الملك)
      if (piece.kind.role != Role.king) {
        final kingSq = b.kingOf(opp);
        if (kingSq != null) {
          // نطاق هجوم هذه القطعة (تقريب باستخدام الدالة العمومية attacks)
          final att = attacks(piece, sq, occupied);
          if (att.has(kingSq)) {
            score +=
                (side == Side.white ? 1 : -1) *
                (EvalWeights.threatHigherPiece + 10);
          }
        }
      }
    }

    return (op: score, eg: score);
  }

  int _pieceValue(Role r) {
    switch (r) {
      case Role.pawn:
        return EvalWeights.pawn;
      case Role.knight:
        return EvalWeights.knight;
      case Role.bishop:
        return EvalWeights.bishop;
      case Role.rook:
        return EvalWeights.rook;
      case Role.queen:
        return EvalWeights.queen;
      case Role.king:
        return 0;
    }
  }

  // ---------------- king tropism ----------------
  ({int op, int eg}) _kingTropism(Chess pos) {
    final b = pos.board;
    int score = 0;
    final wK = b.kingOf(Side.white);
    final bK = b.kingOf(Side.black);
    if (wK != null && bK != null) {
      for (final (sq, piece) in b.pieces) {
        if (piece.kind.role == Role.king) continue;
        final side = b.sideAt(sq)!;
        final targetK = (side == Side.white) ? bK : wK;
        final df = (sq.file.value - targetK.file.value).abs();
        final dr = (sq.rank.value - targetK.rank.value).abs();
        final dist = df + dr;
        final contrib = (8 - dist).clamp(0, 8) * EvalWeights.kingTropism;
        score += (side == Side.white ? 1 : -1) * contrib;
      }
    }
    return (op: score, eg: score + (score ~/ 2));
  }

  // ---------------- space advantage ----------------
  ({int op, int eg}) _spaceAdvantage(Chess pos) {
    final b = pos.board;
    int whiteSpace = 0, blackSpace = 0;

    // مقياس بسيط: عدد المربعات في نصف الخصم التي يسيطر عليها الجانب
    for (final (sq, piece) in b.pieces) {
      final side = b.sideAt(sq)!;
      final att = attacks(piece, sq, b.occupied);
      for (final a in att.squares) {
        if (side == Side.white && a.rank.value >= 4) whiteSpace++;
        if (side == Side.black && a.rank.value <= 3) blackSpace++;
      }
    }
    final diff = (whiteSpace - blackSpace) * EvalWeights.spaceAdvantage;
    return (op: diff, eg: diff);
  }
}

// -------------------- أمثلة عملية --------------------

void main() {
  group('Evaluation', () {

    test('Evaluation ', () {
      final eval = Evaluation();

      // مثال 1: FEN افتتاحي بسيط
      final fen1 =
          'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1'; // d4 من الأبيض
      final s1 = eval.evaluateFEN(fen1);
      print('Score fen1 = $s1 (cp)');

      // مثال 2: وضعية بيدق مُرَقّى/بيادق ممرورة محتملة
      final fen2 = '8/8/3k4/3P4/8/8/3K4/8 b - - 0 50';
      final s2 = eval.evaluateFEN(fen2);
      print('Score fen2 = $s2 (cp)');

      // مقارنة وضعيتين
      final better = (s1 > s2) ? 'fen1 أفضل للأبيض' : 'fen2 أفضل للأبيض';
      print('Comparison: $better');
    });
  });
}
