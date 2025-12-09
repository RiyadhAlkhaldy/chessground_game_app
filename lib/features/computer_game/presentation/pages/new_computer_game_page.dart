import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/new_computer_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for setting up a new computer game
/// شاشة إعداد لعبة جديدة ضد الكمبيوتر
class NewComputerGamePage extends GetView<NewComputerGameController> {
  const NewComputerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play vs Computer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Setup Computer Game',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Choose side
            const Text(
              'Choose Your PlayerSide',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      label: 'White',
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
                      label: 'Black',
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
            const Text(
              'Computer Difficulty',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Obx(
              () => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.getDifficultyLabel(
                          controller.selectedDifficulty.value,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: controller.getDifficultyColor(
                            controller.selectedDifficulty.value,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Level ${controller.selectedDifficulty.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.selectedDifficulty.value.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: controller.selectedDifficulty.value.toString(),
                    onChanged: (value) =>
                        controller.setDifficulty(value.toInt()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Beginner',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Master',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Start button
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.startGame(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Start Game',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
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
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
