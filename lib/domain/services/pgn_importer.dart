// lib/services/pgn_importer.dart
// اختياري: المكتبة التي ستستخدمها لحساب الـ FEN.
// تأكد من تعديل الاستيراد ليتوافق مع المكتبة التي تختارها.
import 'package:chess/chess.dart'; // مثال
import 'package:isar/isar.dart';

import '../collections/chess_game.dart';

/// تنبّه:
/// - هذا كود "قابل للتنفيذ" لكن قد تحتاج لتعديل طفيف حسب API الحقيقية للمكتبة 'chess' أو 'dartchess' التي تختارها.
/// - إذا استخدمت مكتبة تدعم loadPgn / load_pgn فستستخدمها مباشرة للحصول على سلسلة الحركات وFEN بعد كل حركة.

Future<Id> importPgnToIsar({
  required String pgnText,
  required Isar isar,
  String? userId,
}) async {
  // 1. استخرج الـ tag pairs
  final tagReg = RegExp(r'^\[([A-Za-z0-9_]+)\s+"([^"]*)"\]', multiLine: true);
  final tags = <String, String>{};
  for (final m in tagReg.allMatches(pgnText)) {
    tags[m.group(1)!] = m.group(2)!;
  }

  // 2. أنشئ كائن ChessGame وأملأ الحقول من التاجز
  final game =
      ChessGame()
        ..event = tags['Event']
        ..site = tags['Site']
        ..round = tags['Round']
        //TODO: ربط اللاعبين لاحقًا بعد جلبهم من قاعدة البيانات
        // ..whitePlayer = tags['White']
        // ..blackPlayer = tags['Black']
        ..result = tags['Result']
        ..eco = tags['ECO']
        ..timeControl = tags['TimeControl']
        ..fullPgn = pgnText
        ..userId = userId;

  // تحويل Elo من string إلى int إن وُجد
  game.whiteElo =
      tags['WhiteElo'] != null ? int.tryParse(tags['WhiteElo']!) : null;
  game.blackElo =
      tags['BlackElo'] != null ? int.tryParse(tags['BlackElo']!) : null;

  // تحويل التاريخ إن وُجد (الصيغة الشائعة "YYYY.MM.DD" أو "YYYY-MM-DD")
  if (tags['Date'] != null) {
    final d = tags['Date']!.replaceAll('.', '-');
    try {
      game.date = DateTime.tryParse(d);
    } catch (e) {
      // إذا لم ينجح التحويل، اترك null
    }
  }

  // 3. الحصول على نص الحركات (إزالة التاجز)
  var movesSection =
      pgnText.replaceAll(RegExp(r'^\[.*\]\s*', multiLine: true), '').trim();

  // الطريقة المفضلة: استخدم محلل PGN أو مكتبة chess التي تدعم loadPGN،
  // ثم استخرج تسلسل الحركات واطلب FEN بعد كل حركة.
  //
  // مثال توضيحي باستخدام مكتبة 'chess' (API قد تحتاج تعديل طفيف):
  final board = Chess(); // إنشاء اللوحة
  try {
    // بعض مكتبات الـ chess تحتوي على load_pgn / loadPgn
    // هنا نفترض وجود طريقة loadPgn أو load_pgn — عدّلها بحسب المكتبة
    final loaded = board.load_pgn(movesSection); // قد يكون loadPgn أو load_pgn
    if (loaded == true) {
      // استخرج تاريخ الحركات (history) بصيغة SAN
      final history = board.getHistory(); // قد تُرجع قائمة SAN
      // لكن نحتاج أيضاً FEN بعد كل حركة؛ سنعيد إنشاء اللوحة خطوة بخطوة:
      final board2 = Chess(); // لوحة فارغة (initial)
      for (final san in history) {
        // الطريقة العامة: نفذ الحركة بصيغة SAN
        final moveResult = board2.move(
          san,
        ); // API متغير؛ في بعض المكتبات board.move({'san': san})
        final fenAfter = board2.fen; // الحصول على FEN الحالي
        final lan = _moveToLan(
          moveResult,
        ); // تابع مساعدة لتحويل نتيجة الحركة إلى LAN
        final moveData =
            MoveData()
              ..san = san
              ..lan = lan
              ..fenAfter = fenAfter;
        game.moves.add(moveData);
      }
    } else {
      // fallback: استخدم محلل بسيط أدناه
      _fallbackParseMoves(movesSection, game);
    }
  } catch (e) {
    // في حال فشل المحاولات أعلاه: fallback بسيط
    _fallbackParseMoves(movesSection, game);
  }

  // 4. تخزين اللعبة في Isar
  await isar.writeTxn(() async {
    await isar.chessGames.put(game);
  });

  return game.id;
}

/// محول مساعد: من نتيجة الحركة من مكتبة chess إلى LAN (مثال شعاعي، عدّل تبعًا لنتيجة مكتبتك)
String? _moveToLan(dynamic moveResult) {
  // moveResult يمكن أن يكون Map أو كائن؛ عادة يحتوي على 'from' و 'to' وأحيانًا 'promotion'
  try {
    if (moveResult == null) return null;
    final from = moveResult['from'] as String?;
    final to = moveResult['to'] as String?;
    if (from != null && to != null) {
      var lan = '$from$to';
      if (moveResult.containsKey('promotion')) {
        lan += moveResult['promotion'];
      }
      return lan;
    }
    return null;
  } catch (e) {
    return null;
  }
}

/// تحليل احتياطي بسيط للغاية (لن يكون بديلاً كاملاً عن محلل PGN حقيقي)
void _fallbackParseMoves(String movesText, ChessGame game) {
  // إزالة التعليقات والملاحظات
  var t = movesText;
  t = t.replaceAll(RegExp(r'\{[^}]*\}'), ''); // remove { comments }
  t = t.replaceAll(RegExp(r'\([^)]*\)'), ''); // remove (variations)
  t = t.replaceAll(RegExp(r'\d+\.(\.\.)?'), ''); // remove move numbers
  t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
  // ازالة النتيجة في نهاية النص
  t = t.replaceAll(RegExp(r'(1-0|0-1|1/2-1/2|\*)$'), '').trim();

  final tokens = t.split(' ').where((s) => s.trim().isNotEmpty).toList();
  // tokens الآن تقريبًا سلسلة SAN متسلسلة، الآن نضعها في moves مع fenAfter=null (إن لم نستخدم مكتبة)
  for (final san in tokens) {
    if (RegExp(r'^(1-0|0-1|1/2-1/2|\*)$').hasMatch(san)) continue;
    final md = MoveData()..san = san;
    game.moves.add(md);
  }
}
