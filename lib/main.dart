import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:l10n_esperanto/l10n_esperanto.dart';

import 'core/utils/helper/helper_methodes.dart';
import 'l10n/l10n.dart';
import 'presentation/screens/home/home_page.dart';
import 'routes/app_pages.dart';
import 'routes/game_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initFirstDependencies();
  // تأكد أن تُنشئ الـ Guest مبكراً
  // final storage = Get.find<GetStorageControllerImp>();

  await createOrGetGustPlayer();

  runApp(MyApp(locale: await getLocale()));
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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    );
  }
}
