import 'package:chessground_game_app/features/computer_game/presentation/controllers/new_computer_game_controller.dart';
import 'package:get/get.dart';

class NewComputerGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewComputerGameController>(
      () => NewComputerGameController(
        getOrCreateGuestPlayerUseCase: Get.find(),
        boardSettingsController: Get.find(),
      ),
    );
  }
}
