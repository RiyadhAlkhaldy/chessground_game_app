import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/chess_game_local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/models/chess_game_model.dart';
import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockIsar extends Mock implements Isar {}

class MockIsarCollection<T> extends Mock implements IsarCollection<T> {}

class MockQueryBuilder<OBJ, R, S> extends Mock
    implements QueryBuilder<OBJ, R, S> {}

class MockQuery<T> extends Mock implements Query<T> {}

class MockIsarLink<T> extends Mock implements IsarLink<T> {}

void main() {
  late MockIsar mockIsar;
  late ChessGameLocalDataSourceImpl dataSource;
  late MockIsarCollection<ChessGame> mockChessGamesCollection;
  late MockIsarCollection<Player> mockPlayersCollection;

  setUp(() {
    mockIsar = MockIsar();
    mockChessGamesCollection = MockIsarCollection<ChessGame>();
    mockPlayersCollection = MockIsarCollection<Player>();
    dataSource = ChessGameLocalDataSourceImpl(isar: mockIsar);

    // Set up default collection access
    when(() => mockIsar.chessGames).thenReturn(mockChessGamesCollection);
    when(() => mockIsar.players).thenReturn(mockPlayersCollection);
  });

  // Helper function to create test player model
  PlayerModel createTestPlayerModel({
    int? id = 1,
    String uuid = 'player-uuid-123',
    String name = 'Test Player',
    String type = 'human',
  }) {
    return PlayerModel(
      id: id,
      uuid: uuid,
      name: name,
      type: type,
      playerRating: 1500,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  // Helper function to create test chess game model
  ChessGameModel createTestGameModel({
    int? id = 1,
    String uuid = 'game-uuid-123',
    String result = '*',
  }) {
    return ChessGameModel(
      id: id,
      uuid: uuid,
      event: 'Test Event',
      site: 'Test Site',
      date: DateTime(2024, 1, 1),
      round: '1',
      whitePlayer: createTestPlayerModel(
        id: 1,
        uuid: 'white-player-uuid',
        name: 'White Player',
      ),
      blackPlayer: createTestPlayerModel(
        id: 2,
        uuid: 'black-player-uuid',
        name: 'Black Player',
      ),
      result: result,
      termination: GameTermination.ongoing,
      eco: 'C00',
      whiteElo: 1600,
      blackElo: 1550,
      timeControl: '10+0',
      movesCount: 0,
      moves: [],
    );
  }

  group('ChessGameLocalDataSource - saveGame', () {
    test('should save game successfully with players', () async {
      // Arrange
      final gameModel = createTestGameModel();
      final chessGameCollection = gameModel.toCollection();

      when(() => mockIsar.writeTxn(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Function();
        return await callback();
      });

      when(
        () => mockChessGamesCollection.put(any()),
      ).thenAnswer((_) async => 1);
      when(() => mockPlayersCollection.put(any())).thenAnswer((_) async => 1);

      // Act
      final result = await dataSource.saveGame(gameModel);

      // Assert
      expect(result, isA<ChessGameModel>());
      expect(result.uuid, gameModel.uuid);
      verify(() => mockIsar.writeTxn(any())).called(1);
      verify(() => mockChessGamesCollection.put(any())).called(1);
      verify(
        () => mockPlayersCollection.put(any()),
      ).called(2); // white and black players
    });

    test('should throw exception when save fails', () async {
      // Arrange
      final gameModel = createTestGameModel();
      when(
        () => mockIsar.writeTxn(any()),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => dataSource.saveGame(gameModel), throwsException);
    });
  });

  group('ChessGameLocalDataSource - updateGame', () {
    test('should update game successfully', () async {
      // Arrange
      final gameModel = createTestGameModel(id: 1);

      when(() => mockIsar.writeTxn(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Function();
        return await callback();
      });

      when(
        () => mockChessGamesCollection.put(any()),
      ).thenAnswer((_) async => 1);
      when(() => mockPlayersCollection.put(any())).thenAnswer((_) async => 1);

      // Act
      final result = await dataSource.updateGame(gameModel);

      // Assert
      expect(result, isA<ChessGameModel>());
      expect(result.uuid, gameModel.uuid);
      verify(() => mockIsar.writeTxn(any())).called(1);
    });

    test('should throw exception when game has no ID', () async {
      // Arrange
      final gameModel = createTestGameModel(id: null);

      // Act & Assert
      expect(() => dataSource.updateGame(gameModel), throwsException);
    });

    test('should throw exception when update fails', () async {
      // Arrange
      final gameModel = createTestGameModel(id: 1);
      when(
        () => mockIsar.writeTxn(any()),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => dataSource.updateGame(gameModel), throwsException);
    });
  });

  group('ChessGameLocalDataSource - getGameByUuid', () {
    test('should return game when found', () async {
      // Arrange
      final gameModel = createTestGameModel();
      final chessGameCollection = gameModel.toCollection();
      final mockQueryBuilder =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();
      final mockQuery = MockQuery<ChessGame>();

      when(
        () => mockChessGamesCollection.filter(),
      ).thenReturn(mockQueryBuilder);
      when(
        () => mockQueryBuilder.uuidEqualTo(any()),
      ).thenReturn(mockQueryBuilder);
      when(
        () => mockQueryBuilder.findFirst(),
      ).thenAnswer((_) async => chessGameCollection);

      // Mock player links
      when(
        () => chessGameCollection.whitePlayer.load(),
      ).thenAnswer((_) async {});
      when(
        () => chessGameCollection.blackPlayer.load(),
      ).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getGameByUuid('game-uuid-123');

      // Assert
      expect(result, isA<ChessGameModel>());
      expect(result.uuid, 'game-uuid-123');
    });

    test('should throw exception when game not found', () async {
      // Arrange
      final mockQueryBuilder =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();

      when(
        () => mockChessGamesCollection.filter(),
      ).thenReturn(mockQueryBuilder);
      when(
        () => mockQueryBuilder.uuidEqualTo(any()),
      ).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.findFirst()).thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => dataSource.getGameByUuid('non-existent-uuid'),
        throwsException,
      );
    });
  });

  group('ChessGameLocalDataSource - getAllGames', () {
    test('should return all games', () async {
      // Arrange
      final gameModel1 = createTestGameModel(uuid: 'game-1');
      final gameModel2 = createTestGameModel(uuid: 'game-2');
      final collection1 = gameModel1.toCollection();
      final collection2 = gameModel2.toCollection();

      final mockWhere = MockQueryBuilder<ChessGame, ChessGame, QWhere>();

      when(() => mockChessGamesCollection.where()).thenReturn(mockWhere);
      when(
        () => mockWhere.findAll(),
      ).thenAnswer((_) async => [collection1, collection2]);

      // Mock player links
      when(() => collection1.whitePlayer.load()).thenAnswer((_) async {});
      when(() => collection1.blackPlayer.load()).thenAnswer((_) async {});
      when(() => collection2.whitePlayer.load()).thenAnswer((_) async {});
      when(() => collection2.blackPlayer.load()).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getAllGames();

      // Assert
      expect(result, isA<List<ChessGameModel>>());
      expect(result.length, 2);
    });

    test('should return empty list when no games', () async {
      // Arrange
      final mockWhere = MockQueryBuilder<ChessGame, ChessGame, QWhere>();

      when(() => mockChessGamesCollection.where()).thenReturn(mockWhere);
      when(() => mockWhere.findAll()).thenAnswer((_) async => []);

      // Act
      final result = await dataSource.getAllGames();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('ChessGameLocalDataSource - getRecentGames', () {
    test('should return recent games with specified limit', () async {
      // Arrange
      final gameModel = createTestGameModel();
      final collection = gameModel.toCollection();

      final mockWhere = MockQueryBuilder<ChessGame, ChessGame, QWhere>();
      final mockSorted = MockQueryBuilder<ChessGame, ChessGame, QAfterSortBy>();
      final mockLimited = MockQueryBuilder<ChessGame, ChessGame, QAfterLimit>();

      when(() => mockChessGamesCollection.where()).thenReturn(mockWhere);
      when(() => mockWhere.sortByDateDesc()).thenReturn(mockSorted);
      when(() => mockSorted.limit(any())).thenReturn(mockLimited);
      when(() => mockLimited.findAll()).thenAnswer((_) async => [collection]);

      when(() => collection.whitePlayer.load()).thenAnswer((_) async {});
      when(() => collection.blackPlayer.load()).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getRecentGames(limit: 10);

      // Assert
      expect(result, isA<List<ChessGameModel>>());
      expect(result.length, 1);
      verify(() => mockSorted.limit(10)).called(1);
    });
  });

  group('ChessGameLocalDataSource - getOngoingGames', () {
    test('should return only ongoing games', () async {
      // Arrange
      final ongoingGame = createTestGameModel(result: '*');
      final collection = ongoingGame.toCollection();

      final mockFilter =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();

      when(() => mockChessGamesCollection.filter()).thenReturn(mockFilter);
      when(() => mockFilter.resultEqualTo(any())).thenReturn(mockFilter);
      when(() => mockFilter.findAll()).thenAnswer((_) async => [collection]);

      when(() => collection.whitePlayer.load()).thenAnswer((_) async {});
      when(() => collection.blackPlayer.load()).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getOngoingGames();

      // Assert
      expect(result, isA<List<ChessGameModel>>());
      verify(() => mockFilter.resultEqualTo('*')).called(1);
    });
  });

  group('ChessGameLocalDataSource - getCompletedGames', () {
    test('should return only completed games', () async {
      // Arrange
      final completedGame = createTestGameModel(result: '1-0');
      final collection = completedGame.toCollection();

      final mockFilter =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();
      final mockNotFilter =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();

      when(() => mockChessGamesCollection.filter()).thenReturn(mockFilter);
      when(() => mockFilter.not()).thenReturn(mockNotFilter);
      when(() => mockNotFilter.resultEqualTo(any())).thenReturn(mockFilter);
      when(() => mockFilter.findAll()).thenAnswer((_) async => [collection]);

      when(() => collection.whitePlayer.load()).thenAnswer((_) async {});
      when(() => collection.blackPlayer.load()).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getCompletedGames();

      // Assert
      expect(result, isA<List<ChessGameModel>>());
      verify(() => mockNotFilter.resultEqualTo('*')).called(1);
    });
  });

  group('ChessGameLocalDataSource - deleteGame', () {
    test('should delete game successfully when found', () async {
      // Arrange
      final gameModel = createTestGameModel();
      final collection = gameModel.toCollection();
      collection.id = 1;

      final mockFilter =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();

      when(() => mockChessGamesCollection.filter()).thenReturn(mockFilter);
      when(() => mockFilter.uuidEqualTo(any())).thenReturn(mockFilter);
      when(() => mockFilter.findFirst()).thenAnswer((_) async => collection);

      when(() => mockIsar.writeTxn(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Function();
        return await callback();
      });
      when(
        () => mockChessGamesCollection.delete(any()),
      ).thenAnswer((_) async => true);

      // Act
      final result = await dataSource.deleteGame('game-uuid-123');

      // Assert
      expect(result, true);
      verify(() => mockChessGamesCollection.delete(1)).called(1);
    });

    test('should return false when game not found', () async {
      // Arrange
      final mockFilter =
          MockQueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>();

      when(() => mockChessGamesCollection.filter()).thenReturn(mockFilter);
      when(() => mockFilter.uuidEqualTo(any())).thenReturn(mockFilter);
      when(() => mockFilter.findFirst()).thenAnswer((_) async => null);

      // Act
      final result = await dataSource.deleteGame('non-existent-uuid');

      // Assert
      expect(result, false);
    });
  });

  group('ChessGameLocalDataSource - deleteAllGames', () {
    test('should delete all games successfully', () async {
      // Arrange
      when(() => mockIsar.writeTxn(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Function();
        return await callback();
      });
      when(() => mockChessGamesCollection.clear()).thenAnswer((_) async {});

      // Act
      final result = await dataSource.deleteAllGames();

      // Assert
      expect(result, true);
      verify(() => mockChessGamesCollection.clear()).called(1);
    });
  });

  group('ChessGameLocalDataSource - getGamesCount', () {
    test('should return count of games', () async {
      // Arrange
      when(() => mockChessGamesCollection.count()).thenAnswer((_) async => 5);

      // Act
      final result = await dataSource.getGamesCount();

      // Assert
      expect(result, 5);
      verify(() => mockChessGamesCollection.count()).called(1);
    });
  });
}
