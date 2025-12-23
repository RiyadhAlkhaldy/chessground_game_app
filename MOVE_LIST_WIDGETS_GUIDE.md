# Move List Widgets Documentation

## Available Move List Widgets

### 1. MoveListWidget (Vertical)
**Location:** `lib/core/global_feature/presentaion/widgets/game_info/move_list_widget.dart`

**Description:**
- عرض قائمة الحركات بشكل عمودي (Vertical)
- كل صف يحتوي على رقم الحركة + حركة أبيض + حركة أسود
- يستخدم `ListView.builder` للتمرير العمودي

**Features:**
- ✅ عرض رقم الحركة
- ✅ تمييز الحركة الحالية بلون مختلف
- ✅ النقر على الحركة للانتقال إليها
- ✅ تنسيق بسيط وواضح

**Usage:**
```dart
MoveListWidget()
```

---

### 2. HorizontalMoveListWidget
**Location:** `lib/core/global_feature/presentaion/widgets/game_info/horizontal_move_list_widget.dart`

**Description:**
- عرض قائمة الحركات بشكل أفقي (Horizontal)
- التمرير التلقائي إلى الحركة الحالية
- تصميم مضغوط يوفر مساحة الشاشة

**Features:**
- ✅ عرض أفقي مع `ScrollController`
- ✅ تمييز الحركة الحالية
- ✅ التمرير التلقائي (Auto-scroll)
- ✅ تنسيق محسّن مع فواصل بين الحركات
- ✅ ألوان مختلفة للأبيض والأسود

**Usage:**
```dart
HorizontalMoveListWidget()
```

---

### 3. EnhancedHorizontalMoveListWidget ⭐ (Recommended)
**Location:** `lib/core/global_feature/presentaion/widgets/game_info/enhanced_horizontal_move_list_widget.dart`

**Description:**
- نسخة محسّنة من `HorizontalMoveListWidget`
- يعرض أيقونات للحركات الخاصة (الكش، المات، الأخذ، الترقية)
- تصميم احترافي مع ظلال وألوان متدرجة

**Features:**
- ✅ **أيقونات الحركات الخاصة:**
  - 🏆 **Checkmate** (المات): أيقونة حمراء
  - ⚠️ **Check** (الكش): أيقونة برتقالية
  - ❌ **Capture** (الأخذ): أيقونة X حمراء
  - ⬆️ **Promotion** (الترقية): سهم أخضر
- ✅ **Header** يعرض عدد الحركات
- ✅ **Empty State** محسّن عند عدم وجود حركات
- ✅ **Gradient Colors** للأرقام
- ✅ **Box Shadow** للتصميم الاحترافي
- ✅ **Auto-scroll** ذكي مع حدود آمنة
- ✅ ارتفاع أكبر قليلاً (70px بدلاً من 60px)

**Usage:**
```dart
EnhancedHorizontalMoveListWidget()
```

---

## Implementation in OfflineGamePage

### Current Implementation ✅
```dart
// lib/features/offline_game/presentation/pages/offline_game_page.dart

Widget _buildPortraitLayout(BuildContext context) {
  return Column(
    children: [
      const BuildPlayerSectionWidget(side: Side.black, isTop: true),
      
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ChessBoardWidget(),
        ),
      ),
      
      const BuildPlayerSectionWidget(side: Side.white, isTop: false),
      
      // Enhanced horizontal move list
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: const EnhancedHorizontalMoveListWidget(),
      ),
      
      const GameControlsWidget(),
    ],
  );
}
```

---

## Comparison Table

| Feature | MoveListWidget | HorizontalMoveListWidget | EnhancedHorizontalMoveListWidget |
|---------|---------------|-------------------------|----------------------------------|
| **Direction** | Vertical ⬇️ | Horizontal ➡️ | Horizontal ➡️ |
| **Height** | Variable | 60px | 70px |
| **Auto-scroll** | ❌ | ✅ | ✅ |
| **Special Move Icons** | ❌ | ❌ | ✅ |
| **Header** | ❌ | ❌ | ✅ |
| **Empty State** | Basic | Basic | Enhanced |
| **Visual Design** | Simple | Good | Professional |
| **Box Shadow** | ❌ | ❌ | ✅ |
| **Gradient Colors** | ❌ | ❌ | ✅ |

---

## How to Switch Between Widgets

### Option 1: Use Enhanced (Recommended)
```dart
const EnhancedHorizontalMoveListWidget()
```

### Option 2: Use Simple Horizontal
```dart
const HorizontalMoveListWidget()
```

### Option 3: Use Vertical (Traditional)
```dart
const MoveListWidget()
```

---

## Design Philosophy

### MoveListWidget
- **Target:** Traditional chess notation lovers
- **Best for:** Desktop/tablet landscape mode
- **Space:** Takes full height

### HorizontalMoveListWidget
- **Target:** Mobile-first design
- **Best for:** Portrait mode, compact spaces
- **Space:** Fixed 60px height

### EnhancedHorizontalMoveListWidget
- **Target:** Modern users who want visual feedback
- **Best for:** All screen sizes, professional apps
- **Space:** Fixed 70px height with rich information

---

## Architecture Compliance ✅

All widgets follow **Clean Architecture** principles:

1. **Presentation Layer Only**
   - Extends `GetView<BaseGameController>`
   - No business logic
   - Uses `Obx()` for reactivity

2. **Dependency Injection**
   - Accesses controller via GetX DI
   - No direct instantiation

3. **State Management**
   - Reads from `controller.gameState.getMoveTokens`
   - Uses `controller.currentHalfmoveIndex`
   - Calls `controller.navigateToMove(index)`

4. **Separation of Concerns**
   - UI rendering only
   - Navigation logic in controller
   - No data manipulation

---

## Future Enhancements

### Planned Features:
- [ ] Long-press to show move analysis
- [ ] Swipe gestures for navigation
- [ ] Move annotations (!, !!, ?, ??)
- [ ] Opening name display
- [ ] Export selected moves
- [ ] Copy move notation

### Performance Optimizations:
- [ ] Use `ListView.builder` with keys
- [ ] Implement lazy loading for large games
- [ ] Cache rendered moves
- [ ] Optimize scroll calculations

---

## Testing

### Manual Testing Checklist:
- [ ] Click on move navigates correctly
- [ ] Current move is highlighted
- [ ] Auto-scroll works on move play
- [ ] Special move icons appear correctly
- [ ] Empty state shows properly
- [ ] Responsive on different screen sizes
- [ ] Works in landscape and portrait

### Widget Tests:
```dart
testWidgets('should display moves horizontally', (tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: Scaffold(
        body: EnhancedHorizontalMoveListWidget(),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(MockGameController());
      }),
    ),
  );
  
  expect(find.byType(ListView), findsOneWidget);
  expect(find.text('No moves yet'), findsNothing);
});
```

---

## Related Files

- **Controller:** `lib/core/global_feature/presentaion/controllers/base_game_controller.dart`
- **Game State:** `lib/core/utils/game_state/game_state.dart`
- **Move Data Model:** `lib/core/global_feature/data/models/move_data_model.dart`
- **Game Controls:** `lib/core/global_feature/presentaion/widgets/game_controls_widget.dart`

---

**Last Updated:** December 21, 2025
**Author:** AI Assistant
**Version:** 1.0.0
