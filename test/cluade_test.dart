// مخطط الاختبارات للمعمارية النظيفة
// سأعرض لك هيكل مجلد test/ المتوافق مع Clean Architecture ثم أحدد الملفات القابلة للاختبار.
// هيكل مجلد test/
// test/
// ├── fixtures/                                    # بيانات وهمية للاختبارات
// │   ├── chess_game_fixture.dart                 # ألعاب جاهزة للاختبار
// │   ├── chess_move_fixture.dart
// │   ├── player_fixture.dart
// │   │
// │   └── json/                                   # ملفات JSON للاختبارات
// │       ├── chess_game.json
// │       ├── online_match.json
// │       └── analysis_result.json
// │
// ├── helpers/                                     # أدوات مساعدة للاختبارات
// │   ├── test_helper.dart                        # دوال مساعدة عامة
// │   ├── mock_generator.dart                     # Mocks جاهزة
// │   └── pump_app.dart                           # للـ Widget Tests
// │
// ├── core/                                        # اختبارات Core
// │   │
// │   ├── domain/
// │   │   ├── entities/
// │   │   │   ├── chess_game_test.dart           # ✅ Unit Test
// │   │   │   ├── chess_move_test.dart           # ✅ Unit Test
// │   │   │   └── player_test.dart               # ✅ Unit Test
// │   │   │
// │   │   └── usecases/
// │   │       └── game/
// │   │           ├── make_move_test.dart         # ✅ Unit Test
// │   │           ├── validate_move_test.dart     # ✅ Unit Test
// │   │           ├── get_legal_moves_test.dart   # ✅ Unit Test
// │   │           ├── check_game_status_test.dart # ✅ Unit Test
// │   │           ├── undo_move_test.dart         # ✅ Unit Test
// │   │           └── redo_move_test.dart         # ✅ Unit Test
// │   │
// │   ├── data/
// │   │   ├── models/
// │   │   │   ├── chess_game_model_test.dart     # ✅ Unit Test
// │   │   │   ├── chess_move_model_test.dart     # ✅ Unit Test
// │   │   │   └── player_model_test.dart         # ✅ Unit Test
// │   │   │
// │   │   ├── datasources/
// │   │   │   ├── local/
// │   │   │   │   ├── isar_service_test.dart     # ✅ Integration Test
// │   │   │   │   ├── game_local_datasource_test.dart      # ✅ Unit Test (Mock)
// │   │   │   │   └── settings_local_datasource_test.dart  # ✅ Unit Test (Mock)
// │   │   │   │
// │   │   │   └── remote/
// │   │   │       ├── api_service_test.dart               # ✅ Unit Test (Mock)
// │   │   │       ├── websocket_service_test.dart         # ✅ Unit Test (Mock)
// │   │   │       └── game_remote_datasource_test.dart    # ✅ Unit Test (Mock)
// │   │   │
// │   │   └── repositories/
// │   │       ├── base_game_repository_impl_test.dart     # ✅ Unit Test
// │   │       └── storage_repository_impl_test.dart       # ✅ Unit Test
// │   │
// │   ├── presentation/
// │   │   ├── controllers/
// │   │   │   └── base_game_controller_test.dart          # ✅ Unit Test
// │   │   │
// │   │   └── widgets/
// │   │       ├── chess_board/
// │   │       │   ├── chess_board_widget_test.dart        # ✅ Widget Test
// │   │       │   └── piece_widget_test.dart              # ✅ Widget Test
// │   │       │
// │   │       ├── game_info/
// │   │       │   ├── move_history_widget_test.dart       # ✅ Widget Test
// │   │       │   ├── captured_pieces_widget_test.dart    # ✅ Widget Test
// │   │       │   ├── player_info_widget_test.dart        # ✅ Widget Test
// │   │       │   └── timer_widget_test.dart              # ✅ Widget Test
// │   │       │
// │   │       └── controls/
// │   │           ├── game_controls_widget_test.dart      # ✅ Widget Test
// │   │           ├── move_navigation_widget_test.dart    # ✅ Widget Test
// │   │           └── game_menu_widget_test.dart          # ✅ Widget Test
// │   │
// │   ├── network/
// │   │   ├── dio_client_test.dart                        # ✅ Unit Test
// │   │   └── websocket_client_test.dart                  # ✅ Unit Test
// │   │
// │   └── utils/
// │       ├── validators_test.dart                        # ✅ Unit Test
// │       ├── extensions_test.dart                        # ✅ Unit Test
// │       └── helpers_test.dart                           # ✅ Unit Test
// │
// ├── features/                                    # اختبارات Features
// │   │
// │   ├── offline_game/
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   └── offline_game_controller_test.dart   # ✅ Unit Test
// │   │   │   │
// │   │   │   └── pages/
// │   │   │       └── offline_game_page_test.dart         # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── offline_game_flow_test.dart             # ✅ Integration Test
// │   │
// │   ├── computer_game/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   │   └── engine_config_test.dart             # ✅ Unit Test
// │   │   │   │
// │   │   │   └── usecases/
// │   │   │       ├── initialize_engine_test.dart         # ✅ Unit Test
// │   │   │       ├── get_engine_move_test.dart           # ✅ Unit Test
// │   │   │       ├── set_engine_difficulty_test.dart     # ✅ Unit Test
// │   │   │       └── analyze_position_test.dart          # ✅ Unit Test
// │   │   │
// │   │   ├── data/
// │   │   │   ├── models/
// │   │   │   │   └── engine_config_model_test.dart       # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── datasources/
// │   │   │   │   └── stockfish_datasource_test.dart      # ✅ Unit Test (Mock)
// │   │   │   │
// │   │   │   └── repositories/
// │   │   │       └── engine_repository_impl_test.dart    # ✅ Unit Test
// │   │   │
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   └── computer_game_controller_test.dart  # ✅ Unit Test
// │   │   │   │
// │   │   │   └── pages/
// │   │   │       ├── computer_game_page_test.dart        # ✅ Widget Test
// │   │   │       └── difficulty_selection_page_test.dart # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── computer_game_flow_test.dart            # ✅ Integration Test
// │   │
// │   ├── online_game/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   │   ├── online_match_test.dart              # ✅ Unit Test
// │   │   │   │   ├── match_request_test.dart             # ✅ Unit Test
// │   │   │   │   └── opponent_test.dart                  # ✅ Unit Test
// │   │   │   │
// │   │   │   └── usecases/
// │   │   │       ├── find_match_test.dart                # ✅ Unit Test
// │   │   │       ├── create_match_test.dart              # ✅ Unit Test
// │   │   │       ├── join_match_test.dart                # ✅ Unit Test
// │   │   │       ├── leave_match_test.dart               # ✅ Unit Test
// │   │   │       ├── send_move_online_test.dart          # ✅ Unit Test
// │   │   │       └── sync_game_state_test.dart           # ✅ Unit Test
// │   │   │
// │   │   ├── data/
// │   │   │   ├── models/
// │   │   │   │   ├── online_match_model_test.dart        # ✅ Unit Test
// │   │   │   │   └── match_request_model_test.dart       # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── datasources/
// │   │   │   │   └── online_match_datasource_test.dart   # ✅ Unit Test (Mock)
// │   │   │   │
// │   │   │   └── repositories/
// │   │   │       └── online_match_repository_impl_test.dart # ✅ Unit Test
// │   │   │
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   ├── online_game_controller_test.dart    # ✅ Unit Test
// │   │   │   │   └── matchmaking_controller_test.dart    # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── pages/
// │   │   │   │   ├── online_game_page_test.dart          # ✅ Widget Test
// │   │   │   │   ├── matchmaking_page_test.dart          # ✅ Widget Test
// │   │   │   │   └── lobby_page_test.dart                # ✅ Widget Test
// │   │   │   │
// │   │   │   └── widgets/
// │   │   │       ├── matchmaking_widget_test.dart        # ✅ Widget Test
// │   │   │       └── online_status_widget_test.dart      # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── online_game_flow_test.dart              # ✅ Integration Test
// │   │
// │   ├── game_analysis/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   │   ├── analysis_result_test.dart           # ✅ Unit Test
// │   │   │   │   ├── move_evaluation_test.dart           # ✅ Unit Test
// │   │   │   │   └── position_score_test.dart            # ✅ Unit Test
// │   │   │   │
// │   │   │   └── usecases/
// │   │   │       ├── analyze_game_test.dart              # ✅ Unit Test
// │   │   │       ├── analyze_position_test.dart          # ✅ Unit Test
// │   │   │       ├── get_best_moves_test.dart            # ✅ Unit Test
// │   │   │       └── compare_moves_test.dart             # ✅ Unit Test
// │   │   │
// │   │   ├── data/
// │   │   │   ├── models/
// │   │   │   │   └── analysis_result_model_test.dart     # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── datasources/
// │   │   │   │   └── analysis_datasource_test.dart       # ✅ Unit Test (Mock)
// │   │   │   │
// │   │   │   └── repositories/
// │   │   │       └── analysis_repository_impl_test.dart  # ✅ Unit Test
// │   │   │
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   └── analysis_controller_test.dart       # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── pages/
// │   │   │   │   └── analysis_page_test.dart             # ✅ Widget Test
// │   │   │   │
// │   │   │   └── widgets/
// │   │   │       ├── analysis_board_widget_test.dart     # ✅ Widget Test
// │   │   │       ├── evaluation_bar_widget_test.dart     # ✅ Widget Test
// │   │   │       └── best_moves_widget_test.dart         # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── game_analysis_flow_test.dart            # ✅ Integration Test
// │   │
// │   ├── game_history/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   │   └── game_record_test.dart               # ✅ Unit Test
// │   │   │   │
// │   │   │   └── usecases/
// │   │   │       ├── get_game_history_test.dart          # ✅ Unit Test
// │   │   │       ├── filter_games_test.dart              # ✅ Unit Test
// │   │   │       ├── export_game_test.dart               # ✅ Unit Test
// │   │   │       └── import_game_test.dart               # ✅ Unit Test
// │   │   │
// │   │   ├── data/
// │   │   │   ├── models/
// │   │   │   │   └── game_record_model_test.dart         # ✅ Unit Test
// │   │   │   │
// │   │   │   └── repositories/
// │   │   │       └── history_repository_impl_test.dart   # ✅ Unit Test
// │   │   │
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   └── history_controller_test.dart        # ✅ Unit Test
// │   │   │   │
// │   │   │   ├── pages/
// │   │   │   │   └── history_page_test.dart              # ✅ Widget Test
// │   │   │   │
// │   │   │   └── widgets/
// │   │   │       ├── game_list_item_widget_test.dart     # ✅ Widget Test
// │   │   │       └── filter_widget_test.dart             # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── game_history_flow_test.dart             # ✅ Integration Test
// │   │
// │   ├── settings/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   │   ├── app_settings_test.dart              # ✅ Unit Test
// │   │   │   │   └── board_theme_test.dart               # ✅ Unit Test
// │   │   │   │
// │   │   │   └── usecases/
// │   │   │       ├── get_settings_test.dart              # ✅ Unit Test
// │   │   │       ├── update_board_theme_test.dart        # ✅ Unit Test
// │   │   │       └── update_sound_settings_test.dart     # ✅ Unit Test
// │   │   │
// │   │   ├── data/
// │   │   │   └── repositories/
// │   │   │       └── settings_repository_impl_test.dart  # ✅ Unit Test
// │   │   │
// │   │   ├── presentation/
// │   │   │   ├── controllers/
// │   │   │   │   └── settings_controller_test.dart       # ✅ Unit Test
// │   │   │   │
// │   │   │   └── pages/
// │   │   │       └── settings_page_test.dart             # ✅ Widget Test
// │   │   │
// │   │   └── integration/
// │   │       └── settings_flow_test.dart                 # ✅ Integration Test
// │   │
// │   └── home/
// │       ├── presentation/
// │       │   ├── controllers/
// │       │   │   └── home_controller_test.dart           # ✅ Unit Test
// │       │   │
// │       │   ├── pages/
// │       │   │   └── home_page_test.dart                 # ✅ Widget Test
// │       │   │
// │       │   └── widgets/
// │       │       └── game_mode_card_widget_test.dart     # ✅ Widget Test
// │       │
// │       └── integration/
// │           └── home_navigation_test.dart               # ✅ Integration Test
// │
// └── integration/                             # اختبارات التكامل الشاملة
//     ├── app_test.dart                       # ✅ End-to-End Test
//     ├── full_game_flow_test.dart            # ✅ End-to-End Test
//     └── offline_to_online_test.dart         # ✅ End-to-End Test
// جدول الملفات القابلة للاختبار من lib/
// ✅ يجب اختبارها (أولوية عالية)
// الطبقة
// الملف
// نوع الاختبار
// السبب
// Domain/Entities
// chess_game.dart
// Unit
// منطق أعمال نقي

