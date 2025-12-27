import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_setup_controller.dart';
import 'package:get/get.dart';

class OfflineGameSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineGameSetupController>(
      () => OfflineGameSetupController(
        getOrCreateGuestPlayerUseCase: Get.find(),
        boardSettingsController: Get.find(),
      ),
    );
  }
}
