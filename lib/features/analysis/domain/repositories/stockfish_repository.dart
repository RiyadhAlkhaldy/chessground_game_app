import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/engine_move_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for Stockfish engine operations
/// واجهة المستودع لعمليات محرك Stockfish
abstract class StockfishRepository {
  /// Initialize the engine
  /// تهيئة المحرك
  Future<Either<Failure, void>> initialize();

  /// Dispose the engine
  /// التخلص من المحرك
  Future<Either<Failure, void>> dispose();

  /// Analyze a position (FEN)
  /// تحليل موضع (FEN)
  Future<Either<Failure, EngineEvaluationEntity>> analyzePosition({
    required String fen,
    int depth = 20,
    int? timeLimit,
  });

  /// Get best move for a position
  /// الحصول على أفضل حركة لموضع
  Future<Either<Failure, EngineMoveEntity>> getBestMove({
    required String fen,
    int depth = 20,
  });

  /// Get best move for a position with time limit
  /// الحصول على أفضل حركة لموضع مع حد زمني
  Future<Either<Failure, EngineMoveEntity>> getBestMoveWithTime({
    required String fen,
    required int timeMilliseconds,
  });

  /// Get best move for a position with both time and depth constraints
  /// الحصول على أفضل حركة لموضع مع قيود الوقت والعمق
  Future<Either<Failure, EngineMoveEntity>> getBestMoveWithTimeAndDepth({
    required String fen,
    required int depth,
    required int timeMilliseconds,
  });

  /// Get multiple move suggestions
  /// الحصول على عدة اقتراحات للحركات
  Future<Either<Failure, List<EngineMoveEntity>>> getMoveSuggestions({
    required String fen,
    int count = 3,
    int depth = 15,
  });

  /// Stream real-time analysis updates
  /// دفق تحديثات التحليل في الوقت الفعلي
  Stream<Either<Failure, EngineEvaluationEntity>> streamAnalysis({
    required String fen,
    int maxDepth = 25,
  });

  /// Stop current analysis
  /// إيقاف التحليل الحالي
  Future<Either<Failure, void>> stopAnalysis();

  /// Set engine skill level (0-20)
  /// تعيين مستوى مهارة المحرك (0-20)
  Future<Either<Failure, void>> setSkillLevel(int level);

  /// Check if engine is ready
  /// التحقق من جاهزية المحرك
  Future<Either<Failure, bool>> isReady();
}
