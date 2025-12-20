import 'package:chessground_game_app/features/computer_game/computer_game_binding.dart';
import 'package:chessground_game_app/features/analysis/game_analysis_binding.dart';
import 'package:chessground_game_app/features/analysis/presentation/pages/game_analysis_screen.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/computer_game_page.dart';
import 'package:chessground_game_app/features/computer_game/presentation/pages/new_computer_game_page.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/stockfish_binding.dart';
import 'package:chessground_game_app/features/home/presentation/pages/home_page.dart';
import 'package:chessground_game_app/features/computer_game/new_computer_game_binding.dart';
import 'package:chessground_game_app/features/offline_game/new_offline_game_binding.dart';
import 'package:chessground_game_app/features/offline_game/offline_game_bindings.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/new_offline_game_page.dart';
import 'package:chessground_game_app/features/offline_game/presentation/pages/offline_game_page.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/pages/recent_page.dart';
import 'package:chessground_game_app/features/settings/presentation/pages/settings_page.dart';
import 'package:chessground_game_app/features/home/presentation/pages/about_page.dart';
import 'package:get/get.dart';

abstract class AppRoutes {
  AppRoutes._();

  static String home = '/';
  static String offlineGamePage = '/offlineGamePage';
  static String newOfflineGamePage = '/newOfflineGamePage';
  static String newGameComputerPage = '/newGameComputerPage';
  static String computerGamePage = '/computerGamePage';
  static const String game = '/game';
  static const String gameHistory = '/game-history';
  static const String gameDetail = '/game-detail';
  static const String gameAnalysis = '/game-analysis'; // NEW
  static const String settings = '/settings';
  static const String about = '/about';

  static String editPosition = '/EditPosition';
  static String analysisPage = '/AnalysisScreen';
  static String settingsPage = '/SettingsScreen';
  static String aboutPage = '/aboutPage';
  static String recentGamesPage = '/recentGamesPage';
  static String puzzles = '/Puzzles';
  static String rankings = '/Rankings';
  static String friends = '/Friends';
  static const String computerGame = '/computer-game'; // NEW
  static const String puzzlePlay = '/puzzle-play'; // NEW
}

class AppPages {
  AppPages._();
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    // GetPage(name: '/online', page: () => const OnlineView()),
    GetPage(
      name: AppRoutes.computerGamePage,
      page: () => const ComputerGamePage(),
      binding: ComputerGameBinding(),
    ),

    GetPage(name: AppRoutes.aboutPage, page: () => const AboutPage()),
    GetPage(name: AppRoutes.settingsPage, page: () => const SettingsPage()),
    GetPage(
      name: AppRoutes.recentGamesPage,
      page: () => const RecentGamesPage(),
    ),
    GetPage(
      name: AppRoutes.offlineGamePage,
      page: () => const OfflineGamePage(),
      binding: OfflineGameBindings(),
    ),
    GetPage(
      name: AppRoutes.newOfflineGamePage,
      page: () => const NewOfflineGamePage(),
      binding: NewOfflineGameBinding(),
    ),
    // Game analysis screen
    GetPage(
      name: AppRoutes.gameAnalysis,
      page: () => const GameAnalysisScreen(),
      bindings: [
        StockfishBinding(), // Ensure Stockfish is initialized
        GameAnalysisBinding(),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.newGameComputerPage,
      page: () => const NewComputerGamePage(),
      binding: NewComputerGameBinding(),
    ),

    // GetPage(
    //   name: AppRoutes.computerGame,
    //   page: () => const GameScreen(), // Reuse GameScreen with ComputerGameController
    //   binding: ComputerGameBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.puzzles,
    //   page: () => const PuzzlesScreen(),
    //   binding: PuzzleBinding(),
    //   transition: Transition.rightToLeft,
    // ),

    // GetPage(
    //   name: AppRoutes.puzzlePlay,
    //   page: () => const PuzzlePlayScreen(),
    //   binding: PuzzleBinding(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(name: RouteNames.editPosition, page: () => EditPositionPage(positionController: positionController)),
    // GetPage(name: RouteNames.analysisScreen, page: () => AnalysisScreen()),
    // GetPage(name: '/puzzles', page: () => const PuzzlesView()),
    // GetPage(name: '/rankings', page: () => const RankingsView()),
    // GetPage(name: '/settings', page: () => const SettingsView()),
  ];
}
