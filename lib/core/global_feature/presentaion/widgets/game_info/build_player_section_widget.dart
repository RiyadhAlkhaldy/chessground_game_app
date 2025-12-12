import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/captured_pieces_widget.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:get/get.dart';

/// Build player section with info and captured pieces
/// بناء قسم اللاعب مع المعلومات والقطع المأسورة
class BuildPlayerSectionWidget extends GetView<BaseGameController> {
  const BuildPlayerSectionWidget({
    super.key,
    required this.side,
    required this.isTop,
  });

  final Side side;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isTop ? Colors.grey[200] : Colors.grey[100],
        border: Border(
          bottom: isTop
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
          top: !isTop ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            backgroundColor: side == Side.white ? Colors.white : Colors.black,
            child: Text(
              side == Side.white ? 'W' : 'B',
              style: TextStyle(
                color: side == Side.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Player name and turn indicator
          Expanded(
            child: Obx(() {
              final game = controller.currentGame;
              final player = side == Side.white
                  ? game?.whitePlayer
                  : game?.blackPlayer;

              final isCurrentTurn = controller.currentTurn == side;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        player?.name ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCurrentTurn
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isCurrentTurn) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Turn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Rating: ${player?.playerRating ?? 1200}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            }),
          ),

          // Captured pieces preview
          Obx(() {
            final capturedPieces = controller.gameState.getCapturedPieces(side);
            if (capturedPieces.isEmpty) {
              return const SizedBox(width: 100);
            }

            return SizedBox(
              width: 100,
              child: CapturedPiecesWidget(side: side, compact: true),
            );
          }),
        ],
      ),
    );
  }
}
