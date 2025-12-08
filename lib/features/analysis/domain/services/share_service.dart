// lib/features/analysis/domain/services/share_service.dart

import 'dart:io';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/services/pgn_export_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for sharing games and analysis
/// خدمة لمشاركة الألعاب والتحليل
class ShareService {
  /// Share game as PGN file
  /// مشاركة اللعبة كملف PGN
  static Future<void> shareGameAsPgn(
    ChessGameEntity game,
    GameState gameState, {
    GameAnalysisEntity? analysis,
  }) async {
    try {
      AppLogger.info('Sharing game as PGN', tag: 'ShareService');

      final fileData = PgnExportService.exportToFile(
        game,
        gameState,
        analysis: analysis,
      );

      // Create temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${fileData['fileName']}');
      await file.writeAsString(fileData['content']!);

      // Share file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
            'Chess Game: ${game.whitePlayer.name} vs ${game.blackPlayer.name}',
      );

      AppLogger.info('Game shared successfully', tag: 'ShareService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error sharing game',
        error: e,
        stackTrace: stackTrace,
        tag: 'ShareService',
      );
      rethrow;
    }
  }

  /// Share analysis as text
  /// مشاركة التحليل كنص
  static Future<void> shareAnalysisAsText(
    ChessGameEntity game,
    GameState gameState,
    GameAnalysisEntity analysis,
  ) async {
    try {
      AppLogger.info('Sharing analysis as text', tag: 'ShareService');

      final text = PgnExportService.createShareableAnalysis(
        game,
        gameState,
        analysis,
      );

      await Share.share(
        text,
        subject:
            'Chess Analysis: ${game.whitePlayer.name} vs ${game.blackPlayer.name}',
      );

      AppLogger.info('Analysis shared successfully', tag: 'ShareService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error sharing analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'ShareService',
      );
      rethrow;
    }
  }

  /// Share game URL (if hosted online)
  /// مشاركة رابط اللعبة (إذا كانت متاحة على الإنترنت)
  static Future<void> shareGameUrl(String gameUrl) async {
    try {
      AppLogger.info('Sharing game URL', tag: 'ShareService');

      await Share.share(gameUrl, subject: 'Check out this chess game!');

      AppLogger.info('URL shared successfully', tag: 'ShareService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error sharing URL',
        error: e,
        stackTrace: stackTrace,
        tag: 'ShareService',
      );
      rethrow;
    }
  }
}
