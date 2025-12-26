import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/game_storage_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chessground/chessground.dart' as chessground;

// Mocks
class MockPlaySoundUseCase extends Mock implements PlaySoundUseCase {}
class MockGameStorageController extends Mock implements GameStorageController {}
class MockChessBoardSettingsController extends Mock implements ChessBoardSettingsController {
  @override
  final Rx<Side> orientation = Side.white.obs;
}
class MockChessGameEntity extends Mock implements ChessGameEntity {}

void main() {
  late OfflineGameController controller;
  late MockPlaySoundUseCase mockPlaySoundUseCase;
  late MockGameStorageController mockGameStorageController;
  late MockChessBoardSettingsController mockChessBoardSettingsController;

  setUp(() {
    Get.reset();
    mockPlaySoundUseCase = MockPlaySoundUseCase();
    mockGameStorageController = MockGameStorageController();
    mockChessBoardSettingsController = MockChessBoardSettingsController();

    // Stub all necessary method calls
    when(() => mockPlaySoundUseCase.executeMoveSound()).thenAnswer((_) async {});
    when(() => mockPlaySoundUseCase.executeResignSound()).thenAnswer((_) async {});
    
    // Stub the storage controller methods to return a mock entity
    final mockGame = ChessGameEntity(
        uuid: 'test-uuid',
        whitePlayer: PlayerEntity(uuid: 'p1', name: 'Player 1'),
        blackPlayer: PlayerEntity(uuid: 'p2', name: 'Player 2'),
        event: 'Offline Game',
        site: 'Local',
        date: DateTime.now(),
        round: '1',
        result: '*',
        termination: 'ongoing',
        moves: [],
        movesCount: 0);

    when(() => mockGameStorageController.startAndSaveNewGame(
      whitePlayerName: any(named: 'whitePlayerName'),
      blackPlayerName: any(named: 'blackPlayerName'),
      gameState: any(named: 'gameState'),
      event: any(named: 'event'),
      site: any(named: 'site'),
      timeControl: any(named: 'timeControl'),
    )).thenAnswer((_) async => mockGame);

    when(() => mockGameStorageController.updateGame(any(), any())).thenAnswer((_) async => mockGame);
     when(() => mockGameStorageController.autoSaveGame(any(), any())).thenAnswer((_) async => mockGame);

    // Inject all dependencies before creating the controller
    Get.put<GameStorageController>(mockGameStorageController);
    Get.put<ChessBoardSettingsController>(mockChessBoardSettingsController);
    
    controller = OfflineGameController(plySound: mockPlaySoundUseCase);
  });

  tearDown(() {
    Get.reset();
  });

  group('OfflineGameController', () {
    test('startOfflineGame should initialize the game correctly', () async {
      // Manually call the start game method
      await controller.startOfflineGame(
        playerName: 'Player 1',
        playerSide: chessground.PlayerSide.white,
      );

      // Assertions are checked after the async setup call.
      expect(controller.isLoading, isFalse);
      expect(controller.currentGame, isNotNull);
      expect(controller.currentGame!.whitePlayer.name, 'Player 1');
      expect(controller.currentGame!.blackPlayer.name, 'Player 2');
      expect(controller.currentGame!.event, 'Offline Game');
    });

    test('onUserMove should switch turns correctly', () async {
      await controller.startOfflineGame(playerName: 'P1', playerSide: chessground.PlayerSide.white);
      final move = NormalMove.fromUci('e2e4')!;
      
      expect(controller.currentTurn, Side.white);
      controller.onUserMove(move);
      expect(controller.currentTurn, Side.black);
    });

    test('agreeDrawn should end the game with a draw result', () async {
      await controller.startOfflineGame(playerName: 'P1', playerSide: chessground.PlayerSide.white);
      await controller.agreeDrawn();

      expect(controller.isGameOver, isTrue);
      expect(controller.gameState.result, Outcome.draw);
      verify(() => mockGameStorageController.updateGame(any(), any())).called(1);
    });

    test('undoMove on initial position should set an error state', () async {
      await controller.startOfflineGame(playerName: 'P1', playerSide: chessground.PlayerSide.white);
      await controller.undoMove();
      expect(controller.errorMessage, 'noMovesToUndo');
    });

    test('resign should end the game and declare a winner', () async {
      await controller.startOfflineGame(playerName: 'P1', playerSide: chessground.PlayerSide.white);
      await controller.resign(Side.white);
      
      expect(controller.isGameOver, isTrue);
      expect(controller.gameState.result?.winner, equals(Side.black));
      verify(() => mockPlaySoundUseCase.executeResignSound()).called(1);
      verify(() => mockGameStorageController.updateGame(any(), any())).called(1);
    });
  });
}