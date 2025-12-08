import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewComputerGameController extends GetxController {
  final nameController = TextEditingController(text: 'Player');

  final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;

  final RxInt selectedDifficulty = 10.obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void setSide(PlayerSide side) {
    selectedSide.value = side;
  }

  void setDifficulty(int difficulty) {
    selectedDifficulty.value = difficulty;
  }

  Future<void> startGame() async {
    final playerName = nameController.text.trim();

    if (playerName.isEmpty) {
      Get.snackbar(
        'Invalid Input',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to game page with arguments
    Get.offNamed(
      AppRoutes.computerGamePage,
      arguments: {
        'playerName': playerName,
        'playerSide': selectedSide.value,
        'difficulty': selectedDifficulty.value,
      },
    );
  }

  // Helpers for UI
  String getDifficultyLabel(int level) {
    if (level <= 5) return 'Beginner';
    if (level <= 10) return 'Intermediate';
    if (level <= 15) return 'Advanced';
    return 'Master';
  }

  Color getDifficultyColor(int level) {
    if (level <= 5) return Colors.green;
    if (level <= 10) return Colors.orange;
    if (level <= 15) return Colors.red;
    return Colors.purple;
  }
}
