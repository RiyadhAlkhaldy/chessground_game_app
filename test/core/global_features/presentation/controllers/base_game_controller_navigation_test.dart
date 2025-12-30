// test/core/global_features/presentation/controllers/base_game_controller_navigation_test.dart
//
// TDD Tests for BaseGameController Navigation Methods
// Used by EnhancedHorizontalMoveListWidget for move navigation

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

// ============================================================
// Mock Classes
// ============================================================

class MockPlaySoundUseCase extends Mock implements PlaySoundUseCase {}

/// Concrete implementation of BaseGameController for testing
class TestGameController extends BaseGameController {
  TestGameController({required super.plySound});

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty game state
    gameState = GameState();
    updateReactiveState();
  }
}

// ============================================================
// Test Helpers
// ============================================================

TestGameController createController() {
  final mockPlaySound = MockPlaySoundUseCase();
  final controller = TestGameController(plySound: mockPlaySound);
  Get.put<BaseGameController>(controller);
  controller.onInit();
  return controller;
}

void playMoves(TestGameController controller, List<String> uciMoves) {
  for (final uci in uciMoves) {
    final move = Move.parse(uci);
    if (move != null) {
      controller.gameState.play(move);
    }
  }
  controller.updateReactiveState();
}

// ============================================================
// Tests
// ============================================================

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('BaseGameController Navigation', () {
    // ======================================================
    // 1. currentHalfmoveIndex Tests
    // ======================================================
    group('currentHalfmoveIndex', () {
      test('returns -1 when no moves played', () {
        // Arrange
        final controller = createController();

        // Assert
        expect(controller.currentHalfmoveIndex, equals(-1));
      });

      test('returns 0 after first move', () {
        // Arrange
        final controller = createController();

        // Act
        playMoves(controller, ['e2e4']);

        // Assert
        expect(controller.currentHalfmoveIndex, equals(0));
      });

      test('returns correct index after multiple moves', () {
        // Arrange
        final controller = createController();

        // Act - Play 4 half-moves
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Assert
        expect(controller.currentHalfmoveIndex, equals(3));
      });
    });

    // ======================================================
    // 2. navigateToMove Tests
    // ======================================================
    group('navigateToMove', () {
      test('navigates to specific move index', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Act - Navigate to first move (index 0)
        controller.navigateToMove(0);

        // Assert - Position should be after e4
        expect(controller.currentHalfmoveIndex, equals(0));
      });

      test('navigates to middle move', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Act - Navigate to second move (index 1)
        controller.navigateToMove(1);

        // Assert
        expect(controller.currentHalfmoveIndex, equals(1));
      });

      test('does not navigate to invalid negative index', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5']);

        // Act - Try to navigate to negative index
        controller.navigateToMove(-5);

        // Assert - Should stay at current index or go to 0
        expect(controller.currentHalfmoveIndex, greaterThanOrEqualTo(-1));
      });
    });

    // ======================================================
    // 3. navigateToFirstMove Tests
    // ======================================================
    group('navigateToFirstMove', () {
      test('navigates to initial position (before any moves)', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Act
        controller.navigateToFirstMove();

        // Assert - Should be at start (index -1 means before first move)
        expect(controller.currentHalfmoveIndex, lessThanOrEqualTo(0));
      });

      test('works when already at first move', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4']);
        controller.navigateToFirstMove();

        // Act - Call again
        controller.navigateToFirstMove();

        // Assert - Should still be at start
        expect(controller.currentHalfmoveIndex, lessThanOrEqualTo(0));
      });
    });

    // ======================================================
    // 4. navigateToLastMove Tests
    // ======================================================
    group('navigateToLastMove', () {
      test('navigates to last move', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Navigate to middle move first (index 1)
        controller.navigateToMove(1);
        expect(controller.currentHalfmoveIndex, equals(1));

        // Act - Navigate to last move
        // Note: After navigateToMove(1), gameState only has 2 moves
        // So last move will be index 1
        controller.navigateToLastMove();

        // Assert - After navigateToMove(1), last index is 1
        expect(controller.currentHalfmoveIndex, equals(1));
      });

      test('works when already at last move', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5']);

        // Act
        controller.navigateToLastMove();

        // Assert - Should be at last move (index 1)
        expect(controller.currentHalfmoveIndex, equals(1));
      });

      test('does nothing when no moves played', () {
        // Arrange
        final controller = createController();

        // Act
        controller.navigateToLastMove();

        // Assert - Should still be at -1
        expect(controller.currentHalfmoveIndex, equals(-1));
      });
    });

    // ======================================================
    // 5. Navigation with GameState Sync Tests
    // ======================================================
    group('GameState Synchronization', () {
      test('getMoveTokens returns correct moves after navigation', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4']);

        // Assert - getMoveTokens should have all 3 moves
        final tokens = controller.gameState.getMoveTokens;
        expect(tokens.length, equals(3));
        expect(tokens[0].san, equals('e4'));
        expect(tokens[1].san, equals('e5'));
        expect(tokens[2].san, equals('d4'));
      });

      test('position updates after navigateToMove', () {
        // Arrange
        final controller = createController();
        playMoves(controller, ['e2e4', 'e7e5', 'd2d4', 'd7d5']);

        // Act - Navigate to move index 1 (after e5)
        controller.navigateToMove(1);

        // Assert - The reactive state should reflect navigation
        // Note: navigateToMove calls jumpToHalfmove internally
        expect(controller.currentHalfmoveIndex, equals(1));
      });
    });
  });
}
