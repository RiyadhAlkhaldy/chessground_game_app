# Chessground Game App - Custom Instructions

## 📋 Project Overview

You are working on **Chessground Game App**, a cross-platform Flutter chess application following Clean Architecture principles with GetX state management.

**Project Path:** `F:\MyWorkSpase\Projects-2026\lichess\chessground_game_app`

**Current Status:** 🟡 Partially Complete
- ✅ Computer Game (AI), Offline Game, Settings, Game History
- 🟡 Analysis (partially)
- ❌ Online Multiplayer, Puzzle Mode

---

## 🏗️ Architecture Guidelines

### Clean Architecture Layers (Strict Rules)

#### 1. **Data Layer** (`lib/core/global_feature/data` & `lib/features/*/data`)
```
data/
├── models/           # Freezed data models with JSON serialization
├── datasources/      # Abstract interfaces + implementations
└── repositories/     # Repository implementations (bridge to domain)
```

**Rules:**
- ✅ Models use **Freezed** + **json_serializable**
- ✅ DataSources are **abstract classes** with implementations
- ✅ Repositories implement **domain interfaces**
- ✅ Use **Isar** for local database
- ✅ Use **Dio** for HTTP (when needed)
- ❌ NO business logic here
- ❌ NO direct widget imports

**Example Pattern:**
```dart
// Model (Freezed)
@freezed
class ChessGameModel with _$ChessGameModel {
  const factory ChessGameModel({
    required String uuid,
    required PlayerModel whitePlayer,
    required PlayerModel blackPlayer,
    required String result,
  }) = _ChessGameModel;
  
  factory ChessGameModel.fromJson(Map<String, dynamic> json) =>
      _$ChessGameModelFromJson(json);
}

// DataSource
abstract class ChessGameLocalDataSource {
  Future<void> saveGame(ChessGameModel game);
  Future<ChessGameModel?> getGameByUuid(String uuid);
  Future<List<ChessGameModel>> getAllGames();
}

// Repository Implementation
class ChessGameRepositoryImpl implements ChessGameRepository {
  final ChessGameLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, void>> saveGame(ChessGameEntity game) async {
    try {
      await localDataSource.saveGame(game.toModel());
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
```

---

#### 2. **Domain Layer** (`lib/core/global_feature/domain` & `lib/features/*/domain`)
```
domain/
├── entities/         # Pure business objects (Equatable)
├── repositories/     # Repository interfaces (contracts)
├── usecases/         # Single-responsibility business logic
└── services/         # Complex multi-entity logic
```

**Rules:**
- ✅ Entities use **Equatable** for value equality
- ✅ Each UseCase does **ONE thing**
- ✅ Repositories are **abstract classes** (contracts only)
- ✅ Return **Either<Failure, T>** from usecases (Dartz)
- ✅ Entities are **immutable**
- ❌ NO Flutter imports (except for @immutable)
- ❌ NO external dependencies except dart:core and dartz

**Example Pattern:**
```dart
// Entity
class ChessGameEntity extends Equatable {
  final String uuid;
  final PlayerEntity whitePlayer;
  final PlayerEntity blackPlayer;
  final String result;
  final GameTermination termination;
  
  const ChessGameEntity({
    required this.uuid,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.result,
    required this.termination,
  });
  
  @override
  List<Object?> get props => [uuid, whitePlayer, blackPlayer, result, termination];
}

// Repository Interface
abstract class ChessGameRepository {
  Future<Either<Failure, void>> saveGame(ChessGameEntity game);
  Future<Either<Failure, ChessGameEntity>> getGameByUuid(String uuid);
  Future<Either<Failure, List<ChessGameEntity>>> getAllGames();
}

// UseCase
class SaveGameUseCase {
  final ChessGameRepository repository;
  
  SaveGameUseCase(this.repository);
  
  Future<Either<Failure, void>> call(ChessGameEntity game) async {
    return await repository.saveGame(game);
  }
}
```

---

#### 3. **Presentation Layer** (`lib/features/*/presentation`)
```
presentation/
├── controllers/      # GetX controllers (business logic + state)
├── pages/           # Full-screen widgets
└── widgets/         # Reusable UI components
```

**Rules:**
- ✅ Controllers extend **GetxController** or **BaseGameController**
- ✅ Use **Rx** types for reactive state
- ✅ Inject UseCases via constructor
- ✅ Use **Obx()** or **GetBuilder()** for reactive UI
- ✅ Keep widgets **dumb** (no business logic)
- ❌ NO direct repository access (use UseCases)
- ❌ NO complex logic in build() methods

