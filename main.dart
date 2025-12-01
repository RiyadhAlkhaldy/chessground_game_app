import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/features/home/presentation/pages/home_page.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:chessground_game_app/routes/game_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:l10n_esperanto/l10n_esperanto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initFirstDependencies();
  // تأكد أن تُنشئ الـ Guest مبكراً
  // final storage = Get.find<GetStorageControllerImp>();

  await createOrGetGustPlayer();
  try {
    AppLogger.info('Starting Chess Game Application', tag: 'Main');

    // Initialize dependency injection
    await InjectionContainer.init();

    AppLogger.info('Application initialized successfully', tag: 'Main');

    // Run the app
    runApp(MyApp(locale: await getLocale()));
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to start application',
      error: e,
      stackTrace: stackTrace,
      tag: 'Main',
    );

    // Show error screen or rethrow
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.locale});

  final Locale locale;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chessground Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        MaterialLocalizationsEo.delegate,
        CupertinoLocalizationsEo.delegate,
      ],
      locale: locale,
      // fallbackLocale: Locale('en', 'en-US'),
      // translations: AppLocalizations.delegate, // GetX Translations
      supportedLocales: AppLocalizations.supportedLocales,
      initialBinding: GameBinding(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    );
  }
}
