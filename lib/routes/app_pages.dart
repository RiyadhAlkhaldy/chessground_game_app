import 'package:get/get.dart';

import '../presentation/screens/game_computer_screen.dart';
import '../presentation/screens/get_options_view.dart';
import '../presentation/screens/home_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => const HomePage()),
    // GetPage(name: '/online', page: () => const OnlineView()),
    GetPage(
      name: '/GameComputerScreen',
      page: () => GameComputerScreen(title: 'play'),
    ),
    GetPage(name: '/GameOptionsView', page: () => GameOptionsView()),
    // GetPage(name: '/friends', page: () => const FriendsView()),
    // GetPage(name: '/puzzles', page: () => const PuzzlesView()),
    // GetPage(name: '/rankings', page: () => const RankingsView()),
    // GetPage(name: '/settings', page: () => const SettingsView()),
  ];
}
