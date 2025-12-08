import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:dartz/dartz.dart';

 /// Repository interface for game analysis operations
/// واجهة المستودع لعمليات تحليل الألعاب
abstract class GameAnalysisRepository {
  /// Save game analysis
  /// حفظ تحليل اللعبة
  Future<Either<Failure, GameAnalysisEntity>> saveAnalysis(
    GameAnalysisEntity analysis,
  );

  /// Get analysis by game UUID
  /// الحصول على التحليل بواسطة UUID اللعبة
  Future<Either<Failure, GameAnalysisEntity?>> getAnalysisByGameUuid(
    String gameUuid,
  );

  /// Get all saved analyses
  /// الحصول على جميع التحليلات المحفوظة
  Future<Either<Failure, List<GameAnalysisEntity>>> getAllAnalyses();

  /// Delete analysis
  /// حذف التحليل
  Future<Either<Failure, void>> deleteAnalysis(String gameUuid);

  /// Check if analysis exists for game
  /// التحقق من وجود تحليل للعبة
  Future<Either<Failure, bool>> hasAnalysis(String gameUuid);
}
