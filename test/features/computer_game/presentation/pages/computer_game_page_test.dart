import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/board_theme.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/computer_game_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockComputerGameController extends GetxController
    with Mock
    implements ComputerGameController {
  
  final Rx<Side> orientationRx = Side.white.obs;
  @override
  Side get orientation => orientationRx.value;
  
  final Rx<PlayerSide> playerSideRx = PlayerSide.white.obs;
  @override
  PlayerSide get playerSide => playerSideRx.value;
  
  @override
  final RxBool canUndo = true.obs;
  
  @override
  final RxBool showMoveHints = true.obs;
  
  final Rx<Side> currentTurnRx = Side.white.obs;
  @override
  Side get currentTurn => currentTurnRx.value;
  
  final RxInt difficultyRx = 10.obs;
  @override
  int get difficulty => difficultyRx.value;
  
  final RxBool computerThinkingRx = false.obs;
  @override
  bool get computerThinking => computerThinkingRx.value;

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
  final Rx<NormalMove?> promotionMove = Rx<NormalMove?>(null);
  
  @override
  final Rx<NormalMove?> premove = Rx<NormalMove?>(null);
  
  @override
  String get currentFen => gameState.position.fen;
  
  final Rx<ValidMoves> validMovesRx = ValidMoves(const {}).obs;
  @override
  ValidMoves get validMoves => validMovesRx.value;
  @override
  set validMoves(ValidMoves value) => validMovesRx.value = value;
}

class MockStockfishController extends GetxController
    with Mock
    implements StockfishController {
  @override
  final RxBool isInitializedRx = true.obs;
  
  final RxString errorMessageRx = ''.obs;
  @override
  String get errorMessage => errorMessageRx.value;
}

class MockChessBoardSettingsController extends GetxController
    with Mock
    implements ChessBoardSettingsController {
      @override
      final Rx<Side> orientation = Side.white.obs;
      @override
      final Rx<BoardTheme> boardTheme = BoardTheme.wood.obs;
      @override
      final Rx<PieceSet> pieceSet = PieceSet.gioco.obs;
      @override
      final RxBool showBorder = true.obs;
      @override
      final RxBool pieceAnimation = true.obs;
      @override
      final RxBool dragMagnify = true.obs;
      @override
      final Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;
      @override
      final Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;
      @override
      final bool drawMode = false;
      @override
      final Rx<ISet<Shape>> shapes = ISet<Shape>().obs;
}

void main() {
  late MockComputerGameController mockController;
  late MockStockfishController mockStockfish;
  late MockChessBoardSettingsController mockBoardSettings;

  setUp(() {
    mockController = MockComputerGameController();
    mockStockfish = MockStockfishController();
    mockBoardSettings = MockChessBoardSettingsController();
    
    when(() => mockController.stockfishController).thenReturn(mockStockfish);
    when(() => mockController.isStockfishReady).thenReturn(true);
    
    Get.put<ComputerGameController>(mockController);
    Get.put<BaseGameController>(mockController);
    Get.put<StockfishController>(mockStockfish);
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
      home: const ComputerGamePage(),
    );
  }

  testWidgets('ComputerGamePage renders correctly in Portrait', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600, 1200); 
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('vs Stockfish'), findsAtLeastNWidgets(1));
    expect(find.text('Level 10'), findsAtLeastNWidgets(1));
    
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('ComputerGamePage renders correctly in Landscape', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800); 
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle(); 

    expect(find.text('vs Stockfish'), findsAtLeastNWidgets(1));
    expect(find.byType(Row), findsAtLeastNWidgets(1));
    
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Shows computer thinking indicator', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();
    
    mockController.computerThinkingRx.value = true;
    await tester.pump();
    
    expect(find.text('Computer thinking ...'), findsAtLeastNWidgets(1));
  });

  testWidgets('Shows engine error view', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    mockStockfish.errorMessageRx.value = 'Engine failed to start';
    await tester.pump();
    
    expect(find.text('Engine Error'), findsOneWidget);
    expect(find.text('Engine failed to start'), findsOneWidget);
  });
}