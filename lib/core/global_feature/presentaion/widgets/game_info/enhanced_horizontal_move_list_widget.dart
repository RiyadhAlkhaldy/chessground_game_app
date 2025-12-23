// lib/core/global_feature/presentaion/widgets/game_info/enhanced_horizontal_move_list_widget.dart

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Enhanced horizontal move list widget with icons for special moves
/// عنصر محسّن لعرض قائمة الحركات أفقياً مع أيقونات للحركات الخاصة
class EnhancedHorizontalMoveListWidget extends GetView<BaseGameController> {
  const EnhancedHorizontalMoveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Obx(() {
      final moves = controller.gameState.getMoveTokens;

      if (moves.isEmpty) {
        return _buildEmptyState();
      }

      // التمرير التلقائي إلى الحركة الحالية
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          _scrollToCurrentMove(scrollController);
        }
      });

      return Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(moves.length),
            // Moves list
            Expanded(
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

                  return _buildMoveCard(
                    context,
                    moveNumber,
                    whiteMove,
                    blackMove,
                    index * 2,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build empty state when no moves
  /// بناء حالة فارغة عندما لا توجد حركات
  Widget _buildEmptyState() {
    return Container(
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            'No moves yet - Start playing!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build header with move count
  /// بناء رأس العنصر مع عدد الحركات
  Widget _buildHeader(int totalMoves) {
    final fullMoves = (totalMoves / 2).ceil();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.history, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            'Moves: $fullMoves',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  /// Scroll to current move
  /// التمرير إلى الحركة الحالية
  void _scrollToCurrentMove(ScrollController controller) {
    if (!controller.hasClients) return;

    final currentIndex = this.controller.currentHalfmoveIndex;
    if (currentIndex < 0) return;

    const itemWidth = 130.0; // عرض تقريبي لكل عنصر
    final targetOffset = (currentIndex / 2).floor() * itemWidth;

    // تأكد من أن الإزاحة ضمن النطاق الصحيح
    final maxScroll = controller.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    controller.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Build move card with both white and black moves
  /// بناء بطاقة الحركة مع حركات الأبيض والأسود
  Widget _buildMoveCard(
    BuildContext context,
    int moveNumber,
    dynamic whiteMove,
    dynamic blackMove,
    int moveIndex,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Move number
          _buildMoveNumber(moveNumber),

          // White move
          _buildMoveButton(
            whiteMove.san ?? '',
            moveIndex,
            isWhite: true,
            wasCapture: whiteMove.wasCapture ?? false,
            wasCheck: whiteMove.wasCheck ?? false,
            wasCheckmate: whiteMove.wasCheckmate ?? false,
            wasPromotion: whiteMove.wasPromotion ?? false,
          ),

          // Separator
          if (blackMove != null)
            Container(width: 1, height: 35, color: Colors.grey[300]),

          // Black move
          if (blackMove != null)
            _buildMoveButton(
              blackMove.san ?? '',
              moveIndex + 1,
              isWhite: false,
              wasCapture: blackMove.wasCapture ?? false,
              wasCheck: blackMove.wasCheck ?? false,
              wasCheckmate: blackMove.wasCheckmate ?? false,
              wasPromotion: blackMove.wasPromotion ?? false,
            ),
        ],
      ),
    );
  }

  /// Build move number indicator
  /// بناء مؤشر رقم الحركة
  Widget _buildMoveNumber(int moveNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
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
    );
  }

  /// Build move button with special move indicators
  /// بناء زر الحركة مع مؤشرات الحركات الخاصة
  Widget _buildMoveButton(
    String move,
    int moveIndex, {
    required bool isWhite,
    required bool wasCapture,
    required bool wasCheck,
    required bool wasCheckmate,
    required bool wasPromotion,
  }) {
    final currentIndex = controller.gameState.currentHalfmoveIndex;
    final isCurrentMove = moveIndex == currentIndex;

    return InkWell(
      onTap: () => _handleMoveClick(moveIndex),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentMove
              ? (isWhite ? Colors.blue[50] : Colors.grey[800])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Move text
            Text(
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

            // Special move indicators
            if (wasCheckmate)
              _buildIcon(Icons.gpp_maybe, Colors.red, isCurrentMove, isWhite)
            else if (wasCheck)
              _buildIcon(Icons.add_alert, Colors.orange, isCurrentMove, isWhite)
            else if (wasCapture)
              _buildIcon(Icons.close, Colors.red[300]!, isCurrentMove, isWhite)
            else if (wasPromotion)
              _buildIcon(
                Icons.arrow_upward,
                Colors.green,
                isCurrentMove,
                isWhite,
              ),
          ],
        ),
      ),
    );
  }

  /// Build icon for special moves
  /// بناء أيقونة للحركات الخاصة
  Widget _buildIcon(
    IconData icon,
    Color color,
    bool isCurrentMove,
    bool isWhite,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(
        icon,
        size: 12,
        color: isCurrentMove
            ? (isWhite ? Colors.blue[700] : Colors.white)
            : color,
      ),
    );
  }

  /// Handle move click for navigation
  /// معالجة النقر على الحركة للتنقل
  void _handleMoveClick(int moveIndex) {
    controller.navigateToMove(moveIndex);
  }
}
