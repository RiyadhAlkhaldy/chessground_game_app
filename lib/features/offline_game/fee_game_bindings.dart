// lib/presentation/bindings/game_binding.dart
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
import 'package:chessground_game_app/features/offline_game/presentation/controllers/freee_game_controller.dart';
import 'package:get/get.dart';

class FreeGameBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseGameController>(
      () => FreeGameController(
        plySound: sl<PlaySoundUseCase>(),
        saveGameUseCase: sl<SaveGameUseCase>(),
        updateGameUseCase: sl<UpdateGameUseCase>(),
        getGameByUuidUseCase: sl<GetGameByUuidUseCase>(),
        cacheGameStateUseCase: sl<CacheGameStateUseCase>(),
        getCachedGameStateUseCase: sl<GetCachedGameStateUseCase>(),
        savePlayerUseCase: sl<SavePlayerUseCase>(),
        getOrCreateGuestPlayerUseCase: sl<GetOrCreateGuestPlayerUseCase>(),
      ),
      fenix: true, // Keep alive even when not in use
    );
  }
}
