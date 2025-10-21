import 'package:flutter/material.dart';

import '../../domain/models/chess_game.dart';

typedef JumpCallback = void Function(int halfmoveIndex);

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
    return GestureDetector(
      onTap: () {
        if (onJumpTo != null) onJumpTo!(t.halfmoveIndex!);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            if (t.isWhiteMove!)
              Text('${t.moveNumber}.', style: theme.textTheme.bodySmall)
            else
              const SizedBox(width: 0),
            const SizedBox(width: 2),
            Text(t.san!, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
