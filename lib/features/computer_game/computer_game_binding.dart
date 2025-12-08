import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_controller.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/stockfish_binding.dart';
import 'package:get/get.dart';

/// Binding for ComputerGameController
/// ربط ComputerGameController
class ComputerGameBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure StockfishController is available
    if (!Get.isRegistered<StockfishController>()) {
      StockfishBinding().dependencies();
    }

    Get.lazyPut<BaseGameController>(
      () => ComputerGameController(
        plySound: sl<PlaySoundUseCase>(),
        saveGameUseCase: sl<SaveGameUseCase>(),
        cacheGameStateUseCase: sl<CacheGameStateUseCase>(),
        getOrCreateGuestPlayerUseCase: sl<GetOrCreateGuestPlayerUseCase>(),
        stockfishController: Get.find<StockfishController>(),
        getCachedGameStateUseCase: sl<GetCachedGameStateUseCase>(),
        getGameByUuidUseCase: sl<GetGameByUuidUseCase>(),
        updateGameUseCase: sl<UpdateGameUseCase>(),
        savePlayerUseCase: sl<SavePlayerUseCase>(),
      ),
      // fenix: true,
    );
  }
}
