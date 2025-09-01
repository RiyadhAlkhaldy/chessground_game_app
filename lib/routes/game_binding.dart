import 'package:chessground_game_app/presentation/controllers/chess_controller.dart';
import 'package:get/get.dart';

import '../data/engine/eval.dart';
import '../data/engine/search.dart';
import '../data/usecases/get_ai_move.dart';
import '../presentation/controllers/game_computer_controller.dart';
import '../presentation/controllers/games_controller.dart';
import '../presentation/controllers/side_choosing_controller.dart';

/// [GameBinding]
/// يربط الاعتمادات (dependencies) لوحدة اللعبة.
/// Binds the dependencies for the game module.
class GameBinding extends Bindings {
  @override
  void dependencies() {
    // تسجيل GetAIMoveUseCase
    // Register GetAIMoveUseCase
    // Get.lazyPut<GetAIMoveUseCase>(
    //   () => GetAIMoveUseCase(Get.find<AIGameRepositoryImpl>()),
    // );

    // Data Layer: Register concrete implementations of services and repositories
    Get.lazyPut<ChessController>(
      () => ChessController(),
      fenix: true,
    ); // Local storage service

    // // make this controller singleton
    Get.lazyPut<SideChoosingController>(
      () => SideChoosingController(),
      fenix: true,
    );

    Get.lazyPut<Evaluator>(() => Evaluator(), fenix: true);
    Get.lazyPut<SearchEngine>(
      () => SearchEngine(eval: Get.find<Evaluator>()),
      fenix: true,
    );

    // // تسجيل الـ Use Cases
    // Get.lazyPut(
    //   () => GetBoardState(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // );
    // Get.lazyPut(
    //   () => GetLegalMoves(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // );
    // Get.lazyPut(
    //   () => MakeMove(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // );
    // Get.lazyPut(
    //   () => ResetGame(Get.find<GameRepository>()),

    //   fenix: true, // Make this controller singleton
    // );
    // Get.lazyPut(
    //   () => GetGameResult(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // );
    // Get.lazyPut(
    //   () => IsKingInCheck(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // );
    Get.lazyPut<GetAiMove>(
      () => GetAiMove(Get.find<SearchEngine>()),
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
      () => GameComputerController(Get.find<GetAiMove>()),
      fenix: true, // Make this controller singleton
    );
    // // تسجيل المتحكم (GameComputerController)
    Get.lazyPut<GamesController>(
      () => GamesController(),
      fenix: true, // Make this controller singleton
    );
  }
}
