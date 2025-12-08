import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/data/models/stockfish/engine_evaluation_model.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_evaluation_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_move_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of StockfishRepository
/// تنفيذ مستودع Stockfish
class StockfishRepositoryImpl implements StockfishRepository {
  final StockfishDataSource dataSource;

  StockfishRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      AppLogger.info(
        'Repository: Initializing Stockfish',
        tag: 'StockfishRepository',
      );

      await dataSource.initialize();

      AppLogger.info(
        'Repository: Stockfish initialized',
        tag: 'StockfishRepository',
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to initialize Stockfish',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to initialize engine: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> dispose() async {
    try {
      AppLogger.info(
        'Repository: Disposing Stockfish',
        tag: 'StockfishRepository',
      );

      await dataSource.dispose();

      AppLogger.info(
        'Repository: Stockfish disposed',
        tag: 'StockfishRepository',
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to dispose Stockfish',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to dispose engine: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EngineEvaluationEntity>> analyzePosition({
    required String fen,
    int depth = 20,
    int? timeLimit,
  }) async {
    try {
      AppLogger.info(
        'Repository: Analyzing position at depth $depth',
        tag: 'StockfishRepository',
      );

      final model = await dataSource.analyzePosition(
        fen: fen,
        depth: depth,
        timeLimit: timeLimit,
      );

      final entity = model.toEntity();

      AppLogger.info(
        'Repository: Position analyzed - ${entity.evaluationString}',
        tag: 'StockfishRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to analyze position',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to analyze position: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EngineMoveEntity>> getBestMove({
    required String fen,
    int depth = 20,
  }) async {
    try {
      AppLogger.info(
        'Repository: Getting best move',
        tag: 'StockfishRepository',
      );

      final bestMoveUci = await dataSource.getBestMove(fen: fen, depth: depth);

      // Get evaluation for this move
      final evaluation = await dataSource.analyzePosition(
        fen: fen,
        depth: depth,
      );

      final entity = EngineMoveEntity(
        uci: bestMoveUci,
        evaluation: evaluation.centipawns,
        isBestMove: true,
        rank: 1,
      );

      AppLogger.info(
        'Repository: Best move retrieved - $bestMoveUci',
        tag: 'StockfishRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get best move',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get best move: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EngineMoveEntity>> getBestMoveWithTime({
    required String fen,
    required int timeMilliseconds,
  }) async {
    try {
      AppLogger.info(
        'Repository: Getting best move with time limit: ${timeMilliseconds}ms',
        tag: 'StockfishRepository',
      );

      final bestMoveUci = await dataSource.getBestMoveWithTime(
        fen: fen,
        timeMilliseconds: timeMilliseconds,
      );

      // Get evaluation for this move
      final evaluation = await dataSource.analyzePosition(
        fen: fen,
        timeLimit: timeMilliseconds,
      );

      final entity = EngineMoveEntity(
        uci: bestMoveUci,
        evaluation: evaluation.centipawns,
        isBestMove: true,
        rank: 1,
      );

      AppLogger.info(
        'Repository: Best move retrieved (time-based) - $bestMoveUci',
        tag: 'StockfishRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get best move with time',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get best move with time: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EngineMoveEntity>> getBestMoveWithTimeAndDepth({
    required String fen,
    required int depth,
    required int timeMilliseconds,
  }) async {
    try {
      AppLogger.info(
        'Repository: Getting best move with depth $depth and time ${timeMilliseconds}ms',
        tag: 'StockfishRepository',
      );

      final bestMoveUci = await dataSource.getBestMoveWithTimeAndDepth(
        fen: fen,
        depth: depth,
        timeMilliseconds: timeMilliseconds,
      );

      // Get evaluation for this move
      final evaluation = await dataSource.analyzePosition(
        fen: fen,
        depth: depth,
        timeLimit: timeMilliseconds,
      );

      final entity = EngineMoveEntity(
        uci: bestMoveUci,
        evaluation: evaluation.centipawns,
        isBestMove: true,
        rank: 1,
      );

      AppLogger.info(
        'Repository: Best move retrieved (depth+time) - $bestMoveUci',
        tag: 'StockfishRepository',
      );

      return Right(entity);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get best move with time and depth',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message:
              'Failed to get best move with time and depth: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<EngineMoveEntity>>> getMoveSuggestions({
    required String fen,
    int count = 3,
    int depth = 15,
  }) async {
    try {
      AppLogger.info(
        'Repository: Getting $count move suggestions',
        tag: 'StockfishRepository',
      );

      // Get best move
      final bestMoveResult = await getBestMove(fen: fen, depth: depth);

      if (bestMoveResult.isLeft()) {
        return bestMoveResult.fold(
          (failure) => Left(failure),
          (_) => throw Exception('Unexpected result'),
        );
      }

      final bestMove = bestMoveResult.getOrElse(() => throw Exception());

      // For now, return only best move
      // In future, can implement MultiPV for multiple suggestions
      final suggestions = [bestMove];

      AppLogger.info(
        'Repository: Retrieved ${suggestions.length} move suggestions',
        tag: 'StockfishRepository',
      );

      return Right(suggestions);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to get move suggestions',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to get move suggestions: ${e.toString()}',
          details: e,
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, EngineEvaluationEntity>> streamAnalysis({
    required String fen,
    int maxDepth = 25,
  }) {
    try {
      AppLogger.info(
        'Repository: Starting analysis stream',
        tag: 'StockfishRepository',
      );

      return dataSource
          .streamAnalysis(fen: fen, maxDepth: maxDepth)
          .map(
            (model) => Right<Failure, EngineEvaluationEntity>(model.toEntity()),
          )
          .handleError((error, stackTrace) {
            AppLogger.error(
              'Repository: Analysis stream error',
              error: error,
              stackTrace: stackTrace,
              tag: 'StockfishRepository',
            );

            return Left<Failure, EngineEvaluationEntity>(
              DatabaseFailure(
                message: 'Analysis stream error: ${error.toString()}',
              ),
            );
          });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to start analysis stream',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Stream.value(
        Left(
          DatabaseFailure(
            message: 'Failed to start analysis stream: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> stopAnalysis() async {
    try {
      await dataSource.stopAnalysis();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to stop analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(message: 'Failed to stop analysis: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> setSkillLevel(int level) async {
    try {
      AppLogger.info(
        'Repository: Setting skill level to $level',
        tag: 'StockfishRepository',
      );

      await dataSource.setSkillLevel(level);

      AppLogger.info(
        'Repository: Skill level set successfully',
        tag: 'StockfishRepository',
      );

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to set skill level',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(message: 'Failed to set skill level: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isReady() async {
    try {
      final ready = await dataSource.isReady();
      return Right(ready);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Repository: Failed to check ready state',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishRepository',
      );

      return Left(
        DatabaseFailure(
          message: 'Failed to check ready state: ${e.toString()}',
        ),
      );
    }
  }
}
