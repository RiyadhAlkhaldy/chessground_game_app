// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:chessground_game_app/mainq.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/main.dart';
import 'package:chessground_game_app/presentation/controllers/get_storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // تأكد أaن تُنشئ الـ Guest مبكراً
  final storage = Get.put(GetStorageControllerImp());
  Locale? locale = await getLocale(storage);

  await ChessGameStorageService.init();
  await createPlayerIfNotExists(storage);
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MyApp(locale:locale));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
