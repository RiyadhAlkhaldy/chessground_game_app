import 'package:chessground_game_app/core/global_feature/data/datasources/game_state_cache_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/models/game_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GameStateCacheDataSourceImpl dataSource;

  setUp(() {
    dataSource = GameStateCacheDataSourceImpl();
  });

  // Helper function to create test game state model
  GameStateModel createTestGameState({
    String gameUuid = 'game-uuid-123',
    String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
  }) {
    return GameStateModel(
      gameUuid: gameUuid,
      currentFen: fen,
      fenHistory: [fen],
      fenCounts: {fen: 1},
      moves: [],
      lastUpdated: DateTime.now(),
    );
  }

  group('GameStateCacheDataSource - cacheGameState', () {
    test('should cache game state successfully', () async {
      // Arrange
      final gameState = createTestGameState();

      // Act
      await dataSource.cacheGameState(gameState);

      // Assert
      final hasState = await dataSource.hasGameState('game-uuid-123');
      expect(hasState, true);
    });

    test('should overwrite existing game state', () async {
      // Arrange
      final gameState1 = createTestGameState(fen: 'initial-fen');
      final gameState2 = createTestGameState(fen: 'updated-fen');

      // Act
      await dataSource.cacheGameState(gameState1);
      await dataSource.cacheGameState(gameState2);

      // Assert
      final retrievedState = await dataSource.getCachedGameState(
        'game-uuid-123',
      );
      expect(retrievedState.currentFen, 'updated-fen');
    });

    test('should cache multiple game states', () async {
      // Arrange
      final gameState1 = createTestGameState(gameUuid: 'game-1');
      final gameState2 = createTestGameState(gameUuid: 'game-2');

      // Act
      await dataSource.cacheGameState(gameState1);
      await dataSource.cacheGameState(gameState2);

      // Assert
      final allStates = await dataSource.getAllActiveStates();
      expect(allStates.length, 2);
      expect(allStates.containsKey('game-1'), true);
      expect(allStates.containsKey('game-2'), true);
    });
  });

  group('GameStateCacheDataSource - getCachedGameState', () {
    test('should retrieve cached game state successfully', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);

      // Act
      final retrievedState = await dataSource.getCachedGameState(
        'game-uuid-123',
      );

      // Assert
      expect(retrievedState, isA<GameStateModel>());
      expect(retrievedState.gameUuid, 'game-uuid-123');
      expect(retrievedState.currentFen, gameState.currentFen);
    });

    test('should throw exception when game state not found', () async {
      // Act & Assert
      expect(
        () => dataSource.getCachedGameState('non-existent-uuid'),
        throwsException,
      );
    });

    test('should throw exception with not found message', () async {
      // Act & Assert
      try {
        await dataSource.getCachedGameState('missing-game');
        fail('Should have thrown exception');
      } catch (e) {
        expect(e.toString(), contains('not found'));
      }
    });
  });

  group('GameStateCacheDataSource - removeCachedGameState', () {
    test('should remove cached game state successfully', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);

      // Act
      await dataSource.removeCachedGameState('game-uuid-123');

      // Assert
      final hasState = await dataSource.hasGameState('game-uuid-123');
      expect(hasState, false);
    });

    test('should not throw error when removing non-existent state', () async {
      // Act & Assert
      expect(
        () => dataSource.removeCachedGameState('non-existent-uuid'),
        returnsNormally,
      );
    });

    test('should only remove specified game state', () async {
      // Arrange
      final gameState1 = createTestGameState(gameUuid: 'game-1');
      final gameState2 = createTestGameState(gameUuid: 'game-2');
      await dataSource.cacheGameState(gameState1);
      await dataSource.cacheGameState(gameState2);

      // Act
      await dataSource.removeCachedGameState('game-1');

      // Assert
      final hasState1 = await dataSource.hasGameState('game-1');
      final hasState2 = await dataSource.hasGameState('game-2');
      expect(hasState1, false);
      expect(hasState2, true);
    });
  });

  group('GameStateCacheDataSource - getAllActiveStates', () {
    test('should return all cached game states', () async {
      // Arrange
      final gameState1 = createTestGameState(gameUuid: 'game-1');
      final gameState2 = createTestGameState(gameUuid: 'game-2');
      final gameState3 = createTestGameState(gameUuid: 'game-3');

      await dataSource.cacheGameState(gameState1);
      await dataSource.cacheGameState(gameState2);
      await dataSource.cacheGameState(gameState3);

      // Act
      final allStates = await dataSource.getAllActiveStates();

      // Assert
      expect(allStates, isA<Map<String, GameStateModel>>());
      expect(allStates.length, 3);
      expect(allStates.keys, containsAll(['game-1', 'game-2', 'game-3']));
    });

    test('should return empty map when no states cached', () async {
      // Act
      final allStates = await dataSource.getAllActiveStates();

      // Assert
      expect(allStates, isEmpty);
    });

    test('should return a copy to prevent external modifications', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);

      // Act
      final allStates = await dataSource.getAllActiveStates();
      allStates.clear(); // Modify the returned map

      // Assert
      final hasState = await dataSource.hasGameState('game-uuid-123');
      expect(hasState, true); // Original cache should be unaffected
    });
  });

  group('GameStateCacheDataSource - clearAllCachedStates', () {
    test('should clear all cached states', () async {
      // Arrange
      final gameState1 = createTestGameState(gameUuid: 'game-1');
      final gameState2 = createTestGameState(gameUuid: 'game-2');
      await dataSource.cacheGameState(gameState1);
      await dataSource.cacheGameState(gameState2);

      // Act
      await dataSource.clearAllCachedStates();

      // Assert
      final allStates = await dataSource.getAllActiveStates();
      expect(allStates, isEmpty);
    });

    test('should handle clearing empty cache', () async {
      // Act & Assert
      expect(() => dataSource.clearAllCachedStates(), returnsNormally);
    });

    test('should allow caching after clearing', () async {
      // Arrange
      final gameState1 = createTestGameState(gameUuid: 'game-1');
      final gameState2 = createTestGameState(gameUuid: 'game-2');

      await dataSource.cacheGameState(gameState1);
      await dataSource.clearAllCachedStates();

      // Act
      await dataSource.cacheGameState(gameState2);

      // Assert
      final allStates = await dataSource.getAllActiveStates();
      expect(allStates.length, 1);
      expect(allStates.containsKey('game-2'), true);
      expect(allStates.containsKey('game-1'), false);
    });
  });

  group('GameStateCacheDataSource - hasGameState', () {
    test('should return true when game state exists', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);

      // Act
      final result = await dataSource.hasGameState('game-uuid-123');

      // Assert
      expect(result, true);
    });

    test('should return false when game state does not exist', () async {
      // Act
      final result = await dataSource.hasGameState('non-existent-uuid');

      // Assert
      expect(result, false);
    });

    test('should return false after removing game state', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);
      await dataSource.removeCachedGameState('game-uuid-123');

      // Act
      final result = await dataSource.hasGameState('game-uuid-123');

      // Assert
      expect(result, false);
    });

    test('should return false after clearing all states', () async {
      // Arrange
      final gameState = createTestGameState();
      await dataSource.cacheGameState(gameState);
      await dataSource.clearAllCachedStates();

      // Act
      final result = await dataSource.hasGameState('game-uuid-123');

      // Assert
      expect(result, false);
    });
  });

  group('GameStateCacheDataSource - Integration Tests', () {
    test('should handle multiple operations in sequence', () async {
      // Cache multiple states
      await dataSource.cacheGameState(createTestGameState(gameUuid: 'game-1'));
      await dataSource.cacheGameState(createTestGameState(gameUuid: 'game-2'));
      await dataSource.cacheGameState(createTestGameState(gameUuid: 'game-3'));

      // Verify all cached
      var allStates = await dataSource.getAllActiveStates();
      expect(allStates.length, 3);

      // Remove one
      await dataSource.removeCachedGameState('game-2');
      allStates = await dataSource.getAllActiveStates();
      expect(allStates.length, 2);

      // Update one
      await dataSource.cacheGameState(
        createTestGameState(gameUuid: 'game-1', fen: 'updated-fen'),
      );

      // Verify update
      final updatedState = await dataSource.getCachedGameState('game-1');
      expect(updatedState.currentFen, 'updated-fen');

      // Clear all
      await dataSource.clearAllCachedStates();
      allStates = await dataSource.getAllActiveStates();
      expect(allStates, isEmpty);
    });
  });
}
