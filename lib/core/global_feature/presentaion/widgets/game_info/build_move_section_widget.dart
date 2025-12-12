import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/move_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Build move list section (collapsible)
/// بناء قسم قائمة الحركات (قابل للطي)
class BuildMoveSectionWidget extends GetView<BaseGameController> {
  const BuildMoveSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Move History',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  final moves = controller.gameState.getMoveTokens;
                  return Text(
                    '${moves.length} moves',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  );
                }),
              ],
            ),
          ),

          // Move list
          const Expanded(child: MoveListWidget()),
        ],
      ),
    );
  }
}