// chess_move.dart
// Unit
// منطق أعمال نقي

// player.dart
// Unit
// منطق أعمال نقي

// engine_config.dart
// Unit
// منطق أعمال نقي

// online_match.dart
// Unit
// منطق أعمال نقي
// Domain/UseCases
// make_move.dart
// Unit
// منطق رئيسي

// validate_move.dart
// Unit
// منطق رئيسي

// get_legal_moves.dart
// Unit
// منطق رئيسي

// check_game_status.dart
// Unit
// منطق رئيسي

// get_engine_move.dart
// Unit
// منطق رئيسي

// find_match.dart
// Unit
// منطق رئيسي

// analyze_game.dart
// Unit
// منطق رئيسي
// Data/Models
// *_model.dart
// Unit
// تحويل JSON
// Data/Repositories
// *_repository_impl.dart
// Unit
// ربط الطبقات
// Presentation/Controllers
// *_controller.dart
// Unit
// منطق الحالة
// Utils
// validators.dart
// Unit
// دوال مساعدة

// extensions.dart
// Unit
// دوال مساعدة
// ⚠️ اختياري (أولوية متوسطة)
// الطبقة
// الملف
// نوع الاختبار
// السبب
// Presentation/Widgets
// chess_board_widget.dart
// Widget
// واجهة معقدة

