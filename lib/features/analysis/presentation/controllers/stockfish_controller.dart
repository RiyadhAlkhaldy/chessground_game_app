import 'dart:async';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/engine_move_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_with_time_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_with_time_and_depth_usecase.dart';
import 'package:get/get.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_hint_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/stream_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/set_engine_level_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/analyze_position_usecase.dart';

/// Controller for Stockfish engine operations
/// المتحكم في عمليات محرك Stockfish
class StockfishController extends GetxController {
  final StockfishRepository _repository;
  final AnalyzePositionUseCase _analyzePositionUseCase;
  final GetBestMoveUseCase _getBestMoveUseCase;
  final GetBestMoveWithTimeUseCase _getBestMoveWithTimeUseCase;
  final GetBestMoveWithTimeAndDepthUseCase _getBestMoveWithTimeAndDepthUseCase;
  final GetHintUseCase _getHintUseCase;
  final StreamAnalysisUseCase _streamAnalysisUseCase;
  final SetEngineLevelUseCase _setEngineLevelUseCase;

  StockfishController({
    required StockfishRepository repository,
    required AnalyzePositionUseCase analyzePositionUseCase,
    required GetBestMoveUseCase getBestMoveUseCase,
    required GetBestMoveWithTimeUseCase getBestMoveWithTimeUseCase,
    required GetBestMoveWithTimeAndDepthUseCase
    getBestMoveWithTimeAndDepthUseCase,
    required GetHintUseCase getHintUseCase,
    required StreamAnalysisUseCase streamAnalysisUseCase,
    required SetEngineLevelUseCase setEngineLevelUseCase,
  }) : _repository = repository,
       _analyzePositionUseCase = analyzePositionUseCase,
       _getBestMoveUseCase = getBestMoveUseCase,
       _getBestMoveWithTimeUseCase = getBestMoveWithTimeUseCase,
       _getBestMoveWithTimeAndDepthUseCase = getBestMoveWithTimeAndDepthUseCase,
       _getHintUseCase = getHintUseCase,
       _streamAnalysisUseCase = streamAnalysisUseCase,
       _setEngineLevelUseCase = setEngineLevelUseCase;

  // ========== Observable State ==========

  /// Engine initialization state
  final RxBool _isInitialized = false.obs;
  bool get isInitialized => _isInitialized.value;

  /// Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Analyzing state
  final RxBool _isAnalyzing = false.obs;
  bool get isAnalyzing => _isAnalyzing.value;

  /// Current evaluation
  final Rx<EngineEvaluationEntity?> _currentEvaluation =
      Rx<EngineEvaluationEntity?>(null);
  EngineEvaluationEntity? get currentEvaluation => _currentEvaluation.value;

  /// Best move
  final Rx<EngineMoveEntity?> _bestMove = Rx<EngineMoveEntity?>(null);
  EngineMoveEntity? get bestMove => _bestMove.value;

  /// Hint move
  final Rx<EngineMoveEntity?> _hintMove = Rx<EngineMoveEntity?>(null);
  EngineMoveEntity? get hintMove => _hintMove.value;

  /// Engine skill level (0-20)
  final RxInt _skillLevel = 20.obs;
  int get skillLevel => _skillLevel.value;

  /// Error message
  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  /// Analysis stream subscription
  StreamSubscription<dynamic>? _analysisSubscription;

  // ========== Lifecycle Methods ==========

  @override
  void onInit() {
    super.onInit();
    _initializeEngine();
  }

  @override
  void onClose() {
    _disposeEngine();
    super.onClose();
  }

  // ========== Public Methods ==========

