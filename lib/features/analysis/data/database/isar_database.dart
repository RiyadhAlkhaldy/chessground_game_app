// lib/features/analysis/data/database/isar_database.dart

import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/data/collections/game_analysis.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Isar Database Setup
/// إعداد قاعدة بيانات Isar
class IsarDatabase {
  static Isar? _isar;

  /// Get Isar instance
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    try {
      AppLogger.info('Initializing Isar database', tag: 'IsarDatabase');

      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [
          ChessGameSchema,
          PlayerSchema,
          GameAnalysisSchema, // NEW
        ],
        directory: dir.path,
        name: 'chess_master_db',
        inspector: true, // Enable inspector in debug mode
      );

      AppLogger.info(
        'Isar database initialized successfully',
        tag: 'IsarDatabase',
      );

      return _isar!;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Isar database',
        error: e,
        stackTrace: stackTrace,
        tag: 'IsarDatabase',
      );
      rethrow;
    }
  }

  /// Close database
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
      AppLogger.info('Isar database closed', tag: 'IsarDatabase');
    }
  }

  /// Clear all data (for testing/reset)
  static Future<void> clearAll() async {
    try {
      final isar = await getInstance();

      await isar.writeTxn(() async {
        await isar.clear();
      });

      AppLogger.info('All database data cleared', tag: 'IsarDatabase');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear database',
        error: e,
        stackTrace: stackTrace,
        tag: 'IsarDatabase',
      );
      rethrow;
    }
  }
}
