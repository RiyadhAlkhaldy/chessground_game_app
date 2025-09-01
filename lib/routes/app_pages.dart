import 'package:get/get.dart';

import '../presentation/screens/game_computer_screen.dart';
import '../presentation/screens/games_screen.dart';
import '../presentation/screens/home_page.dart';
import '../presentation/screens/side_choosing_view.dart';

abstract class RouteNames {
  static String home = '/';
  static String sideChoosingView = '/SideChoosingView';
  static String gameComputerScreen = '/GameComputerScreen';
  static String gamesScreen = '/GamesScreen';
}

class AppPages {
  static final routes = [
    GetPage(name: RouteNames.home, page: () => const HomePage()),
    // GetPage(name: '/online', page: () => const OnlineView()),
    GetPage(
      name: RouteNames.gameComputerScreen,
      page: () => GameComputerScreen(),
    ),
    GetPage(
      name: RouteNames.gamesScreen,
      page: () => GamesScreen(title: 'games'),
    ),
    GetPage(name: RouteNames.sideChoosingView, page: () => SideChoosingView()),
    // GetPage(name: '/friends', page: () => const FriendsView()),
    // GetPage(name: '/puzzles', page: () => const PuzzlesView()),
    // GetPage(name: '/rankings', page: () => const RankingsView()),
    // GetPage(name: '/settings', page: () => const SettingsView()),
  ];
}
