// lib/presentation/pages/new_game_screen.dart

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/widgets.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for creating a new game
/// شاشة إنشاء لعبة جديدة
class NewGamePage extends GetView<BaseGameController> {
  const NewGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Game')),
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                              title: 'Play as ${PlayerSide.white.name}',
                              value: PlayerSide.white,
                              groupValue: controller.playerSide,
                              onChanged: (value) {
                                (controller as OfflineGameController)
                                    .setPlayerColor(player: PlayerSide.white);
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
                              title: 'Play as ${PlayerSide.black.name}',
                              value: PlayerSide.black,
                              groupValue: controller.playerSide,
                              onChanged: (value) {
                                (controller as OfflineGameController)
                                    .setPlayerColor(player: PlayerSide.black);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            const SizedBox(height: 32),

            // Start game button
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () => _startGame(context),
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
  Future<void> _startGame(BuildContext context) async {
    try {
      // Get or create guest players using the use case
      final whitePlayerResult = await (controller as OfflineGameController)
          .getOrCreateGuestPlayerUseCase(
            GetOrCreateGuestPlayerParams(name: 'White Player'),
          );

      final blackPlayerResult = await (controller as OfflineGameController)
          .getOrCreateGuestPlayerUseCase(
            GetOrCreateGuestPlayerParams(name: 'Black Player'),
          );

      // Handle potential failures
      final whiteName = whitePlayerResult.fold((failure) {
        Get.snackbar(
          'Error',
          'Failed to load white player: ${failure.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return 'White Player';
      }, (player) => player.name);

      final blackName = blackPlayerResult.fold((failure) {
        Get.snackbar(
          'Error',
          'Failed to load black player: ${failure.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return 'Black Player';
      }, (player) => player.name);

      await (controller as OfflineGameController).startNewGame(
        whitePlayerName: whiteName,
        blackPlayerName: blackName,
        event: 'Casual Game',
        site: 'Local',
      );

      // Navigate to game screen
      if (!controller.isLoading && controller.errorMessage.isEmpty) {
        Get.toNamed(AppRoutes.offlineGamePage);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start game: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
