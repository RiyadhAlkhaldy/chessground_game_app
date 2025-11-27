import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class MiniBoardWidget extends StatefulWidget {
  final String? fen;
  const MiniBoardWidget({super.key, this.fen});

  @override
  State<MiniBoardWidget> createState() => _MiniBoardWidgetState();
}

class _MiniBoardWidgetState extends State<MiniBoardWidget> {
  late ChessBoardController controller;

  @override
  void initState() {
    super.initState();
    controller = ChessBoardController();
    // إذا كانت هناك FEN ممررة، نعيّنها
    if (widget.fen != null && widget.fen!.isNotEmpty) {
      try {
        controller.loadFen(widget.fen!);
      } catch (e) {
        // في حال كان الفين غير صالح، تجاهله
      }
    }
  }

  @override
  void didUpdateWidget(covariant MiniBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fen != oldWidget.fen && widget.fen != null) {
      try {
        controller.loadFen(widget.fen!);
      } catch (e) {
        // handle invalid fen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // نعرض رقعة غير تفاعلية (disable gestures) بمقاس مصغّر
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ChessBoard(
          enableUserMoves: false, // عرض فقط
          size: 110,
          controller: controller,
          // boardType: BoardType.brown,
          boardColor: BoardColor.brown,
        ),
      ),
    );
  }
}
