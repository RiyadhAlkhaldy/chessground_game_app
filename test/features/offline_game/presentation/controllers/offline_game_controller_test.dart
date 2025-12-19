import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/board_theme.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/game_storage_controller.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart' hide ISet;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

// === Mock Classes ===
class MockPlaySoundUseCase extends Mock implements PlaySoundUseCase {}

class MockGameStorageController extends Mock implements GameStorageController {}

/// Real implementation of ChessBoardSettingsController for testing
/// We use the real class since it doesn't have external dependencies
class TestChessBoardSettingsController extends GetxController
    implements ChessBoardSettingsController {
  @override
  Rx<Side> orientation = Side.white.obs;

  @override
  Rx<PieceSet> pieceSet = PieceSet.gioco.obs;

  @override
  Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;

  @override
  Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;

  @override
  Rx<BoardTheme> boardTheme = BoardTheme.brown.obs;

  @override
  bool drawMode = true;

  @override
  RxBool pieceAnimation = true.obs;

  @override
  RxBool dragMagnify = true.obs;

  @override
  Rx<ISet<Shape>> shapes = ISet<Shape>().obs;

  @override
  RxBool showBorder = false.obs;

  @override
  void onCompleteShape(Shape shape) {
    if (shapes.value.any((element) => element == shape)) {
      shapes.value = shapes.value.remove(shape);
      return;
    } else {
      shapes.value = shapes.value.add(shape);
    }
  }

  @override
  void showChoicesPicker<T extends Enum>(
    BuildContext context, {
    required List<T> choices,
    required T selectedItem,
    required Widget Function(T choice) labelBuilder,
    required void Function(T choice) onSelectedItemChanged,
  }) {
    // No-op for testing
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late OfflineGameController offlineGameController;
  late MockPlaySoundUseCase mockPlaySoundUseCase;
  late MockGameStorageController mockGameStorageController;
  late TestChessBoardSettingsController testChessBoardSettingsController;

  // Test Data
  final tPlayer1 = PlayerEntity(
    uuid: 'white-uuid',
    name: 'White Player',
    type: 'human',
    playerRating: 1500,
    createdAt: DateTime.now(),
  );
  final tPlayer2 = PlayerEntity(
    uuid: 'black-uuid',
    name: 'Black Player',
    type: 'human',
    playerRating: 1500,
    createdAt: DateTime.now(),
  );
  final tChessGame = ChessGameEntity(
    uuid: 'game-uuid',
    whitePlayer: tPlayer1,
    blackPlayer: tPlayer2,
  );

  setUp(() {
    // Reset GetX before each test
    Get.reset();

    // Create mocks
    mockPlaySoundUseCase = MockPlaySoundUseCase();
    mockGameStorageController = MockGameStorageController();
    testChessBoardSettingsController = TestChessBoardSettingsController();

    // Register dependencies in GetX BEFORE creating the controller
    Get.put<GameStorageController>(mockGameStorageController);
    Get.put<ChessBoardSettingsController>(testChessBoardSettingsController);

    // Default mock setup for PlaySoundUseCase
    when(
      () => mockPlaySoundUseCase.executeMoveSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executeCaptureSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executeCheckSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executeCheckmateSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executePromoteSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executeDongSound(),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => mockPlaySoundUseCase.executeResignSound(),
    ).thenAnswer((_) async => const Right(null));

    // Create controller AFTER dependencies are registered
    offlineGameController = OfflineGameController(
      plySound: mockPlaySoundUseCase,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('OfflineGameController', () {
    group('Initial State', () {
      test('initial values are correct', () {
        expect(offlineGameController.currentGame, isNull);
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.isGameOver, isFalse);
        expect(offlineGameController.currentFen, Chess.initial.fen);
        expect(offlineGameController.currentTurn, Side.white);
      });

      test('gameState is initialized with initial position', () {
        expect(offlineGameController.gameState, isNotNull);
        expect(offlineGameController.gameState.position.fen, Chess.initial.fen);
      });
    });

    group('startNewGame', () {
      testWidgets('should create a new game and update the state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);

        // Act
        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.currentGame, isNotNull);
        expect(
          offlineGameController.currentGame!.whitePlayer.name,
          'White Player',
        );
        expect(
          offlineGameController.currentGame!.blackPlayer.name,
          'Black Player',
        );
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.isGameOver, isFalse);

        verify(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: 'White Player',
            blackPlayerName: 'Black Player',
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).called(1);
      });

      testWidgets('should handle failure when saving game fails', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.currentGame, isNull);
        expect(offlineGameController.errorMessage, isNotEmpty);
        expect(offlineGameController.isLoading, isFalse);
      });
    });

    group('applyMove', () {
      testWidgets('should apply a legal move and update game state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange - Start a game first
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
        expect(offlineGameController.currentTurn, Side.black);
        verify(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).called(1);
      });

      testWidgets('should play move sound after applying move', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockPlaySoundUseCase.executeMoveSound()).called(1);
      });
    });

    group('undoMove', () {
      testWidgets('should undo the last move', (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();

        expect(offlineGameController.gameState.getMoveTokens.length, 1);

        // Act
        await offlineGameController.undoMove();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 0);
        expect(offlineGameController.currentTurn, Side.white);
      });
    });

    group('redoMove', () {
      testWidgets('should redo the undone move', (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();
        await offlineGameController.undoMove();
        await tester.pumpAndSettle();

        expect(offlineGameController.gameState.getMoveTokens.length, 0);

        // Act
        await offlineGameController.redoMove();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
        expect(offlineGameController.currentTurn, Side.black);
      });
    });

    group('reset', () {
      testWidgets('should reset the game to initial position', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();

        // Act
        offlineGameController.reset();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 0);
        expect(offlineGameController.gameState.position.fen, Chess.initial.fen);
        expect(offlineGameController.currentTurn, Side.white);
        verify(() => mockPlaySoundUseCase.executeDongSound()).called(1);
      });
    });

    group('resign', () {
      testWidgets('should end the game when white resigns', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.resign(Side.white);
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result!.winner, Side.black);
        verify(() => mockPlaySoundUseCase.executeResignSound()).called(1);
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('should end the game when black resigns', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.resign(Side.black);
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result!.winner, Side.white);
      });
    });

    group('agreeDrawn', () {
      testWidgets('should end the game with a draw', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.agreeDrawn();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result, Outcome.draw);
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });
    });

    group('saveGame', () {
      testWidgets('should call storage controller saveGame', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.saveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.saveGame();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.saveGame(any(), any()),
        ).called(1);
      });
    });

    group('loadGame', () {
      testWidgets('should load the game from storage', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        final gameState = GameState(initial: Chess.initial);
        when(
          () => mockGameStorageController.loadGame(any()),
        ).thenAnswer((_) async => Right((tChessGame, gameState)));

        // Act
        await offlineGameController.loadGame('game-uuid');
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.currentGame, isNotNull);
        expect(offlineGameController.currentGame!.uuid, 'game-uuid');
        verify(() => mockGameStorageController.loadGame('game-uuid')).called(1);
      });

      testWidgets('should handle load failure', (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.loadGame(any()),
        ).thenAnswer((_) async => const Left('Failed to load game'));

        // Act
        await offlineGameController.loadGame('game-uuid');
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isLoading, isFalse);
        expect(offlineGameController.errorMessage, isNotEmpty);
      });
    });

    group('jumpToHalfmove', () {
      testWidgets('should jump to the specified move index', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();
        offlineGameController.applyMove(NormalMove.fromUci('e7e5'));
        await tester.pumpAndSettle();
        offlineGameController.applyMove(NormalMove.fromUci('g1f3'));
        await tester.pumpAndSettle();

        expect(offlineGameController.gameState.getMoveTokens.length, 3);

        // Act - Jump to first move (index 0)
        offlineGameController.jumpToHalfmove(0);
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.gameState.getMoveTokens.length, 1);
        expect(offlineGameController.gameState.getMoveTokens.first.san, 'e4');
      });
    });

    group('getCapturedPieces', () {
      testWidgets('should return captured pieces for a side', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Italian Game opening with pawn capture
        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();
        offlineGameController.applyMove(NormalMove.fromUci('d7d5'));
        await tester.pumpAndSettle();
        offlineGameController.applyMove(NormalMove.fromUci('e4d5')); // Capture
        await tester.pumpAndSettle();

        // Assert
        final blackCaptured = offlineGameController.getCapturedPieces(
          Side.black,
        );
        expect(blackCaptured, isNotEmpty);
        expect(blackCaptured.contains(Role.pawn), isTrue);
      });
    });

    group('getPgnString', () {
      testWidgets('should return PGN string with moves', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.autoSaveGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        offlineGameController.applyMove(NormalMove.fromUci('e2e4'));
        await tester.pumpAndSettle();
        offlineGameController.applyMove(NormalMove.fromUci('e7e5'));
        await tester.pumpAndSettle();

        // Act
        final pgn = offlineGameController.getPgnString();

        // Assert
        expect(pgn, contains('White Player'));
        expect(pgn, contains('Black Player'));
        expect(pgn, contains('e4'));
        expect(pgn, contains('e5'));
      });
    });

    group('End Game Interface Methods', () {
      testWidgets('agreeDraw should end game as draw', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.agreeDraw();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result, Outcome.draw);
      });

      testWidgets('checkMate should update game and show result', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.checkMate();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('draw should end game as draw', (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.draw();
        await tester.pumpAndSettle();

        // Assert
        expect(offlineGameController.isGameOver, isTrue);
        expect(offlineGameController.gameState.result, Outcome.draw);
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('fiftyMoveRule should update game', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.fiftyMoveRule();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('insufficientMaterial should update game', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.insufficientMaterial();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('staleMate should update game', (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.staleMate();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });

      testWidgets('threefoldRepetition should update game', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(home: Scaffold(body: Container())),
        );

        // Arrange
        when(
          () => mockGameStorageController.startAndSaveNewGame(
            whitePlayerName: any(named: 'whitePlayerName'),
            blackPlayerName: any(named: 'blackPlayerName'),
            gameState: any(named: 'gameState'),
            event: any(named: 'event'),
            site: any(named: 'site'),
            timeControl: any(named: 'timeControl'),
          ),
        ).thenAnswer((_) async => tChessGame);
        when(
          () => mockGameStorageController.updateGame(any(), any()),
        ).thenAnswer((_) async => tChessGame);

        await offlineGameController.startNewGame(
          whitePlayerName: 'White Player',
          blackPlayerName: 'Black Player',
        );
        await tester.pumpAndSettle();

        // Act
        await offlineGameController.threefoldRepetition();
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockGameStorageController.updateGame(any(), any()),
        ).called(1);
      });
    });
  });
}
