import 'package:chessground/chessground.dart' show PlayerSide;
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/new_offline_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/new_offline_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockNewOfflineGameController extends GetxController
    with Mock
    implements NewOfflineGameController {
      @override
      final Rx<PlayerSide> selectedSide = PlayerSide.white.obs;
      @override
      final RxBool isLoading = false.obs;
      @override
      final RxString errorMessage = ''.obs;
}

void main() {
  late MockNewOfflineGameController mockController;

  setUp(() {
    mockController = MockNewOfflineGameController();
    Get.put<NewOfflineGameController>(mockController);
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
      home: const NewOfflineGamePage(),
    );
  }

  testWidgets('NewOfflineGamePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Setup Offline Game'), findsAtLeastNWidgets(1));
    expect(find.text('White'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });

  testWidgets('NewOfflineGamePage renders correctly in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(ThemeMode.light, const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('إعداد لعبة محلية'), findsAtLeastNWidgets(1));
    expect(find.text('بدء اللعبة'), findsOneWidget);
  });
}
