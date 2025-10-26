import 'package:flutter/material.dart';

import '../../domain/models/chess_game.dart';

typedef JumpCallback = void Function(int halfmoveIndex);

/// Helper: return a unicode chess symbol based on piece letter and color.
String pieceSymbolFromSan(String san, {required bool isWhiteMove}) {
  // SAN starts with piece letter for pieces: K Q R B N
  // Pawn moves usually start with file letter 'a'..'h' -> we can return pawn symbol if desired.
  if (san.isEmpty) return '';

  final pieceLetter = san[0];
  // mapping for white pieces (use white symbols) and black pieces (use black symbols)
  const whiteMap = {'K': '♔', 'Q': '♕', 'R': '♖', 'B': '♗', 'N': '♘'};
  const blackMap = {'K': '♚', 'Q': '♛', 'R': '♜', 'B': '♝', 'N': '♞'};

  debugPrint('san : $san');
  if (whiteMap.containsKey(pieceLetter)) {
    var char = san.substring(1, san.length);
    char =
        isWhiteMove
            ? whiteMap[pieceLetter]! + char
            : blackMap[pieceLetter]! + char;
    debugPrint('char: $char');
    return char;
  }
  debugPrint('char $san');
  return san;
}

class PgnHorizontalRow extends StatelessWidget {
  final List<MoveData> tokens;
  final int? currentHalfmoveIndex;
  final JumpCallback? onJumpTo;

  const PgnHorizontalRow({
    super.key,
    required this.tokens,
    this.currentHalfmoveIndex,
    this.onJumpTo,
  });

  @override
  Widget build(BuildContext context) {
    if (tokens.isEmpty) {
      return Container(
        height: 48,
        alignment: Alignment.center,
        child: Text(
          'No moves yet',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              tokens.map((t) {
                final isCurrent =
                    (currentHalfmoveIndex != null &&
                        currentHalfmoveIndex == t.halfmoveIndex);
                return _buildToken(context, t, isCurrent);
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildToken(BuildContext context, MoveData t, bool isCurrent) {
    final theme = Theme.of(context);
    final bg =
        isCurrent
            ? theme.colorScheme.primary.withOpacity(0.15)
            : Colors.transparent;
    final borderColor =
        isCurrent ? theme.colorScheme.primary : Colors.transparent;
    final pieceSymbol = pieceSymbolFromSan(t.san!, isWhiteMove: t.isWhiteMove!);
    //   // نص الـ SAN قد يبدأ مثلاً "Bxf2" أو "exd6" أو "O-O"
    //   // سنعرض الرمز فقط إن كان غير فارغ
    final List<Widget> children = [];
    if (t.isWhiteMove!) {
      children.add(Text('${t.moveNumber}.', style: theme.textTheme.bodySmall));
      children.add(const SizedBox(width: 6));
    }

    // نعرض رمز القطعة بحجم أصغر قليلاً
    children.add(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Text(pieceSymbol, style: theme.textTheme.bodyMedium),
      ),
    );
    children.add(const SizedBox(width: 2));

    return GestureDetector(
      onTap: () {
        // if (onJumpTo != null) onJumpTo!(t.halfmoveIndex!);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(children: children),
      ),
    );
  }
}
