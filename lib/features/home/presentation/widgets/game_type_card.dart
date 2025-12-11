import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

/// بطاقة مخصصة لعرض خيارات اللعب مع animations جذابة ودعم Dark Mode
class GameTypeCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;
  final int delay;
  final bool isDarkMode;

  const GameTypeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
    this.delay = 0,
    this.isDarkMode = false,
  });

  @override
  State<GameTypeCard> createState() => _GameTypeCardState();
}

class _GameTypeCardState extends State<GameTypeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  /// تهيئة جميع الـ Animations
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  /// بدء الـ Entry Animation مع التأخير
  void _startEntryAnimation() {
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildCardContent(),
        ),
      ),
    );
  }

  /// بناء محتوى البطاقة مع التفاعلات
  Widget _buildCardContent() {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: _buildCardContainer(),
      ),
    );
  }

  /// بناء Container البطاقة الرئيسي
  Widget _buildCardContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _buildShadows(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // خلفية متحركة خفيفة
            _buildAnimatedBackground(),

            // المحتوى الرئيسي
            _buildMainContent(),

            // تأثير لمعان عند الضغط
            if (_isPressed) _buildPressOverlay(),
          ],
        ),
      ),
    );
  }

  /// بناء الظلال مع دعم Dark Mode
  List<BoxShadow> _buildShadows() {
    return [
      BoxShadow(
        color: widget.gradient.colors.first.withOpacity(
          widget.isDarkMode ? 0.4 : 0.3,
        ),
        blurRadius: widget.isDarkMode ? 16 : 12,
        offset: const Offset(0, 6),
        spreadRadius: widget.isDarkMode ? 1 : 0,
      ),
    ];
  }

  /// خلفية متحركة خفيفة
  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isPressed ? 0.2 : 0.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(widget.isDarkMode ? 0.15 : 0.2),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  /// المحتوى الرئيسي للبطاقة
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة مع خلفية دائرية
          _buildIcon(),

          const SizedBox(height: 16),

          // النص
          _buildLabel(),
        ],
      ),
    );
  }

  /// بناء الأيقونة مع خلفية
  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(widget.isDarkMode ? 0.15 : 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(widget.icon, size: 40, color: Colors.white),
    );
  }

  /// بناء النص مع دعم RTL
  Widget _buildLabel() {
    return Text(
      widget.label,
      style: TextStyle(
        color: Colors.white,
        fontSize: _calculateFontSize(),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// حساب حجم الخط بناءً على طول النص
  double _calculateFontSize() {
    if (widget.label.length > 20) return 13;
    if (widget.label.length > 15) return 13.5;
    return 14;
  }

  /// تأثير لمعان عند الضغط
  Widget _buildPressOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(widget.isDarkMode ? 0.25 : 0.3),
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  // ==================== Event Handlers ====================

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    // Haptic feedback للتفاعل الأفضل
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    // تأخير بسيط قبل التنقل للسماح بـ animation
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onTap();
    });
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }
}

/// بطاقة بديلة مع تصميم أبسط للأجهزة البطيئة
class SimpleGameTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDarkMode;

  const SimpleGameTypeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDarkMode ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(isDarkMode ? 0.85 : 0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// بطاقة خاصة لعرض إحصائيات سريعة (اختياري)
class QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const QuickStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
