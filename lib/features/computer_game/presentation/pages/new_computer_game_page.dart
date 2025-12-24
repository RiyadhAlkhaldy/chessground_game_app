import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/new_computer_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for setting up a new computer game
class NewComputerGamePage extends GetView<NewComputerGameController> {
  const NewComputerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive layout wrapper
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.setupComputerGame)),
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
                  context.l10n.setupComputerGame,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Choose side
                Text(
                  context.l10n.chooseYourSide,
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

                const SizedBox(height: 24),

                // Difficulty
                Text(
                  context.l10n.puzzleDifficultyLevel, // "Difficulty level"
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

                Obx(
                  () {
                    final level = controller.selectedDifficulty.value;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getDifficultyLabel(context, level),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(context, level),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${context.l10n.level} $level',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: level.toDouble(),
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: level.toString(),
                          onChanged: (value) =>
                              controller.setDifficulty(value.toInt()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.difficultyBeginner,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                context.l10n.difficultyMaster,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                Obx(
                  () => SwitchListTile(
                    title: Text(context.l10n.showMoveHints),
                    value: controller.showMoveHints.value,
                    onChanged: (val) => controller.showMoveHints.value = val,
                    activeColor: Colors.green, // Keep green as positive action or use Theme
                  ),
                ),

                const SizedBox(height: 32),

                // Start button
                Obx(
                  () {
                    if (controller.errorMessage.isNotEmpty) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                           Get.snackbar(
                             context.l10n.errorTitle,
                             context.l10n.failedToLoadPlayer(controller.errorMessage.value),
                             snackPosition: SnackPosition.BOTTOM,
                             backgroundColor: Theme.of(context).colorScheme.error,
                             colorText: Theme.of(context).colorScheme.onError,
                           );
                           controller.errorMessage.value = ''; // Reset after showing
                         });
                    }

                    return FilledButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.startGame(),
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
                    );
                  }
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
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
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

  String _getDifficultyLabel(BuildContext context, int level) {
    if (level <= 5) return context.l10n.difficultyBeginner;
    if (level <= 10) return context.l10n.difficultyIntermediate;
    if (level <= 15) return context.l10n.difficultyAdvanced;
    return context.l10n.difficultyMaster;
  }

  Color _getDifficultyColor(BuildContext context, int level) {
    if (level <= 5) return Colors.green;
    if (level <= 10) return Colors.orange;
    if (level <= 15) return Colors.red;
    return Colors.purple;
  }
}