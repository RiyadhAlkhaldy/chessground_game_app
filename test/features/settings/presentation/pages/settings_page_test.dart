import 'package:chessground_game_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:chessground_game_app/features/settings/presentation/pages/settings_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsController extends GetxController
    with Mock
    implements SettingsController {}

void main() {
  late MockSettingsController mockController;

  setUp(() {
    mockController = MockSettingsController();
    Get.put<SettingsController>(mockController);
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest(Locale locale) {
    return GetMaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const SettingsPage(),
    );
  }

  testWidgets('SettingsPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsAtLeastNWidgets(1));
  });

  testWidgets('Changing language calls controller', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    // Tap 'العربية' in dropdown
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    verify(() => mockController.changeLocale('ar')).called(1);
  });
}