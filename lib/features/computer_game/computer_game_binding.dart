import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/stockfish_binding.dart';
import 'package:chessground_game_app/di/ingection_container.dart'; 
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_controller.dart';
import 'package:get/get.dart';

/// Bindings for the computer game feature (using StockfishController)
/// Dependencies required for ComputerGameController
class ComputerGameBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure StockfishController is available
    if (!Get.isRegistered<StockfishController>()) {
      StockfishBinding().dependencies();
    }

    // Register GameController with simplified dependencies
    // Storage operations are handled by GameStorageController via StorageFeatures mixin
    Get.lazyPut<BaseGameController>(
      () => ComputerGameController(
        plySound: sl<PlaySoundUseCase>(),
        stockfishController: Get.find<StockfishController>(),
      ),
      // fenix: true,
    );
  }
}