// move_history_widget.dart
// Widget
// واجهة معقدة

// timer_widget.dart
// Widget
// منطق توقيت
// Presentation/Pages
// *_page.dart
// Widget
// تكامل UI
// Data/DataSources
// *_datasource.dart
// Unit (Mock)
// تكامل خارجي
// ❌ لا يحتاج اختبار
// النوع
// السبب
// main.dart
// بسيط جداً
// app.dart
// إعداد فقط
// *_bindings.dart
// GetX bindings بسيطة
// constants/*.dart
// قيم ثابتة فقط
// themes/*.dart
// ألوان وأنماط
// Widgets بسيطة
// عرض فقط بدون منطق
// أنواع الاختبارات
// 1. Unit Tests (الأكثر أهمية)
// // test/core/domain/usecases/game/make_move_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockGameRepository extends Mock implements GameRepository {}

// void main() {
//   late MakeMove usecase;
//   late MockGameRepository mockRepository;

//   setUp(() {
//     mockRepository = MockGameRepository();
//     usecase = MakeMove(mockRepository);
//   });

//   group('MakeMove', () {
//     test('should execute move when valid', () async {
//       // Arrange
//       final game = ChessGameFixture.initial();
//       final move = ChessMoveFixture.e2e4();
      
//       when(() => mockRepository.makeMove(any(), any()))
//           .thenAnswer((_) async => Right(game.copyWith(moves: [move])));

