import 'package:get/get.dart';

import '../data/engine/evaluation.dart';
import '../data/engine/search.dart';
import '../data/usecases/get_ai_move.dart';
import '../data/usecases/get_ai_move_stockfish_usecase.dart';
import '../data/usecases/set_engine_usecase.dart';
import '../data/usecases/start_engine_usecase.dart';
import '../data/usecases/stop_engine_usecase.dart';
import '../domain/repositories/stockfish_repository.dart';
import '../domain/repositories/stockfish_repository_impl.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/games_controller.dart';
import '../presentation/controllers/side_choosing_controller.dart';

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    // // make this controller singleton
    Get.lazyPut<SideChoosingController>(
      () => SideChoosingController(),
      fenix: true,
    );

    // Get.lazyPut<Evaluator>(() => Evaluator(), fenix: true);
    // Get.lazyPut<Evaluation>(() => Evaluation(), fenix: true);
    Get.lazyPut<SearchEngine>(
      () => SearchEngine(eval: Get.find<Evaluation>()),
      fenix: true,
    );

    // يجب هنا استخدام lazyPut أو put حسب الحاجة
    // Get.lazyPut<StockfishLocalDataSource>(() => StockfishLocalDataSourceImpl());
    // Get.lazyPut(() => StockfishController(), fenix: true);
    Get.lazyPut<StockfishRepository>(
      () => StockfishRepositoryImpl(),
      fenix: true,
    );
    // Get.lazyPut(() => GetBestMoveUseCase(Get.find<StockfishRepository>()));
    Get.lazyPut(
      () => SetEngineUseCase(Get.find<StockfishRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => StartEngineUseCase(Get.find<StockfishRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => StopEngineUseCase(Get.find<StockfishRepository>()),
      fenix: true,
    );
    // Get.lazyPut(() => GetLegalMovesUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => MakeMoveUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => ResetGameUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => GetGameResultUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => IsKingInCheckUseCase(Get.find<StockfishRepository>()));

    Get.lazyPut<GetAiMove>(
      () => GetAiMove(Get.find()),
      fenix: true,
    ); // تسجيل جديد
    Get.lazyPut(
      () => GetAiMoveStockfishUseCase(Get.find<StockfishRepository>()),
      fenix: true,
    ); // تسجيل جديد
    // Get.lazyPut<AudioPlayerService>(
    //   () => AudioPlayerServiceImpl(),
    //   fenix: true, // Make this controller singleton
    // ); // تسجيل جديد
    // Get.lazyPut(
    //   () => PlaySoundUseCase(Get.find<AudioPlayerService>()),
    //   fenix: true, // Make this controller singleton
    // ); // تسجيل جديد

    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GameComputerController>(
      () => GameComputerController(
        Get.find<SideChoosingController>(),
        Get.find<StartEngineUseCase>(),
        Get.find<GetAiMoveStockfishUseCase>(),
        Get.find<StopEngineUseCase>(),
        Get.find<SetEngineUseCase>(),
      ),
      fenix: true, // Make this controller singleton
    );
    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GamesController>(
      () => GamesController(),
      fenix: true, // Make this controller singleton
    );
  }
}
