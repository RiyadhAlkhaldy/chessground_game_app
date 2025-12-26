import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/board_theme.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/offline_game_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineGameController extends GetxController
    with Mock
    implements OfflineGameController {
  
  final Rx<Side> orientationRx = Side.white.obs;
  @override
  Side get orientation => orientationRx.value;
  
  final Rx<PlayerSide> playerSideRx = PlayerSide.white.obs;
  @override
  PlayerSide get playerSide => playerSideRx.value;
  
  @override
  final RxBool canUndo = true.obs;
  
  @override
  final RxBool canRedo = true.obs;
  
  final Rx<Side> currentTurnRx = Side.white.obs;
  @override
  Side get currentTurn => currentTurnRx.value;

  @override
  final RxList<Role> whiteCapturedList = <Role>[].obs;
  @override
  final RxList<Role> blackCapturedList = <Role>[].obs;

  final Rx<GameState> _gameStateRx = GameState().obs;
  @override
  GameState get gameState => _gameStateRx.value;

  final RxBool _isLoadingRx = false.obs;
  @override
  bool get isLoading => _isLoadingRx.value;
  @override
  set isLoading(bool value) => _isLoadingRx.value = value;
  
  @override
  final RxString errorMessageRx = ''.obs;
  @override
  String get errorMessage => errorMessageRx.value;

  @override
  final Rx<NormalMove?> promotionMove = Rx<NormalMove?>(null);
  @override
  final Rx<NormalMove?> premove = Rx<NormalMove?>(null);

  final RxBool _autoSaveEnabledRx = true.obs;
  @override
  bool get autoSaveEnabled => _autoSaveEnabledRx.value;
  @override
  set autoSaveEnabled(bool value) => _autoSaveEnabledRx.value = value;

  @override
  void onInit() {}
  
  @override
  String get currentFen => gameState.position.fen;
  
  @override
  final Rx<ValidMoves> validMovesRx = ValidMoves(const {}).obs;
  @override
  ValidMoves get validMoves => validMovesRx.value;
  
  @override
  List<Role> getCapturedPieces(Side side) => [];
  
  @override
  String getPgnString() => '';
  
  @override
  final Rx<Outcome?> gameResultRx = Rx<Outcome?>(null);
  @override
  Outcome? get getResult => gameResultRx.value;
  
  @override
  String get gameResult => '';
}

class MockChessBoardSettingsController extends GetxController
    with Mock
    implements ChessBoardSettingsController {}

void main() {
  late MockOfflineGameController mockController;
  late MockChessBoardSettingsController mockBoardSettings;

  setUp(() {
    mockController = MockOfflineGameController();
    mockBoardSettings = MockChessBoardSettingsController();
    
    // Setup ChessBoardSettings mocks
    when(() => mockBoardSettings.orientation).thenReturn(Side.white.obs);
    when(() => mockBoardSettings.showBorder).thenReturn(true.obs);
    when(() => mockBoardSettings.pieceAnimation).thenReturn(true.obs);
    when(() => mockBoardSettings.dragMagnify).thenReturn(true.obs);
    when(() => mockBoardSettings.dragTargetKind).thenReturn(DragTargetKind.circle.obs);
    when(() => mockBoardSettings.pieceShiftMethod).thenReturn(PieceShiftMethod.either.obs);
    when(() => mockBoardSettings.pieceSet).thenReturn(PieceSet.gioco.obs);
    when(() => mockBoardSettings.boardTheme).thenReturn(BoardTheme.wood.obs);
    when(() => mockBoardSettings.shapes).thenReturn(ISet<Shape>().obs);
    when(() => mockBoardSettings.drawMode).thenReturn(false);

    Get.put<OfflineGameController>(mockController);
    Get.put<BaseGameController>(mockController);
    Get.put<ChessBoardSettingsController>(mockBoardSettings);
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest(ThemeMode themeMode, Locale locale) {
    return GetMaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: const OfflineGamePage(),
    );
  }

  testWidgets('OfflineGamePage renders correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 1500);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.byType(ChessBoardWidget), findsOneWidget);
    
    addTearDown(tester.view.resetPhysicalSize);
  });
}
