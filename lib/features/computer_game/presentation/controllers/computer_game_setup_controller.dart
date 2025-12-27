import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class ComputerGameSetupController extends GetxController {
  final GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase;
  final ChessBoardSettingsController boardSettingsController;

  ComputerGameSetupController({
    required this.getOrCreateGuestPlayerUseCase,
    required this.boardSettingsController,
  });

  final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
  final RxInt selectedDifficulty = 10.obs;
  final RxBool showMoveHints = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Reactive Error Handling
    ever(errorMessage, (String msg) {
      if (msg.isNotEmpty) {
        Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
        errorMessage.value = '';
      }
    });
  }

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

      // Get localization safely
      final guestName = Get.context != null ? Get.context!.l10n.guest : 'Guest';
      final stockfishName =
          Get.context != null ? Get.context!.l10n.stockfish : 'Stockfish';

      // Get or create guest player
      final playerResult = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: guestName),
      );

      final playerName = playerResult.fold((failure) {
        errorMessage.value = failure.message;
        return guestName;
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
          'stockfishName': stockfishName,
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
