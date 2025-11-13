// lib/presentation/bindings/game_binding.dart

import 'package:chessground_game_app/domain/usecases/init_chess_game.dart';
import 'package:chessground_game_app/domain/usecases/play_sound_usecase.dart';
import 'package:get/get.dart';

import '../../di/ingection_container.dart';
import '../../domain/usecases/game_state/cache_game_state_usecase.dart';
import '../../domain/usecases/game_state/get_cached_game_state_usecase.dart';
import '../../domain/usecases/get_game_by_uuid_usecase.dart';
import '../../domain/usecases/get_or_create_gust_player_usecase.dart';
import '../../domain/usecases/play_move.dart';
import '../../domain/usecases/save_game_usecase.dart';
import '../../domain/usecases/save_player_usecase.dart';
import '../../domain/usecases/update_game_usecase.dart';
import '../controllers/game_controller.dart';

/// Binding for GameController dependencies
/// ربط تبعيات GameController
class GameRouteBinding extends Bindings {
  @override
  void dependencies() {
    // Register GameController with all its dependencies
    Get.lazyPut<GameController>(
      () => GameController(
        playMoveUsecase: sl<PlayMove>(),
        initChessGame: sl<InitChessGame>(),
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
