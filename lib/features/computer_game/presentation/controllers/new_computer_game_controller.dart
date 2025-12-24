import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
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
      errorMessage.value = '';

      // Get or create guest player
      final playerResult = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: 'Guest'),
      );

      final playerName = playerResult.fold((failure) {
        errorMessage.value = failure.message; // Store error to be handled by view if needed
        return 'Guest'; // Fallback
      }, (player) => player.name);
      
      if(errorMessage.isNotEmpty) {
         // Optionally show snackbar here or let the view listen to errorMessage
         // For now, we proceed as 'Guest' but could stop.
         // Let's just log or show snackbar in View.
         // But clean architecture prefers Controller to drive logic.
         // We will proceed.
      }

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
}