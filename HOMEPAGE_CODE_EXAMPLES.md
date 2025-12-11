# 💻 HomePage Code Examples & Snippets

## 📚 أمثلة عملية للاستخدام

هذا الملف يحتوي على أمثلة كود جاهزة للاستخدام والتخصيص.

---

## 🎨 أمثلة GameTypeCard

### 1. البطاقة الأساسية
```dart
GameTypeCard(
  icon: Symbols.computer,
  label: 'Play Computer',
  gradient: const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  delay: 0,
  onTap: () {
    print('Computer card tapped');
  },
)
```

### 2. بطاقة مع navigation
```dart
GameTypeCard(
  icon: Symbols.play_arrow,
  label: context.l10n.play,
  gradient: const LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
  ),
  delay: 100,
  onTap: () {
    Get.toNamed(
      AppRoutes.newGamePage,
      arguments: {'gameMode': 'quick'},
    );
  },
)
```

### 3. بطاقة مع confirmation dialog
```dart
GameTypeCard(
  icon: Symbols.delete,
  label: 'Delete All Games',
  gradient: const LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  ),
  delay: 200,
  onTap: () {
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete logic here
              Get.back();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  },
)
```

### 4. البطاقة البسيطة (للأجهزة البطيئة)
```dart
SimpleGameTypeCard(
  icon: Symbols.settings,
  label: 'Settings',
  color: Color(0xFF64748B),
  onTap: () {
    Get.toNamed(AppRoutes.settingsPage);
  },
)
```

---

## 🎨 أمثلة الألوان

### مجموعة ألوان Blue/Purple
```dart
const blueGradient = LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
);

const purpleGradient = LinearGradient(
  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
);

const indigoGradient = LinearGradient(
  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
);
```

### مجموعة ألوان Warm
```dart
const orangeGradient = LinearGradient(
  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
);

const redGradient = LinearGradient(
  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
);

const pinkGradient = LinearGradient(
  colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
);
```

### مجموعة ألوان Cool
```dart
const greenGradient = LinearGradient(
  colors: [Color(0xFF10B981), Color(0xFF059669)],
);

const tealGradient = LinearGradient(
  colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
);

const cyanGradient = LinearGradient(
  colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
);
```

---

## 📱 أمثلة Responsive

### 1. Column Count مخصص
```dart
int _calculateCrossAxisCount(double width) {
  // للهواتف الصغيرة
  if (width < 400) return 1;
  // للهواتف العادية
  if (width < 600) return 2;
  // للتابلت الصغير
  if (width < 800) return 2;
  // للتابلت الأفقي
  if (width < 1000) return 3;
  // للشاشات الكبيرة
  if (width < 1400) return 4;
  // للشاشات العريضة جداً
  return 5;
}
```

### 2. Aspect Ratio ديناميكي
```dart
double _calculateAspectRatio(double width) {
  // للهواتف: بطاقات أطول
  if (width < 600) return 0.85;
  // للتابلت: بطاقات متوازنة
  if (width < 900) return 0.95;
  // للتابلت الأفقي: بطاقات أعرض قليلاً
  if (width < 1200) return 1.05;
  // للديسكتوب: بطاقات عريضة
  return 1.15;
}
```

### 3. Padding متغير
```dart
EdgeInsets _calculatePadding(double width) {
  if (width < 600) {
    return const EdgeInsets.all(12);
  } else if (width < 900) {
    return const EdgeInsets.all(20);
  } else if (width < 1200) {
    return const EdgeInsets.all(28);
  } else {
    return const EdgeInsets.all(40);
  }
}
```

---

## ⚡ أمثلة Animation

### 1. Entry Animation مخصص
```dart
class CustomEntryCard extends StatefulWidget {
  @override
  State<CustomEntryCard> createState() => _CustomEntryCardState();
}

class _CustomEntryCardState extends State<CustomEntryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RotationTransition(
        turns: _rotationAnimation,
        child: Container(
          // Your card content
        ),
      ),
    );
  }
}
```

### 2. Press Animation متقدم
```dart
class AdvancedPressCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const AdvancedPressCard({
    required this.onTap,
    required this.child,
  });

  @override
  State<AdvancedPressCard> createState() => _AdvancedPressCardState();
}

class _AdvancedPressCardState extends State<AdvancedPressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: Opacity(
              opacity: 1.0 - (_controller.value * 0.2),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
```

