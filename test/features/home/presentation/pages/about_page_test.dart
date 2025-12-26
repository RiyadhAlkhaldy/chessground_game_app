import 'package:chessground_game_app/features/home/presentation/pages/about_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
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
      home: const AboutPage(),
    );
  }

  testWidgets('AboutPage renders correctly in English', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.textContaining('professional chess application'), findsOneWidget);
  });

  testWidgets('AboutPage renders correctly in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('عن التطبيق'), findsOneWidget);
    expect(find.textContaining('تطبيق شطرنج احترافي'), findsOneWidget);
  });
}
