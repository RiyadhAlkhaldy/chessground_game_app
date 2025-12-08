// lib/features/puzzle/presentation/controllers/puzzle_controller.dart

import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/puzzle/domain/entities/chess_puzzle_entity.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chessground_game_app/core/utils/logger.dart';

/// Controller for puzzle mode
/// المتحكم في وضع الألغاز
class PuzzleController extends GetxController {
  final StockfishController stockfishController;

  PuzzleController({required this.stockfishController});

  // ========== Observable State ==========

  /// Current puzzle
  final Rx<ChessPuzzleEntity?> _currentPuzzle = Rx<ChessPuzzleEntity?>(null);
  ChessPuzzleEntity? get currentPuzzle => _currentPuzzle.value;

  /// Puzzle game state
  final Rx<GameState?> _puzzleState = Rx<GameState?>(null);
  GameState? get puzzleState => _puzzleState.value;

  /// Current FEN
  final RxString _currentFen = ''.obs;
  String get currentFen => _currentFen.value;

  /// Solution progress (index in solution list)
  final RxInt _solutionIndex = 0.obs;
  int get solutionIndex => _solutionIndex.value;

  /// User moves made
  final RxList<String> _userMoves = <String>[].obs;
  List<String> get userMoves => _userMoves;

  /// Puzzle status
  final Rx<PuzzleStatus> _status = PuzzleStatus.ready.obs;
  PuzzleStatus get status => _status.value;

  /// Start time
  DateTime? _startTime;

  /// Hint count
  final RxInt _hintsUsed = 0.obs;
  int get hintsUsed => _hintsUsed.value;

  /// Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Error message
  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // ========== Public Methods ==========

