import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';

// Mocks
class MockPlaySoundUseCase extends Mock implements PlaySoundUseCase {}

// A concrete implementation of the abstract BaseGameController for testing
class TestGameController extends BaseGameController {
  TestGameController({required super.plySound});

  // Expose error for testing, since the original is private
  String? testErrorMessage;

  @override
  void setError(String message) {
    testErrorMessage = message;
    super.setError(message);
  }
}

void main() {
  late TestGameController controller;
  late MockPlaySoundUseCase mockPlaySoundUseCase;

  setUp(() {
    mockPlaySoundUseCase = MockPlaySoundUseCase();

    // Stub all the use case calls to prevent null errors
    when(
      () => mockPlaySoundUseCase.executeMoveSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executeCaptureSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executeCheckSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executeCheckmateSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executePromoteSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executeResignSound(),
    ).thenAnswer((_) async {});
    when(
      () => mockPlaySoundUseCase.executeDongSound(),
    ).thenAnswer((_) async {});

    controller = TestGameController(plySound: mockPlaySoundUseCase);

    Get.put<BaseGameController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('BaseGameController Tests', () {
    test('Initial state should be correct', () {
      expect(controller.currentFen, equals(Chess.initial.fen));
      expect(controller.isGameOver, isFalse);
      expect(controller.pgnTokens, isEmpty);
      expect(controller.canUndo.value, isFalse);
    });

    test('onUserMove with a legal move should update game state', () {
      // GIVEN an initial position
      final initialFen = controller.currentFen;
      final move = NormalMove.fromUci('e2e4');

      // WHEN a legal move is made
      controller.onUserMove(move);

      // THEN the game state should be updated
      expect(controller.currentFen, isNot(equals(initialFen)));
      expect(controller.pgnTokens, hasLength(1));
      expect(controller.pgnTokens.first.san, equals('e4'));
      expect(controller.canUndo.value, isTrue);
      expect(controller.testErrorMessage, isNull);

      // Verify sound was played
      verify(() => mockPlaySoundUseCase.executeMoveSound()).called(1);
    });

    test(
      'onUserMove with an illegal move should set an error and not update state',
      () {
        // GIVEN an initial position
        final initialFen = controller.currentFen;
        final illegalMove = NormalMove.fromUci('e2e5');

        // WHEN an illegal move is made
        controller.onUserMove(illegalMove);

        // THEN the game state should NOT be updated
        expect(controller.currentFen, equals(initialFen));
        expect(controller.pgnTokens, isEmpty);

        // AND the correct error key should be set
        expect(controller.testErrorMessage, equals('invalidMoveError'));
      },
    );

    test('undoMove should revert the game state', () {
      // GIVEN a move has been made
      final move = NormalMove.fromUci('e2e4');
      controller.onUserMove(move);
      final fenAfterMove = controller.currentFen;

      // WHEN undoMove is called
      controller.undoMove();

      // THEN the game state should revert
      expect(controller.currentFen, isNot(equals(fenAfterMove)));
      expect(controller.currentFen, equals(Chess.initial.fen));
      expect(controller.pgnTokens, isEmpty);
      expect(controller.canUndo.value, isFalse);
    });

    test('resign should end the game and declare a winner', () async {
      // WHEN a side resigns
      await controller.resign(Side.white);

      // THEN the game should be over and the result set
      expect(controller.isGameOver, isTrue);
      expect(controller.gameState.result?.winner, equals(Side.black));
      verify(() => mockPlaySoundUseCase.executeResignSound()).called(1);
    });

    test('Making a move in a game that is over should not be allowed', () async {
      // GIVEN the game is over
      await controller.resign(Side.white);
      final fenAfterResign = controller.currentFen;

      // WHEN trying to make a move
      final move = NormalMove.fromUci('d2d4');
      controller.onUserMove(move);

      // THEN the state should not change and the correct error key should be set
      expect(controller.currentFen, equals(fenAfterResign));
      expect(controller.testErrorMessage, equals('gameOverMoveError'));
    });
  });
}
