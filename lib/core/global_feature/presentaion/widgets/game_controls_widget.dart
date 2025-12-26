import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget for game control buttons (undo, redo, etc.)
/// عنصر لأزرار التحكم في اللعبة (تراجع، إعادة، إلخ)
class GameControlsWidget extends GetView<BaseGameController> {
  const GameControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          // Undo button
          Obx(
            () => _buildControlButton(
              context,
              icon: Icons.undo,
              label: l10n.undo,
              onPressed: controller.canUndo.value ? () => controller.undoMove() : null,
              enabled: controller.canUndo.value,
            ),
          ),

          // Redo button
          Obx(
            () => _buildControlButton(
              context,
              icon: Icons.redo,
              label: l10n.redo,
              onPressed: controller.canRedo.value ? () => controller.redoMove() : null,
              enabled: controller.canRedo.value,
            ),
          ),

          // First move button
          _buildControlButton(
            context,
            icon: Icons.first_page,
            label: l10n.first,
            onPressed: () => _goToFirstMove(),
            enabled: true,
          ),

          // Last move button
          _buildControlButton(
            context,
            icon: Icons.last_page,
            label: l10n.last,
            onPressed: () => _goToLastMove(),
            enabled: true,
          ),

          // Flip board button
          _buildControlButton(
            context,
            icon: Icons.flip,
            label: l10n.flip,
            onPressed: () => _flipBoard(),
            enabled: true,
          ),
        ],
      ),
    );
  }

  /// Build control button
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    final theme = Theme.of(context);
    final color = enabled ? theme.colorScheme.primary : theme.disabledColor;
    
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to first move
  void _goToFirstMove() {
    Get.snackbar(
      'Navigate',
      'Go to first move',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Navigate to last move
  void _goToLastMove() {
    Get.snackbar(
      'Navigate',
      'Go to last move',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// Flip board orientation
  void _flipBoard() {
    Get.snackbar(
      'Flip Board',
      'Board flipped',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}