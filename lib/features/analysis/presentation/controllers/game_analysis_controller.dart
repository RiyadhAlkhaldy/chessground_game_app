import 'dart:async';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/game_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/entities/game_analysis_entity.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/get_game_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/game_analysis/save_game_analysis_usecase.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chessground_game_app/core/utils/logger.dart';

/// Controller for game analysis screen
/// المتحكم في شاشة تحليل اللعبة
class GameAnalysisController extends GetxController {
  final GetGameByUuidUseCase _getGameByUuidUseCase;
  final StockfishController _stockfishController;
  final SaveGameAnalysisUseCase _saveGameAnalysisUseCase;
  final GetGameAnalysisUseCase _getGameAnalysisUseCase;

  GameAnalysisController({
    required GetGameByUuidUseCase getGameByUuidUseCase,
    required StockfishController stockfishController,
    required SaveGameAnalysisUseCase saveGameAnalysisUseCase,
    required GetGameAnalysisUseCase getGameAnalysisUseCase,
  }) : _getGameByUuidUseCase = getGameByUuidUseCase,
       _stockfishController = stockfishController,
       _saveGameAnalysisUseCase = saveGameAnalysisUseCase,
       _getGameAnalysisUseCase = getGameAnalysisUseCase;

  // ========== Observable State ==========

  /// Current game being analyzed
  final Rx<ChessGameEntity?> _game = Rx<ChessGameEntity?>(null);
  ChessGameEntity? get game => _game.value;

  /// Game state for navigation
  final Rx<GameState?> _gameState = Rx<GameState?>(null);
  GameState? get gameState => _gameState.value;

  /// Current move index
  final RxInt _currentMoveIndex = 0.obs;
  int get currentMoveIndex => _currentMoveIndex.value;

  /// Current position FEN
  final RxString _currentFen = ''.obs;
  String get currentFen => _currentFen.value;

  /// Analysis enabled
  final RxBool _analysisEnabled = false.obs;
  bool get analysisEnabled => _analysisEnabled.value;

  /// Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Error message
  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  /// Move evaluations (cached)
  final RxMap<int, EngineEvaluationEntity> _moveEvaluations =
      <int, EngineEvaluationEntity>{}.obs;
  Map<int, EngineEvaluationEntity> get moveEvaluations => _moveEvaluations;

  // ========== Public Methods ==========

