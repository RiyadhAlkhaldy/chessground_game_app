// lib/presentation/pages/new_game_screen.dart

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/widgets.dart';
import 'package:chessground_game_app/core/utils/helper/constants.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for creating a new game
/// شاشة إنشاء لعبة جديدة
class NewGameVsComputerPage extends GetView<BaseGameController> {
  const NewGameVsComputerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final whiteNameController = TextEditingController(text: 'White Player');
    final blackNameController = TextEditingController(text: 'Black Player');
    final eventController = TextEditingController(text: 'Casual Game');
    final siteController = TextEditingController(text: 'Local');

    return Scaffold(
      appBar: AppBar(title: const Text('New Game')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Setup New Game',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),
            GetBuilder<BaseGameController>(
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // radioListTile
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: PlayerColorRadioButton(
                              title: 'Play as ${Side.white.name}',
                              value: Side.white,
                              groupValue: controller.playerColor.value,
                              onChanged: (value) {
                                controller.setPlayerColor(player: Side.white);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            //
                            child: PlayerColorRadioButton(
                              title: 'Play as ${Side.black.name}',
                              value: Side.black,
                              groupValue: controller.playerColor.value,
                              onChanged: (value) {
                                controller.setPlayerColor(player: Side.black);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          GameLevelRadioButton(
                            onChanged: (value) {
                              controller.setGameDifficulty(level: 1);
                            },
                            value: GameDifficulty.easy,
                            groupValue: controller.gameDifficulty,
                            title: GameDifficulty.medium.name,
                          ),
                          GameLevelRadioButton(
                            onChanged: (value) {
                              controller.setGameDifficulty(level: 2);
                            },

                            value: GameDifficulty.medium,
                            groupValue: controller.gameDifficulty,
                            title: GameDifficulty.medium.name,
                          ),
                          GameLevelRadioButton(
                            onChanged: (value) {
                              controller.setGameDifficulty(level: 3);
                            },
                            value: GameDifficulty.hard,
                            groupValue: controller.gameDifficulty,
                            title: GameDifficulty.hard.name,
                          ),
                        ],
                      ),

                      Obx(
                        () => Opacity(
                          opacity: controller.uciLimitStrength.value
                              ? 1.0
                              : 0.5,
                          child: AbsorbPointer(
                            absorbing: !controller.uciLimitStrength.value,
                            child: Column(
                              children: [
                                // UCI_Elo Slider
                                Text(
                                  'UCI Elo: ${controller.uciElo.value}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Slider(
                                  value: controller.uciElo.value.toDouble(),
                                  min: 1320,
                                  max: 3190,
                                  divisions: 300,
                                  label: controller.uciElo.value.toString(),
                                  onChanged: (double value) {
                                    controller.uciElo.value = value.toInt();
                                  },
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.orange.shade200
                                      .withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 16),

            const SizedBox(height: 32),

            // Start game button
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () => _startGame(
                        context,
                        whiteNameController.text,
                        blackNameController.text,
                        eventController.text,
                        siteController.text,
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

  /// Start new game
  /// بدء لعبة جديدة
  Future<void> _startGame(
    BuildContext context,
    String whiteName,
    String blackName,
    String event,
    String site,
  ) async {
    // Validate input
    if (whiteName.trim().isEmpty || blackName.trim().isEmpty) {
      Get.snackbar(
        'Invalid Input',
        'Player names cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await (controller as GameComputerController).startNewGame(
      whitePlayerName: whiteName.trim(),
      blackPlayerName: blackName.trim(),
      event: event.trim().isNotEmpty ? event.trim() : null,
      site: site.trim().isNotEmpty ? site.trim() : null,
    );

    // Navigate to game screen
    if (!controller.isLoading && controller.errorMessage.isEmpty) {
      Get.toNamed(RouteNames.gameComputerPage);
    }
  }
}
