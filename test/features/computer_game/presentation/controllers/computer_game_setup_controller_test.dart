import 'package:chessground/chessground.dart' show PlayerSide;
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_setup_controller.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOrCreateGuestPlayerUseCase extends Mock
    implements GetOrCreateGuestPlayerUseCase {}

class MockChessBoardSettingsController extends Mock
    implements ChessBoardSettingsController {}

class MockPlayerEntity extends Mock implements PlayerEntity {}

class MockFailure extends Mock implements Failure {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ComputerGameSetupController controller;
  late MockGetOrCreateGuestPlayerUseCase mockGetGuestPlayerUseCase;
  late MockChessBoardSettingsController mockBoardSettingsController;
  late MockAppLocalizations mockL10n;

  setUpAll(() {
    registerFallbackValue(GetOrCreateGuestPlayerParams(name: 'Guest'));
  });

  setUp(() {
    mockGetGuestPlayerUseCase = MockGetOrCreateGuestPlayerUseCase();
    mockBoardSettingsController = MockChessBoardSettingsController();
    mockL10n = MockAppLocalizations();

    // Setup L10n mocks
    when(() => mockL10n.guest).thenReturn('Guest');
    when(() => mockL10n.stockfish).thenReturn('Stockfish');
    Get.put<AppLocalizations>(mockL10n);

    // Mock Rx behavior for orientation
    final rxOrientation = Side.white.obs;
    when(() => mockBoardSettingsController.orientation).thenReturn(rxOrientation);

    controller = ComputerGameSetupController(
      getOrCreateGuestPlayerUseCase: mockGetGuestPlayerUseCase,
      boardSettingsController: mockBoardSettingsController,
    );
    
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('ComputerGameSetupController', () {
    test('initial state should be correct', () {
      expect(controller.selectedSide.value, PlayerSide.white);
      expect(controller.selectedDifficulty.value, 10);
      expect(controller.showMoveHints.value, false);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, '');
    });

    test('setSide should update selectedSide', () {
      controller.setSide(PlayerSide.black);
      expect(controller.selectedSide.value, PlayerSide.black);
    });

    test('setDifficulty should update selectedDifficulty', () {
      controller.setDifficulty(5);
      expect(controller.selectedDifficulty.value, 5);
    });

    test('startGame success should navigate to game page', () async {
      // Arrange
      final player = MockPlayerEntity();
      when(() => player.name).thenReturn('Guest Player');
      
      when(() => mockGetGuestPlayerUseCase(any()))
          .thenAnswer((_) async => Right(player));
      
      // Act
      await controller.startGame();

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, '');
      expect(mockBoardSettingsController.orientation.value, Side.white);
    });

    test('startGame failure should set errorMessage', () async {
      // Arrange
      final failure = MockFailure();
      when(() => failure.message).thenReturn('Failed to create guest');
      
      when(() => mockGetGuestPlayerUseCase(any()))
          .thenAnswer((_) async => Left(failure));
      
      // Act
      await controller.startGame();

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, 'Failed to create guest');
    });

    group('Navigation Check', () {
      test('startGame with black side should set black orientation', () async {
        // Arrange
        controller.setSide(PlayerSide.black);
        final player = MockPlayerEntity();
        when(() => player.name).thenReturn('Guest');
        when(() => mockGetGuestPlayerUseCase(any()))
            .thenAnswer((_) async => Right(player));

        // Act
        await controller.startGame();

        // Assert
        expect(mockBoardSettingsController.orientation.value, Side.black);
      });
    });
  });
}