**Example Pattern:**
```dart
// Controller
class OfflineGameController extends BaseGameController {
  final SaveGameUseCase saveGameUseCase;
  final GetGameByUuidUseCase getGameByUuidUseCase;
  
  OfflineGameController({
    required this.saveGameUseCase,
    required this.getGameByUuidUseCase,
  });
  
  @override
  void onInit() {
    super.onInit();
    _loadGame();
  }
  
  Future<void> _loadGame() async {
    final result = await getGameByUuidUseCase(gameUuid);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (game) => currentGame.value = game,
    );
  }
}

// Page
class OfflineGamePage extends GetView<OfflineGameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading
          ? CircularProgressIndicator()
          : ChessBoardWidget()),
    );
  }
}
```

---

## 🎯 Coding Standards

### General Rules
```dart
// ✅ DO: Use Arabic comments for complex logic
// حساب أفضل حركة من محرك Stockfish
final bestMove = await stockfish.getBestMove(fen);

// ✅ DO: Use descriptive variable names
final whitePlayerElo = 1500;
final blackPlayerElo = 1600;

// ❌ DON'T: Use single-letter variables (except loops)
final w = 1500; // Bad
final b = 1600; // Bad

// ✅ DO: Use early returns
if (game == null) return;
if (!isValidMove) return;

// ❌ DON'T: Deep nesting
if (game != null) {
  if (isValidMove) {
    if (isCheckmate) {
      // ...
    }
  }
}
```

### Naming Conventions
```dart
// Classes: PascalCase
class ChessGameController {}
class SaveGameUseCase {}

// Files: snake_case
chess_game_controller.dart
save_game_usecase.dart

// Variables/Functions: camelCase
final currentFen = '...';
void playMove() {}

// Constants: camelCase with k prefix
const kDefaultTimeControl = '5+0';

// Private: underscore prefix
final _gameState = GameState();
void _updateBoard() {}
```

### State Management (GetX)
```dart
// ✅ DO: Use proper Rx types
final Rx<GameState> gameState = GameState().obs;
final RxList<ChessMove> moveHistory = <ChessMove>[].obs;
final RxBool isLoading = false.obs;
final RxString errorMessage = ''.obs;

// ✅ DO: Use getters/setters for reactive values
set gameState(GameState state) => _gameState.value = state;
GameState get gameState => _gameState.value;

// ✅ DO: Update reactive values correctly
gameState.value = newState;  // ✅
moveHistory.add(move);       // ✅

// ❌ DON'T: Forget .value
gameState = newState;        // ❌ Won't trigger UI update
```

---

## 🔧 Dependency Injection (GetX)

### Registration in injection_container.dart
```dart
// Singleton (permanent: true)
Get.put<Isar>(isar, permanent: true);
Get.put<SoundEffectService>(SoundEffectService(), permanent: true);

// Lazy (fenix: true for recreation after disposal)
Get.lazyPut<ChessGameRepository>(
  () => ChessGameRepositoryImpl(localDataSource: sl()),
  fenix: true,
);

// Use Cases
Get.lazyPut(() => SaveGameUseCase(sl()), fenix: true);
Get.lazyPut(() => UpdateGameUseCase(sl()), fenix: true);
```

### Bindings for Features
```dart
class OfflineGameBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OfflineGameController(
      saveGameUseCase: Get.find(),
      getGameByUuidUseCase: Get.find(),
    ));
  }
}
```

---

## 📊 Database (Isar)

### Collections
```dart
@Collection()
class ChessGame {
  Id id = Isar.autoIncrement;
  
  @Index(type: IndexType.value)
  String uuid = const Uuid().v4();
  
  String? event;
  DateTime? date;
  
  final whitePlayer = IsarLink<Player>();
  final blackPlayer = IsarLink<Player>();
  
  @enumerated
  GameTermination termination = GameTermination.ongoing;
  
  List<MoveData> moves = [];
}

// Generate with:
// flutter pub run build_runner build --delete-conflicting-outputs
```

### Queries
```dart
// Get by UUID
final game = await isar.chessGames
    .filter()
    .uuidEqualTo(uuid)
    .findFirst();

// Get recent games (last 10)
final games = await isar.chessGames
    .where()
    .sortByDateDesc()
    .limit(10)
    .findAll();

// Save with links
await isar.writeTxn(() async {
  await isar.chessGames.put(game);
  await game.whitePlayer.save();
  await game.blackPlayer.save();
});
```

---

## 🎮 Chess-Specific Guidelines

### Using Chessground
```dart
// Board widget
Chessground(
  size: boardSize,
  orientation: Side.white,
  fen: currentFen,
  validMoves: validMoves,
  onMove: (move, {isDrop, isPremove}) {
    controller.onUserMove(move);
  },
  settings: ChessgroundSettings(
    enableCoordinates: true,
    animationDuration: Duration(milliseconds: 200),
  ),
)
```

