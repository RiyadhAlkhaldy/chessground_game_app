import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaySoundUseCase extends Mock implements PlaySoundUseCase {}

class MockSaveGameUseCase extends Mock implements SaveGameUseCase {}

class MockUpdateGameUseCase extends Mock implements UpdateGameUseCase {}

class MockGetGameByUuidUseCase extends Mock implements GetGameByUuidUseCase {}

class MockCacheGameStateUseCase extends Mock implements CacheGameStateUseCase {}

class MockGetCachedGameStateUseCase extends Mock
    implements GetCachedGameStateUseCase {}

class MockSavePlayerUseCase extends Mock implements SavePlayerUseCase {}

class MockGetOrCreateGuestPlayerUseCase extends Mock
    implements GetOrCreateGuestPlayerUseCase {}

class FakeGetOrCreateGuestPlayerParams extends Fake
    implements GetOrCreateGuestPlayerParams {}

class FakeSaveGameParams extends Fake implements SaveGameParams {}

class FakeUpdateGameParams extends Fake implements UpdateGameParams {}

class FakeCacheGameStateParams extends Fake implements CacheGameStateParams {}

class FakeGetGameByUuidParams extends Fake implements GetGameByUuidParams {}

class FakeGetCachedGameStateParams extends Fake implements GetCachedGameStateParams {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  late OfflineGameController offlineGameController;
  late MockPlaySoundUseCase mockPlaySoundUseCase;
  late MockSaveGameUseCase mockSaveGameUseCase;
  late MockUpdateGameUseCase mockUpdateGameUseCase;
  late MockGetGameByUuidUseCase mockGetGameByUuidUseCase;
  late MockCacheGameStateUseCase mockCacheGameStateUseCase;
  late MockGetCachedGameStateUseCase mockGetCachedGameStateUseCase;
  late MockSavePlayerUseCase mockSavePlayerUseCase;
  late MockGetOrCreateGuestPlayerUseCase mockGetOrCreateGuestPlayerUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetOrCreateGuestPlayerParams());
    registerFallbackValue(FakeSaveGameParams());
    registerFallbackValue(FakeUpdateGameParams());
    registerFallbackValue(FakeCacheGameStateParams());
    registerFallbackValue(FakeGetGameByUuidParams());
    registerFallbackValue(FakeGetCachedGameStateParams());
  });

  setUp(() {
    mockPlaySoundUseCase = MockPlaySoundUseCase();
    mockSaveGameUseCase = MockSaveGameUseCase();
    mockUpdateGameUseCase = MockUpdateGameUseCase();
    mockGetGameByUuidUseCase = MockGetGameByUuidUseCase();
    mockCacheGameStateUseCase = MockCacheGameStateUseCase();
    mockGetCachedGameStateUseCase = MockGetCachedGameStateUseCase();
    mockSavePlayerUseCase = MockSavePlayerUseCase();
    mockGetOrCreateGuestPlayerUseCase = MockGetOrCreateGuestPlayerUseCase();

    offlineGameController = OfflineGameController(
      plySound: mockPlaySoundUseCase,
      saveGameUseCase: mockSaveGameUseCase,
      updateGameUseCase: mockUpdateGameUseCase,
      getGameByUuidUseCase: mockGetGameByUuidUseCase,
      cacheGameStateUseCase: mockCacheGameStateUseCase,
      getCachedGameStateUseCase: mockGetCachedGameStateUseCase,
      savePlayerUseCase: mockSavePlayerUseCase,
      getOrCreateGuestPlayerUseCase: mockGetOrCreateGuestPlayerUseCase,
    );
  });
  final tPlayer1 = PlayerEntity(
      uuid: 'white',
      name: 'White Player',
      type: 'human',
      playerRating: 1500,
      createdAt: DateTime.now());
  final tPlayer2 = PlayerEntity(
      uuid: 'black',
      name: 'Black Player',
      type: 'human',
      playerRating: 1500,
      createdAt: DateTime.now());
  final tChessGame =
      ChessGameEntity(uuid: 'game-uuid', whitePlayer: tPlayer1, blackPlayer: tPlayer2);
  group('OfflineGameController', () {
    test('initial values are correct', () {
      expect(offlineGameController.currentGame, isNull);
      expect(offlineGameController.isLoading, isFalse);
      expect(offlineGameController.isGameOver, isFalse);
    });

    testWidgets('startNewGame should create a new game and update the state',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        // Act
        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();

        // Assert
        expect(offlineGameController.currentGame, isNotNull);
        expect(offlineGameController.currentGame!.whitePlayer.name,
            'White Player');
        expect(offlineGameController.currentGame!.blackPlayer.name,
            'Black Player');
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.isGameOver, isFalse);
      });
    });

    testWidgets('applyMove should update the game state and auto-save',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeMoveSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();

        // Act
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        async.flushTimers();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
        verify(() => mockUpdateGameUseCase(any())).called(1);
      });
    });

    testWidgets('undoMove should revert the game state',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeMoveSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        async.flushTimers();

        // Act
        offlineGameController.undoMove();
        async.flushTimers();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 0);
        verify(() => mockUpdateGameUseCase(any())).called(2);
      });
    });

    testWidgets('redoMove should restore the game state',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeMoveSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        async.flushTimers();
        offlineGameController.undoMove();
        async.flushTimers();

        // Act
        offlineGameController.redoMove();
        async.flushTimers();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
        verify(() => mockUpdateGameUseCase(any())).called(3);
      });
    });

    testWidgets('reset should reset the game state',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeMoveSound())
            .thenAnswer((_) async => const Right(null));
        when(() => mockPlaySoundUseCase.executeDongSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        async.flushTimers();

        // Act
        offlineGameController.reset();
        async.flushTimers();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 0);
        expect(offlineGameController.gameState.position.fen, Chess.initial.fen);
      });
    });

    testWidgets('resign should end the game', (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeResignSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();

        // Act
        offlineGameController.resign(Side.white);
        async.flushTimers();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result!.winner, Side.black);
      });
    });

    testWidgets('agreeDrawn should end the game with a draw',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();

        // Act
        offlineGameController.agreeDrawn();
        async.flushTimers();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result, Outcome.draw);
      });
    });

    testWidgets('saveGame should call updateGameUseCase',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();

        // Act
        offlineGameController.saveGame();
        async.flushTimers();

        // Assert
        verify(() => mockUpdateGameUseCase(any())).called(1);
      });
    });

    testWidgets('jumpToHalfmove should jump to the correct move',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetOrCreateGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(tPlayer1));
        when(() => mockSaveGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockUpdateGameUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockPlaySoundUseCase.executeMoveSound())
            .thenAnswer((_) async => const Right(null));

        offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        async.flushTimers();
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        async.flushTimers();
        offlineGameController.applyMove(NormalMove.fromUci('e7e5'));
        async.flushTimers();

        // Act
        offlineGameController.jumpToHalfmove(0);
        async.flushTimers();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
      });
    });

    testWidgets('loadGame should load the game from the database',
        (WidgetTester tester) async {
      fakeAsync((async) {
        tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Container(),
            ),
          ),
        );
        // Arrange
        when(() => mockGetGameByUuidUseCase(any()))
            .thenAnswer((_) async => Right(tChessGame));
        when(() => mockGetCachedGameStateUseCase(any()))
            .thenAnswer((_) async => Left(CacheFailure(message: 'not found')));
        when(() => mockCacheGameStateUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        // Act
        offlineGameController.loadGame('game-uuid');
        async.flushTimers();

        // Assert
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.currentGame, isNotNull);
        expect(offlineGameController.currentGame!.uuid, 'game-uuid');
      });
    });
  });
}
