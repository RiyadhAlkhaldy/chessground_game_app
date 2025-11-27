import 'dart:ffi';
import 'dart:io';

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/move_data.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider_windows/path_provider_windows.dart'; // Import the Linux path provider

// مسار مؤقت يتم إنشاؤه لبيئة الاختبار
class MockPathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return 'test/temp_isar_dir';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    // نستخدم مساراً صالحاً للاختبارات (يجب أن يكون مساراً موجوداً أو سيتم إنشاؤه)
    return 'test/temp_isar_dir';
  }

  // أضف أي دوال أخرى قد تحتاجها هنا
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // final isar = await openTempIsar([IntModelSchema]);
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    PathProviderPlatform.instance = PathProviderWindows();
    // final tempDir = await PathProviderPlatform.instance
    //     .getApplicationSupportPath();
    Directory.systemTemp.createSync();
    debugPrint('Using temp directory: ${Directory.systemTemp.path}');
    await Isar.initializeIsarCore(
      libraries: {Abi.windowsArm64: Directory.systemTemp.path},
    );

    // set temp directory for path_provider
    // // depending on test env you might need to override platform interface - else tests may fail
    // // PathProviderPlatform.instance = FakePathProvider(tempDir.path);
    await ChessGameStorageService.initForTest(
      Directory.systemTemp.path,
    ); // اضف دالة initForTest تأخذ المسار المؤقت
    // await ChessGameStorageService.init();
  });

  group('Isar integration', () {
    test('create player and game and add move', () async {
      final storage = ChessGameStorageService();
      final p = Player(
        uuid: 'u1',
        name: 'Tester',
        type: 'human',
        playerRating: 1200,
      );
      await storage.upsertPlayer(p);
      final g = ChessGame();
      final started = await storage.startNewGame(
        chessGame: g,
        white: p,
        black: Player(uuid: 'u2', name: 'Engine', type: 'computer'),
        headers: {'White': 'Tester', 'Black': 'Engine'},
      );
      expect(started.id, isNonZero);

      final move = MoveData()
        ..san = 'e4'
        ..lan = 'e2e4';
      final updated = await storage.addMoveToGame(started.id, move);

      expect(updated.movesCount, 1);
    });
  });
}