### Using Dartchess
```dart
// Create position from FEN
final position = Chess.fromSetup(Setup.parseFen(fen));

// Get legal moves
final legalMoves = position.legalMoves;

// Make move
final newPosition = position.playUnchecked(move);

// Check game state
if (position.isCheckmate) {
  // Handle checkmate
}
```

### Using Stockfish
```dart
// Initialize
await stockfishDataSource.initialize();

// Get best move
final bestMove = await stockfishDataSource.getBestMoveWithTime(
  fen: currentFen,
  timeMilliseconds: 2000,
);

// Set difficulty
await stockfishDataSource.setSkillLevel(level: 10);
await stockfishDataSource.setElo(rating: 1500);
```

---

## 🐛 Error Handling

### Failures (Domain Layer)
```dart
// Base failure
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

// Specific failures
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}
```

### Exceptions (Data Layer)
```dart
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
```

### Using Either<Failure, T>
```dart
// In repository
@override
Future<Either<Failure, ChessGameEntity>> getGameByUuid(String uuid) async {
  try {
    final model = await localDataSource.getGameByUuid(uuid);
    if (model == null) {
      return Left(CacheFailure('Game not found'));
    }
    return Right(model.toEntity());
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  }
}

// In controller
final result = await useCase(uuid);
result.fold(
  (failure) {
    AppLogger.error('Failed to load game', error: failure);
    Get.snackbar('Error', failure.message);
  },
  (game) {
    currentGame.value = game;
    AppLogger.info('Game loaded successfully');
  },
);
```

---

## 📝 Logging

```dart
// Use AppLogger for all logging
AppLogger.info('Game started', tag: 'GameController');
AppLogger.debug('Current FEN: $fen', tag: 'GameController');
AppLogger.warning('Invalid move attempted', tag: 'GameController');
AppLogger.error(
  'Failed to save game',
  error: error,
  stackTrace: stackTrace,
  tag: 'GameController',
);
```

---

## 🧪 Testing Guidelines

### Unit Tests (Use Cases)
```dart
class MockChessGameRepository extends Mock implements ChessGameRepository {}

void main() {
  late SaveGameUseCase usecase;
  late MockChessGameRepository mockRepository;
  
  setUp(() {
    mockRepository = MockChessGameRepository();
    usecase = SaveGameUseCase(mockRepository);
  });
  
  test('should save game successfully', () async {
    // Arrange
    when(() => mockRepository.saveGame(any()))
        .thenAnswer((_) async => Right(null));
    
    // Act
    final result = await usecase(tChessGameEntity);
    
    // Assert
    expect(result, Right(null));
    verify(() => mockRepository.saveGame(tChessGameEntity));
  });
}
```

### Widget Tests
```dart
testWidgets('should display chess board', (tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: OfflineGamePage(),
      initialBinding: BindingsBuilder(() {
        Get.put(MockOfflineGameController());
      }),
    ),
  );
  
  expect(find.byType(Chessground), findsOneWidget);
});
```

---

## 📦 When Adding New Features

### Checklist for New Feature Implementation

#### 1. **Data Layer** (Always start here)
- [ ] Create Freezed model (`*_model.dart`)
- [ ] Run code generation: `flutter pub run build_runner build`
- [ ] Create DataSource interface
- [ ] Implement DataSource
- [ ] Create Repository implementation
- [ ] Write unit tests for repository

#### 2. **Domain Layer**
- [ ] Create Entity (with Equatable)
- [ ] Create Repository interface
- [ ] Create UseCases (one per action)
- [ ] Create custom Failures if needed
- [ ] Write unit tests for UseCases

#### 3. **Presentation Layer**
- [ ] Create Controller (extend GetxController or BaseGameController)
- [ ] Inject UseCases
- [ ] Implement reactive state with Rx
- [ ] Create Page widget
- [ ] Create reusable Widgets
- [ ] Create Bindings class
- [ ] Add route to `app_pages.dart`
- [ ] Write widget tests

#### 4. **Integration**
- [ ] Register dependencies in `injection_container.dart`
- [ ] Update navigation routes
- [ ] Add localization strings
- [ ] Test end-to-end flow

---

## 🚫 Common Mistakes to Avoid

