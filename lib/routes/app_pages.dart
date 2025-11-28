import 'package:chessground_game_app/features/computer_game/game_computer_binding.dart';
import 'package:chessground_game_app/features/computer_game/game_computer_with_time_binding.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/game_computer_page.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/game_computer_with_time_page.dart';
import 'package:chessground_game_app/features/home/presentation/pages/home_page.dart';
import 'package:chessground_game_app/features/offline_game/fee_game_bindings.dart';
import 'package:chessground_game_app/features/offline_game/offline_game_bindings.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/free_game_page.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/offline_game_page.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/pages/recent_page.dart';
import 'package:chessground_game_app/features/settings/presentation/pages/settings_page.dart';
import 'package:chessground_game_app/features/home/presentation/pages/about_page.dart';
import 'package:chessground_game_app/features/home/presentation/pages/game_start_up_screen.dart';
import 'package:chessground_game_app/features/home/presentation/pages/game_time_page.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/side_choosing_page.dart';
import 'package:get/get.dart';

abstract class RouteNames {
  static String home = '/';
  static String sideChoosingPage = '/sideChoosingPage';
  static String gameComputerPage = '/gameComputerPage';
  static String gameComputerWithTimePage = '/gameComputerWithTimePage';
  static String freeGamePage = '/FreeGameScreen';
  static String offlineGamePage = '/offlineGamePage';
  static String editPosition = '/EditPosition';
  static String analysisPage = '/AnalysisScreen';
  static String gameTimePage = '/GameTimeScreen';
  static String settingsPage = '/SettingsScreen';
  static String gameStartUpPage = '/gameStartUpPage';
  static String aboutPage = '/aboutPage';
  static String recentGamesPage = '/recentGamesPage';
  static String puzzles = '/Puzzles';
  static String rankings = '/Rankings';
  static String friends = '/Friends';
}

class AppPages {
  static final routes = [
    GetPage(name: RouteNames.home, page: () => const HomePage()),
    // GetPage(name: '/online', page: () => const OnlineView()),
    GetPage(
      name: RouteNames.gameComputerPage,
      page: () => GameComputerPage(),
      binding: GameComputerBindings(),
    ),
    GetPage(
      name: RouteNames.gameComputerWithTimePage,
      page: () => GameComputerWithTimePage(),
      binding: GameComputerWithTimeBindings(),
    ),
    GetPage(name: RouteNames.sideChoosingPage, page: () => SideChoosingPage()),
    GetPage(name: RouteNames.aboutPage, page: () => const AboutPage()),
    GetPage(name: RouteNames.settingsPage, page: () => const SettingsPage()),
    GetPage(name: RouteNames.gameTimePage, page: () => const GameTimePage()),
    GetPage(
      name: RouteNames.gameStartUpPage,
      page: () => const GameStartUpPage(isCustomTime: false, gameTime: '5'),
    ),
    GetPage(
      name: RouteNames.freeGamePage,
      page: () => FreeGamePage(),
      binding: FreeGameBindings(),
    ),
    GetPage(
      name: RouteNames.recentGamesPage,
      page: () => const RecentGamesPage(),
    ),
    GetPage(
      name: RouteNames.offlineGamePage,
      page: () => const OfflineGamePage(),
      binding: OfflineGameBindings(),
    ),

    // GetPage(name: RouteNames.editPosition, page: () => EditPositionPage(positionController: positionController)),
    // GetPage(name: RouteNames.analysisScreen, page: () => AnalysisScreen()),
    // GetPage(name: '/puzzles', page: () => const PuzzlesView()),
    // GetPage(name: '/rankings', page: () => const RankingsView()),
    // GetPage(name: '/settings', page: () => const SettingsView()),
  ];
}
