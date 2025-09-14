// import 'package:chessground_game_app/data/usecases/make_move_stockfish_usecase.dart';
import 'package:get/get.dart';

// import '../data/usecases/get_ai_move_stockfish_usecase.dart';
// import '../data/usecases/get_state_stockfish_usecase.dart';
// import '../data/usecases/set_engine_usecase.dart';
// import '../data/usecases/start_engine_usecase.dart';
// import '../data/usecases/stop_engine_usecase.dart';
// import '../domain/repositories/stockfish_repository.dart';
// import '../domain/repositories/stockfish_repository_impl.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/games_controller.dart';
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
    Get.lazyPut<EngineService>(() => EngineService(), fenix: true);
    // Get.lazyPut<Evaluator>(() => Evaluator(), fenix: true);
    // Get.lazyPut<Evaluation>(() => Evaluation(), fenix: true);
    // Get.lazyPut<SearchEngine>(
    //   () => SearchEngine(eval: Get.find<Evaluation>()),
    //   fenix: true,
    // );

    // يجب هنا استخدام lazyPut أو put حسب الحاجة
    // Get.lazyPut<StockfishLocalDataSource>(() => StockfishLocalDataSourceImpl());
    // Get.lazyPut(() => StockfishController(), fenix: true);
    // Get.lazyPut<StockfishRepository>(
    //   () => StockfishRepositoryImpl(),
    //   fenix: true,
    // );
    // Get.lazyPut(() => GetBestMoveUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(
    //   () => SetEngineUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(
    //   () => StartEngineUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(
    //   () => StopEngineUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(() => StockfishEngineService(), fenix: true);
    // Get.lazyPut<AIRepository>(() => AIRepositoryImpl(), fenix: true);

    // Get.lazyPut(
    //   () => GetBestMoveUseCase(Get.find<AIRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(
    //   () => MakeMoveStockfishUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(
    //   () => GetStateStockfishUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // );
    // Get.lazyPut(() => GetLegalMovesUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => MakeMoveUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => ResetGameUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => GetGameResultUseCase(Get.find<StockfishRepository>()));
    // Get.lazyPut(() => IsKingInCheckUseCase(Get.find<StockfishRepository>()));

    // Get.lazyPut<GetAiMove>(
    //   () => GetAiMove(Get.find()),
    //   fenix: true,
    // ); // تسجيل جديد
    // Get.lazyPut(
    //   () => GetAiMoveStockfishUseCase(Get.find<StockfishRepository>()),
    //   fenix: true,
    // ); // تسجيل جديد

    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GameComputerController>(
      () => GameComputerController(
        Get.find<SideChoosingController>(),
        Get.find<EngineService>(),
        // Get.find<StartEngineUseCase>(),
        // Get.find<GetAiMoveStockfishUseCase>(),
        // Get.find<StopEngineUseCase>(),
        // Get.find<SetEngineUseCase>(),
        // Get.find(),
        // Get.find(),
      ),
      // fenix: true, // Make this controller singleton
    );
    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GamesController>(
      () => GamesController(),
      fenix: true, // Make this controller singleton
    );
  }
}
