import 'package:chessground_game_app/data/collections/chess_game.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'mini_board_widget.dart' as mbw;

class GameCardWidget extends StatelessWidget {
  final ChessGame game;
  const GameCardWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // الحصول على آخر FEN: إما من آخر حركة أو startingFen
    String? fen;
    if (game.moves.isNotEmpty) {
      final last = game.moves.last;
      fen = last.fenAfter ?? game.startingFen;
    } else {
      fen = game.startingFen;
    }

    final whiteName = game.whitePlayer.value?.name ?? 'لاعب';
    final blackName = game.blackPlayer.value?.name ?? 'خصم';

    final dateStr = game.date != null
        ? DateFormat.yMd().add_Hm().format(game.date!)
        : '';

    // الواجهة: بطاقة مع مصغّر رقعة وأرقام وتصنيف ونتيجة
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          // RTL: المصغّر على اليمين (في الصفحات العربية عادة)
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: meta (اسم اللاعبين، النتيجة)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${game.id}: $whiteName  •  ${game.whiteElo ?? '-'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$blackName  •  ${game.blackElo ?? '-'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _tagColor(game), // لون للـ tag
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _tagText(game),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        game.result ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (game.eco != null)
                        Text(
                          game.eco!,
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Right side: mini board
            SizedBox(
              width: 110,
              height: 110,
              // import '../../../../lib/widgets/mini_board_widget.dart' as mbw;
              child: mbw.MiniBoardWidget(fen: fen, key: ValueKey(fen)),
            ),
          ],
        ),
      ),
    );
  }

  // مثال بسيط لتحديد نص العلامة (+/-)
  String _tagText(ChessGame g) {
    // استخدم قاعدة بسيطة: إذا الفوز فان +
    if (g.result == '1-0') return '+';
    if (g.result == '0-1') return '-';
    return '—';
  }

  Color _tagColor(ChessGame g) {
    if (g.result == '1-0') return Colors.green;
    if (g.result == '0-1') return Colors.orange;
    return Colors.grey;
  }
}
