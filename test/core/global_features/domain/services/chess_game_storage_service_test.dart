import 'dart:io';

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/move_data.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:uuid/uuid.dart';

/// 🧪 Mock لتوفير مسار للتخزين (لأن path_provider يحتاج بيئة حقيقية)
class TestPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async {
    final dir = Directory.systemTemp.createTempSync();
    return dir.path;
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Isar isar;
  late ChessGameStorageService storage;
  late Player white;
  late Player black;
  late ChessGame activeGame;

  setUpAll(() async {
    // تسجيل mock بدلاً من path_provider الحقيقي
    PathProviderPlatform.instance = TestPathProviderPlatform();
    await Isar.initializeIsarCore(download: true);

    final dir = await PathProviderPlatform.instance.getApplicationSupportPath();
    
    isar = await Isar.open(
      [ChessGameSchema, PlayerSchema],
      directory: dir!,
      name: 'test_instance_${const Uuid().v4()}', // Unique name
    );
    
    storage = ChessGameStorageService(isar);

    // تنظيف قاعدة البيانات قبل كل الاختبارات
    await storage.clearAll();
  });

  tearDownAll(() async {
    await isar.close();
  });

  group('ChessGameStorageService tests', () {
    // tearDown(() async {
    //   await storage.clearAll();
    // });

    group('🧩 Isar Database Initialization', () {
      test('يتم تهيئة قاعدة البيانات بنجاح', () async {
        expect(storage.isar, isNotNull);
      });
    });

    group('👤 Player CRUD', () {
      test('إنشاء لاعب جديد وتخزينه واسترجاعه', () async {
        final player = Player(
          uuid: const Uuid().v4(),
          name: 'Riyadh',
          type: 'human',
          playerRating: 1500,
        );

        final saved = await storage.upsertPlayer(player);
        final found = await storage.getPlayerByUuid(saved.uuid);

        expect(found, isNotNull);
        expect(found!.name, equals('Riyadh'));
        expect(found.playerRating, equals(1500));
      });

      test('createOrGetPlayerByUuid يجب أن يتجنب التكرار', () async {
        final uuid = const Uuid().v4();
        final first = await storage.createOrGetPlayerByUuid(
          uuid,
          name: 'Guest1',
          rating: 1200,
          type: 'guest',
        );
        final second = await storage.createOrGetPlayerByUuid(uuid, name: 'Updated');

        expect(first.id, equals(second.id));
        expect(second.name, equals('Updated'));
      });
    });

    group('♟️ Game Lifecycle', () {
      setUp(() async {
        await storage.clearAll();
        white = Player(uuid: const Uuid().v4(), name: 'Riyadh', type: 'human', playerRating: 1500);
        black = Player(
          uuid: const Uuid().v4(),
          name: 'Stockfish-17',
          type: 'computer',
          playerRating: 3200,
        );
        
        final headers = <String, String>{'Event': 'Casual Game', 'Site': 'MyApp', 'Round': '1'};
        activeGame = ChessGame();
        activeGame = await storage.startNewGame(
          chessGame: activeGame,
          white: white,
          black: black,
          headers: headers,
        );
      });

      test('بدء لعبة جديدة وتخزينها', () async {
        expect(activeGame.id, greaterThan(0));
        expect(activeGame.whitePlayer.value!.name, equals('Riyadh'));
        expect(activeGame.blackPlayer.value!.name, contains('Stockfish'));
      });

      test('إضافة حركة وتحديث PGN', () async {
        final move = MoveData()
          ..san = 'e4'
          ..lan = 'e2e4'
          ..comment = 'Opening move'
          ..isWhiteMove = true
          ..halfmoveIndex = 0
          ..moveNumber = 1;

        final updated = await storage.addMoveToGame(activeGame.id, move);

        expect(updated.moves.length, equals(1));
        expect(updated.moves.first.san, equals('e4'));
        expect(updated.fullPgn, contains('1. e4'));
      });

      test('إنهاء اللعبة بنتيجة وتوليد PGN نهائي', () async {
        final headers = <String, String>{
          'Event': 'Casual Game',
          'Site': 'MyApp',
          'Date': DateTime.now().toIso8601String().split('T').first,
          'Round': '1',
          'White': white.name,
          'Black': black.name,
        };

        final ended = await storage.endGame(
          activeGame,
          result: '1-0',
          movesData: activeGame.moves,
          headers: headers,
        );

        expect(ended.result, equals('1-0'));
        expect(ended.fullPgn, contains('[Result "1-0"]'));
      });

      test('جلب جميع الألعاب واسترجاعها مع اللاعبين', () async {
        final allGames = await storage.getAllGames();
        expect(allGames.isNotEmpty, isTrue);
        expect(allGames.first.whitePlayer.value!.name, equals('Riyadh'));
      });

      test('جلب ألعاب اللاعب باستخدام uuid', () async {
        final games = await storage.getGamesByPlayer(white.uuid);
        expect(games.isNotEmpty, isTrue);
        expect(games.first.whitePlayer.value!.uuid, equals(white.uuid));
      });

      test('حذف لعبة والتأكد من حذفها', () async {
        final id = activeGame.id;
        await storage.deleteGame(id);

        final allAfter = await storage.getAllGames();
        final deleted = allAfter.any((g) => g.id == id);
        expect(deleted, isFalse);
      });
    });
  });
  group('PGN builder', () {
    test('builds simple pgn with moves, nags, comment and variations', () {
      // Create a dummy service or reuse storage from setUpAll
      // Ideally should be separate but since we need Isar instance...
      // We can create a dummy one if we pass null? No, type is non-nullable.
      // We can use the 'storage' from main scope.
      
      final svc = storage;

      final headers = {
        'Event': 'TestEvent',
        'Site': 'Local',
        'Date': '2025.11.05',
        'Round': '1',
        'White': 'Alice',
        'Black': 'Bob',
      };

      final moves = <MoveData>[
        MoveData()
          ..san = 'e4'
          ..lan = 'e2e4',
        MoveData()
          ..san = 'e5'
          ..lan = 'e7e5'
          ..nags = [1]
          ..comment = 'Good move',
        MoveData()
          ..san = 'Nf3'
          ..lan = 'g1f3',
      ];

      final pgn = svc.manualPgnFromSanListForTest(headers, moves, '1-0');

      // توقع أن يحتوي PGN على رؤوس و1. e4 e5 {Good move} $1 2. Nf3 و النتيجة
      expect(pgn.contains('[Event "TestEvent"]'), isTrue);
      debugPrint(pgn);
      expect(pgn.contains('[Site "Local"]'), isTrue);
      expect(pgn.contains('1. e4  e5'), isTrue);
      expect(pgn.contains('{Good move}'), isTrue);
      expect(pgn.contains('\$1'), isTrue);
      expect(pgn.trim().endsWith('1-0'), isTrue);
    });
  });
}