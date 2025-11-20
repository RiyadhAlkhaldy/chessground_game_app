// lib/presentation/pages/new_game_screen.dart

import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/offline_game_controller.dart';

/// Screen for creating a new game
/// شاشة إنشاء لعبة جديدة
class NewGameScreen extends GetView<OfflineGameController> {
  const NewGameScreen({super.key});

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

            // White player
            TextField(
              controller: whiteNameController,
              decoration: const InputDecoration(
                labelText: 'White Player Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            // Black player
            TextField(
              controller: blackNameController,
              decoration: const InputDecoration(
                labelText: 'Black Player Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 16),

            // Event
            TextField(
              controller: eventController,
              decoration: const InputDecoration(
                labelText: 'Event (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
            ),

            const SizedBox(height: 16),

            // Site
            TextField(
              controller: siteController,
              decoration: const InputDecoration(
                labelText: 'Site (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

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
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Start Game',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

    await controller.startNewGame(
      whitePlayerName: whiteName.trim(),
      blackPlayerName: blackName.trim(),
      event: event.trim().isNotEmpty ? event.trim() : null,
      site: site.trim().isNotEmpty ? site.trim() : null,
    );

    // Navigate to game screen
    if (!controller.isLoading && controller.errorMessage.isEmpty) {
      Get.toNamed(RouteNames.gamesScreen);
    }
  }
}
