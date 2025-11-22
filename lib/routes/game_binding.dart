import 'package:chessground_game_app/core/global_feature/data/datasources/local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/games_respository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/games_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_clock_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/service/sound_effect_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/stockfish_engine_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/init_chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/get_storage_controller.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_with_time_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/freee_game_controller.dart';
import 'package:chessground_game_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

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
    Get.lazyPut<StockfishEngineService>(() => StockfishEngineService(), fenix: true);
    Get.lazyPut(() {
      final gameCtrl = Get.find<GameStartUpController>();
      return ChessClockService(
        initialTimeMs: (gameCtrl.whitesTime.inMinutes * 60 * 1000).toInt(),
        incrementMs: gameCtrl.incrementalValue * 1000,
        onTimeout: handleTimeout,
      );
    }, fenix: true);

    /// usecases
    Get.lazyPut(() => PlaySoundUseCase(Get.find<SoundEffectService>()), fenix: true);
    Get.lazyPut(() => PlayMove(Get.find<GameRepository>()), fenix: true);
    Get.lazyPut(() => InitChessGame(Get.find()), fenix: true);

    /// controllers
    Get.lazyPut<GetStorageController>(() => GetStorageControllerImp(), fenix: true);

    Get.lazyPut<SideChoosingController>(() => SideChoosingController(), fenix: true);
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
    Get.lazyPut(() => GameStartUpController(), fenix: true);
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
    Get.lazyPut(() => FreeGameController(Get.find(), Get.find(), Get.find()), fenix: true);

    /// repositories
    Get.lazyPut<GamesRepository>(
      () => GamesRepositoryImpl(isar: Get.find<Isar>(), storageService: Get.find()),
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
