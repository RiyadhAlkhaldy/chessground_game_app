import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for setting up a new computer game
/// شاشة إعداد لعبة جديدة ضد الكمبيوتر
class NewComputerGamePage extends GetView<BaseGameController> {
  const NewComputerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: 'Player');
    final selectedSide = Side.white.obs;
    final selectedDifficulty = 10.obs;

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

            // Player name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 24),

            // Choose side
            const Text(
              'Choose Your Side',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildSideCard(
                      context,
                      side: Side.white,
                      icon: '♔',
                      label: 'White',
                      isSelected: selectedSide.value == Side.white,
                      onTap: () => selectedSide.value = Side.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSideCard(
                      context,
                      side: Side.black,
                      icon: '♚',
                      label: 'Black',
                      isSelected: selectedSide.value == Side.black,
                      onTap: () => selectedSide.value = Side.black,
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
                      Text(_getDifficultyLabel(selectedDifficulty.value)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(selectedDifficulty.value),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Level ${selectedDifficulty.value}',
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
                    value: selectedDifficulty.value.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: selectedDifficulty.value.toString(),
                    onChanged: (value) =>
                        selectedDifficulty.value = value.toInt(),
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
                onPressed: controller.isLoading
                    ? null
                    : () => _startGame(
                        context,
                        nameController.text,
                        selectedSide.value,
                        selectedDifficulty.value,
                      ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: controller.isLoading
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
    required Side side,
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

  String _getDifficultyLabel(int level) {
    if (level <= 5) return 'Beginner';
    if (level <= 10) return 'Intermediate';
    if (level <= 15) return 'Advanced';
    return 'Master';
  }

  Color _getDifficultyColor(int level) {
    if (level <= 5) return Colors.green;
    if (level <= 10) return Colors.orange;
    if (level <= 15) return Colors.red;
    return Colors.purple;
  }

  Future<void> _startGame(
    BuildContext context,
    String playerName,
    Side playerSide,
    int difficulty,
  ) async {
    if (playerName.trim().isEmpty) {
      Get.snackbar(
        'Invalid Input',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await (controller as ComputerGameController).startComputerGame(
      playerName: playerName.trim(),
      playerSide: playerSide,
      difficulty: difficulty,
    );

    if (!controller.isLoading && controller.errorMessage.isEmpty) {
      Get.offNamed(AppRoutes.newGameComputerPage);
    }
  }
}