//       // Act
//       final result = await usecase(game, move);

//       // Assert
//       expect(result.isRight(), true);
//       verify(() => mockRepository.makeMove(game, move)).called(1);
//     });

//     test('should return failure when move is invalid', () async {
//       // Arrange
//       final game = ChessGameFixture.initial();
//       final invalidMove = ChessMoveFixture.invalid();
      
//       when(() => mockRepository.makeMove(any(), any()))
//           .thenAnswer((_) async => Left(InvalidMoveFailure()));

//       // Act
//       final result = await usecase(game, invalidMove);

//       // Assert
//       expect(result.isLeft(), true);
//     });
//   });
// }
// 2. Widget Tests
// // test/core/presentation/widgets/chess_board/chess_board_widget_test.dart
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('ChessBoardWidget displays correctly', (tester) async {
//     // Arrange
//     final game = ChessGameFixture.initial();

//     // Act
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ChessBoardWidget(game: game),
//       ),
//     );

//     // Assert
//     expect(find.byType(ChessBoardWidget), findsOneWidget);
//     expect(find.byType(PieceWidget), findsNWidgets(32)); // 32 قطعة
//   });

//   testWidgets('ChessBoardWidget responds to tap', (tester) async {
//     // Arrange
//     var tappedSquare = '';
//     final game = ChessGameFixture.initial();

//     // Act
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ChessBoardWidget(
//           game: game,
//           onSquareTap: (square) => tappedSquare = square,
//         ),
//       ),
//     );
    
//     await tester.tap(find.text('e2'));
//     await tester.pump();

//     // Assert
//     expect(tappedSquare, 'e2');
//   });
// }
// 3. Integration Tests
// // test/features/offline_game/integration/offline_game_flow_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Complete offline game flow', (tester) async {
//     // Arrange
//     await tester.pumpWidget(MyApp());

//     // Act - Navigate to offline game
//     await tester.tap(find.text('Play Offline'));
//     await tester.pumpAndSettle();

//     // Make a move
//     await tester.tap(find.text('e2'));
//     await tester.pumpAndSettle();
//     await tester.tap(find.text('e4'));
//     await tester.pumpAndSettle();

//     // Assert
//     expect(find.text('1. e4'), findsOneWidget);
//   });
// }
// الأولويات في الاختبار
// المرحلة 1: الأساسيات (Core)
// ✅ Domain Entities
// ✅ Domain UseCases (الأساسية)
// ✅ Data Models
// ✅ Utils & Extensions
// المرحلة 2: الميزات الرئيسية
// ✅ Offline Game (أبسط feature)
// ✅ Computer Game
// ✅ Repositories Implementation
// المرحلة 3: الميزات المتقدمة
// ✅ Online Game
// ✅ Game Analysis
// ✅ Controllers
// المرحلة 4: UI
// ⚠️ Core Widgets
// ⚠️ Feature Pages
// ⚠️ Integration Tests
// نصائح مهمة
// استخدم Fixtures: أنشئ بيانات جاهزة للاختبار
// استخدم Mocktail: للـ Mocking بدلاً من Mockito
// اختبر الـ Edge Cases: ليس فقط الحالات الطبيعية
// Coverage Target: استهدف 80%+ للـ Domain و Data
// Golden Tests: لاختبار UI consistency
// هل تريد أمثلة تفصيلية لاختبار معين؟