حل مشكلة تكرار الكود في المعمارية النظيفة
تحليل ممتاز! هذه مشكلة حقيقية. دعني أحلل المشكلة وأقدم حلولاً عملية.
التحليل المنطقي
1. أنواع التكرار المحتملة
Entities/Models مشتركة: ChessGame, ChessMove, Player
UseCases متشابهة: MakeMove, ValidateMove (تستخدم في كل الأنماط)
DataSources مشتركة: الوصول لـ Isar أو API
Repository Methods متكررة: نفس العمليات في كل feature
2. الحل: Feature Modularity + Shared Core
الهيكل المعدل (الحل الأمثل)
lib/
├── main.dart
├── app.dart
│
├── core/                                    # كل ما هو مشترك
│   │
│   ├── domain/                              # منطق الأعمال المشترك
│   │   ├── entities/                        # الكيانات الأساسية
│   │   │   ├── chess_game.dart             # يستخدم في كل الميزات
│   │   │   ├── chess_move.dart
│   │   │   ├── chess_position.dart
│   │   │   ├── player.dart
│   │   │   ├── game_result.dart
│   │   │   └── time_control.dart
│   │   │
│   │   ├── repositories/                    # الواجهات المشتركة
│   │   │   ├── base_game_repository.dart   # عمليات اللعبة الأساسية
│   │   │   ├── storage_repository.dart     # عمليات التخزين
│   │   │   └── settings_repository.dart
│   │   │
│   │   └── usecases/                        # حالات استخدام مشتركة
│   │       ├── base/
│   │       │   └── usecase.dart            # Base UseCase Class
│   │       │
│   │       └── game/                        # UseCases مشتركة للعبة
│   │           ├── make_move.dart          # مشترك بين كل الأنماط
│   │           ├── validate_move.dart
│   │           ├── get_legal_moves.dart
│   │           ├── check_game_status.dart
│   │           ├── undo_move.dart
│   │           └── redo_move.dart
│   │
│   ├── data/                                # البيانات المشتركة
│   │   ├── models/                          # Models الأساسية
│   │   │   ├── chess_game_model.dart
│   │   │   ├── chess_game_model.freezed.dart
│   │   │   ├── chess_game_model.g.dart
│   │   │   ├── chess_move_model.dart
│   │   │   ├── player_model.dart
│   │   │   └── game_result_model.dart
│   │   │
│   │   ├── datasources/                     # DataSources مشتركة
│   │   │   ├── local/
│   │   │   │   ├── isar_service.dart       # خدمة Isar الأساسية
│   │   │   │   ├── game_local_datasource.dart
│   │   │   │   └── settings_local_datasource.dart
│   │   │   │
│   │   │   └── remote/
│   │   │       ├── api_service.dart         # Dio Service
│   │   │       ├── websocket_service.dart   # WebSocket Service
│   │   │       └── game_remote_datasource.dart
│   │   │
│   │   └── repositories/                    # تنفيذ Repository المشترك
│   │       ├── base_game_repository_impl.dart
│   │       └── storage_repository_impl.dart
│   │
│   ├── presentation/                        # مكونات UI مشتركة
│   │   ├── controllers/
│   │   │   └── base_game_controller.dart   # Controller أساسي
│   │   │
│   │   └── widgets/                         # Widgets مشتركة
│   │       ├── chess_board/
│   │       │   ├── chess_board_widget.dart
│   │       │   └── piece_widget.dart
│   │       │
│   │       ├── game_info/
│   │       │   ├── move_history_widget.dart
│   │       │   ├── captured_pieces_widget.dart
│   │       │   ├── player_info_widget.dart
│   │       │   └── timer_widget.dart
│   │       │
│   │       └── controls/
│   │           ├── game_controls_widget.dart
│   │           ├── move_navigation_widget.dart
│   │           └── game_menu_widget.dart
│   │
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── storage_constants.dart
│   │
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   │
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── websocket_client.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── extensions.dart
│   │   └── helpers.dart
│   │
│   └── themes/
│       ├── app_theme.dart
│       └── app_colors.dart
│
├── features/                                # فقط الميزات الفريدة
│   │
│   ├── offline_game/                       # اللعب المحلي (بسيط جداً)
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── offline_game_controller.dart  # يمتد من BaseGameController
│   │   │   │
│   │   │   └── pages/
│   │   │       └── offline_game_page.dart
│   │   │
│   │   └── offline_game_bindings.dart      # GetX Bindings
│   │
│   ├── computer_game/                      # اللعب ضد الكمبيوتر
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── engine_config.dart      # خاص بالمحرك فقط
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── engine_repository.dart
│   │   │   │
│   │   │   └── usecases/                   # فقط UseCases خاصة بالمحرك
│   │   │       ├── initialize_engine.dart
│   │   │       ├── get_engine_move.dart
│   │   │       ├── set_engine_difficulty.dart
│   │   │       └── analyze_position.dart
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── engine_config_model.dart
│   │   │   │
│   │   │   ├── datasources/
│   │   │   │   └── stockfish_datasource.dart  # فقط Stockfish
│   │   │   │
│   │   │   └── repositories/
│   │   │       └── engine_repository_impl.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── computer_game_controller.dart  # يمتد من BaseGameController
│   │   │   │
│   │   │   └── pages/
│   │   │       ├── computer_game_page.dart
│   │   │       └── difficulty_selection_page.dart
│   │   │
│   │   └── computer_game_bindings.dart
│   │
│   ├── online_game/                        # اللعب أونلاين
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── online_match.dart       # خاص بالأونلاين فقط
│   │   │   │   ├── match_request.dart
│   │   │   │   └── opponent.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── online_match_repository.dart
│   │   │   │
│   │   │   └── usecases/                   # فقط UseCases خاصة بالأونلاين
│   │   │       ├── find_match.dart
│   │   │       ├── create_match.dart
│   │   │       ├── join_match.dart
│   │   │       ├── leave_match.dart
│   │   │       ├── send_move_online.dart
│   │   │       └── sync_game_state.dart
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── online_match_model.dart
│   │   │   │   └── match_request_model.dart
│   │   │   │
│   │   │   ├── datasources/
│   │   │   │   └── online_match_datasource.dart  # WebSocket specific
│   │   │   │
│   │   │   └── repositories/
│   │   │       └── online_match_repository_impl.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   ├── online_game_controller.dart  # يمتد من BaseGameController
│   │   │   │   └── matchmaking_controller.dart
│   │   │   │
│   │   │   ├── pages/
│   │   │   │   ├── online_game_page.dart
│   │   │   │   ├── matchmaking_page.dart
│   │   │   │   └── lobby_page.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── matchmaking_widget.dart
│   │   │       └── online_status_widget.dart
│   │   │
│   │   └── online_game_bindings.dart
│   │
│   ├── game_analysis/                      # تحليل المباريات
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── analysis_result.dart
│   │   │   │   ├── move_evaluation.dart
│   │   │   │   └── position_score.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── analysis_repository.dart
│   │   │   │
│   │   │   └── usecases/
│   │   │       ├── analyze_game.dart
│   │   │       ├── analyze_position.dart
│   │   │       ├── get_best_moves.dart
│   │   │       └── compare_moves.dart
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── analysis_result_model.dart
│   │   │   │
│   │   │   ├── datasources/
│   │   │   │   └── analysis_datasource.dart  # يستخدم Stockfish
│   │   │   │
│   │   │   └── repositories/
│   │   │       └── analysis_repository_impl.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── analysis_controller.dart
│   │   │   │
│   │   │   ├── pages/
│   │   │   │   └── analysis_page.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── analysis_board_widget.dart
│   │   │       ├── evaluation_bar_widget.dart
│   │   │       └── best_moves_widget.dart
│   │   │
│   │   └── analysis_bindings.dart
│   │
│   ├── game_history/                       # سجل المباريات
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── game_record.dart
│   │   │   │
│   │   │   └── usecases/
│   │   │       ├── get_game_history.dart
│   │   │       ├── filter_games.dart
│   │   │       ├── export_game.dart
│   │   │       └── import_game.dart
│   │   │
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── game_record_model.dart
│   │   │   │
│   │   │   └── repositories/
│   │   │       └── history_repository_impl.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── history_controller.dart
│   │   │   │
│   │   │   ├── pages/
│   │   │   │   └── history_page.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │       ├── game_list_item_widget.dart
│   │   │       └── filter_widget.dart
│   │   │
│   │   └── history_bindings.dart
│   │
│   ├── settings/                           # الإعدادات
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── app_settings.dart
│   │   │   │   └── board_theme.dart
│   │   │   │
│   │   │   └── usecases/
│   │   │       ├── get_settings.dart
│   │   │       ├── update_board_theme.dart
│   │   │       └── update_sound_settings.dart
│   │   │
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── settings_repository_impl.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   │   └── settings_controller.dart
│   │   │   │
│   │   │   └── pages/
│   │   │       └── settings_page.dart
│   │   │
│   │   └── settings_bindings.dart
│   │
│   └── home/                               # الشاشة الرئيسية
│       ├── presentation/
│       │   ├── controllers/
│       │   │   └── home_controller.dart
│       │   │
│       │   ├── pages/
│       │   │   └── home_page.dart
│       │   │
│       │   └── widgets/
│       │       └── game_mode_card_widget.dart
│       │
│       └── home_bindings.dart
│
└── injection_container.dart                # Dependency Injection
استراتيجيات تجنب التكرار
1. Base Classes & Inheritance
// core/presentation/controllers/base_game_controller.dart
abstract class BaseGameController extends GetxController {
  // منطق مشترك لكل أنواع الألعاب
  final MakeMove makeMove;
  final ValidateMove validateMove;
  final GetLegalMoves getLegalMoves;
  
