import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/new_offline_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for setting up a new offline game
class NewOfflineGamePage extends GetView<NewOfflineGameController> {
  const NewOfflineGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playOfflineGame)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  context.l10n.setupOfflineGame,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Choose side
                Text(
                  context.l10n.choosePlayerSide,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _buildSideCard(
                          context,
                          side: PlayerSide.white,
                          icon: '♔',
                          label: context.l10n.white,
                          isSelected:
                              controller.selectedSide.value == PlayerSide.white,
                          onTap: () => controller.setSide(PlayerSide.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSideCard(
                          context,
                          side: PlayerSide.black,
                          icon: '♚',
                          label: context.l10n.black,
                          isSelected:
                              controller.selectedSide.value == PlayerSide.black,
                          onTap: () => controller.setSide(PlayerSide.black),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Start button
                Obx(
                  () => FilledButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async => await controller.startGame(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            context.l10n.startGame,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideCard(
    BuildContext context, {
    required PlayerSide side,
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