```dart
// ❌ DON'T: Access repository directly from controller
class MyController extends GetxController {
  final ChessGameRepository repository;
  
  void saveGame() {
    repository.saveGame(game); // ❌ BAD
  }
}

// ✅ DO: Use UseCases
class MyController extends GetxController {
  final SaveGameUseCase saveGameUseCase;
  
  void saveGame() {
    saveGameUseCase(game); // ✅ GOOD
  }
}

// ❌ DON'T: Put business logic in widgets
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    final isCheckmate = game.position.isCheckmate; // ❌ BAD
    if (isCheckmate) {
      // Show dialog
    }
  }
}

// ✅ DO: Keep logic in controller
class MyController extends GetxController {
  void checkGameStatus() {
    if (game.position.isCheckmate) { // ✅ GOOD
      _showCheckmateDialog();
    }
  }
}

// ❌ DON'T: Use .value for non-Rx values
final name = 'John';
name.value = 'Jane'; // ❌ Compile error

// ✅ DO: Use .value for Rx values only
final name = 'John'.obs;
name.value = 'Jane'; // ✅ GOOD

// ❌ DON'T: Forget to dispose streams/timers
class MyController extends GetxController {
  StreamSubscription? subscription;
  
  void listen() {
    subscription = stream.listen(...);
  }
  // ❌ Missing dispose
}

// ✅ DO: Clean up in onClose()
class MyController extends GetxController {
  StreamSubscription? subscription;
  
  @override
  void onClose() {
    subscription?.cancel(); // ✅ GOOD
    super.onClose();
  }
}
```

---

## 🔄 Code Generation Commands

```bash
# Generate Freezed models
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean before build
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🎨 UI/UX Guidelines

### Responsive Design
```dart
// Use MediaQuery for responsive sizes
final screenWidth = MediaQuery.of(context).size.width;
final boardSize = screenWidth * 0.9;

// Use LayoutBuilder for adaptive layouts
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return DesktopLayout();
    }
    return MobileLayout();
  },
)
```

### Localization
```dart
// Use context.l10n for translations
Text(context.l10n.playAgainstComputer)
Text(context.l10n.newGame)

// Add new strings to lib/l10n/arb files
// app_en.arb, app_ar.arb, etc.
```

---

## 📚 Key Files Reference

### Must-Read Files
1. `lib/core/global_feature/presentaion/controllers/base_game_controller.dart` - Base for all game controllers
2. `lib/di/injection_container.dart` - Dependency injection setup
3. `lib/routes/app_pages.dart` - All app routes
4. `lib/core/global_feature/data/collections/chess_game.dart` - Main game entity

### Important Mixins
- `storage_features.dart` - Game saving/loading
- `setup_game_vs_ai_mixin.dart` - AI game setup
- `init_game_mixin.dart` - Game initialization

---

## 🎯 Current Priorities (from Implementation Plan)

### Phase 1: Core Improvements (19 hours)
1. Implement 32 end game interface methods
2. Add game navigation controls (first, last, flip)
3. Delete dead code
4. Fix build configuration

### Phase 2: Online Multiplayer (42 hours)
- Backend setup (WebSocket + REST)
- Online game data/domain/presentation layers

### Phase 3: Puzzle Mode (24 hours)
- Lichess API integration
- Puzzle solving logic
- Progress tracking

---

## 🤝 Communication Protocol

When implementing new features:

1. **Announce Layer**: "I'm starting on [Data/Domain/Presentation] layer for [Feature]"
2. **Show Code**: Always show the complete implementation
3. **Explain Decisions**: Explain any architectural choices
4. **Ask for Review**: Request review before moving to next layer
5. **Document**: Update comments and documentation

When fixing bugs:

1. **Identify Location**: Specify file and line number
2. **Explain Issue**: Describe what's wrong
3. **Show Fix**: Provide corrected code
4. **Test**: Mention how to test the fix

---

## ⚡ Quick Commands

```bash
# Run app
flutter run

# Run tests
flutter test

# Build APK
flutter build apk --release

# Analyze code
flutter analyze

# Format code
dart format lib/

# Clean build
flutter clean
flutter pub get

# Check dependencies
flutter pub outdated
```

---

## 🎓 Learning Resources

- **GetX**: https://pub.dev/packages/get
- **Freezed**: https://pub.dev/packages/freezed
- **Dartz**: https://pub.dev/packages/dartz
- **Isar**: https://isar.dev/
- **Chessground**: https://pub.dev/packages/chessground
- **Dartchess**: https://pub.dev/packages/dartchess
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

## ✅ Definition of Done

A feature is complete when:
- [ ] All three layers implemented (Data → Domain → Presentation)
- [ ] Unit tests written and passing
- [ ] Widget tests for UI
- [ ] Documented with comments
- [ ] Added to dependency injection
- [ ] Routes configured
- [ ] Localization strings added
- [ ] Manually tested on device/emulator
- [ ] No compilation warnings
- [ ] Code formatted with `dart format`

---

**Last Updated:** December 10, 2025
**Project Version:** 1.0.0+1
**Flutter SDK:** ^3.9.0