  final Rx<ChessGame> game = ChessGame.initial().obs;
  final RxList<ChessMove> moveHistory = <ChessMove>[].obs;
  
  // دوال مشتركة
  Future<void> playMove(ChessMove move);
  void undoMove();
  void redoMove();
  bool isGameOver();
}

// features/offline_game/presentation/controllers/offline_game_controller.dart
class OfflineGameController extends BaseGameController {
  // فقط الوظائف الخاصة باللعب المحلي
  @override
  Future<void> playMove(ChessMove move) async {
    // منطق بسيط للعب المحلي
  }
}

// features/computer_game/presentation/controllers/computer_game_controller.dart
class ComputerGameController extends BaseGameController {
  final GetEngineMove getEngineMove;
  
  @override
  Future<void> playMove(ChessMove move) async {
    // لعب حركة اللاعب + الحصول على حركة المحرك
  }
}
2. Composition Over Inheritance للـ UseCases
// core/domain/usecases/game/game_service.dart
class GameService {
  final MakeMove makeMove;
  final ValidateMove validateMove;
  final GetLegalMoves getLegalMoves;
  final CheckGameStatus checkGameStatus;
  
  // مجموعة من الدوال المشتركة
  Future<ChessGame> executeMove(ChessGame game, ChessMove move) {
    // منطق مشترك
  }
}

