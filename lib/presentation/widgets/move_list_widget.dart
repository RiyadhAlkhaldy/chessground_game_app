// lib/presentation/widgets/move_list_widget.dart

import 'package:chessground_game_app/presentation/controllers/base_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to display the list of moves in the game
/// عنصر لعرض قائمة الحركات في اللعبة
class MoveListWidget extends GetView<BaseGameController> {
  const MoveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final moves = controller.gameState.getMoveTokens;

      if (moves.isEmpty) {
        return const Center(
          child: Text('No moves yet', style: TextStyle(color: Colors.grey)),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: (moves.length / 2).ceil(),
        itemBuilder: (context, index) {
          final moveNumber = index + 1;
          final whiteMove = moves[index * 2];
          final blackMove = (index * 2 + 1) < moves.length ? moves[index * 2 + 1] : null;

          return _buildMoveRow(context, moveNumber, whiteMove.san ?? '', blackMove?.san, index * 2);
        },
      );
    });
  }

  /// Build a row displaying one full move (white + black)
  /// بناء صف يعرض حركة كاملة (أبيض + أسود)
  Widget _buildMoveRow(
    BuildContext context,
    int moveNumber,
    String whiteMove,
    String? blackMove,
    int moveIndex,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Move number
          Container(
            width: 40,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              '$moveNumber.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),

          // White move
          Expanded(
            child: InkWell(
              onTap: () => _handleMoveClick(moveIndex),
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: _buildMoveText(whiteMove, moveIndex),
              ),
            ),
          ),

          // Black move
          if (blackMove != null)
            Expanded(
              child: InkWell(
                onTap: () => _handleMoveClick(moveIndex + 1),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: _buildMoveText(blackMove, moveIndex + 1),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  /// Build move text with annotations
  /// بناء نص الحركة مع التعليقات
  Widget _buildMoveText(String move, int moveIndex) {
    final currentIndex = controller.gameState.currentHalfmoveIndex;
    final isCurrentMove = moveIndex == currentIndex;

    return Text(
      move,
      style: TextStyle(
        fontWeight: isCurrentMove ? FontWeight.bold : FontWeight.normal,
        fontSize: 14,
        color: isCurrentMove ? Colors.blue : Colors.black,
        fontFamily: 'monospace',
      ),
    );
  }

  /// Handle move click for navigation
  /// معالجة النقر على الحركة للتنقل
  void _handleMoveClick(int moveIndex) {
    // TODO: Implement move navigation
    // This would require adding navigation methods to GameController
    Get.snackbar(
      'Navigate to Move',
      'Navigation to move ${moveIndex + 1}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
