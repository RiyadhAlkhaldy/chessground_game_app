// 📤 الخطوة المقترحة 4: مشاركة التحليل عبر PGN
// 📝 A. Export PGN Service
// lib/features/analysis/domain/services/pgn_export_service.dart

import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';

/// Service for exporting games to PGN format
/// خدمة لتصدير الألعاب بصيغة PGN
/// Service for exporting games to PGN format
/// خدمة لتصدير الألعاب بصيغة PGN
class PgnExportService {
  /// Export game to PGN string
  /// تصدير اللعبة إلى نص PGN
  static String exportGameToPgn(
    ChessGameEntity game,
    GameState gameState, {
    GameAnalysisEntity? analysis,
    bool includeEvaluations = false,
  }) {
    final StringBuffer pgn = StringBuffer();

    // Seven Tag Roster
    pgn.writeln('[Event "${game.event ?? "?"}"]');
    pgn.writeln('[Site "${game.site ?? "?"}"]');
    pgn.writeln('[Date "${_formatDate(game.date)}"]');
    pgn.writeln('[Round "${game.round ?? "?"}"]');
    pgn.writeln('[White "${game.whitePlayer.name}"]');
    pgn.writeln('[Black "${game.blackPlayer.name}"]');
    pgn.writeln('[Result "${game.result}"]');

    // Additional tags
    if (game.whiteElo != null) {
      pgn.writeln('[WhiteElo "${game.whiteElo}"]');
    }
    if (game.blackElo != null) {
      pgn.writeln('[BlackElo "${game.blackElo}"]');
    }
    if (game.eco != null) {
      pgn.writeln('[ECO "${game.eco}"]');
    }
    if (game.timeControl != null) {
      pgn.writeln('[TimeControl "${game.timeControl}"]');
    }

    // Analysis tags
    if (analysis != null) {
      if (analysis.whiteAccuracy != null) {
        pgn.writeln(
          '[WhiteAccuracy "${analysis.whiteAccuracy!.toStringAsFixed(1)}"]',
        );
      }
      if (analysis.blackAccuracy != null) {
        pgn.writeln(
          '[BlackAccuracy "${analysis.blackAccuracy!.toStringAsFixed(1)}"]',
        );
      }
      pgn.writeln('[AnalyzedAt "${_formatDate(analysis.analyzedAt)}"]');
    }

    pgn.writeln();

    // Moves
    final moves = gameState.getMoveTokens;
    for (int i = 0; i < moves.length; i++) {
      final move = moves[i];
      final isWhiteMove = i % 2 == 0;

      if (isWhiteMove) {
        final moveNumber = (i ~/ 2) + 1;
        pgn.write('$moveNumber. ');
      }

      pgn.write('${move.san} ');

      // Add evaluation comment if available
      if (includeEvaluations && analysis != null) {
        final evaluation = analysis.moveEvaluations[i];
        if (evaluation != null) {
          pgn.write('{ ${evaluation.evaluationString} } ');
        }
      }

      // Add comment if present
      if (move.comment != null && move.comment!.isNotEmpty) {
        pgn.write('{ ${move.comment} } ');
      }

      // Line break every 8 moves for readability
      if ((i + 1) % 8 == 0) {
        pgn.writeln();
      }
    }

    // Add final newline and result
    pgn.writeln();
    pgn.write(game.result);

    return pgn.toString();
  }

  /// Format date for PGN (YYYY.MM.DD format)
  /// تنسيق التاريخ لصيغة PGN
  static String _formatDate(DateTime? date) {
    if (date == null) return '????.??.??';

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year.$month.$day';
  }
}
