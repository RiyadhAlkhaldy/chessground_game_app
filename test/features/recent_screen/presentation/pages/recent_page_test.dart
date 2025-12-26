import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/controllers/recent_games_controller.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/pages/recent_page.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockRecentGamesController extends GetxController
    with Mock
    implements RecentGamesController {
  @override
  final RxBool isLoading = false.obs;
  @override
  final RxBool isLoadingMore = false.obs;
  @override
  final RxList<ChessGame> recentGames = <ChessGame>[].obs;
  
  @override
  Future<void> refresh() async {}
  
  @override
  Future<void> loadMore() async {}
}

void main() {
  late MockRecentGamesController mockController;

  setUp(() {
    mockController = MockRecentGamesController();
    Get.put<RecentGamesController>(mockController);
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
      home: const RecentGamesPage(),
    );
  }

  testWidgets('RecentGamesPage renders correctly in English', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Recent games'), findsOneWidget);
    expect(find.text('No games yet'), findsOneWidget);
  });

  testWidgets('RecentGamesPage renders correctly in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('أحدث المباريات'), findsOneWidget);
    expect(find.text('لا توجد مباريات بعد'), findsOneWidget);
  });
}