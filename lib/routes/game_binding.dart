import 'package:chessground_game_app/domain/repositories/game_repository.dart';
import 'package:chessground_game_app/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/domain/services/service/sound_effect_service.dart';
import 'package:get/get.dart';

import '../data/usecases/play_sound_usecase.dart';
import '../domain/services/stockfish_engine_service.dart';
import '../presentation/controllers/chess_board_settings_controller.dart';
import '../presentation/controllers/freee_game_controller.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/game_computer_with_time_controller.dart';
import '../presentation/controllers/game_controller.dart';
import '../presentation/controllers/get_storage_controller.dart';
import '../presentation/controllers/settings_controller.dart';
import '../presentation/controllers/side_choosing_controller.dart';

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    /// services
    Get.lazyPut(() => SoundEffectService(), fenix: true);
    Get.lazyPut(() => ChessGameStorageService(), fenix: true);
    Get.lazyPut<StockfishEngineService>(
      () => StockfishEngineService(),
      fenix: true,
    );

    /// usecases
    Get.lazyPut(
      () => PlaySoundUseCase(Get.find<SoundEffectService>()),
      fenix: true,
    );

    /// controllers
    Get.lazyPut<GetStorageController>(
      () => GetStorageControllerImp(),
      fenix: true,
    );

    Get.lazyPut<SideChoosingController>(
      () => SideChoosingController(),
      fenix: true,
    );
    // chess board settings controller
    Get.lazyPut(() => ChessBoardSettingsController(), fenix: true);
    // settings controller
    Get.lazyPut(() => SettingsController(), fenix: true);

    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GameComputerController>(
      () => GameComputerController(
        Get.find<SideChoosingController>(),
        Get.find<StockfishEngineService>(),
        Get.find<PlaySoundUseCase>(),
      ),
      fenix: true,
    );
    // تسجيل المتحكم (GameController)
    Get.lazyPut(() => GameController(), fenix: true);
    // // تسجيل المتحكم (GameComputerWithTimeController)
    Get.lazyPut<GameComputerWithTimeController>(
      () => GameComputerWithTimeController(
        Get.find<SideChoosingController>(),
        Get.find<StockfishEngineService>(),
        Get.find<PlaySoundUseCase>(),
      ),
      fenix: true,
    );

    /// تسجيل المتحكم (FreeGameController)
    Get.lazyPut(() => FreeGameController(Get.find()), fenix: true);

    /// repositories
    Get.lazyPut(
      () => GamesRepository(
        isar: ChessGameStorageService.db!,
        storageService: Get.find(),
      ),
      fenix: true,
    );
  }
}
