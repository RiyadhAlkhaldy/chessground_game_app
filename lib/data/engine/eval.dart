// lib/engine/eval.dart
import 'package:dartchess/dartchess.dart';

class Evaluator {
  static const values = {
    Role.pawn: 100,
    Role.knight: 320,
    Role.bishop: 330,
    Role.rook: 500,
    Role.queen: 900,
    Role.king: 0,
  };

  // PST مبسطة (MG/EG) — قيم تمهيدية يمكن تحسينها لاحقًا
  static const List<int> pstPawnMG = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    50,
    50,
    50,
    50,
    50,
    50,
    50,
    50,
    10,
    10,
    20,
    30,
    30,
    20,
    10,
    10,
    5,
    5,
    10,
    25,
    25,
    10,
    5,
    5,
    0,
    0,
    0,
    20,
    20,
    0,
    0,
    0,
    5,
    -5,
    -10,
    0,
    0,
    -10,
    -5,
    5,
    5,
    10,
    10,
    -20,
    -20,
    10,
    10,
    5,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  static const List<int> pstPawnEG = [
    0,
    5,
    5,
    -10,
    -10,
    5,
    5,
    0,
    0,
    10,
    -5,
    0,
    0,
    -5,
    10,
    0,
    0,
    10,
    10,
    20,
    20,
    10,
    10,
    0,
    5,
    5,
    10,
    25,
    25,
    10,
    5,
    5,
    10,
    10,
    20,
    30,
    30,
    20,
    10,
    10,
    50,
    50,
    50,
    50,
    50,
    50,
    50,
    50,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  // (للاختصار سنستخدم PST للـ Knight فقط؛ طبّق مثلها لبقية القطع)
  static const List<int> pstKnight = [
    -50,
    -40,
    -30,
    -30,
    -30,
    -30,
    -40,
    -50,
    -40,
    -20,
    0,
    5,
    5,
    0,
    -20,
    -40,
    -30,
    5,
    10,
    15,
    15,
    10,
    5,
    -30,
    -30,
    0,
    15,
    20,
    20,
    15,
    0,
    -30,
    -30,
    5,
    15,
    20,
    20,
    15,
    5,
    -30,
    -30,
    0,
    10,
    15,
    15,
    10,
    0,
    -30,
    -40,
    -20,
    0,
    0,
    0,
    0,
    -20,
    -40,
    -50,
    -40,
    -30,
    -30,
    -30,
    -30,
    -40,
    -50,
  ];

  int evaluate(Position pos) {
    // Mate/stalemate نتائج
    if (pos.isCheckmate) return (pos.turn == Side.white) ? -30000 : 30000;
    if (pos.isStalemate) return 0;

    int mgScore = 0, egScore = 0;
    int phase = 0; // 0..24 تقريبًا

    for (int sq = 0; sq < 64; sq++) {
      final piece = pos.board.pieceAt(Square(sq));
      if (piece == null) continue;
      final sign = (piece.color == Side.white) ? 1 : -1;
      final v = values[piece.role]!;
      mgScore += sign * v;
      egScore += sign * v;
      // PST سريعة كنقطة بدء
      if (piece.role == Role.pawn) {
        mgScore += sign * pstPawnMG[_pstIndex(piece.color, sq)];
        egScore += sign * pstPawnEG[_pstIndex(piece.color, sq)];
      } else if (piece.role == Role.knight) {
        mgScore += sign * pstKnight[_pstIndex(piece.color, sq)];
        egScore += sign * pstKnight[_pstIndex(piece.color, sq)];
      }
      // phase: تقل مع تبادل القطع الثقيلة
      phase += switch (piece.role) {
        Role.pawn => 0,
        Role.knight => 1,
        Role.bishop => 1,
        Role.rook => 2,
        Role.queen => 4,
        Role.king => 0,
      };
    }

    // بساطة: Mobility = عدد النقلات القانونية * وزن صغير
    final legalCount = pos.legalMoves.values.fold<int>(0, (a, s) => a + s.size);
    final mob = 2 * legalCount * (pos.turn == Side.white ? 1 : -1);
    mgScore += mob;
    egScore += mob;

    // King safety (خفيف): خصم بسيط إن لم يكن هناك حرس بيدق أمام الملك
    mgScore += _kingShieldPenalty(pos);

    // Pawn structure مبسط: معاقبة isolated ومكافأة passed
    mgScore += _pawnStructure(pos);

    // Blend MG/EG
    if (phase > 24) phase = 24;
    final score = ((mgScore * phase) + (egScore * (24 - phase))) ~/ 24;
    return (pos.turn == Side.white) ? score : -score;
  }

  int _pstIndex(Side color, int sqIndex) {
    // اقلب الجدول للأسود
    return (color == Side.white) ? (63 - sqIndex) : sqIndex;
  }

  int _kingShieldPenalty(Position pos) {
    // جد مربع الملك لكل جانب ثم افحص وجود بيدق أمامه (تقريب)
    int pen = 0;
    for (final side in [Side.white, Side.black]) {
      final kingSq = _findKing(pos, side);
      if (kingSq == null) continue;
      final dir = (side == Side.white) ? 1 : -1; // اتجاه أمام الملك تقريبي
      int shield = 0;
      for (final df in [-1, 0, 1]) {
        final file = kingSq.file.value + df;
        final rank = kingSq.rank.value + dir;
        if (file < 0 || file > 7 || rank < 0 || rank > 7) continue;
        final s = Square.fromCoords(File(file), Rank(rank));
        final p = pos.board.pieceAt(s);
        if (p != null && p.color == side && p.role == Role.pawn) shield++;
      }
      if (shield == 0) pen += (side == Side.white ? -30 : 30);
    }
    return pen;
  }

  Square? _findKing(Position pos, Side side) {
    for (int sq = 0; sq < 64; sq++) {
      final p = pos.board.pieceAt(Square(sq));
      if (p != null && p.color == side && p.role == Role.king) {
        return Square(sq);
      }
    }
    return null;
  }

  int _pawnStructure(Position pos) {
    int sc = 0;
    for (int sq = 0; sq < 64; sq++) {
      final piece = pos.board.pieceAt(Square(sq));
      if (piece == null || piece.role != Role.pawn) continue;
      final side = piece.color;
      final sign = side == Side.white ? 1 : -1;
      final f = Square(sq).file.value;
      // isolated: لا يوجد بيدق لنفس اللون على الملفات المجاورة
      bool isolated = true;
      for (final df in [-1, 1]) {
        final nf = f + df;
        if (nf < 0 || nf > 7) continue;
        for (int r = 0; r < 8; r++) {
          final s = Square.fromCoords(File(nf), Rank(r));
          final p = pos.board.pieceAt(s);
          if (p != null && p.color == side && p.role == Role.pawn) {
            isolated = false;
            break;
          }
        }
      }
      if (isolated) sc -= 10 * sign;

      // passed: لا توجد بيادق خصم أمامه على نفس/ملفات مجاورة
      bool passed = true;
      for (final df in [-1, 0, 1]) {
        final nf = f + df;
        if (nf < 0 || nf > 7) continue;
        for (int r = 0; r < 8; r++) {
          final s = Square.fromCoords(File(nf), Rank(r));
          final p = pos.board.pieceAt(s);
          if (p != null && p.color != side && p.role == Role.pawn) {
            final ahead = (side == Side.white)
                ? (r > Square(sq).rank.value)
                : (r < Square(sq).rank.value);
            if (ahead) {
              passed = false;
              break;
            }
          }
        }
      }
      if (passed) sc += 25 * sign;
    }
    return sc;
  }
}
