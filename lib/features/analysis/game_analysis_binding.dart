import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/analysis/save_game_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/game_analysis_controller.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/analysis/stockfish_binding.dart';
import 'package:get/get.dart';

/// Binding for GameAnalysisController
/// ربط GameAnalysisController
class GameAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure StockfishController is available
    if (!Get.isRegistered<StockfishController>()) {
      StockfishBinding().dependencies();
    }

    Get.lazyPut<GameAnalysisController>(
      () => GameAnalysisController(
        getGameByUuidUseCase: sl<GetGameByUuidUseCase>(),
        stockfishController: Get.find<StockfishController>(),
        saveGameAnalysisUseCase: sl<SaveGameAnalysisUseCase>(),
      ),
    );
  }
}
