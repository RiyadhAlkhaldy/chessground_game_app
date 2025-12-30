import 'package:chessground_game_app/core/global_feature/data/repositories/games_respository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/games_repository.dart'; 
import 'package:chessground_game_app/core/global_feature/domain/services/service/sound_effect_service.dart';

import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/get_storage_controller.dart';
import 'package:chessground_game_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    /// data sources
    // Get.lazyPut(() => StockfishDataSource(), fenix: true);

    /// services
    Get.lazyPut(() => SoundEffectService(), fenix: true);

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
    Get.lazyPut(() => GameStartUpController(), fenix: true);

    // chess board settings controller
    Get.lazyPut(() => ChessBoardSettingsController(), fenix: true);
    // settings controller
    Get.lazyPut(() => SettingsController(), fenix: true);

    Get.lazyPut<GamesRepository>(
      () => GamesRepositoryImpl(
        isar: Get.find<Isar>(),
        storageService: Get.find(),
      ),
      fenix: true,
    );
  }
}
