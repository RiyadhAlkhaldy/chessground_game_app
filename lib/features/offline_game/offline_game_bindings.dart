import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:get/get.dart';

/// Bindings for the offline game feature
/// Dependencies required for OfflineGameController
class OfflineGameBindings extends Bindings {
  @override
  void dependencies() {
    // Register GameController with simplified dependencies
    // Storage operations are handled by GameStorageController via StorageFeatures mixin
    Get.lazyPut<BaseGameController>(
      () => OfflineGameController(plySound: sl<PlaySoundUseCase>()),
      // fenix: true, // Keep alive even when not in use
    );
  }
}
