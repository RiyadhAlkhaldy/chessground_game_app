import 'package:chessground_game_app/presentation/controllers/chess_controller.dart';
import 'package:get/get.dart';

import '../presentation/controllers/get_options_controller.dart';

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
    Get.lazyPut<GameOptionsController>(
      () => GameOptionsController(),
      fenix: true,
    );

    // // تسجيل الـ Repository
    // Get.lazyPut<GameRepository>(() => GameRepositoryImpl());

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
    // Get.lazyPut(
    //   () => GetAiMove(Get.find<GameRepository>()),
    //   fenix: true, // Make this controller singleton
    // ); // تسجيل جديد
    // Get.lazyPut<AudioPlayerService>(
    //   () => AudioPlayerServiceImpl(),
    //   fenix: true, // Make this controller singleton
    // ); // تسجيل جديد
    // Get.lazyPut(
    //   () => PlaySoundUseCase(Get.find<AudioPlayerService>()),
    //   fenix: true, // Make this controller singleton
    // ); // تسجيل جديد

    // // تسجيل المتحكم (Controller)
    // Get.lazyPut<GameController>(
    //   () => GameController(
    //     getBoardState: Get.find<GetBoardState>(),
    //     getLegalMoves: Get.find<GetLegalMoves>(),
    //     makeMove: Get.find<MakeMove>(),
    //     resetGame: Get.find<ResetGame>(),
    //     getGameResult: Get.find<GetGameResult>(),
    //     isKingInCheck: Get.find<IsKingInCheck>(),
    //     // getAiMove: Get.find<GetAiMove>(),
    //     getAIMoveUseCase: Get.find(),
    //     playSoundUseCase: Get.find<PlaySoundUseCase>(),
    //   ),
    //   fenix: true, // Make this controller singleton
    // );
  }
}
