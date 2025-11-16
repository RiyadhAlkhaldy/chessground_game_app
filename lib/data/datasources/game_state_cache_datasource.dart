// lib/data/datasources/cache/game_state_cache_datasource.dart

import '../../../core/utils/logger.dart';
import '../models/game_state_model.dart';

/// Cache data source for game state operations
/// مصدر بيانات الذاكرة المؤقتة لعمليات حالة اللعبة
abstract class GameStateCacheDataSource {
  Future<void> cacheGameState(GameStateModel state);
  Future<GameStateModel> getCachedGameState(String gameUuid);
  Future<void> removeCachedGameState(String gameUuid);
  Future<Map<String, GameStateModel>> getAllActiveStates();
  Future<void> clearAllCachedStates();
  Future<bool> hasGameState(String gameUuid);
}

/// Implementation of GameStateCacheDataSource using in-memory storage
/// تنفيذ مصدر بيانات الذاكرة المؤقتة باستخدام التخزين في الذاكرة
class GameStateCacheDataSourceImpl implements GameStateCacheDataSource {
  /// In-memory cache for active game states
  /// ذاكرة مؤقتة داخلية لحالات الألعاب النشطة
  final Map<String, GameStateModel> _cache = {};

  @override
  Future<void> cacheGameState(GameStateModel state) async {
    try {
      AppLogger.debug(
        'Caching game state: ${state.gameUuid}',
        tag: 'GameStateCacheDataSource',
      );

      _cache[state.gameUuid] = state;

      AppLogger.debug(
        'Game state cached successfully. Total cached: ${_cache.length}',
        tag: 'GameStateCacheDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error caching game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<GameStateModel> getCachedGameState(String gameUuid) async {
    try {
      AppLogger.debug(
        'Retrieving cached game state: $gameUuid',
        tag: 'GameStateCacheDataSource',
      );

      final state = _cache[gameUuid];

      if (state == null) {
        throw Exception('Game state not found in cache: $gameUuid');
      }

      AppLogger.debug(
        'Game state retrieved from cache',
        tag: 'GameStateCacheDataSource',
      );

      return state;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error retrieving cached game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> removeCachedGameState(String gameUuid) async {
    try {
      AppLogger.debug(
        'Removing cached game state: $gameUuid',
        tag: 'GameStateCacheDataSource',
      );

      _cache.remove(gameUuid);

      AppLogger.debug(
        'Game state removed from cache. Remaining: ${_cache.length}',
        tag: 'GameStateCacheDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error removing cached game state',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, GameStateModel>> getAllActiveStates() async {
    try {
      AppLogger.debug(
        'Retrieving all active game states',
        tag: 'GameStateCacheDataSource',
      );

      // Return a copy to prevent external modifications
      final activeStates = Map<String, GameStateModel>.from(_cache);

      AppLogger.debug(
        'Retrieved ${activeStates.length} active game states',
        tag: 'GameStateCacheDataSource',
      );

      return activeStates;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error retrieving all active states',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> clearAllCachedStates() async {
    try {
      AppLogger.debug(
        'Clearing all cached game states',
        tag: 'GameStateCacheDataSource',
      );

      final count = _cache.length;
      _cache.clear();

      AppLogger.debug(
        'Cleared $count cached game states',
        tag: 'GameStateCacheDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error clearing all cached states',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> hasGameState(String gameUuid) async {
    try {
      final exists = _cache.containsKey(gameUuid);

      AppLogger.debug(
        'Checking game state existence: $gameUuid = $exists',
        tag: 'GameStateCacheDataSource',
      );

      return exists;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking game state existence',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateCacheDataSource',
      );
      rethrow;
    }
  }
}
