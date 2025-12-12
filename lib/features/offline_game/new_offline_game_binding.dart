import 'package:chessground_game_app/features/offline_game/presentation/controllers/new_offline_game_controller.dart';
import 'package:get/get.dart';

class NewOfflineGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewOfflineGameController>(
      () => NewOfflineGameController(
        getOrCreateGuestPlayerUseCase: Get.find(),
        boardSettingsController: Get.find(),
      ),
    );
  }
}
