import 'package:chessground_game_app/domain/repositories/games_repository.dart';
import 'package:chessground_game_app/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/domain/services/service/sound_effect_service.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../core/utils/logger.dart';
import '../data/datasources/local_datasource.dart';
import '../data/datasources/stockfish_datasource.dart';
import '../data/repositories/game_repository_impl.dart';
import '../data/repositories/games_respository_impl.dart';
import '../domain/repositories/game_repository.dart';
import '../domain/services/chess_clock_service.dart';
import '../domain/services/stockfish_engine_service.dart';
import '../domain/usecases/init_chess_game.dart';
import '../domain/usecases/play_move.dart';
import '../domain/usecases/play_sound_usecase.dart';
import '../features/free_game/presentation/controllers/freee_game_controller.dart';
import '../presentation/controllers/chess_board_settings_controller.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/game_computer_with_time_controller.dart';
import '../presentation/controllers/game_controllerr.dart';
import '../presentation/controllers/get_storage_controller.dart';
import '../presentation/controllers/settings_controller.dart';
import '../presentation/controllers/side_choosing_controller.dart';

Future<void> initFirstDependencies() async {
  await Get.putAsync<Isar>(() async {
    await ChessGameStorageService.init();
    return ChessGameStorageService.db!;
  }, permanent: true);
  Get.put(ChessGameStorageService(), permanent: true);
  Get.lazyPut(() => GetStorageControllerImp(), fenix: true);
  Get.put<AppLoggerr>(AppLoggerr(), permanent: true);
  // Get.put<NetworkInfo>(
  //   NetworkInfoImpl(DataConnectionChecker()),
  //   permanent: true,
  // );
  // Get.put(Dio(), permanent: true);
  // Get.put<ApiConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);
}

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    /// data sources
    Get.lazyPut(() => LocalDataSourceImpl(Get.find<Isar>()), fenix: true);
    Get.lazyPut(() => StockfishDataSource(), fenix: true);

    /// services
    Get.lazyPut(() => SoundEffectService(), fenix: true);
    Get.lazyPut<StockfishEngineService>(
      () => StockfishEngineService(),
      fenix: true,
    );
    Get.lazyPut(() {
      final gameCtrl = Get.find<GameControllerr>();
      return ChessClockService(
        initialTimeMs: (gameCtrl.whitesTime.inMinutes * 60 * 1000).toInt(),
        incrementMs: gameCtrl.incrementalValue * 1000,
        onTimeout: handleTimeout,
      );
    }, fenix: true);

    /// usecases
    Get.lazyPut(
      () => PlaySoundUseCase(Get.find<SoundEffectService>()),
      fenix: true,
    );
    Get.lazyPut(() => PlayMove(Get.find<GameRepository>()), fenix: true);
    Get.lazyPut(() => InitChessGame(Get.find()), fenix: true);

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
    // تسجيل المتحكم (GameControllerr)
    Get.lazyPut(() => GameControllerr(), fenix: true);
    // // تسجيل المتحكم (GameComputerWithTimeController)
    Get.lazyPut<GameComputerWithTimeController>(
      () => GameComputerWithTimeController(
        Get.find<SideChoosingController>(),
        Get.find<StockfishEngineService>(),
        Get.find<PlaySoundUseCase>(),
        Get.find<ChessClockService>(),
      ),
      fenix: true,
    );

    /// تسجيل المتحكم (FreeGameController)
    Get.lazyPut(
      () => FreeGameController(Get.find(), Get.find(), Get.find()),
      fenix: true,
    );

    /// repositories
    Get.lazyPut<GamesRepository>(
      () => GamesRepositoryImpl(
        isar: Get.find<Isar>(),
        storageService: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<GameRepository>(
      () => GameRepositoryImpl(
        local: LocalDataSourceImpl(Get.find<Isar>()),
        stockfish: Get.find<StockfishDataSource>(),
      ),
      fenix: true,
    );
  }
}
