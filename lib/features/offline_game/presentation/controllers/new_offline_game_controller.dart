import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class NewOfflineGameController extends GetxController {
  final GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase;
  final ChessBoardSettingsController boardSettingsController;

  NewOfflineGameController({
    required this.getOrCreateGuestPlayerUseCase,
    required this.boardSettingsController,
  });

  final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
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

  Future<void> startGame() async {
    try {
      isLoading.value = true;
      final l10n = Get.context!.l10n;

      // Get or create guest player
      final playerResult = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: l10n.guest),
      );

      final playerName = playerResult.fold((failure) {
        errorMessage.value = failure.message;
        return l10n.guest;
      }, (player) => player.name);

      // Set board orientation based on player side
      if (selectedSide.value == PlayerSide.black) {
        boardSettingsController.orientation.value = Side.black;
      } else {
        boardSettingsController.orientation.value = Side.white;
      }

      // Navigate to game page with arguments
      Get.offNamed(
        AppRoutes.offlineGamePage,
        arguments: {'playerName': playerName, 'playerSide': selectedSide.value},
      );
    } finally {
      isLoading.value = false;
    }
  }
}
