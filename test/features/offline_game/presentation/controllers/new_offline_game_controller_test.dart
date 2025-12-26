import 'package:chessground/chessground.dart' show PlayerSide;
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/new_offline_game_controller.dart';
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

  late NewOfflineGameController controller;
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

    when(() => mockL10n.guest).thenReturn('Guest');
    Get.put<AppLocalizations>(mockL10n);

    final rxOrientation = Side.white.obs;
    when(() => mockBoardSettingsController.orientation).thenReturn(rxOrientation);

    controller = NewOfflineGameController(
      getOrCreateGuestPlayerUseCase: mockGetGuestPlayerUseCase,
      boardSettingsController: mockBoardSettingsController,
    );
    
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('NewOfflineGameController', () {
    test('initial state should be correct', () {
      expect(controller.selectedSide.value, PlayerSide.white);
      expect(controller.isLoading.value, false);
    });

    test('setSide should update selectedSide', () {
      controller.setSide(PlayerSide.black);
      expect(controller.selectedSide.value, PlayerSide.black);
    });

    test('startGame success should navigate to offline game page', () async {
      final player = MockPlayerEntity();
      when(() => player.name).thenReturn('Guest Player');
      
      when(() => mockGetGuestPlayerUseCase(any()))
          .thenAnswer((_) async => Right(player));
      
      await controller.startGame();

      expect(controller.isLoading.value, false);
      expect(mockBoardSettingsController.orientation.value, Side.white);
    });
  });
}
