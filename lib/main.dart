import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'domain/services/game_storage_service.dart';
import 'domain/services/todo_service.dart';
import 'domain/services/user_service.dart';
import 'presentation/screens/home_page.dart';
import 'routes/app_pages.dart';
import 'routes/game_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final userService = UserService();
  // await userService.init();
  await GameStorageService().init();
  // await _setup();
  // TodoService.adds();
  // TodoService.gets();
  runApp(const MyApp());
}

Future<void> _setup() async {
  await TodoService.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialBinding: GameBinding(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    );
  }
}
