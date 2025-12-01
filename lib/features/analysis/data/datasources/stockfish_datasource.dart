import 'dart:async';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/data/models/engine_evaluation_model.dart';
import 'package:stockfish/stockfish.dart'; 

/// DataSource for Stockfish engine operations
/// مصدر البيانات لعمليات محرك Stockfish
abstract class StockfishDataSource {
  Future<void> initialize();
  Future<void> dispose();
  Future<EngineEvaluationModel> analyzePosition({
    required String fen,
    int depth = 20,
    int? timeLimit,
  });
  Future<String> getBestMove({required String fen, int depth = 20});
  Stream<EngineEvaluationModel> streamAnalysis({
    required String fen,
    int maxDepth = 25,
  });
  Future<void> stopAnalysis();
  Future<void> setSkillLevel(int level);
  Future<bool> isReady();
}

/// Implementation of StockfishDataSource
/// تنفيذ مصدر بيانات Stockfish
class StockfishDataSourceImpl implements StockfishDataSource {
  Stockfish? _stockfish;
  StreamSubscription<String>? _outputSubscription;
  final StreamController<EngineEvaluationModel> _analysisController =
      StreamController<EngineEvaluationModel>.broadcast();

  Completer<EngineEvaluationModel>? _evaluationCompleter;
  Completer<String>? _bestMoveCompleter;
  Completer<bool>? _readyCompleter;

  EngineEvaluationModel? _lastEvaluation;
  int _currentDepth = 0;

