import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/game_state_cache_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/models/game_state_model.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_state_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/game_state_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockGameStateCacheDataSource extends Mock
    implements GameStateCacheDataSource {}

class FakeGameStateModel extends Fake implements GameStateModel {}

void main() {
  late MockGameStateCacheDataSource mockCacheDataSource;
  late GameStateRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeGameStateModel());
  });

  setUp(() {
    mockCacheDataSource = MockGameStateCacheDataSource();
    repository = GameStateRepositoryImpl(cacheDataSource: mockCacheDataSource);
  });

  // Helper to create test game state entity
  GameStateEntity createTestGameStateEntity({
    String gameUuid = 'game-uuid-123',
  }) {
    return GameStateEntity(
      gameUuid: gameUuid,
      currentFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      fenHistory: const [
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      ],
      fenCounts: const {
        'rnbqkbnr/ppppppp p/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1': 1,
      },
      moves: const [],
      lastUpdated: DateTime(2024, 1, 1),
    );
  }

  // Helper to create test game state model
  GameStateModel createTestGameStateModel({String gameUuid = 'game-uuid-123'}) {
    return GameStateModel(
      gameUuid: gameUuid,
      currentFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      fenHistory: const [
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      ],
      fenCounts: const {
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1': 1,
      },
      moves: const [],
      lastUpdated: DateTime(2024, 1, 1),
    );
  }

  group('GameStateRepositoryImpl - cacheGameState', () {
    test('should cache game state successfully via data source', () async {
      // Arrange
      final entity = createTestGameStateEntity();
      when(
        () => mockCacheDataSource.cacheGameState(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.cacheGameState(entity);

      // Assert
      expect(result, isA<Right>());
      verify(() => mockCacheDataSource.cacheGameState(any())).called(1);
    });

    test('should return CacheFailure when caching fails', () async {
      // Arrange
      final entity = createTestGameStateEntity();
      when(
        () => mockCacheDataSource.cacheGameState(any()),
      ).thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.cacheGameState(entity);

      // Assert
      expect(result, isA<Left>());
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(
          (failure as CacheFailure).message,
          contains('Failed to cache game state'),
        );
      }, (_) => fail('Should have returned a failure'));
    });
  });

  group('GameStateRepositoryImpl - getCachedGameState', () {
    test('should retrieve cached game state successfully', () async {
      // Arrange
      final model = createTestGameStateModel();
      when(
        () => mockCacheDataSource.getCachedGameState(any()),
      ).thenAnswer((_) async => model);

      // Act
      final result = await repository.getCachedGameState('game-uuid-123');

      // Assert
      expect(result, isA<Right>());
      result.fold((_) => fail('Should have succeeded'), (entity) {
        expect(entity, isA<GameStateEntity>());
        expect(entity.gameUuid, 'game-uuid-123');
      });
      verify(
        () => mockCacheDataSource.getCachedGameState('game-uuid-123'),
      ).called(1);
    });

    test('should return NotFoundFailure when game state not found', () async {
      // Arrange
      when(
        () => mockCacheDataSource.getCachedGameState(any()),
      ).thenThrow(Exception('Game state not found in cache'));

      // Act
      final result = await repository.getCachedGameState('non-existent-uuid');

      // Assert
      expect(result, isA<Left>());
      result.fold((failure) {
        expect(failure, isA<NotFoundFailure>());
        expect(
          (failure as NotFoundFailure).message,
          contains('not found in cache'),
        );
      }, (_) => fail('Should have returned a failure'));
    });

    test('should return CacheFailure for other errors', () async {
      // Arrange
      when(
        () => mockCacheDataSource.getCachedGameState(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getCachedGameState('game-uuid-123');

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });
  });

  group('GameStateRepositoryImpl - removeCachedGameState', () {
    test('should remove cached game state successfully', () async {
      // Arrange
      when(
        () => mockCacheDataSource.removeCachedGameState(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.removeCachedGameState('game-uuid-123');

      // Assert
      expect(result, isA<Right>());
      verify(
        () => mockCacheDataSource.removeCachedGameState('game-uuid-123'),
      ).called(1);
    });

    test('should return CacheFailure when removal fails', () async {
      // Arrange
      when(
        () => mockCacheDataSource.removeCachedGameState(any()),
      ).thenThrow(Exception('Removal error'));

      // Act
      final result = await repository.removeCachedGameState('game-uuid-123');

      // Assert
      expect(result, isA<Left>());
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect((failure as CacheFailure).message, contains('Failed to remove'));
      }, (_) => fail('Should have returned a failure'));
    });
  });

  group('GameStateRepositoryImpl - getAllActiveStates', () {
    test('should retrieve all active game states', () async {
      // Arrange
      final model1 = createTestGameStateModel(gameUuid: 'game-1');
      final model2 = createTestGameStateModel(gameUuid: 'game-2');
      when(
        () => mockCacheDataSource.getAllActiveStates(),
      ).thenAnswer((_) async => {'game-1': model1, 'game-2': model2});

      // Act
      final result = await repository.getAllActiveStates();

      // Assert
      expect(result, isA<Right>());
      result.fold((_) => fail('Should have succeeded'), (statesMap) {
        expect(statesMap, isA<Map<String, GameStateEntity>>());
        expect(statesMap.length, 2);
        expect(statesMap.keys, containsAll(['game-1', 'game-2']));
      });
      verify(() => mockCacheDataSource.getAllActiveStates()).called(1);
    });

    test('should return empty map when no active states', () async {
      // Arrange
      when(
        () => mockCacheDataSource.getAllActiveStates(),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getAllActiveStates();

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should have succeeded'),
        (statesMap) => expect(statesMap, isEmpty),
      );
    });

    test('should return CacheFailure when retrieval fails', () async {
      // Arrange
      when(
        () => mockCacheDataSource.getAllActiveStates(),
      ).thenThrow(Exception('Retrieval error'));

      // Act
      final result = await repository.getAllActiveStates();

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });
  });

  group('GameStateRepositoryImpl - clearAllCachedStates', () {
    test('should clear all cached states successfully', () async {
      // Arrange
      when(
        () => mockCacheDataSource.clearAllCachedStates(),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.clearAllCachedStates();

      // Assert
      expect(result, isA<Right>());
      verify(() => mockCacheDataSource.clearAllCachedStates()).called(1);
    });

    test('should return CacheFailure when clearing fails', () async {
      // Arrange
      when(
        () => mockCacheDataSource.clearAllCachedStates(),
      ).thenThrow(Exception('Clear error'));

      // Act
      final result = await repository.clearAllCachedStates();

      // Assert
      expect(result, isA<Left>());
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect((failure as CacheFailure).message, contains('Failed to clear'));
      }, (_) => fail('Should have returned a failure'));
    });
  });

  group('GameStateRepositoryImpl - hasGameState', () {
    test('should return true when game state exists', () async {
      // Arrange
      when(
        () => mockCacheDataSource.hasGameState(any()),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.hasGameState('game-uuid-123');

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should have succeeded'),
        (exists) => expect(exists, true),
      );
      verify(() => mockCacheDataSource.hasGameState('game-uuid-123')).called(1);
    });

    test('should return false when game state does not exist', () async {
      // Arrange
      when(
        () => mockCacheDataSource.hasGameState(any()),
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.hasGameState('non-existent-uuid');

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Should have succeeded'),
        (exists) => expect(exists, false),
      );
    });

    test('should return CacheFailure when check fails', () async {
      // Arrange
      when(
        () => mockCacheDataSource.hasGameState(any()),
      ).thenThrow(Exception('Check error'));

      // Act
      final result = await repository.hasGameState('game-uuid-123');

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });
  });
}
