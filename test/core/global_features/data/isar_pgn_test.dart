// example_usage.dart
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

String makePgnFromSanList({
  required Map<String, String>
  headers, // ex: {'Event':'MyGame', 'White':'Alice', ...}
  required List<String> sanMoves,
  required String result, // "1-0", "0-1", "1/2-1/2", or "*"
}) {
  // 1) Headers
  final sb = StringBuffer();
  headers.forEach((k, v) {
    sb.writeln('[$k "${v.replaceAll('"', '\\"')}"]');
  });
  sb.writeln(); // سطر فارغ بعد الـheaders

  // 2) Moves with numbering
  final movesSb = StringBuffer();
  for (int i = 0; i < sanMoves.length; i += 2) {
    final moveNumber = (i ~/ 2) + 1;
    movesSb.write('$moveNumber. ');
    movesSb.write(sanMoves[i]);
    if (i + 1 < sanMoves.length) {
      movesSb.write(' ${sanMoves[i + 1]} ');
    } else {
      movesSb.write(' ');
    }
  }

  movesSb.write(result);
  sb.writeln(movesSb.toString().trim());
  return sb.toString();
}

// مساعدة لتطبيق حركة مع الحصول على SAN (يدعم طريقتين إن لزم)
Position applyMoveAndRecordSAN(Position p, NormalMove move, List<String> out) {
  // طريقة 1: استخدام makeSan إن كانت متوفرة (ترجع (Position, String))
  try {
    // في توثيق dartchess: makeSan(Move) → (Position, String)
    final record = p.makeSan(
      move,
    ); // هذا يعيد record في Dart3: (Position, String)
    // فك الـrecord (Dart 3 syntax):
    final Position newPos = record.$1;
    final String san = record.$2;
    out.add(san);
    return newPos;
  } catch (e) {
    // بديل: استخدم toSan + play
    final makeSan = p.makeSan(move); // احصل على SAN من الوضع الحالي
    out.add(makeSan.$2);
    final Position newPos = p.play(move);
    return newPos;
  }
}

void main() {
  test('make pgn test', () {
    // 1) ابتداءً من الوضعية الابتدائية
    Position pos =
        Chess.initial; // أو Chess.fromSetup(Setup.parseFen(kInitialFEN))

    // قائمة SAN (الخط الرئيسي فقط)
    final List<String> sanList = [];

    // الآن نطبق سلسلة حركات (مثال: افتتاح Ruy Lopez حتى بعض الحركات)
    // 1. e4 e5
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.e2, to: Square.e4),
      sanList,
    );
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.e7, to: Square.e5),
      sanList,
    );

    // 2. Nf3 Nc6
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.g1, to: Square.f3),
      sanList,
    );
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.b8, to: Square.c6),
      sanList,
    );

    // 3. Bb5 a6
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.f1, to: Square.b5),
      sanList,
    );
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.a7, to: Square.a6),
      sanList,
    );

    // 4. Ba4 Nf6
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.b5, to: Square.a4),
      sanList,
    );
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.g8, to: Square.f6),
      sanList,
    );

    // 5. O-O Be7  (castling example - castling is represented as a NormalMove with from/to)
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.e1, to: Square.g1),
      sanList,
    ); // O-O
    pos = applyMoveAndRecordSAN(
      pos,
      const NormalMove(from: Square.f8, to: Square.e7),
      sanList,
    );

    // الآن sanList يحتوي على سلسلة الـSAN للحركات:
    debugPrint('SAN moves: ${sanList.join(' ')}');

    // يمكنك استخدام pos.outcome أو pos.isGameOver للتحقق من النهاية
    debugPrint('Is game over? ${pos.isGameOver}  Outcome: ${pos.outcome}');
  });
}
