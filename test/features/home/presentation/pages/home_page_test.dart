import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:chessground_game_app/features/home/presentation/pages/home_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

// Mock Dependencies
class MockGameStartUpController extends GetxController
    with Mock
    implements GameStartUpController {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockGameStartUpController mockController;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    // Register fallback values if needed
  });

  setUp(() {
    mockController = MockGameStartUpController();
    mockNavigatorObserver = MockNavigatorObserver();
    
    // Register controller
    Get.put<GameStartUpController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest({Locale locale = const Locale('en')}) {
    // Re-register controller for each test widget pump to ensure it's available
    if (!Get.isRegistered<GameStartUpController>()) {
      Get.put<GameStartUpController>(mockController);
    }
    
    return GetMaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const HomePage(),
      navigatorObservers: [mockNavigatorObserver],
      getPages: [
        GetPage(name: AppRoutes.newGameComputerPage, page: () => Container()),
        GetPage(name: AppRoutes.newOfflineGamePage, page: () => Container()),
        GetPage(name: AppRoutes.recentGamesPage, page: () => Container()),
        GetPage(name: AppRoutes.settingsPage, page: () => Container()),
        GetPage(name: AppRoutes.aboutPage, page: () => Container()),
      ],
    );
  }

  testWidgets('HomePage renders correctly in English', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 2)); // Allow animations to finish
      
      // Verify Title (AppBar)
      expect(find.text('Home'), findsOneWidget);

      // Verify Cards
      expect(find.text('Play against computer'), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Recent games'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      
      // Scroll to see 'About'
      await tester.scrollUntilVisible(find.text('About'), 100);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('About'), findsOneWidget);
    });
  });

  testWidgets('HomePage renders correctly in Arabic (RTL)', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetUnderTest(locale: const Locale('ar')));
      await tester.pump(const Duration(seconds: 2)); // Allow animations to finish

      // Verify RTL
      final Directionality directionality = tester.widget(find.byType(Directionality).last);
      expect(directionality.textDirection, TextDirection.rtl);

      // Verify Arabic Texts
      // Now that we regenerated l10n, it should find the Arabic text
      expect(find.text('لعب ضد الحاسوب'), findsOneWidget);
      
      // Ensure English text is not present
      expect(find.text('Play against computer'), findsNothing);
    });
  });

  testWidgets('Navigation to Computer Game calls controller', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play against computer'));
    await tester.pumpAndSettle();

    verify(() => mockController.setVsComputer(value: true)).called(1);
  });

  testWidgets('Responsive Layout Check (Mobile)', (tester) async {
    tester.view.physicalSize = const Size(400 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Check Grid Delegate crossAxisCount
    // This is hard to check directly via finder, but we can verify it renders without overflow
    expect(find.byType(CustomScrollView), findsOneWidget);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Responsive Layout Check (Tablet)', (tester) async {
    tester.view.physicalSize = const Size(800 * 3, 1000 * 3); // Tablet width
    tester.view.devicePixelRatio = 3.0;
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(CustomScrollView), findsOneWidget);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
