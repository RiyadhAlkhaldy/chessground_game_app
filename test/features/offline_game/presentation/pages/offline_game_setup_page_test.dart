import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_setup_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/offline_game_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineGameSetupController extends GetxController
    with Mock
    implements OfflineGameSetupController {
      @override
      final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
      @override
      final RxBool isLoading = false.obs;
      @override
      final RxString errorMessage = ''.obs;
}

void main() {
  late MockOfflineGameSetupController mockController;

  setUp(() {
    mockController = MockOfflineGameSetupController();
    Get.put<OfflineGameSetupController>(mockController);
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
      home: const OfflineGameSetupPage(),
    );
  }

  testWidgets('OfflineGameSetupPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Setup Offline Game'), findsAtLeastNWidgets(1));
    expect(find.text('White'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });

  testWidgets('OfflineGameSetupPage renders correctly in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('إعداد لعبة محلية'), findsAtLeastNWidgets(1));
    expect(find.text('بدء اللعبة'), findsOneWidget);
  });
}
