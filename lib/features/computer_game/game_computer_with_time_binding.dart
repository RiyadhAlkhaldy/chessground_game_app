import 'package:chessground_game_app/core/global_feature/domain/services/chess_clock_service.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_with_time_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:get/get.dart';

/// Bindings for the game computer with time feature
/// Dependencies required for GameComputerWithTimeController
class GameComputerWithTimeBindings extends Bindings {
  @override
  void dependencies() {
    // Register GameController with simplified dependencies
    // Storage operations are handled by GameStorageController via StorageFeatures mixin
    Get.lazyPut<BaseGameController>(
      () => GameComputerWithTimeController(
        choosingCtrl: Get.find<SideChoosingController>(),
        dataSource: sl<StockfishDataSource>(),
        plySound: sl<PlaySoundUseCase>(),
        clockCtrl: Get.find<ChessClockService>(),
      ),
      // fenix: true,
    );
  }
}