  @override
  Future<void> initialize() async {
    try {
      AppLogger.info(
        'Initializing Stockfish engine',
        tag: 'StockfishDataSource',
      );

      _stockfish = Stockfish();

      // Listen to engine output
      _outputSubscription = _stockfish!.stdout.listen(
        _handleEngineOutput,
        onError: (error) {
          AppLogger.error(
            'Stockfish output error',
            error: error,
            tag: 'StockfishDataSource',
          );
        },
      );

      // Send UCI command
      _stockfish!.stdin = 'uci';

      // Wait for engine to be ready
      await _waitForReady();

      // Set default options
      _stockfish!.stdin = 'setoption name Threads value 2';
      _stockfish!.stdin = 'setoption name Hash value 128';

      AppLogger.info(
        'Stockfish initialized successfully',
        tag: 'StockfishDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Stockfish',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      AppLogger.info('Disposing Stockfish engine', tag: 'StockfishDataSource');

      await stopAnalysis();
      await _outputSubscription?.cancel();
      await _analysisController.close();
      _stockfish?.stdin = 'quit';
      _stockfish = null;

      AppLogger.info('Stockfish disposed', tag: 'StockfishDataSource');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error disposing Stockfish',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
    }
  }

  @override
  Future<EngineEvaluationModel> analyzePosition({
    required String fen,
    int depth = 20,
    int? timeLimit,
  }) async {
    try {
      AppLogger.info(
        'Analyzing position at depth $depth',
        tag: 'StockfishDataSource',
      );

      if (_stockfish == null) {
        throw Exception('Stockfish not initialized');
      }

      // Stop any ongoing analysis
      await stopAnalysis();

      // Reset state
      _evaluationCompleter = Completer<EngineEvaluationModel>();
      _lastEvaluation = null;
      _currentDepth = 0;

      // Set position
      _stockfish!.stdin = 'position fen $fen';

      // Start analysis
      if (timeLimit != null) {
        _stockfish!.stdin = 'go movetime $timeLimit';
      } else {
        _stockfish!.stdin = 'go depth $depth';
      }

      // Wait for analysis to complete
      final evaluation = await _evaluationCompleter!.future;

      AppLogger.info(
        'Analysis complete: ${evaluation.toString()}',
        tag: 'StockfishDataSource',
      );

      return evaluation;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error analyzing position',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<String> getBestMove({required String fen, int depth = 20}) async {
    try {
      AppLogger.info('Getting best move', tag: 'StockfishDataSource');

      if (_stockfish == null) {
        throw Exception('Stockfish not initialized');
      }

      // Stop any ongoing analysis
      await stopAnalysis();

      // Reset state
      _bestMoveCompleter = Completer<String>();

      // Set position
      _stockfish!.stdin = 'position fen $fen';

      // Get best move
      _stockfish!.stdin = 'go depth $depth';

      // Wait for best move
      final bestMove = await _bestMoveCompleter!.future;

      AppLogger.info('Best move: $bestMove', tag: 'StockfishDataSource');

      return bestMove;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting best move',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
      rethrow;
    }
  }

  @override
  Stream<EngineEvaluationModel> streamAnalysis({
    required String fen,
    int maxDepth = 25,
  }) {
    try {
      AppLogger.info('Starting analysis stream', tag: 'StockfishDataSource');

      if (_stockfish == null) {
        throw Exception('Stockfish not initialized');
      }

      // Stop any ongoing analysis
      stopAnalysis();

      // Reset state
      _lastEvaluation = null;
      _currentDepth = 0;

      // Set position
      _stockfish!.stdin = 'position fen $fen';

      // Start infinite analysis
      _stockfish!.stdin = 'go infinite';

      return _analysisController.stream;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting analysis stream',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> stopAnalysis() async {
    try {
      if (_stockfish != null) {
        _stockfish!.stdin = 'stop';
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      AppLogger.warning(
        'Error stopping analysis: $e',
        tag: 'StockfishDataSource',
      );
    }
  }

  @override
  Future<void> setSkillLevel(int level) async {
    try {
      if (_stockfish == null) {
        throw Exception('Stockfish not initialized');
      }

      // Clamp level between 0 and 20
      final clampedLevel = level.clamp(0, 20);

      AppLogger.info(
        'Setting skill level to $clampedLevel',
        tag: 'StockfishDataSource',
      );

      _stockfish!.stdin = 'setoption name Skill Level value $clampedLevel';

      // Adjust other parameters based on skill level
      if (clampedLevel < 20) {
        // Add some randomness for lower levels
        final errorProb = (20 - clampedLevel) * 5;
        _stockfish!.stdin =
            'setoption name Skill Level Maximum Error value $errorProb';
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error setting skill level',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> isReady() async {
    try {
      if (_stockfish == null) return false;

      _readyCompleter = Completer<bool>();
      _stockfish!.stdin = 'isready';

      return await _readyCompleter!.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (e) {
      AppLogger.warning(
        'Error checking ready state: $e',
        tag: 'StockfishDataSource',
      );
      return false;
    }
  }

  /// Wait for engine to be ready
  /// الانتظار حتى يصبح المحرك جاهزاً
  Future<void> _waitForReady() async {
    _readyCompleter = Completer<bool>();
    _stockfish!.stdin = 'isready';
    await _readyCompleter!.future;
  }

  /// Handle engine output
  /// معالجة مخرجات المحرك
  void _handleEngineOutput(String line) {
    try {
      AppLogger.debug('Engine output: $line', tag: 'StockfishDataSource');

      // Handle readyok
      if (line.trim() == 'readyok') {
        if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
          _readyCompleter!.complete(true);
        }
        return;
      }

      // Handle info lines (evaluation updates)
      if (line.startsWith('info')) {
        _handleInfoLine(line);
        return;
      }

      // Handle bestmove
      if (line.startsWith('bestmove')) {
        _handleBestMoveLine(line);
        return;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling engine output',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishDataSource',
      );
    }
  }

  /// Handle info line from engine
  /// معالجة سطر معلومات من المحرك
  void _handleInfoLine(String line) {
    try {
      final parts = line.split(' ');

      int? depth;
      int? nodes;
      int? time;
      int? cp;
      int? mate;
      String? bestMove;
      List<String> pv = [];

      for (int i = 0; i < parts.length; i++) {
        switch (parts[i]) {
          case 'depth':
            if (i + 1 < parts.length) depth = int.tryParse(parts[i + 1]);
            break;
          case 'nodes':
            if (i + 1 < parts.length) nodes = int.tryParse(parts[i + 1]);
            break;
          case 'time':
            if (i + 1 < parts.length) time = int.tryParse(parts[i + 1]);
            break;
          case 'cp':
            if (i + 1 < parts.length) cp = int.tryParse(parts[i + 1]);
            break;
          case 'mate':
            if (i + 1 < parts.length) mate = int.tryParse(parts[i + 1]);
            break;
          case 'pv':
            // Principal variation starts here
            pv = parts.sublist(i + 1);
            if (pv.isNotEmpty) bestMove = pv.first;
            break;
        }
      }

      // Only process if we have depth and bestMove
      if (depth != null && bestMove != null) {
        _currentDepth = depth;

        final evaluation = EngineEvaluationModel(
          centipawns: cp,
          mate: mate,
          depth: depth,
          nodes: nodes,
          bestMove: bestMove,
          pv: pv,
          time: time,
        );

        _lastEvaluation = evaluation;

        // Add to stream
        if (!_analysisController.isClosed) {
          _analysisController.add(evaluation);
        }
      }
    } catch (e) {
      AppLogger.warning(
        'Error parsing info line: $e',
        tag: 'StockfishDataSource',
      );
    }
  }

  /// Handle bestmove line from engine
  /// معالجة سطر أفضل حركة من المحرك
  void _handleBestMoveLine(String line) {
    try {
      final parts = line.split(' ');
      if (parts.length >= 2) {
        final bestMove = parts[1];

        // Complete best move completer
        if (_bestMoveCompleter != null && !_bestMoveCompleter!.isCompleted) {
          _bestMoveCompleter!.complete(bestMove);
        }

        // Complete evaluation completer with last evaluation
        if (_evaluationCompleter != null &&
            !_evaluationCompleter!.isCompleted) {
          if (_lastEvaluation != null) {
            _evaluationCompleter!.complete(_lastEvaluation);
          } else {
            // Create a minimal evaluation
            _evaluationCompleter!.complete(
              EngineEvaluationModel(depth: _currentDepth, bestMove: bestMove),
            );
          }
        }
      }
    } catch (e) {
      AppLogger.warning(
        'Error parsing bestmove line: $e',
        tag: 'StockfishDataSource',
      );
    }
  }
}
