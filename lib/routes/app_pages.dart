import 'package:chessground_game_app/presentation/screens/game_computer/free_game_screen.dart';
import 'package:get/get.dart';

import '../presentation/screens/about_screen.dart';
import '../presentation/screens/game_computer/game_computer_screen.dart';
import '../presentation/screens/game_computer/game_computer_with_time_screen.dart';
import '../presentation/screens/game_start_up_screen.dart';
import '../presentation/screens/game_time_screen.dart';
import '../presentation/screens/home_page.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/side_choosing/side_choosing_view.dart';

abstract class RouteNames {
  static String home = '/';
  static String sideChoosingView = '/SideChoosingView';
  static String gameComputerScreen = '/GameComputerScreen';
  static String gameComputerWithTimeScreen = '/GameComputerWithTimeScreen';
  static String freeGameScreen = '/FreeGameScreen';
  static String gamesScreen = '/GamesScreen';
  static String editPosition = '/EditPosition';
  static String analysisScreen = '/AnalysisScreen';
  static String gameTimeScreen = '/GameTimeScreen';
  static String settingsScreen = '/SettingsScreen';
  static String gameStartUpScreen = '/GameStartUpScreen';
  static String aboutScreen = '/AboutScreen';
  static String puzzles = '/Puzzles';
  static String rankings = '/Rankings';
  static String friends = '/Friends';
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
      name: RouteNames.gameComputerWithTimeScreen,
      page: () => GameComputerWithTimeScreen(),
    ),
    GetPage(name: RouteNames.sideChoosingView, page: () => SideChoosingView()),
    GetPage(name: RouteNames.aboutScreen, page: () => const AboutScreen()),
    GetPage(name: RouteNames.settingsScreen, page: () => SettingsScreen()),
    GetPage(
      name: RouteNames.gameTimeScreen,
      page: () => const GameTimeScreen(),
    ),
    GetPage(
      name: RouteNames.gameStartUpScreen,
      page: () => GameStartUpScreen(isCustomTime: false, gameTime: '5'),
    ),
    GetPage(name: RouteNames.freeGameScreen, page: () => FreeGameScreen()),
    // GetPage(name: RouteNames.gamesScreen, page: () => const GameScreen()),

    // GetPage(name: RouteNames.editPosition, page: () => EditPositionPage(positionController: positionController)),
    // GetPage(name: RouteNames.analysisScreen, page: () => AnalysisScreen()),
    // GetPage(name: '/puzzles', page: () => const PuzzlesView()),
    // GetPage(name: '/rankings', page: () => const RankingsView()),
    // GetPage(name: '/settings', page: () => const SettingsView()),
  ];
}
