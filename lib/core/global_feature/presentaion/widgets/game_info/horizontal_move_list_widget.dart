// lib/core/global_feature/presentaion/widgets/game_info/horizontal_move_list_widget.dart

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to display the list of moves horizontally
/// عنصر لعرض قائمة الحركات بشكل أفقي
class HorizontalMoveListWidget extends GetView<BaseGameController> {
  const HorizontalMoveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام ScrollController للتمرير التلقائي
    final scrollController = ScrollController();

    return Obx(() {
      final moves = controller.gameState.getMoveTokens;

      if (moves.isEmpty) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No moves yet',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        );
      }

      // التمرير التلقائي إلى الحركة الحالية
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          final currentIndex = controller.currentHalfmoveIndex;
          final itemWidth = 120.0; // عرض تقريبي لكل عنصر
          final targetOffset = (currentIndex / 2).floor() * itemWidth;

          scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });

      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: (moves.length / 2).ceil(),
          itemBuilder: (context, index) {
            final moveNumber = index + 1;
            final whiteMove = moves[index * 2];
            final blackMove = (index * 2 + 1) < moves.length
                ? moves[index * 2 + 1]
                : null;

            return _buildHorizontalMoveItem(
              context,
              moveNumber,
              whiteMove.san ?? '',
              blackMove?.san,
              index * 2,
            );
          },
        ),
      );
    });
  }

  /// Build a horizontal move item (white + black moves)
  /// بناء عنصر الحركة الأفقي (حركة أبيض + أسود)
  Widget _buildHorizontalMoveItem(
    BuildContext context,
    int moveNumber,
    String whiteMove,
    String? blackMove,
    int moveIndex,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Move number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Text(
              '$moveNumber.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.black87,
              ),
            ),
          ),

          // White move
          InkWell(
            onTap: () => _handleMoveClick(moveIndex),
            borderRadius: BorderRadius.zero,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: _buildMoveText(whiteMove, moveIndex, isWhite: true),
            ),
          ),

          // Separator
          if (blackMove != null)
            Container(width: 1, height: 30, color: Colors.grey[300]),

          // Black move
          if (blackMove != null)
            InkWell(
              onTap: () => _handleMoveClick(moveIndex + 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: _buildMoveText(blackMove, moveIndex + 1, isWhite: false),
              ),
            ),
        ],
      ),
    );
  }

  /// Build move text with styling based on state
  /// بناء نص الحركة مع التنسيق حسب الحالة
  Widget _buildMoveText(String move, int moveIndex, {required bool isWhite}) {
    final currentIndex = controller.gameState.currentHalfmoveIndex;
    final isCurrentMove = moveIndex == currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentMove
            ? (isWhite ? Colors.blue[50] : Colors.grey[800])
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        move,
        style: TextStyle(
          fontWeight: isCurrentMove ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
          color: isCurrentMove
              ? (isWhite ? Colors.blue[700] : Colors.white)
              : (isWhite ? Colors.black87 : Colors.black54),
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  /// Handle move click for navigation
  /// معالجة النقر على الحركة للتنقل
  void _handleMoveClick(int moveIndex) {
    // التنقل إلى الحركة المحددة
    controller.navigateToMove(moveIndex);
  }
}
