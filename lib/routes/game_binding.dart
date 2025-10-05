import 'package:chessground_game_app/domain/services/sound_effect_service.dart';
import 'package:get/get.dart';

import '../data/usecases/play_sound_usecase.dart';
import '../domain/repositories/i_engine_repository.dart';
import '../domain/repositories/i_engine_repository_impl.dart';
import '../domain/services/stockfish_engine_service.dart';
import '../presentation/controllers/chess_board_settings_controller.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/game_controller.dart';
import '../presentation/controllers/side_choosing_controller.dart';

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SideChoosingController>(
      () => SideChoosingController(),
      fenix: true,
    );
    Get.lazyPut<StockfishEngineService>(
      () => StockfishEngineService(),
      fenix: true,
    );

    Get.lazyPut(() => ChessBoardSettingsController(), fenix: true);
    // Get.lazyPut(() => ChessClockService(initialTimeMs: 0), fenix: true);

    ///sounds
    Get.lazyPut(() => SoundEffectService(), fenix: true);
    Get.lazyPut(() => PlaySoundUseCase(Get.find()), fenix: true);
    Get.lazyPut<IEngineRepository>(
      () => StockfishRepositoryImpl(),
      fenix: true,
    );
    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GameComputerController>(
      () => GameComputerController(
        Get.find<SideChoosingController>(),
        Get.find<PlaySoundUseCase>(),
      ),
      // fenix: true, // Make this controller singleton
    );

    Get.lazyPut(() => GameController(), fenix: true);
    // // تسجيل المتحكم (GameComputerWithTimeController)
    Get.lazyPut<GameComputerWithTimeController>(
      () => GameComputerWithTimeController(
        Get.find<SideChoosingController>(),
        Get.find<PlaySoundUseCase>(),
      ),
      // fenix: true, // Make this controller singleton
    );
  }
}
