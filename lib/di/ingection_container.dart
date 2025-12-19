// lib/di/injection_container.dart

import 'dart:io';

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/chess_game_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/game_state_cache_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/player_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/chess_game_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_state_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/player_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/chess_game_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_state_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/player_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/service/sound_effect_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/delete_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/remove_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_all_games_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_player_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_recent_games_usecase.dart';
import 'package:chessground_game_app/features/analysis/data/datasources/game_analysis_datasource.dart';
import 'package:chessground_game_app/features/analysis/data/datasources/game_analysis_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/features/analysis/data/repositories/game_analysis_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/stockfish_repository_impl.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/game_analysis_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/stockfish_repository.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/delete_game_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/get_all_analyses_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/get_game_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/save_game_analysis_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/analyze_position_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/get_best_move_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/get_best_move_with_time_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/get_best_move_with_time_and_depth_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/get_hint_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/set_engine_level_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/stockfish/stream_analysis_usecase.dart';
import 'package:chessground_game_app/features/online_game/domain/usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/update_player_rating_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/update_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/game_storage_controller.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Service locator shim
T sl<T extends Object>() => Get.find<T>();

/// Initialize all dependencies
/// InectionContainer
class InjectionContainer {
  static bool get isInTestMode =>
      Platform.environment.containsKey('FLUTTER_TEST');

  /// Setup all dependencies
  /// إعداد جميع التبعيات
  static Future<void> init() async {
    try {
      AppLogger.info('Initializing dependency injection', tag: 'DI');

      // ========== External Dependencies ==========
      await _initExternalDependencies();

      // ========== Data Sources ==========
      _initDataSources();

      // ========== Repositories ==========
      _initRepositories();

      // ========== Use Cases ==========
      _initUseCases();

      // ========== Controllers (will be initialized via GetX) ==========
      // Controllers are registered on-demand by GetX

      AppLogger.info(
        'Dependency injection initialized successfully',
        tag: 'DI',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize dependency injection',
        error: e,
        stackTrace: stackTrace,
        tag: 'DI',
      );
      rethrow;
    }
  }

  /// Initialize external dependencies (Database, etc.)
  /// تهيئة التبعيات الخارجية (قاعدة البيانات، إلخ)
  static Future<void> _initExternalDependencies() async {
    AppLogger.info('Initializing Isar database', tag: 'DI');

    // Get application directory
    Directory? dir;
    if (!isInTestMode) {
      dir = await getApplicationDocumentsDirectory();
    }
    if (isInTestMode) {
      await Isar.initializeIsarCore(download: true);
    }
    // Open Isar instance
    final isar = await Isar.open(
      [ChessGameSchema, PlayerSchema],
      directory: dir != null ? dir.path : '',
      name: 'chess_game_db',
    );

    // Register Isar as singleton
    Get.put<Isar>(isar, permanent: true);

    AppLogger.info('Isar database initialized', tag: 'DI');
  }

  /// Initialize data sources
  /// تهيئة مصادر البيانات
  static void _initDataSources() {
    AppLogger.debug('Registering data sources', tag: 'DI');

    // Local data sources
    Get.lazyPut<ChessGameLocalDataSource>(
      () => ChessGameLocalDataSourceImpl(isar: sl<Isar>()),
      fenix: true,
    );

    Get.lazyPut<PlayerLocalDataSource>(
      () => PlayerLocalDataSourceImpl(isar: sl()),
      fenix: true,
    );
    // StockfishDataSource
    Get.lazyPut<StockfishDataSource>(
      () => StockfishDataSourceImpl(),
      fenix: true,
    );

    // Cache data source
    Get.lazyPut<GameStateCacheDataSource>(
      () => GameStateCacheDataSourceImpl(),
      fenix: true,
    );

    // Game Analysis data source
    Get.lazyPut<GameAnalysisDataSource>(
      () => GameAnalysisDataSourceImpl(isar: sl()),
      fenix: true,
    );
    Get.lazyPut<GameAnalysisLocalDataSource>(
      () => GameAnalysisLocalDataSourceImpl(isar: sl()),
      fenix: true,
    );

    AppLogger.debug('Data sources registered', tag: 'DI');
  }

