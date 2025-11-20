// lib/presentation/widgets/game_controls_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/base_game_controller.dart';

/// Widget for game control buttons (undo, redo, etc.)
/// عنصر لأزرار التحكم في اللعبة (تراجع، إعادة، إلخ)
class GameControlsWidget extends GetView<BaseGameController> {
  const GameControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Undo button
          Obx(
            () => _buildControlButton(
              icon: Icons.undo,
              label: 'Undo',
              onPressed: controller.canUndo.value ? () => controller.undoMove() : null,
              enabled: controller.canUndo.value,
            ),
          ),

          // Redo button
          Obx(
            () => _buildControlButton(
              icon: Icons.redo,
              label: 'Redo',
              onPressed: controller.canRedo.value ? () => controller.redoMove() : null,
              enabled: controller.canRedo.value,
            ),
          ),

          // First move button
          _buildControlButton(
            icon: Icons.first_page,
            label: 'First',
            onPressed: () => _goToFirstMove(),
            enabled: true,
          ),

          // Last move button
          _buildControlButton(
            icon: Icons.last_page,
            label: 'Last',
            onPressed: () => _goToLastMove(),
            enabled: true,
          ),

          // Flip board button
          _buildControlButton(
            icon: Icons.flip,
            label: 'Flip',
            onPressed: () => _flipBoard(),
            enabled: true,
          ),
        ],
      ),
    );
  }

  /// Build control button
  /// بناء زر التحكم
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: enabled ? Colors.blue : Colors.grey,
          iconSize: 24,
          tooltip: label,
        ),
        Text(label, style: TextStyle(fontSize: 10, color: enabled ? Colors.black87 : Colors.grey)),
      ],
    );
  }

  /// Navigate to first move
  /// الانتقال إلى أول حركة
  void _goToFirstMove() {
    // TODO: Implement navigation to first move
    Get.snackbar(
      'Navigate',
      'Go to first move',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Navigate to last move
  /// الانتقال إلى آخر حركة
  void _goToLastMove() {
    // TODO: Implement navigation to last move
    Get.snackbar(
      'Navigate',
      'Go to last move',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Flip board orientation
  /// قلب اتجاه الرقعة
  void _flipBoard() {
    // TODO: Implement board flip
    Get.snackbar(
      'Flip Board',
      'Board flipped',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
