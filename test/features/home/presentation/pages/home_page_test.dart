import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:chessground_game_app/features/home/presentation/pages/home_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockGameStartUpController extends GetxController
    with Mock
    implements GameStartUpController {}

void main() {
  late MockGameStartUpController mockController;

  setUp(() {
    mockController = MockGameStartUpController();
    Get.put<GameStartUpController>(mockController);
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
      home: const HomePage(),
    );
  }

  testWidgets('HomePage renders correctly in English', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Choose your preferred game mode'), findsOneWidget);
    expect(find.text('Play against computer'), findsOneWidget);
  });

  testWidgets('HomePage renders correctly in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('اختر وضع اللعب المناسب لك'), findsOneWidget);
    expect(find.text('لعب ضد الحاسوب'), findsOneWidget);
  });

  testWidgets('HomePage adapts to Tablet/Desktop size', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    // Verify grid layout
    final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 4); // Should be 4 for desktop (width 1200)
    
    addTearDown(tester.view.resetPhysicalSize);
  });
}