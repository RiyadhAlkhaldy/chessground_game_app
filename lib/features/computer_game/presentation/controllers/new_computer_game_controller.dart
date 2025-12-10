import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewComputerGameController extends GetxController {
  final GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase;
  final ChessBoardSettingsController boardSettingsController;

  NewComputerGameController({
    required this.getOrCreateGuestPlayerUseCase,
    required this.boardSettingsController,
  });

  final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
  final RxInt selectedDifficulty = 10.obs;
  final RxBool showMoveHints = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void setSide(PlayerSide side) {
    selectedSide.value = side;
  }

  void setDifficulty(int difficulty) {
    selectedDifficulty.value = difficulty;
  }

  Future<void> startGame() async {
    try {
      isLoading.value = true;

      // Get or create guest player
      final playerResult = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: 'Guest'),
      );

      final playerName = playerResult.fold((failure) {
        Get.snackbar(
          'Error',
          'Failed to load player: ${failure.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return 'Guest';
      }, (player) => player.name);

      // Set board orientation based on player side
      if (selectedSide.value == PlayerSide.black) {
        boardSettingsController.orientation.value = Side.black;
      } else {
        boardSettingsController.orientation.value = Side.white;
      }

      // Navigate to game page with arguments
      Get.offNamed(
        AppRoutes.computerGamePage,
        arguments: {
          'playerName': playerName,
          'playerSide': selectedSide.value,
          'difficulty': selectedDifficulty.value,
          'showMoveHints': showMoveHints.value,
        },
      );
    } finally {
      isLoading.value = false;
    }
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
