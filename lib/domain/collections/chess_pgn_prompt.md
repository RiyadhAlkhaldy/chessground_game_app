**المتطلب:** إنشاء مخطط (Schema) كامل لتمثيل بيانات مباراة شطرنج (PGN) قابلة للتخزين والاستعلام في قاعدة بيانات Isar داخل تطبيق Flutter. يجب أن يغطي المخطط جميع البيانات الوصفية (Tag Pairs) وتسلسل الحركات والبيانات التحليلية.

### المخطط المقترح (Isar Schema - `ChessGame.dart`)

```dart
// @collection
class ChessGame {
  // 1. المفتاح الأساسي
  Id id = Isar.autoIncrement;

  // 2. ترويسة الحدث الأساسية (Seven Tag Roster - STR)
  
  // @index(type: IndexType.value)
  String? event;            // [Event "World Championship"]
  String? site;             // [Site "New York, USA"]
  DateTime? date;           // [Date "2024.10.05"] (يتم تحويلها من String إلى DateTime)
  String? round;            // [Round "1"]
  String? whitePlayer;      // [White "Kasparov, Garry"]
  String? blackPlayer;      // [Black "Karpov, Anatoly"]
  
  // @index()
  String? result;           // [Result "1-0"] - مهم للفلترة (فوز، تعادل)

  // 3. البيانات الوصفية والتحليلية الإضافية (للتخزين السهل)
  String? eco;              // [ECO "D02"] - كود الافتتاحية
  int? whiteElo;           // [WhiteElo "2750"]
  int? blackElo;           // [BlackElo "2680"]
  String? timeControl;      // [TimeControl "5+0"]
  
  // 4. تمثيل حالة اللعبة (FEN + Raw PGN)
  String? startingFen;      // [FEN ...] - لتسجيل وضع البداية غير القياسي
  String? fullPgn;          // السلسلة النصية الكاملة للمباراة (للعرض والتحليل التفصيلي)

  // 5. التمثيل الهيكلي للحركات (للتنقل والتحليل السريع)
  List<MoveData>? moves;  // قائمة بكائنات صغيرة لتخزين كل حركة وبياناتها

  // 6. بيانات المشغل (اختياري: لتتبع المستخدم المحلي)
  String? userId;           // لتتبع المستخدم الذي لعب/حلل المباراة.
}

// @embedded
class MoveData {
  String? san;          // الحركة بصيغة SAN (مثال: Nf3, Nxe5#)
  String? lan;          // الحركة بصيغة LAN (مثال: g1f3, f3e5)
  String? comment;      // التعليقات المرفقة بالحركة {مثل هذا التعليق}
  String? nag;          // رمز التقييم الرقمي للحركة (مثال: $2)
  String? fenAfter;     // وضع FEN بعد هذه الحركة (مهم للاسترجاع السريع للوضع)
  List<String>? variations; // المتغيرات النصية (القوسين) لهذا الدور (مثال: [ "1... c5 {الدفاع الصقلي}" ] )
}
```

-----

## 📊 مثال كامل ومكمل للبيانات المخزنة (قبل إدخالها في Isar)

**السيناريو:** مباراة قصيرة بفوز الأبيض مع تعليقات وتحليل بسيط: `1. e4 e5 2. Nf3 Nc6 3. Bc4 Nf6 {فخ بسيط} 4. Ng5 d5 5. exd5 Nxd5 6. d4 h6 7. Nf3 e4 8. Ne5 Nxe5 9. dxe5 Bc5 10. O-O O-O $6 {خطأ فادح} 11. Qxd5 Bb6 12. Qxe4 c6 13. Nc3 Be6 14. Bd3 f5 15. exf6 Qxf6 16. Qh7+ Kf7 17. Ne4 Qd8 18. Bxh6 Re8 19. Qxg7# 1-0`