  /// Initialize repositories
  /// تهيئة المستودعات
  static void _initRepositories() {
    AppLogger.debug('Registering repositories', tag: 'DI');

    Get.lazyPut<ChessGameRepository>(
      () => ChessGameRepositoryImpl(
        localDataSource: sl<ChessGameLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PlayerRepository>(
      () => PlayerRepositoryImpl(localDataSource: sl()),
      fenix: true,
    );

    Get.lazyPut<GameStateRepository>(
      () => GameStateRepositoryImpl(cacheDataSource: sl()),
      fenix: true,
    );

    ///
    Get.lazyPut<SoundEffectService>(() => SoundEffectService(), fenix: true);
    // Stockfish repository
    Get.lazyPut<StockfishRepository>(
      () => StockfishRepositoryImpl(dataSource: sl()),
      fenix: true,
    );

    // Game Analysis repository
    Get.lazyPut<GameAnalysisRepository>(
      () => GameAnalysisRepositoryImpl(localDataSource: sl()),
      fenix: true,
    );

    AppLogger.debug('Repositories registered', tag: 'DI');
  }

  /// Initialize use cases
  /// تهيئة حالات الاستخدام
  static void _initUseCases() {
    AppLogger.debug('Registering use cases', tag: 'DI');

    // Game use cases
    Get.lazyPut(() => SaveGameUseCase(sl()), fenix: true);
    Get.lazyPut(() => UpdateGameUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetGameByUuidUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetAllGamesUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetRecentGamesUseCase(sl()), fenix: true);
    Get.lazyPut(() => DeleteGameUseCase(sl()), fenix: true);

    // Player use cases
    Get.lazyPut(() => SavePlayerUseCase(sl()), fenix: true);
    Get.lazyPut(() => UpdatePlayerUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetPlayerByUuidUseCase(sl()), fenix: true);
    Get.lazyPut(() => UpdatePlayerRatingUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetOrCreateGuestPlayerUseCase(sl()), fenix: true);

    // GameState use cases
    Get.lazyPut(() => CacheGameStateUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetCachedGameStateUseCase(sl()), fenix: true);
    Get.lazyPut(() => RemoveCachedGameStateUseCase(sl()), fenix: true);

    ///
    Get.lazyPut(() => PlaySoundUseCase(sl()), fenix: true);
    Get.lazyPut(() => PlayMove(sl()), fenix: true);
    // Stockfish use cases
    Get.lazyPut(() => AnalyzePositionUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetBestMoveUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetBestMoveWithTimeUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetBestMoveWithTimeAndDepthUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetHintUseCase(sl()), fenix: true);
    Get.lazyPut(() => StreamAnalysisUseCase(sl()), fenix: true);
    Get.lazyPut(() => SetEngineLevelUseCase(sl()), fenix: true);

    // Game Analysis use cases
    Get.lazyPut(() => SaveGameAnalysisUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetGameAnalysisUseCase(sl()), fenix: true);
    Get.lazyPut(() => DeleteGameAnalysisUseCase(sl()), fenix: true);
    Get.lazyPut(() => GetAllAnalysesUseCase(sl()), fenix: true);

    // ========== Controllers ==========
    // GameStorageController - centralized storage operations
    Get.lazyPut<GameStorageController>(
      () => GameStorageController(
        saveGameUseCase: sl(),
        updateGameUseCase: sl(),
        getGameByUuidUseCase: sl(),
        savePlayerUseCase: sl(),
        getOrCreateGuestPlayerUseCase: sl(),
        cacheGameStateUseCase: sl(),
        getCachedGameStateUseCase: sl(),
      ),
      fenix: true,
    );

    AppLogger.debug('Use cases registered', tag: 'DI');
  }

  /// Clean up resources
  /// تنظيف الموارد
  static Future<void> dispose() async {
    try {
      AppLogger.info('Disposing dependency injection', tag: 'DI');

      // Close Isar
      if (Get.isRegistered<Isar>()) {
        final isar = Get.find<Isar>();
        await isar.close();
      }

      // Reset Get
      await Get.deleteAll();

      AppLogger.info('Dependency injection disposed', tag: 'DI');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error disposing dependency injection',
        error: e,
        stackTrace: stackTrace,
        tag: 'DI',
      );
    }
  }
}
