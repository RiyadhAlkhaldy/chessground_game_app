// lib/features/analysis/data/datasources/game_analysis_datasource.dart

import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/data/collections/game_analysis.dart';
import 'package:chessground_game_app/features/analysis/data/models/game_analysis_model.dart';
import 'package:isar/isar.dart';

/// DataSource for game analysis operations
/// مصدر البيانات لعمليات تحليل الألعاب
abstract class GameAnalysisDataSource {
  Future<GameAnalysisModel> saveAnalysis(GameAnalysisModel analysis);
  Future<GameAnalysisModel?> getAnalysisByGameUuid(String gameUuid);
  Future<List<GameAnalysisModel>> getAllAnalyses();
  Future<void> deleteAnalysis(String gameUuid);
  Future<bool> hasAnalysis(String gameUuid);
}

/// Implementation of GameAnalysisDataSource using Isar
/// تنفيذ مصدر بيانات تحليل الألعاب باستخدام Isar
class GameAnalysisDataSourceImpl implements GameAnalysisDataSource {
  final Isar isar;

  GameAnalysisDataSourceImpl({required this.isar});

  @override
  Future<GameAnalysisModel> saveAnalysis(GameAnalysisModel analysis) async {
    try {
      AppLogger.info(
        'Saving game analysis for game: ${analysis.gameUuid}',
        tag: 'GameAnalysisDataSource',
      );

      final collection = GameAnalysis()
        ..gameUuid = analysis.gameUuid
        ..moveEvaluationsJson = analysis.moveEvaluationsJson
        ..whiteAccuracy = analysis.whiteAccuracy
        ..blackAccuracy = analysis.blackAccuracy
        ..whiteBlunders = analysis.whiteBlunders
        ..blackBlunders = analysis.blackBlunders
        ..whiteMistakes = analysis.whiteMistakes
        ..blackMistakes = analysis.blackMistakes
        ..whiteInaccuracies = analysis.whiteInaccuracies
        ..blackInaccuracies = analysis.blackInaccuracies
        ..openingName = analysis.openingName
        ..eco = analysis.eco
        ..completionPercentage = analysis.completionPercentage
        ..analyzedAt = analysis.analyzedAt;

      await isar.writeTxn(() async {
        // Check if analysis already exists
        final existing = await isar.gameAnalysis
            .filter()
            .gameUuidEqualTo(analysis.gameUuid)
            .findFirst();

        if (existing != null) {
          // Update existing
          collection.id = existing.id;
        }

        await isar.gameAnalysis.put(collection);
      });

      AppLogger.info(
        'Game analysis saved successfully',
        tag: 'GameAnalysisDataSource',
      );

      return collection.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<GameAnalysisModel?> getAnalysisByGameUuid(String gameUuid) async {
    try {
      AppLogger.info(
        'Getting analysis for game: $gameUuid',
        tag: 'GameAnalysisDataSource',
      );

      final result = await isar.gameAnalysis
          .filter()
          .gameUuidEqualTo(gameUuid)
          .findFirst();

      if (result == null) {
        AppLogger.info(
          'No analysis found for game: $gameUuid',
          tag: 'GameAnalysisDataSource',
        );
        return null;
      }

      return result.toModel();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<GameAnalysisModel>> getAllAnalyses() async {
    try {
      AppLogger.info('Getting all analyses', tag: 'GameAnalysisDataSource');

      final results = await isar.gameAnalysis.where().findAll();

      return results.map((e) => e.toModel()).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting all analyses',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteAnalysis(String gameUuid) async {
    try {
      AppLogger.info(
        'Deleting analysis for game: $gameUuid',
        tag: 'GameAnalysisDataSource',
      );

      await isar.writeTxn(() async {
        final analysis = await isar.gameAnalysis
            .filter()
            .gameUuidEqualTo(gameUuid)
            .findFirst();

        if (analysis != null) {
          await isar.gameAnalysis.delete(analysis.id);
        }
      });

      AppLogger.info(
        'Analysis deleted successfully',
        tag: 'GameAnalysisDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> hasAnalysis(String gameUuid) async {
    try {
      final count = await isar.gameAnalysis
          .filter()
          .gameUuidEqualTo(gameUuid)
          .count();

      return count > 0;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking analysis existence',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisDataSource',
      );
      return false;
    }
  }
}
