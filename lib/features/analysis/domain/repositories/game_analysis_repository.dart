import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for game analysis operations
/// واجهة المستودع لعمليات تحليل اللعبة
abstract class GameAnalysisRepository {
  /// Save game analysis to database
  /// حفظ تحليل اللعبة في قاعدة البيانات
  Future<Either<Failure, void>> saveAnalysis(GameAnalysisEntity analysis);

  /// Get game analysis by game UUID
  /// الحصول على تحليل اللعبة باستخدام UUID
  Future<Either<Failure, GameAnalysisEntity>> getAnalysisByGameUuid(
    String gameUuid,
  );

  /// Delete game analysis
  /// حذف تحليل اللعبة
  Future<Either<Failure, void>> deleteAnalysis(String gameUuid);

  /// Check if analysis exists for a game
  /// التحقق من وجود تحليل للعبة
  Future<Either<Failure, bool>> hasAnalysis(String gameUuid);
}
