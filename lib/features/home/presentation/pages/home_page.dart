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

    // حساب عدد الأعمدة بناءً على عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final childAspectRatio = _calculateAspectRatio(screenWidth);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PlatformAppBar(
        title: Text(
          context.l10n.mobileSettingsHomeWidgets,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        // elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section
              SliverToBoxAdapter(child: _buildHeader(context)),

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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildListDelegate([
                    // Play Against Computer
                    GameTypeCard(
                      icon: Symbols.computer,
                      label: context.l10n.playAgainstComputer,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 0,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(
                          AppRoutes.sideChoosingPage,
                          arguments: {"withTime": false},
                        );
                      },
                    ),

                    // Play Online
                    GameTypeCard(
                      icon: Symbols.person,
                      label: context.l10n.playONline,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 100,
                      onTap: () {
                        controller.setVsComputer(value: false);
                        Get.toNamed(
                          AppRoutes.gameTimePage,
                          arguments: {"withTime": false},
                        );
                      },
                    ),

                    // Quick Play
                    GameTypeCard(
                      icon: Symbols.play_arrow,
                      label: context.l10n.play,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 200,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(AppRoutes.newGamePage);
                      },
                    ),

                    // Recent Games
                    GameTypeCard(
                      icon: Symbols.history,
                      label: context.l10n.recentGames,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 300,
                      onTap: () {
                        Get.toNamed(AppRoutes.recentGamesPage);
                      },
                    ),

                    // Settings
                    GameTypeCard(
                      icon: Symbols.settings,
                      label: context.l10n.mobileSettingsTab,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64748B), Color(0xFF475569)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 400,
                      onTap: () {
                        Get.toNamed(AppRoutes.settingsPage);
                      },
                    ),

                    // About
                    GameTypeCard(
                      icon: Symbols.info,
                      label: context.l10n.about,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      delay: 500,
                      onTap: () {
                        Get.toNamed(AppRoutes.aboutPage);
                      },
                    ),
                  ]),
                ),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Chess',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your game mode',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // حساب عدد الأعمدة بناءً على عرض الشاشة
  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) return 4; // Desktop
    if (width >= 900) return 3; // Tablet Landscape
    if (width >= 600) return 2; // Tablet Portrait
    return 2; // Mobile
  }

  // حساب نسبة الأبعاد بناءً على عرض الشاشة
  double _calculateAspectRatio(double width) {
    if (width >= 1200) return 1.2;
    if (width >= 900) return 1.1;
    if (width >= 600) return 1.0;
    return 0.95;
  }

  // حساب المسافة الأفقية بناءً على عرض الشاشة
  double _getHorizontalPadding(double width) {
    if (width >= 1200) return 48;
    if (width >= 900) return 32;
    if (width >= 600) return 24;
    return 16;
  }
}
