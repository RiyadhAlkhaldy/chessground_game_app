import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/data/collections/game_analysis.dart';
import 'package:chessground_game_app/features/analysis/data/models/game_analysis_model.dart';
import 'package:isar/isar.dart';

/// Local data source for game analysis data
/// مصدر البيانات المحلي لبيانات تحليل اللعبة
abstract class GameAnalysisLocalDataSource {
  /// Save game analysis to database
  /// حفظ تحليل اللعبة في قاعدة البيانات
  Future<void> saveAnalysis(GameAnalysisModel analysis);

  /// Get game analysis by game UUID
  /// الحصول على تحليل اللعبة باستخدام UUID
  Future<GameAnalysisModel?> getAnalysisByGameUuid(String gameUuid);

  /// Delete game analysis
  /// حذف تحليل اللعبة
  Future<void> deleteAnalysis(String gameUuid);

  /// Check if analysis exists for a game
  /// التحقق من وجود تحليل للعبة
  Future<bool> hasAnalysis(String gameUuid);
}

/// Implementation of GameAnalysisLocalDataSource
/// تنفيذ مصدر البيانات المحلي لتحليل اللعبة
class GameAnalysisLocalDataSourceImpl implements GameAnalysisLocalDataSource {
  final Isar isar;

  GameAnalysisLocalDataSourceImpl({required this.isar});

  @override
  Future<void> saveAnalysis(GameAnalysisModel analysis) async {
    try {
      AppLogger.info(
        'Saving game analysis for game: ${analysis.gameUuid}',
        tag: 'GameAnalysisLocalDataSource',
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
        await isar.gameAnalysis.put(collection);
      });

      AppLogger.info(
        'Game analysis saved successfully',
        tag: 'GameAnalysisLocalDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<GameAnalysisModel?> getAnalysisByGameUuid(String gameUuid) async {
    try {
      AppLogger.info(
        'Fetching analysis for game: $gameUuid',
        tag: 'GameAnalysisLocalDataSource',
      );

      final result = await isar.gameAnalysis
          .filter()
          .gameUuidEqualTo(gameUuid)
          .findFirst();

      if (result != null) {
        AppLogger.info(
          'Analysis found for game: $gameUuid',
          tag: 'GameAnalysisLocalDataSource',
        );
        return result.toModel();
      }

      AppLogger.info(
        'No analysis found for game: $gameUuid',
        tag: 'GameAnalysisLocalDataSource',
      );
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisLocalDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteAnalysis(String gameUuid) async {
    try {
      AppLogger.info(
        'Deleting analysis for game: $gameUuid',
        tag: 'GameAnalysisLocalDataSource',
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
        tag: 'GameAnalysisLocalDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete game analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisLocalDataSource',
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
        'Failed to check if analysis exists',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisLocalDataSource',
      );
      return false;
    }
  }
}