  /// Load game for analysis
  /// تحميل لعبة للتحليل
  Future<void> loadGame(String gameUuid) async {
    try {
      _setLoading(true);
      _clearError();

      AppLogger.info(
        'Loading game for analysis: $gameUuid',
        tag: 'GameAnalysisController',
      );

      // Load game
      final result = await _getGameByUuidUseCase(
        GetGameByUuidParams(uuid: gameUuid),
      );

      await result.fold(
        (failure) async {
          _setError('Failed to load game: ${failure.message}');
          AppLogger.error('Failed to load game', tag: 'GameAnalysisController');
        },
        (loadedGame) async {
          _game.value = loadedGame;

          // Restore game state
          final restoreResult = GameService.restoreGameStateFromEntity(
            loadedGame,
          );
          await restoreResult.fold(
            (failure) async {
              _setError('Failed to restore game state: ${failure.message}');
            },
            (restoredState) async {
              _gameState.value = restoredState;
              _currentMoveIndex.value = 0;
              _updateCurrentFen();

              // Load saved analysis if exists
              await _loadSavedAnalysis(gameUuid);

              AppLogger.info(
                'Game loaded for analysis',
                tag: 'GameAnalysisController',
              );

              Get.snackbar(
                'Game Loaded',
                'Ready for analysis',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisController',
      );
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadSavedAnalysis(String gameUuid) async {
    try {
      final result = await _getGameAnalysisUseCase(
        GetGameAnalysisParams(gameUuid: gameUuid),
      );

      result.fold(
        (failure) {
          AppLogger.warning(
            'No saved analysis found for game',
            tag: 'GameAnalysisController',
          );
        },
        (analysis) {
          if (analysis != null) {
            // Load cached evaluations
            _moveEvaluations.clear();
            _moveEvaluations.addAll(analysis.moveEvaluations);

            AppLogger.info(
              'Loaded ${analysis.moveEvaluations.length} cached evaluations',
              tag: 'GameAnalysisController',
            );

            Get.snackbar(
              'Analysis Loaded',
              'Found ${analysis.moveEvaluations.length} cached evaluations',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      AppLogger.warning(
        'Error loading saved analysis: $e',
        tag: 'GameAnalysisController',
      );
    }
  }

  /// Navigate to specific move
  /// الانتقال إلى حركة محددة
  void goToMove(int moveIndex) {
    if (_gameState.value == null) return;

    _currentMoveIndex.value = moveIndex;
    _gameState.value!.replayToHalfmove(moveIndex);
    _updateCurrentFen();

    // Start analysis if enabled
    if (_analysisEnabled.value) {
      _analyzeCurrentPosition();
    }
  }

  /// Go to previous move
  /// الانتقال إلى الحركة السابقة
  void previousMove() {
    if (_currentMoveIndex.value > 0) {
      goToMove(_currentMoveIndex.value - 1);
    }
  }

  /// Go to next move
  /// الانتقال إلى الحركة التالية
  void nextMove() {
    if (_gameState.value != null &&
        _currentMoveIndex.value < _gameState.value!.getMoveTokens.length - 1) {
      goToMove(_currentMoveIndex.value + 1);
    }
  }

  /// Go to first move
  /// الانتقال إلى أول حركة
  void firstMove() {
    goToMove(0);
  }

  /// Go to last move
  /// الانتقال إلى آخر حركة
  void lastMove() {
    if (_gameState.value != null) {
      goToMove(_gameState.value!.getMoveTokens.length - 1);
    }
  }

  /// Toggle real-time analysis
  /// تبديل التحليل في الوقت الفعلي
  void toggleAnalysis() {
    _analysisEnabled.value = !_analysisEnabled.value;

    if (_analysisEnabled.value) {
      _analyzeCurrentPosition();

      Get.snackbar(
        'Analysis Enabled',
        'Real-time analysis started',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      _stockfishController.stopAnalysis();

      Get.snackbar(
        'Analysis Disabled',
        'Real-time analysis stopped',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Analyze all moves in the game
  /// تحليل جميع الحركات في اللعبة
  Future<void> analyzeAllMoves() async {
    if (_gameState.value == null) return;

    try {
      _setLoading(true);
      _clearError();

      AppLogger.info('Analyzing all moves', tag: 'GameAnalysisController');

      final totalMoves = _gameState.value!.getMoveTokens.length;

      for (int i = 0; i < totalMoves; i++) {
        // Navigate to move
        goToMove(i);

        // Analyze position
        await _stockfishController.analyzePosition(
          _currentFen.value,
          depth: 18,
        );

        // Cache evaluation
        if (_stockfishController.currentEvaluation != null) {
          _moveEvaluations[i] = _stockfishController.currentEvaluation!;
        }

        // Update progress
        AppLogger.info(
          'Analyzed ${i + 1}/$totalMoves moves',
          tag: 'GameAnalysisController',
        );
      }

      AppLogger.info('All moves analyzed', tag: 'GameAnalysisController');

      Get.snackbar(
        'Analysis Complete',
        'All $totalMoves moves analyzed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error analyzing all moves',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisController',
      );
      _setError('Failed to analyze all moves: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get evaluation for a specific move
  /// الحصول على تقييم لحركة محددة
  EngineEvaluationEntity? getEvaluationForMove(int moveIndex) {
    return _moveEvaluations[moveIndex];
  }

  /// Save analysis to database
  /// حفظ التحليل في قاعدة البيانات
  Future<void> saveAnalysis() async {
    if (_game.value == null || _moveEvaluations.isEmpty) {
      Get.snackbar(
        'Cannot Save',
        'No analysis data to save',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      _setLoading(true);

      AppLogger.info('Saving game analysis', tag: 'GameAnalysisController');

      // Calculate statistics
      final stats = calculateGameStatistics();

      final analysisEntity = GameAnalysisEntity(
        gameUuid: _game.value!.uuid,
        moveEvaluations: Map<int, EngineEvaluationEntity>.from(
          _moveEvaluations,
        ),
        whiteAccuracy: stats['whiteAccuracy'],
        blackAccuracy: stats['blackAccuracy'],
        whiteBlunders: stats['whiteBlunders'],
        blackBlunders: stats['blackBlunders'],
        whiteMistakes: stats['whiteMistakes'],
        blackMistakes: stats['blackMistakes'],
        whiteInaccuracies: stats['whiteInaccuracies'],
        blackInaccuracies: stats['blackInaccuracies'],
        completionPercentage:
            (_moveEvaluations.length / _gameState.value!.getMoveTokens.length) *
            100,
        analyzedAt: DateTime.now(),
      );

      // Save using use case
      final result = await _saveGameAnalysisUseCase(
        SaveGameAnalysisParams(analysis: analysisEntity),
      );

      result.fold(
        (failure) {
          _setError('Failed to save analysis: ${failure.message}');
        },
        (savedAnalysis) {
          AppLogger.info('Game analysis saved', tag: 'GameAnalysisController');

          Get.snackbar(
            'Analysis Saved',
            'Game analysis saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving analysis',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameAnalysisController',
      );
      _setError('Failed to save analysis: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Calculate game statistics from evaluations
  /// حساب إحصائيات اللعبة من التقييمات
  Map<String, dynamic> calculateGameStatistics() {
    int whiteBlunders = 0, blackBlunders = 0;
    int whiteMistakes = 0, blackMistakes = 0;
    int whiteInaccuracies = 0, blackInaccuracies = 0;

    int? previousEval;
    bool isWhiteMove = true;

    _moveEvaluations.forEach((index, evaluation) {
      if (previousEval != null && evaluation.centipawns != null) {
        final diff = (evaluation.centipawns! - previousEval!).abs();

        // Classify move quality based on evaluation drop
        if (diff > 300) {
          // Blunder (>3 pawns)
          if (isWhiteMove) {
            whiteBlunders++;
          } else {
            blackBlunders++;
          }
        } else if (diff > 150) {
          // Mistake (>1.5 pawns)
          if (isWhiteMove) {
            whiteMistakes++;
          } else {
            blackMistakes++;
          }
        } else if (diff > 50) {
          // Inaccuracy (>0.5 pawns)
          if (isWhiteMove) {
            whiteInaccuracies++;
          } else {
            blackInaccuracies++;
          }
        }
      }

      previousEval = evaluation.centipawns;
      isWhiteMove = !isWhiteMove;
    });

    // Calculate accuracy (simplified)
    final totalWhiteMoves = (_moveEvaluations.length / 2).ceil();
    final totalBlackMoves = (_moveEvaluations.length / 2).floor();

    final whiteErrors =
        whiteBlunders * 3 + whiteMistakes * 2 + whiteInaccuracies;
    final blackErrors =
        blackBlunders * 3 + blackMistakes * 2 + blackInaccuracies;

    final whiteAccuracy = totalWhiteMoves > 0
        ? ((totalWhiteMoves - whiteErrors / 3) / totalWhiteMoves * 100).clamp(
            0,
            100,
          )
        : null;
    final blackAccuracy = totalBlackMoves > 0
        ? ((totalBlackMoves - blackErrors / 3) / totalBlackMoves * 100).clamp(
            0,
            100,
          )
        : null;

    return {
      'whiteAccuracy': whiteAccuracy,
      'blackAccuracy': blackAccuracy,
      'whiteBlunders': whiteBlunders,
      'blackBlunders': blackBlunders,
      'whiteMistakes': whiteMistakes,
      'blackMistakes': blackMistakes,
      'whiteInaccuracies': whiteInaccuracies,
      'blackInaccuracies': blackInaccuracies,
    };
  }

  // ========== Private Methods ==========

  /// Analyze current position
  /// تحليل الموضع الحالي
  void _analyzeCurrentPosition() {
    if (_currentFen.value.isNotEmpty) {
      _stockfishController.startAnalysisStream(_currentFen.value);
    }
  }

  /// Update current FEN
  /// تحديث FEN الحالي
  void _updateCurrentFen() {
    if (_gameState.value != null) {
      _currentFen.value = _gameState.value!.position.fen;
    }
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setError(String message) {
    _errorMessage.value = message;
    AppLogger.error(message, tag: 'GameAnalysisController');
  }

  void _clearError() {
    _errorMessage.value = '';
  }

  @override
  void onClose() {
    _stockfishController.stopAnalysis();
    super.onClose();
  }
}