  /// Load and start a puzzle
  /// تحميل وبدء لغز
  Future<void> loadPuzzle(ChessPuzzleEntity puzzle) async {
    try {
      _setLoading(true);
      _clearError();

      AppLogger.info('Loading puzzle: ${puzzle.id}', tag: 'PuzzleController');

      _currentPuzzle.value = puzzle;
      _solutionIndex.value = 0;
      _userMoves.clear();
      _hintsUsed.value = 0;
      _status.value = PuzzleStatus.ready;

      // Initialize game state from FEN
      final setup = Setup.parseFen(puzzle.fen);
      final position = Chess.fromSetup(setup);
      _puzzleState.value = GameState(initial: position);
      _currentFen.value = puzzle.fen;

      // Make opponent's first move (if solution starts with opponent move)
      if (puzzle.solution.isNotEmpty) {
        await _makeOpponentMove();
      }

      _startTime = DateTime.now();
      _status.value = PuzzleStatus.inProgress;

      AppLogger.info('Puzzle loaded and ready', tag: 'PuzzleController');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading puzzle',
        error: e,
        stackTrace: stackTrace,
        tag: 'PuzzleController',
      );
      _setError('Failed to load puzzle: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Handle user move
  /// معالجة حركة المستخدم
  Future<void> onUserMove(NormalMove move) async {
    try {
      if (_status.value != PuzzleStatus.inProgress) return;
      if (_currentPuzzle.value == null || _puzzleState.value == null) return;

      AppLogger.info('User move: ${move.uci}', tag: 'PuzzleController');

      // Check if move is correct
      final expectedMove =
          _currentPuzzle.value!.solution[_solutionIndex.value + 1];

      if (move.uci != expectedMove) {
        // Wrong move
        _status.value = PuzzleStatus.failed;

        Get.snackbar(
          'Incorrect Move',
          'That\'s not the best move. Try again!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        AppLogger.info(
          'Wrong move: ${move.uci} != $expectedMove',
          tag: 'PuzzleController',
        );
        return;
      }

      // Correct move - execute it
      _puzzleState.value!.play(move);
      _userMoves.add(move.uci);
      _solutionIndex.value += 2; // +2 because we skip opponent's next move
      _updateCurrentFen();

      AppLogger.info('Correct move!', tag: 'PuzzleController');

      // Check if puzzle is solved
      if (_solutionIndex.value >= _currentPuzzle.value!.solution.length) {
        await _solvePuzzle();
        return;
      }

      // Make opponent's next move
      await Future.delayed(const Duration(milliseconds: 500));
      await _makeOpponentMove();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling user move',
        error: e,
        stackTrace: stackTrace,
        tag: 'PuzzleController',
      );
      _setError('Move error: ${e.toString()}');
    }
  }

  /// Make opponent's move from solution
  /// تنفيذ حركة الخصم من الحل
  Future<void> _makeOpponentMove() async {
    if (_currentPuzzle.value == null || _puzzleState.value == null) return;
    if (_solutionIndex.value >= _currentPuzzle.value!.solution.length) return;

    try {
      final moveUci = _currentPuzzle.value!.solution[_solutionIndex.value];
      final move = Move.parse(moveUci);

      if (move is NormalMove) {
        _puzzleState.value!.play(move);
        _updateCurrentFen();

        AppLogger.debug('Opponent move: $moveUci', tag: 'PuzzleController');
      }
    } catch (e) {
      AppLogger.error(
        'Error making opponent move',
        error: e,
        tag: 'PuzzleController',
      );
    }
  }

  /// Get hint for current position
  /// الحصول على تلميح للموضع الحالي
  Future<void> getHint() async {
    try {
      if (_status.value != PuzzleStatus.inProgress) return;
      if (_currentPuzzle.value == null) return;

      _hintsUsed.value++;

      // Get next expected move from solution
      final nextMoveIndex = _solutionIndex.value + 1;
      if (nextMoveIndex >= _currentPuzzle.value!.solution.length) return;

      final hintMoveUci = _currentPuzzle.value!.solution[nextMoveIndex];
      final hintMove = Move.parse(hintMoveUci);

      if (hintMove is NormalMove) {
        Get.dialog(
          AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: 8),
                Text('Hint'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Try moving from ${_squareToAlgebraic(hintMove.from)}'),
                const SizedBox(height: 8),
                Text(
                  'Hints used: $_hintsUsed',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Got it'),
              ),
            ],
          ),
        );

        AppLogger.info('Hint given: ${hintMove.uci}', tag: 'PuzzleController');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting hint',
        error: e,
        stackTrace: stackTrace,
        tag: 'PuzzleController',
      );
    }
  }

  /// Solve puzzle successfully
  /// حل اللغز بنجاح
  Future<void> _solvePuzzle() async {
    _status.value = PuzzleStatus.solved;

    final timeTaken = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    AppLogger.gameEvent(
      'PuzzleSolved',
      data: {
        'puzzleId': _currentPuzzle.value!.id,
        'rating': _currentPuzzle.value!.rating,
        'timeTaken': timeTaken,
        'hintsUsed': _hintsUsed.value,
      },
    );

    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            SizedBox(width: 12),
            Text('Puzzle Solved!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⏱️ Time: ${timeTaken}s'),
            Text('💡 Hints: $_hintsUsed'),
            Text('⭐ Rating: ${_currentPuzzle.value!.rating}'),
            if (_currentPuzzle.value!.themes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Themes: ${_currentPuzzle.value!.themes.join(", ")}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Load next puzzle
            },
            child: const Text('Next Puzzle'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Done'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Reset puzzle to start
  /// إعادة تعيين اللغز للبداية
  void resetPuzzle() {
    if (_currentPuzzle.value != null) {
      loadPuzzle(_currentPuzzle.value!);
    }
  }

  /// Update current FEN
  /// تحديث FEN الحالي
  void _updateCurrentFen() {
    if (_puzzleState.value != null) {
      _currentFen.value = _puzzleState.value!.position.fen;
    }
  }

  /// Convert Square to algebraic notation
  String _squareToAlgebraic(Square square) {
    const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    return '${files[square.file]}${square.rank + 1}';
  }

  void _setLoading(bool value) => _isLoading.value = value;
  void _setError(String message) => _errorMessage.value = message;
  void _clearError() => _errorMessage.value = '';
}

/// Puzzle status enum
enum PuzzleStatus { ready, inProgress, solved, failed }
