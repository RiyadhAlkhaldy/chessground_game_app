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

    // حساب المعلومات الخاصة بالشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // حساب عدد الأعمدة بناءً على عرض الشاشة
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final childAspectRatio = _calculateAspectRatio(screenWidth, screenHeight);

    return Scaffold(
      backgroundColor: _getBackgroundColor(context, isDark),
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
                      label: context.l10n.playAgainstComputer,
                      gradient: _getGradient(0, isDark),
                      delay: 0,
                      isDarkMode: isDark,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(
                          AppRoutes.newGameComputerPage,
                          arguments: {"withTime": false},
                        );
                      },
                    ),
                    // Play Against Computer
                    GameTypeCard(
                      icon: Symbols.computer,
                      label: "${context.l10n.playAgainstComputer} (Offline)",
                      gradient: _getGradient(0, isDark),
                      delay: 0,
                      isDarkMode: isDark,
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
                      gradient: _getGradient(1, isDark),
                      delay: 100,
                      isDarkMode: isDark,
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
                      gradient: _getGradient(2, isDark),
                      delay: 200,
                      isDarkMode: isDark,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        Get.toNamed(AppRoutes.newOfflineGamePage);
                      },
                    ),

                    // Recent Games
                    GameTypeCard(
                      icon: Symbols.history,
                      label: context.l10n.recentGames,
                      gradient: _getGradient(3, isDark),
                      delay: 300,
                      isDarkMode: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.recentGamesPage);
                      },
                    ),

                    // Settings
                    GameTypeCard(
                      icon: Symbols.settings,
                      label: context.l10n.mobileSettingsTab,
                      gradient: _getGradient(4, isDark),
                      delay: 400,
                      isDarkMode: isDark,
                      onTap: () {
                        Get.toNamed(AppRoutes.settingsPage);
                      },
                    ),

                    // About
                    GameTypeCard(
                      icon: Symbols.info,
                      label: context.l10n.about,
                      gradient: _getGradient(5, isDark),
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
      centerTitle: !isRTL, // في العربية نريد النص على اليمين
    );
  }

  /// بناء الـ Header مع animation ودعم اللغات
  Widget _buildHeader(BuildContext context, bool isRTL) {
    // الحصول على الوقت الحالي لتحديد التحية المناسبة
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
          crossAxisAlignment: isRTL
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // التحية
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // العنوان الفرعي
            Text(
              _getSubtitle(context),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الحصول على التحية المناسبة بناءً على الوقت
  String _getGreeting(BuildContext context, int hour) {
    if (hour >= 5 && hour < 12) {
      // صباحاً (5 AM - 12 PM)
      return context.l10n.mobileGoodDayWithoutName;
    } else if (hour >= 12 && hour < 17) {
      // ظهراً (12 PM - 5 PM)
      return context.l10n.mobileGoodDayWithoutName;
    } else {
      // مساءً (5 PM - 5 AM)
      return context.l10n.mobileGoodEveningWithoutName;
    }
  }

  /// الحصول على العنوان الفرعي
  String _getSubtitle(BuildContext context) {
    // يمكن إضافة نص مخصص في ملفات اللغة
    // لكن حالياً سنستخدم نص ثابت
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return isRTL
        ? 'اختر وضع اللعب المناسب لك'
        : 'Choose your preferred game mode';
  }

  /// الحصول على لون الخلفية بناءً على الوضع
  Color _getBackgroundColor(BuildContext context, bool isDark) {
    if (isDark) {
      return Theme.of(context).scaffoldBackgroundColor;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// بناء decoration الخلفية مع gradient ناعم
  BoxDecoration _buildBackgroundDecoration(BuildContext context, bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              ]
            : [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.98),
              ],
      ),
    );
  }

  /// الحصول على الـ Gradient المناسب لكل بطاقة مع دعم Dark Mode
  LinearGradient _getGradient(int index, bool isDark) {
    // في Dark Mode نستخدم ألوان أغمق قليلاً
    final opacity = isDark ? 0.85 : 1.0;

    switch (index) {
      case 0: // Computer
        return LinearGradient(
          colors: [
            const Color(0xFF6366F1).withOpacity(opacity),
            const Color(0xFF8B5CF6).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1: // Online
        return LinearGradient(
          colors: [
            const Color(0xFF10B981).withOpacity(opacity),
            const Color(0xFF059669).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2: // Play
        return LinearGradient(
          colors: [
            const Color(0xFFEC4899).withOpacity(opacity),
            const Color(0xFFDB2777).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3: // Recent
        return LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withOpacity(opacity),
            const Color(0xFFD97706).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 4: // Settings
        return LinearGradient(
          colors: [
            const Color(0xFF64748B).withOpacity(opacity),
            const Color(0xFF475569).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 5: // About
        return LinearGradient(
          colors: [
            const Color(0xFF14B8A6).withOpacity(opacity),
            const Color(0xFF0D9488).withOpacity(opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF6366F1).withOpacity(opacity),
            const Color(0xFF8B5CF6).withOpacity(opacity),
          ],
        );
    }
  }

  // ==================== Responsive Calculations ====================

  /// حساب عدد الأعمدة بناءً على عرض الشاشة
  int _calculateCrossAxisCount(double width) {
    if (width >= 1400) return 4; // Extra Large Desktop
    if (width >= 1200) return 4; // Desktop
    if (width >= 900) return 3; // Tablet Landscape
    if (width >= 600) return 2; // Tablet Portrait
    return 2; // Mobile
  }

  /// حساب نسبة الأبعاد بناءً على عرض وارتفاع الشاشة
  double _calculateAspectRatio(double width, double height) {
    // نأخذ في الاعتبار نسبة الشاشة لتحسين التناسق
    final screenRatio = width / height;

    if (width >= 1400) {
      return screenRatio > 1.5 ? 1.3 : 1.2;
    }
    if (width >= 1200) {
      return screenRatio > 1.5 ? 1.25 : 1.2;
    }
    if (width >= 900) {
      return screenRatio > 1.5 ? 1.15 : 1.1;
    }
    if (width >= 600) {
      return screenRatio > 1.3 ? 1.05 : 1.0;
    }
    // Mobile
    return screenRatio > 0.6 ? 1.0 : 0.95;
  }

  /// حساب المسافة الأفقية بناءً على عرض الشاشة
  double _getHorizontalPadding(double width) {
    if (width >= 1400) return 64; // Extra Large Desktop
    if (width >= 1200) return 48; // Desktop
    if (width >= 900) return 32; // Tablet Landscape
    if (width >= 600) return 24; // Tablet Portrait
    return 16; // Mobile
  }

  /// حساب المسافة بين البطاقات
  double _getSpacing(double width) {
    if (width >= 1200) return 20; // Desktop
    if (width >= 900) return 18; // Tablet Landscape
    if (width >= 600) return 16; // Tablet Portrait
    return 12; // Mobile
  }

  /// حساب المسافة السفلية
  double _getBottomSpacing(double height) {
    if (height >= 900) return 48; // Tall screens
    if (height >= 700) return 40; // Medium screens
    return 32; // Short screens
  }
}