// استخدامها في أي UseCase
class SendMoveOnline {
  final GameService gameService;
  final OnlineMatchRepository repository;
  
  Future<void> call(OnlineMatch match, ChessMove move) async {
    // استخدام gameService بدلاً من تكرار الكود
    final updatedGame = await gameService.executeMove(match.game, move);
    await repository.sendMove(match.id, move);
  }
}
3. Shared DataSources مع Parameters
// core/data/datasources/local/game_local_datasource.dart
abstract class GameLocalDataSource {
  Future<void> saveGame(ChessGameModel game, String category); // category: 'offline', 'computer', 'online'
  Future<List<ChessGameModel>> getGames(String category);
  Future<ChessGameModel?> getGameById(String id);
}

// استخدامها في مختلف الـ repositories
class OfflineGameRepositoryImpl {
  final GameLocalDataSource localDataSource;
  
  Future<void> saveOfflineGame(ChessGame game) {
    return localDataSource.saveGame(game.toModel(), 'offline');
  }
}

class OnlineMatchRepositoryImpl {
  final GameLocalDataSource localDataSource;
  
  Future<void> cacheMatch(OnlineMatch match) {
    return localDataSource.saveGame(match.game.toModel(), 'online');
  }
}
4. Mixins للوظائف المشتركة
// core/presentation/controllers/mixins/move_navigation_mixin.dart
mixin MoveNavigationMixin on GetxController {
  final currentMoveIndex = 0.obs;
  final moves = <ChessMove>[].obs;
  
  void navigateToMove(int index) {
    currentMoveIndex.value = index;
  }
  
  void nextMove() {
    if (currentMoveIndex.value < moves.length - 1) {
      currentMoveIndex.value++;
    }
  }
  
  void previousMove() {
    if (currentMoveIndex.value > 0) {
      currentMoveIndex.value--;
    }
  }
}

// استخدامها
class OfflineGameController extends BaseGameController with MoveNavigationMixin {
  // تلقائياً يحصل على كل الدوال
}
5. Extension Methods
// core/utils/extensions/chess_game_extensions.dart
extension ChessGameExtensions on ChessGame {
  bool get isCheckmate => status == GameStatus.checkmate;
  bool get isStalemate => status == GameStatus.stalemate;
  bool get isDraw => status == GameStatus.draw;
  
  String toPGN() {
    // تحويل إلى PGN
  }
  
  ChessGame copyWithMove(ChessMove move) {
    // إنشاء نسخة مع حركة جديدة
  }
}

// استخدامها في أي مكان
if (game.isCheckmate) {
  // ...
}
مقارنة: قبل وبعد
❌ قبل (مع التكرار)
features/offline_game/domain/usecases/make_move.dart        (50 سطر)
features/computer_game/domain/usecases/make_move.dart       (50 سطر)
features/online_game/domain/usecases/make_move.dart         (50 سطر)
features/offline_game/domain/usecases/validate_move.dart    (30 سطر)
features/computer_game/domain/usecases/validate_move.dart   (30 سطر)
features/online_game/domain/usecases/validate_move.dart     (30 سطر)

= 240 سطر متكررة
✅ بعد (بدون تكرار)
core/domain/usecases/game/make_move.dart          (50 سطر) ← مشترك
core/domain/usecases/game/validate_move.dart      (30 سطر) ← مشترك
features/online_game/domain/usecases/send_move_online.dart  (20 سطر) ← فقط المنطق الخاص

= 100 سطر فقط
القواعد الذهبية
إذا استخدمت نفس الكود 3 مرات → انقله إلى Core
الـ Entities/Models الأساسية دائماً في Core
UseCases المشتركة في Core، الخاصة في Features
DataSources المشتركة في Core مع parameters للتخصيص
استخدم Composition بدلاً من Inheritance عندما يكون ممكناً
Mixins للوظائف الأفقية (logging, navigation, etc.)
هذا الحل يحافظ على مبادئ Clean Architecture مع تجنب التكرار الزائد. هل تريد أمثلة كود تفصيلية لأي جزء؟