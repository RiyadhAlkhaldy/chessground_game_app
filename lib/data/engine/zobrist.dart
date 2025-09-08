// lib/engine/zobrist.dart
import 'dart:math';

import 'package:dartchess/dartchess.dart';

class Zobrist {
  // استخدم BigInt لمطابقة 64-bit XOR بشكل آمن عبر جميع المنصات
  final List<List<List<BigInt>>> pieceZ = List.generate(
    2,
    (_) => List.generate(6, (_) => List.filled(64, BigInt.zero)),
  );
  final List<BigInt> castlingZ = List.filled(16, BigInt.zero); // 4 بت = 16 حالة
  final List<BigInt> epFileZ = List.filled(9, BigInt.zero); // file A..H + none
  final BigInt sideZ;

  Zobrist._(this.sideZ);

  factory Zobrist([int seed = 88776655]) {
    final rnd = Random(seed);
    BigInt r64() =>
        BigInt.from(rnd.nextInt(1 << 30)) |
        (BigInt.from(rnd.nextInt(1 << 30)) << 30) |
        (BigInt.from(rnd.nextInt(1 << 4)) << 60);
    final z = Zobrist._(r64());
    for (int c = 0; c < 2; c++) {
      for (int r = 0; r < 6; r++) {
        for (int s = 0; s < 64; s++) {
          z.pieceZ[c][r][s] = r64();
        }
      }
    }
    for (int i = 0; i < 16; i++) z.castlingZ[i] = r64();
    for (int i = 0; i < 9; i++) z.epFileZ[i] = r64();
    return z;
  }

  BigInt hash(Position pos) {
    BigInt h = BigInt.zero;
    // قطع
    for (int sq = 0; sq < 64; sq++) {
      final piece = pos.board.pieceAt(Square(sq));
      if (piece == null) continue;
      final c = piece.color == Side.white ? 0 : 1;
      final r = _roleIndex(piece.role);
      h ^= pieceZ[c][r][sq];
    }
    // كاستلينغ: حوّل rights إلى index 0..15
    // final cs = pos.castles; // Castles
    int idx = 0;
    // if (cs.rooksPositions[Side.white]?[CastlingSide.king] != null) idx |= 1;
    // if (cs.whiteQueenSide) idx |= 2;
    // if (cs.blackKingSide) idx |= 4;
    // if (cs.blackQueenSide) idx |= 8;
    h ^= castlingZ[idx];
    // en-passant file (أو none=8)
    final ep = pos.epSquare;
    h ^= epFileZ[ep == null ? 8 : ep.file.value];
    // الدور
    if (pos.turn == Side.white) h ^= sideZ;
    return h;
  }

  int _roleIndex(Role r) => switch (r) {
    Role.pawn => 0,
    Role.knight => 1,
    Role.bishop => 2,
    Role.rook => 3,
    Role.queen => 4,
    Role.king => 5,
  };
}