| الحقل (في `ChessGame`) | نوع البيانات | القيمة المخزنة | ملاحظات |
| :--- | :--- | :--- | :--- |
| `id` | `Id` | `1` | مُنشأ تلقائيًا بواسطة Isar. |
| `event` | `String` | `"Example Game with Annotations"` | |
| `whitePlayer` | `String` | `"Player A"` | |
| `blackPlayer` | `String` | `"Player B"` | |
| `result` | `String` | `"1-0"` | **مُفهرس** للبحث عن جميع انتصارات اللاعب A. |
| `whiteElo` | `int` | `2400` | |
| `blackElo` | `int` | `2350` | |
| `fullPgn` | `String` | سلسلة PGN الكاملة أعلاه | لتخزين المصدر الأصلي للمباراة. |
| `moves` | `List<MoveData>` | (انظر الجدول التالي) | البيانات الهيكلية. |

### مثال لـ `moves` (مستخلص من بيانات الحركة 3 و 10)

| الحقل (في `MoveData`) | الحركة 3 (3. Bc4) | الحركة 10 (10... O-O $6) | ملاحظات |
| :--- | :--- | :--- | :--- |
| `san` | `"Bc4"` | `"O-O"` | تمثيل مختصر للحركة. |
| `lan` | `"f1c4"` | `"e8g8"` | تمثيل طويل للحركة. |
| `nag` | `null` | `"$6"`| رمز الخطأ الفادح. | |`comment`|`null`|`null`| | |`fenAfter`|`"r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3"`|`"r1bq1rk1/ppp2ppp/2p5/2b1P3/2BPP3/5N2/PPP2PPP/RNBQ1RK1 w - - 0 11"\` | وضع اللوحة بعد هذه الحركة. |

-----

## 💾 طريقة التخزين والاسترجاع (المنطق في Flutter)

### 1\. مرحلة التخزين (عند قراءة ملف PGN)

1.  **قراءة PGN وتحليله:** يتم استخدام مكتبة Flutter لتحليل PGN (مثل `flutter_chess_pgn` أو بناء محلل بسيط).
2.  **ملء المخطط (`ChessGame`):**
      * يتم استخراج الـ **Tag Pairs** وملء الحقول الأساسية (`event`, `whitePlayer`, `elo`, إلخ).
      * يتم تحليل **تسلسل الحركات** حركة بحركة. لكل حركة، يتم إنشاء كائن **`MoveData`** يضم الـ SAN، والتعليقات، والـ NAGs، والأهم: حساب وضع **FEN** بعد الحركة.
      * يتم تخزين جميع كائنات `MoveData` في القائمة **`moves`** الخاصة بكائن `ChessGame`.
3.  **الكتابة إلى Isar:** يتم حفظ كائن `ChessGame` الكامل إلى قاعدة البيانات:
    ```dart
    final isar = Isar.getInstance();
    await isar.chessGames.put(game); // تخزين كائن اللعبة
    ```

### 2\. مرحلة الاسترجاع (لواجهة المستخدم)

**أمثلة الاستعلامات باستخدام Isar Query:**

| الهدف من الاستعلام | مثال Isar Query |
| :--- | :--- |
| **عرض جميع المباريات التي فاز بها "Player A"** | `isar.chessGames.filter().whitePlayerEqualTo("Player A").and().resultEqualTo("1-0").findAll()` |
| **البحث السريع عن مباراة بتاريخ معين** | `isar.chessGames.filter().dateEqualTo(targetDate).findAll()` |
| **استرجاع وضع معين (FEN) بعد الحركة الـ 20** | `isar.chessGames.filter().idEqualTo(gameId).findFirst().then((game) { return game?.moves?[19].fenAfter; });` |
| **استرجاع التحليل (NAGs) للمباراة** | `isar.chessGames.filter().idEqualTo(gameId).findFirst().then((game) { // يمكنك التكرار على game.moves للبحث عن NAGs });` |

بهذه الطريقة، يتم تخزين البيانات بشكل **هيكلي وقابل للاستعلام** (مثل الأسماء والنتائج وElo) مع الاحتفاظ بالقدرة على إعادة بناء اللعبة بالكامل عبر قائمة `moves` أو النص الخام `fullPgn`.