// lib/di/injection_container.dart

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/chess_game_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/game_state_cache_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/player_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/chess_game_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_state_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/player_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/chess_game_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/game_repository.dart';
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
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/init_chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/update_player_rating_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/update_player_usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Service locator instance
/// مثيل محدد موقع الخدمة
final sl = GetIt.instance;

/// Initialize all dependencies
/// تهيئة جميع التبعيات
class InjectionContainer {
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

      AppLogger.info('Dependency injection initialized successfully', tag: 'DI');
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
    final dir = await getApplicationDocumentsDirectory();

    // Open Isar instance
    final isar = await Isar.open(
      [PlayerSchema, ChessGameSchema],
      directory: dir.path,
      name: 'chess_game_db',
    );

    // Register Isar as singleton
    sl.registerLazySingleton<Isar>(() => isar);

    AppLogger.info('Isar database initialized', tag: 'DI');
  }

  /// Initialize data sources
  /// تهيئة مصادر البيانات
  static void _initDataSources() {
    AppLogger.debug('Registering data sources', tag: 'DI');

    // Local data sources
    sl.registerLazySingleton<ChessGameLocalDataSource>(
      () => ChessGameLocalDataSourceImpl(isar: sl<Isar>()),
    );

    sl.registerLazySingleton<PlayerLocalDataSource>(() => PlayerLocalDataSourceImpl(isar: sl()));
    //LocalDataSource
    sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
    // StockfishDataSource
    sl.registerLazySingleton<StockfishDataSource>(() => StockfishDataSource());

    // Cache data source
    sl.registerLazySingleton<GameStateCacheDataSource>(() => GameStateCacheDataSourceImpl());

    AppLogger.debug('Data sources registered', tag: 'DI');
  }

  /// Initialize repositories
  /// تهيئة المستودعات
  static void _initRepositories() {
    AppLogger.debug('Registering repositories', tag: 'DI');

    sl.registerLazySingleton<ChessGameRepository>(
      () => ChessGameRepositoryImpl(localDataSource: sl()),
    );

    sl.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl(localDataSource: sl()));

    sl.registerLazySingleton<GameStateRepository>(
      () => GameStateRepositoryImpl(cacheDataSource: sl()),
    );

    ///
    sl.registerLazySingleton<SoundEffectService>(() => SoundEffectService());
    sl.registerLazySingleton<GameRepository>(
      () => GameRepositoryImpl(local: sl(), stockfish: sl()),
    );
    AppLogger.debug('Repositories registered', tag: 'DI');
  }

  /// Initialize use cases
  /// تهيئة حالات الاستخدام
  static void _initUseCases() {
    AppLogger.debug('Registering use cases', tag: 'DI');

    // Game use cases
    sl.registerLazySingleton(() => SaveGameUseCase(sl()));
    sl.registerLazySingleton(() => UpdateGameUseCase(sl()));
    sl.registerLazySingleton(() => GetGameByUuidUseCase(sl()));
    sl.registerLazySingleton(() => GetAllGamesUseCase(sl()));
    sl.registerLazySingleton(() => GetRecentGamesUseCase(sl()));
    sl.registerLazySingleton(() => DeleteGameUseCase(sl()));

    // Player use cases
    sl.registerLazySingleton(() => SavePlayerUseCase(sl()));
    sl.registerLazySingleton(() => UpdatePlayerUseCase(sl()));
    sl.registerLazySingleton(() => GetPlayerByUuidUseCase(sl()));
    sl.registerLazySingleton(() => UpdatePlayerRatingUseCase(sl()));
    sl.registerLazySingleton(() => GetOrCreateGuestPlayerUseCase(sl()));

    // GameState use cases
    sl.registerLazySingleton(() => CacheGameStateUseCase(sl()));
    sl.registerLazySingleton(() => GetCachedGameStateUseCase(sl()));
    sl.registerLazySingleton(() => RemoveCachedGameStateUseCase(sl()));

    ///
    sl.registerLazySingleton(() => PlaySoundUseCase(sl()));
    sl.registerLazySingleton(() => PlayMove(sl()));
    sl.registerLazySingleton(() => InitChessGame(sl()));

    AppLogger.debug('Use cases registered', tag: 'DI');
  }

  /// Clean up resources
  /// تنظيف الموارد
  static Future<void> dispose() async {
    try {
      AppLogger.info('Disposing dependency injection', tag: 'DI');

      // Close Isar
      if (sl.isRegistered<Isar>()) {
        final isar = sl<Isar>();
        await isar.close();
      }

      // Reset GetIt
      await sl.reset();

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
