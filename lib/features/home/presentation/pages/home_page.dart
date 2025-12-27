import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/platform.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:chessground_game_app/features/home/presentation/widgets/game_type_card.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameStartUpController>();
    final l10n = context.l10n;

    // حساب المعلومات الخاصة بالشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // حساب عدد الأعمدة بناءً على عرض الشاشة
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final childAspectRatio = _calculateAspectRatio(screenWidth, screenHeight);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isRTL),
      body: Container(
        decoration: _buildBackgroundDecoration(context, isDark),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section مع animation
              SliverToBoxAdapter(child: _buildHeader(context, isRTL)),

              // Game Options Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getHorizontalPadding(screenWidth),
                  vertical: 16,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: _getSpacing(screenWidth),
                    mainAxisSpacing: _getSpacing(screenWidth),
                  ),
                  delegate: SliverChildListDelegate([
                    // Play Against Computer
                    GameTypeCard(
                      icon: Symbols.computer,
                      label: l10n.playAgainstComputer,
                      gradient: _getGradient(context, 0, isDark),
                      delay: 0,
                      isDarkMode: isDark,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(
                          AppRoutes.computerGameSetup,
                          arguments: {"withTime": false},
                        );
                      },
                    ),

                    // Quick Play
                    GameTypeCard(
                      icon: Symbols.play_arrow,
                      label: l10n.play,
                      gradient: _getGradient(context, 2, isDark),
                      delay: 200,
                      isDarkMode: isDark,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(AppRoutes.offlineGameSetup);
                      },
                    ),

                    // Recent Games
                    GameTypeCard(
                      icon: Symbols.history,
                      label: l10n.recentGames,
                      gradient: _getGradient(context, 3, isDark),
                      delay: 300,
                      isDarkMode: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.recentGamesPage);
                      },
                    ),

                    // Settings
                    GameTypeCard(
                      icon: Symbols.settings,
                      label: l10n.mobileSettingsTab,
                      gradient: _getGradient(context, 4, isDark),
                      delay: 400,
                      isDarkMode: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.settingsPage);
                      },
                    ),

                    // About
                    GameTypeCard(
                      icon: Symbols.info,
                      label: l10n.about,
                      gradient: _getGradient(context, 5, isDark),
                      delay: 500,
                      isDarkMode: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.aboutPage);
                      },
                    ),
                  ]),
                ),
              ),

              // Bottom Spacing
              SliverToBoxAdapter(
                child: SizedBox(height: _getBottomSpacing(screenHeight)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء الـ AppBar مع دعم RTL
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isRTL) {
    return PlatformAppBar(
      title: Text(
        context.l10n.mobileHomeTab,
        style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
      elevation: 0,
      centerTitle: !isRTL,
    );
  }

  /// بناء الـ Header مع animation ودعم اللغات
  Widget _buildHeader(BuildContext context, bool isRTL) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(context, hour);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(MediaQuery.of(context).size.width),
        vertical: 24,
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.chooseGameMode,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(BuildContext context, int hour) {
    if (hour >= 5 && hour < 12) {
      return context.l10n.mobileGoodDayWithoutName;
    } else if (hour >= 12 && hour < 17) {
      return context.l10n.mobileGoodDayWithoutName;
    } else {
      return context.l10n.mobileGoodEveningWithoutName;
    }
  }

  BoxDecoration _buildBackgroundDecoration(BuildContext context, bool isDark) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bgColor,
          bgColor.withOpacity(isDark ? 0.95 : 0.98),
        ],
      ),
    );
  }

  LinearGradient _getGradient(BuildContext context, int index, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    // Map designers hex colors to theme colors or variations
    final opacity = isDark ? 0.85 : 1.0;

    switch (index) {
      case 0: // Computer - Indigo/Violet
        return LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(opacity),
            colorScheme.secondary.withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2: // Play - Pink/Rose
        return LinearGradient(
          colors: [
            const Color(0xFFEC4899).withOpacity(opacity),
            const Color(0xFFDB2777).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3: // Recent - Amber/Orange
        return LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withOpacity(opacity),
            const Color(0xFFD97706).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.surfaceContainerHighest.withOpacity(0.8),
          ],
        );
    }
  }

  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    return 2;
  }

  double _calculateAspectRatio(double width, double height) {
    final screenRatio = width / height;
    if (width >= 1200) return screenRatio > 1.5 ? 1.25 : 1.2;
    if (width >= 600) return 1.05;
    return screenRatio > 0.6 ? 1.0 : 0.95;
  }

  double _getHorizontalPadding(double width) {
    if (width >= 1200) return 48;
    if (width >= 900) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  double _getSpacing(double width) {
    if (width >= 1200) return 20;
    return 12;
  }

  double _getBottomSpacing(double height) {
    if (height >= 900) return 48;
    return 32;
  }
}