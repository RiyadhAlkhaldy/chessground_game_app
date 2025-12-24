import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/new_computer_game_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/new_computer_game_page.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chessground_game_app/l10n/l10n.dart';

// Mock dependencies
class MockNewComputerGameController extends GetxController
    with Mock
    implements NewComputerGameController {
  @override
  final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
  @override
  final RxInt selectedDifficulty = 1.obs;
  @override
  final RxBool showMoveHints = false.obs;
  @override
  final RxBool isLoading = false.obs;
  @override
  final RxString errorMessage = ''.obs;
}

void main() {
  late MockNewComputerGameController mockController;

  setUpAll(() {
    registerFallbackValue(PlayerSide.white);
  });

  setUp(() {
    mockController = MockNewComputerGameController();
    Get.put<NewComputerGameController>(mockController);
    when(() => mockController.setSide(any())).thenReturn(null);
    when(() => mockController.setDifficulty(any())).thenReturn(null);
    when(() => mockController.startGame()).thenAnswer((_) async {});
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest({Locale locale = const Locale('en')}) {
    return GetMaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const NewComputerGamePage(),
    );
  }

  testWidgets('NewComputerGamePage renders correctly in English', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Title (Expect 2 occurrences: AppBar and Body)
    expect(find.text('Setup Computer Game'), findsNWidgets(2));

    // Verify Sides
    expect(find.text('White'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);

    // Verify Difficulty
    expect(find.text('Difficulty level'), findsOneWidget);
    expect(find.text('Level 1'), findsOneWidget);

    // Verify Hints
    expect(find.byType(Switch), findsOneWidget);

    // Verify Start Button
    expect(find.text('Start Game'), findsOneWidget);
  });

  testWidgets('NewComputerGamePage renders correctly in Arabic (RTL)', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    // In Arabic mode, we expect RTL layout
    final Directionality directionality = tester.widget(find.byType(Directionality).last);
    expect(directionality.textDirection, TextDirection.rtl);
    
    // Check for Arabic title (AppBar and Body)
    expect(find.text('إعداد لعبة الكمبيوتر'), findsNWidgets(2));
  });

  testWidgets('Selecting side updates controller', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap Black
    await tester.tap(find.text('Black'));
    verify(() => mockController.setSide(PlayerSide.black)).called(1);
  });

  testWidgets('Changing difficulty slider updates controller', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find Slider
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    // Drag slider
    await tester.drag(slider, const Offset(50, 0));
    verify(() => mockController.setDifficulty(any())).called(greaterThan(0));
  });

  testWidgets('Start Game button calls startGame', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final startButtonFinder = find.text('Start Game');
    
    // Ensure button is visible before tapping
    await tester.ensureVisible(startButtonFinder);
    await tester.pumpAndSettle();

    await tester.tap(startButtonFinder);
    verify(() => mockController.startGame()).called(1);
  });
  
  testWidgets('Responsive Layout Check', (tester) async {
    // Mobile
    tester.view.physicalSize = const Size(400 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsOneWidget); // Should be scrollable on mobile

    // Reset
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
