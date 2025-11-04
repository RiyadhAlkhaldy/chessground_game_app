import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/collections/chess_game.dart';

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
    char = isWhiteMove
        ? whiteMap[pieceLetter]! + char
        : blackMap[pieceLetter]! + char;
    debugPrint('char: $char');
    return char;
  }
  debugPrint('char $san');
  return san;
}
// Widget _buildToken(BuildContext context, MoveData t, bool isCurrent) {
//   final theme = Theme.of(context);
//   final bg = isCurrent
//       ? theme.colorScheme.primary.withOpacity(0.15)
//       : Colors.transparent;
//   final borderColor = isCurrent
//       ? theme.colorScheme.primary
//       : Colors.transparent;

//   return GestureDetector(
//     onTap: () {
//       if (widget.onJumpTo != null) widget.onJumpTo!(t.halfmoveIndex!);
//     },
//     onPanDown: (_) => _onUserInteraction(),
//     child: Container(
//       key: _itemKeys.putIfAbsent(t.halfmoveIndex!, () => GlobalKey()),
//       margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: borderColor, width: 1.2),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (t.isWhiteMove!)
//             Text('${t.moveNumber}.', style: theme.textTheme.bodySmall),
//           const SizedBox(width: 6),
//           Text(t.san!, style: theme.textTheme.bodyMedium),
//         ],
//       ),
//     ),
//   );
// }
Widget _buildToken(BuildContext context, MoveData t, bool isCurrent) {
  final theme = Theme.of(context);
  final bg = isCurrent
      ? theme.colorScheme.primary.withValues(alpha: 0.15)
      : Colors.transparent;
  final borderColor = isCurrent
      ? theme.colorScheme.primary
      : Colors.transparent;
  final pieceSymbol = pieceSymbolFromSan(t.san!, isWhiteMove: t.isWhiteMove!);
  //   // نص الـ SAN قد يبدأ مثلاً "Bxf2" أو "exd6" أو "O-O"
  //   // سنعرض الرمز فقط إن كان غير فارغ
  final List<Widget> children = [];
  if (t.isWhiteMove!) {
    children.add(Text('${t.moveNumber}.', style: theme.textTheme.bodySmall));
    children.add(const SizedBox(width: 2));
  }

  // نعرض رمز القطعة بحجم أصغر قليلاً
  children.add(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Text(pieceSymbol, style: theme.textTheme.bodySmall),
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

class PgnHorizontalRow extends StatefulWidget {
  final List<MoveData> tokens;
  final int? currentHalfmoveIndex;
  final JumpCallback? onJumpTo;

  /// مدة الانتظار قبل أن نعتبر أن المستخدم لم يعد يتفاعل (ms)
  final Duration userInteractionTimeout;

  /// مدة الانميشن للتمرير الآلي
  final Duration autoScrollDuration;

  /// إذا true: نفترض أن كل توكن له عرض ثابت (itemExtent) — أسرع للـ ListView.
  /// إذا null أو false: نستخدم عرض ديناميكي (shrinkWrap items) — أقل كفاءة لكن مرن.
  final double? itemExtent;

  const PgnHorizontalRow({
    super.key,
    required this.tokens,
    this.currentHalfmoveIndex,
    this.onJumpTo,
    this.userInteractionTimeout = const Duration(milliseconds: 1500),
    this.autoScrollDuration = const Duration(milliseconds: 360),
    this.itemExtent,
  });

  @override
  State<PgnHorizontalRow> createState() => _PgnHorizontalRowState();
}

class _PgnHorizontalRowState extends State<PgnHorizontalRow> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};
  Timer? _userInteractionTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _rebuildKeys();
  }

  @override
  void dispose() {
    _userInteractionTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PgnHorizontalRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    _rebuildKeys();

    // if tokens length increased or current index changed, attempt auto-scroll
    final tokensChanged = widget.tokens.length != oldWidget.tokens.length;
    final indexChanged =
        widget.currentHalfmoveIndex != oldWidget.currentHalfmoveIndex;

    if (tokensChanged || indexChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeAutoScrollTo(
          widget.currentHalfmoveIndex,
          tokensAppended: tokensChanged,
        );
      });
    }
  }

  void _rebuildKeys() {
    for (final t in widget.tokens) {
      _itemKeys.putIfAbsent(t.halfmoveIndex!, () => GlobalKey());
    }
    final valid = widget.tokens.map((t) => t.halfmoveIndex).toSet();
    _itemKeys.removeWhere((k, _) => !valid.contains(k));
  }

  void _onUserInteraction() {
    _userInteractionTimer?.cancel();
    _userInteracting = true;
    _userInteractionTimer = Timer(widget.userInteractionTimeout, () {
      _userInteracting = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeAutoScrollTo(widget.currentHalfmoveIndex);
      });
    });
  }

  Future<void> _maybeAutoScrollTo(
    int? halfmoveIndex, {
    bool tokensAppended = false,
  }) async {
    if (halfmoveIndex == null) return;
    if (_userInteracting) return;

    // Try to get the item's context and use ensureVisible.
    final key = _itemKeys[halfmoveIndex];
    if (key != null && key.currentContext != null) {
      try {
        await Scrollable.ensureVisible(
          key.currentContext!,
          duration: widget.autoScrollDuration,
          curve: Curves.easeOutCubic,
          alignment: 0.6, // a bit toward center-right for readability
        );
        return;
      } catch (_) {
        // fallthrough to fallback
      }
    }

    // Fallback: if tokens were appended, scroll to end (fast and reliable).
    if (tokensAppended) {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      await _scrollController.animateTo(
        max,
        duration: widget.autoScrollDuration,
        curve: Curves.easeOutCubic,
      );
      return;
    }

    // As last resort: try to compute approximate offset by summing known child widths,
    // otherwise scroll to end.
    await _fallbackScrollToIndex(halfmoveIndex);
  }

  Future<void> _fallbackScrollToIndex(int index) async {
    final scroll = _scrollController;
    if (!scroll.hasClients) return;
    double offset = 0;
    for (int i = 0; i <= index && i < widget.tokens.length; i++) {
      final key = _itemKeys[widget.tokens[i].halfmoveIndex];
      if (key?.currentContext != null) {
        final box = key!.currentContext!.findRenderObject() as RenderBox;
        offset += box.size.width + 12; // approximate margin
      } else if (widget.itemExtent != null) {
        offset += widget.itemExtent!;
      } else {
        offset += 64; // default estimate
      }
    }
    final target = (offset - 120).clamp(0.0, scroll.position.maxScrollExtent);
    await scroll.animateTo(
      target,
      duration: widget.autoScrollDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tokens.isEmpty) {
      return SizedBox(
        height: 56,
        child: Center(
          child: Text('No moves', style: Theme.of(context).textTheme.bodySmall),
        ),
      );
    }

    // If itemExtent provided -> use ListView.builder with itemExtent (more performant).
    if (widget.itemExtent != null) {
      return SizedBox(
        height: widget.itemExtent! + 16,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (n) {
            _onUserInteraction();
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.tokens.length,
            itemExtent: widget.itemExtent!,
            itemBuilder: (context, index) {
              final t = widget.tokens[index];
              final isCurrent =
                  (widget.currentHalfmoveIndex != null &&
                  widget.currentHalfmoveIndex == t.halfmoveIndex);
              return _buildToken(context, t, isCurrent);
            },
          ),
        ),
      );
    }

    // Dynamic width items:
    return SizedBox(
      height: 56,
      child: NotificationListener<UserScrollNotification>(
        onNotification: (n) {
          _onUserInteraction();
          return false;
        },
        child: GestureDetector(
          onPanDown: (_) => _onUserInteraction(),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.tokens.length,
            itemBuilder: (context, index) {
              final t = widget.tokens[index];
              final isCurrent =
                  (widget.currentHalfmoveIndex != null &&
                  widget.currentHalfmoveIndex == t.halfmoveIndex);
              return _buildToken(context, t, isCurrent);
            },
          ),
        ),
      ),
    );
  }
}