  /// Initialize Stockfish engine
  /// تهيئة محرك Stockfish
  Future<void> _initializeEngine() async {
    try {
      _setLoading(true);
      _clearError();

      AppLogger.info(
        'Initializing Stockfish engine',
        tag: 'StockfishController',
      );

      final result = await _repository.initialize();

      result.fold(
        (failure) {
          _setError('Failed to initialize engine: ${failure.message}');
          AppLogger.error(
            'Failed to initialize engine',
            tag: 'StockfishController',
          );
        },
        (_) {
          _isInitialized.value = true;
          AppLogger.info(
            'Stockfish engine initialized',
            tag: 'StockfishController',
          );

          Get.snackbar(
            'Engine Ready',
            'Stockfish engine initialized successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error initializing engine',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Dispose Stockfish engine
  /// التخلص من محرك Stockfish
  Future<void> _disposeEngine() async {
    try {
      AppLogger.info('Disposing Stockfish engine', tag: 'StockfishController');

      await stopAnalysis();
      await _repository.dispose();

      _isInitialized.value = false;

      AppLogger.info('Stockfish engine disposed', tag: 'StockfishController');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error disposing engine',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
    }
  }

  /// Analyze a position
  /// تحليل موضع
  Future<void> analyzePosition(String fen, {int depth = 20}) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      AppLogger.info('Analyzing position', tag: 'StockfishController');

      final result = await _analyzePositionUseCase(
        AnalyzePositionParams(fen: fen, depth: depth),
      );

      result.fold(
        (failure) {
          _setError('Analysis failed: ${failure.message}');
          AppLogger.error('Analysis failed', tag: 'StockfishController');
        },
        (evaluation) {
          _currentEvaluation.value = evaluation;
          AppLogger.info(
            'Analysis complete: ${evaluation.evaluationString}',
            tag: 'StockfishController',
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error analyzing position',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get best move for a position
  /// الحصول على أفضل حركة لموضع
  Future<void> getBestMove(String fen, {int depth = 20}) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      AppLogger.info('Getting best move', tag: 'StockfishController');

      final result = await _getBestMoveUseCase(
        GetBestMoveParams(fen: fen, depth: depth),
      );

      result.fold(
        (failure) {
          _setError('Failed to get best move: ${failure.message}');
          AppLogger.error(
            'Failed to get best move',
            tag: 'StockfishController',
          );
        },
        (move) {
          _bestMove.value = move;
          AppLogger.info('Best move: ${move.uci}', tag: 'StockfishController');
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting best move',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get best move for a position with time limit
  /// الحصول على أفضل حركة لموضع مع حد زمني
  Future<void> getBestMoveWithTime(
    String fen, {
    required int timeMilliseconds,
  }) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      AppLogger.info(
        'Getting best move with time: ${timeMilliseconds}ms',
        tag: 'StockfishController',
      );

      final result = await _getBestMoveWithTimeUseCase(
        GetBestMoveWithTimeParams(fen: fen, timeMilliseconds: timeMilliseconds),
      );

      result.fold(
        (failure) {
          _setError('Failed to get best move: ${failure.message}');
          AppLogger.error(
            'Failed to get best move with time',
            tag: 'StockfishController',
          );
        },
        (move) {
          _bestMove.value = move;
          AppLogger.info(
            'Best move (time-based): ${move.uci}',
            tag: 'StockfishController',
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting best move with time',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get best move for a position with both time and depth constraints
  /// الحصول على أفضل حركة لموضع مع قيود الوقت والعمق
  Future<void> getBestMoveWithTimeAndDepth(
    String fen, {
    required int depth,
    required int timeMilliseconds,
  }) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      AppLogger.info(
        'Getting best move with depth $depth and time ${timeMilliseconds}ms',
        tag: 'StockfishController',
      );

      final result = await _getBestMoveWithTimeAndDepthUseCase(
        GetBestMoveWithTimeAndDepthParams(
          fen: fen,
          depth: depth,
          timeMilliseconds: timeMilliseconds,
        ),
      );

      result.fold(
        (failure) {
          _setError('Failed to get best move: ${failure.message}');
          AppLogger.error(
            'Failed to get best move with time and depth',
            tag: 'StockfishController',
          );
        },
        (move) {
          _bestMove.value = move;
          AppLogger.info(
            'Best move (depth+time): ${move.uci}',
            tag: 'StockfishController',
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting best move with time and depth',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get hint (best move with lower depth for speed)
  /// الحصول على تلميح (أفضل حركة بعمق أقل للسرعة)
  Future<void> getHint(String fen) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _setLoading(true);
      _clearError();

      AppLogger.info('Getting hint', tag: 'StockfishController');

      final result = await _getHintUseCase(
        GetHintParams(fen: fen, depth: 12), // Lower depth for faster hints
      );

      result.fold(
        (failure) {
          _setError('Failed to get hint: ${failure.message}');
          AppLogger.error('Failed to get hint', tag: 'StockfishController');
        },
        (move) {
          _hintMove.value = move;
          AppLogger.info('Hint: ${move.uci}', tag: 'StockfishController');

          Get.snackbar(
            'Hint',
            'Suggested move: ${move.san ?? move.uci}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting hint',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Start real-time analysis stream
  /// بدء دفق التحليل في الوقت الفعلي
  void startAnalysisStream(String fen, {int maxDepth = 25}) {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Stop any existing analysis
      stopAnalysis();

      _clearError();
      _isAnalyzing.value = true;

      AppLogger.info('Starting analysis stream', tag: 'StockfishController');

      final stream = _streamAnalysisUseCase(
        StreamAnalysisParams(fen: fen, maxDepth: maxDepth),
      );

      _analysisSubscription = stream.listen(
        (result) {
          result.fold(
            (failure) {
              _setError('Analysis error: ${failure.message}');
              stopAnalysis();
            },
            (evaluation) {
              _currentEvaluation.value = evaluation;
              AppLogger.debug(
                'Analysis update: depth ${evaluation.depth}, eval ${evaluation.evaluationString}',
                tag: 'StockfishController',
              );
            },
          );
        },
        onError: (error) {
          AppLogger.error(
            'Analysis stream error',
            error: error,
            tag: 'StockfishController',
          );
          _setError('Analysis stream error');
          stopAnalysis();
        },
        onDone: () {
          AppLogger.info(
            'Analysis stream completed',
            tag: 'StockfishController',
          );
          _isAnalyzing.value = false;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting analysis stream',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
      _isAnalyzing.value = false;
    }
  }

  /// Stop current analysis
  /// إيقاف التحليل الحالي
  Future<void> stopAnalysis() async {
    try {
      if (_analysisSubscription != null) {
        await _analysisSubscription!.cancel();
        _analysisSubscription = null;
      }

      await _repository.stopAnalysis();

      _isAnalyzing.value = false;

      AppLogger.info('Analysis stopped', tag: 'StockfishController');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error stopping analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
    }
  }

  /// Set engine skill level
  /// تعيين مستوى مهارة المحرك
  Future<void> setSkillLevel(int level) async {
    try {
      if (!_isInitialized.value) {
        Get.snackbar(
          'Engine Not Ready',
          'Please wait for engine initialization',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _clearError();

      AppLogger.info(
        'Setting skill level to $level',
        tag: 'StockfishController',
      );

      final result = await _setEngineLevelUseCase(
        SetEngineLevelParams(level: level),
      );

      result.fold(
        (failure) {
          _setError('Failed to set skill level: ${failure.message}');
          AppLogger.error(
            'Failed to set skill level',
            tag: 'StockfishController',
          );
        },
        (_) {
          _skillLevel.value = level;
          AppLogger.info(
            'Skill level set to $level',
            tag: 'StockfishController',
          );

          Get.snackbar(
            'Engine Level',
            'Skill level set to $level',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error setting skill level',
        error: e,
        stackTrace: stackTrace,
        tag: 'StockfishController',
      );
      _setError('Unexpected error: ${e.toString()}');
    }
  }

  /// Clear current evaluation and moves
  /// مسح التقييم والحركات الحالية
  void clearEvaluation() {
    _currentEvaluation.value = null;
    _bestMove.value = null;
    _hintMove.value = null;
  }

  // ========== Private Methods ==========

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setError(String message) {
    _errorMessage.value = message;
    AppLogger.error(message, tag: 'StockfishController');
  }

  void _clearError() {
    _errorMessage.value = '';
  }
}