### 3. Staggered Grid Animation
```dart
class StaggeredGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;

  const StaggeredGridView({
    required this.children,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: children[index],
        );
      },
    );
  }
}
```

---

## 🎭 أمثلة Custom Widgets

### 1. Card مع Badge
```dart
class BadgeCard extends StatelessWidget {
  final GameTypeCard card;
  final String? badge;

  const BadgeCard({
    required this.card,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        card,
        if (badge != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// الاستخدام
BadgeCard(
  card: GameTypeCard(...),
  badge: 'NEW',
)
```

### 2. Card مع Progress Bar
```dart
class ProgressCard extends StatelessWidget {
  final GameTypeCard card;
  final double progress; // 0.0 to 1.0

  const ProgressCard({
    required this.card,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        card,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

### 3. Card مع Icon Button
```dart
class ActionCard extends StatelessWidget {
  final GameTypeCard card;
  final VoidCallback? onSecondaryAction;

  const ActionCard({
    required this.card,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        card,
        if (onSecondaryAction != null)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSecondaryAction,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
```

---

## 🔧 أمثلة Utility Functions

### 1. Color Generator
```dart
class ColorUtils {
  static LinearGradient randomGradient() {
    final colors = [
      [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Purple
      [Color(0xFF10B981), Color(0xFF059669)], // Green
      [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
      [Color(0xFFF59E0B), Color(0xFFD97706)], // Orange
      [Color(0xFF3B82F6), Color(0xFF2563EB)], // Blue
      [Color(0xFF14B8A6), Color(0xFF0D9488)], // Teal
    ];
    
    final random = colors[DateTime.now().millisecond % colors.length];
    
    return LinearGradient(
      colors: random,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
```

### 2. Animation Helper
```dart
class AnimationHelper {
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.8,
    double end = 1.0,
    Curve curve = Curves.easeOutBack,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  static Animation<double> createFadeAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
}
```

### 3. Responsive Helper
```dart
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }
}

// الاستخدام
final columns = ResponsiveHelper.responsive<int>(
  context: context,
  mobile: 2,
  tablet: 3,
  desktop: 4,
);
```

---

## 🎯 أمثلة Integration

### 1. HomePage مع Search
```dart
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  List<GameTypeCard> get _filteredCards {
    // Filter cards based on search query
    return allCards.where((card) {
      return card.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
      ),
      body: GridView.builder(
        itemCount: _filteredCards.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return _filteredCards[index];
        },
      ),
    );
  }
}
```

### 2. HomePage مع Categories
```dart
class CategorizedHomePage extends StatelessWidget {
  final Map<String, List<GameTypeCard>> categories = {
    'Play': [
      GameTypeCard(...),
      GameTypeCard(...),
    ],
    'Learn': [
      GameTypeCard(...),
    ],
    'Settings': [
      GameTypeCard(...),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: categories.entries.map((entry) {
        return SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              delegate: SliverChildListDelegate(entry.value),
            ),
          ]),
        );
      }).toList(),
    );
  }
}
```

---

## 📚 Best Practices

### 1. استخدام const
```dart
// ✅ Good
const GameTypeCard(
  icon: Symbols.computer,
  label: 'Play Computer',
  gradient: LinearGradient(...),
)

// ❌ Bad
GameTypeCard(
  icon: Symbols.computer,
  label: 'Play Computer',
  gradient: LinearGradient(...),
)
```

### 2. Extract Repeated Code
```dart
// ✅ Good
class GradientColors {
  static const computer = LinearGradient(...);
  static const online = LinearGradient(...);
}

GameTypeCard(
  gradient: GradientColors.computer,
)

// ❌ Bad
GameTypeCard(
  gradient: LinearGradient(...), // Repeated multiple times
)
```

### 3. Use Keys for Performance
```dart
// ✅ Good
GameTypeCard(
  key: ValueKey('computer_card'),
  ...
)
```

---

**Happy Coding! 💻✨**

للمزيد من الأمثلة، راجع:
- HOMEPAGE_REFACTOR_GUIDE.md
- home_page.dart
- game_type_card.dart
