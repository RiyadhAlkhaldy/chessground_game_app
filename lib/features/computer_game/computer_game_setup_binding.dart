import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_setup_controller.dart';
import 'package:get/get.dart';

class ComputerGameSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComputerGameSetupController>(
      () => ComputerGameSetupController(
        getOrCreateGuestPlayerUseCase: Get.find(),
        boardSettingsController: Get.find(),
      ),
    );
  }
}
