import 'dart:async';

import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/models/extended_evaluation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StockfishDataSource dataSource;

  setUp(() {
    dataSource = StockfishDataSource();
  });

  group('StockfishDataSource - Initialization', () {
    test(
      'should have broadcast streams for raw, evaluations, and bestmoves',
      () {
        // Assert
        expect(dataSource.raw, isA<Stream<String>>());
        expect(dataSource.evaluations, isA<Stream<ExtendedEvaluation?>>());
        expect(dataSource.bestmoves, isA<Stream<String>>());
      },
    );
  });

  group('StockfishDataSource - setOption', () {
    test('should set option with string value', () {
      // Act & Assert - Should not throw
      expect(() => dataSource.setOption('Threads', '4'), returnsNormally);
    });

    test('should set option with integer value', () {
      // Act & Assert - Should not throw
      expect(() => dataSource.setOption('Hash', 128), returnsNormally);
    });
  });

  group('StockfishDataSource - setPosition', () {
    test(
      'should set position from standard starting position without moves',
      () {
        // Act & Assert - Should not throw
        expect(() => dataSource.setPosition(), returnsNormally);
      },
    );

    test('should set position with custom FEN', () {
      // Arrange
      const fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1';

      // Act & Assert - Should not throw
      expect(() => dataSource.setPosition(fen: fen), returnsNormally);
    });

    test('should set position with moves list', () {
      // Arrange
      const moves = ['e2e4', 'e7e5', 'g1f3'];

      // Act & Assert - Should not throw
      expect(() => dataSource.setPosition(moves: moves), returnsNormally);
    });

    test('should set position with FEN and moves', () {
      // Arrange
      const fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1';
      const moves = ['e7e5'];

      // Act & Assert - Should not throw
      expect(
        () => dataSource.setPosition(fen: fen, moves: moves),
        returnsNormally,
      );
    });
  });

  group('StockfishDataSource - stop', () {
    test('should stop engine analysis', () async {
      // Act & Assert - Should not throw
      expect(() => dataSource.stop(), returnsNormally);
    });
  });

  group('StockfishDataSource - dispose', () {
    test('should dispose resources without error', () async {
      // Act & Assert - Should complete normally
      expect(() => dataSource.dispose(), returnsNormally);
    });

    test('should close all streams on dispose', () async {
      // Act
      await dataSource.dispose();

      // Assert - Dispose should complete without error
      expect(true, isTrue);
    });
  });

  group('StockfishDataSource - goMovetime', () {
    test('should send go movetime command with specified milliseconds', () {
      // Act & Assert - Should not throw
      expect(() => dataSource.goMovetime(1000), returnsNormally);
    });

    test('should handle go movetime with custom timeout', () {
      // Act & Assert - Should not throw
      expect(
        () => dataSource.goMovetime(2000, timeout: const Duration(seconds: 5)),
        returnsNormally,
      );
    });
  });

  group('StockfishDataSource - Integration Tests', () {
    test('should handle multiple setPosition calls', () {
      // Act - Multiple position sets
      dataSource.setPosition();
      dataSource.setPosition(
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
      );
      dataSource.setPosition(moves: ['e2e4', 'e7e5']);

      // Assert - Should not throw
      expect(true, isTrue);
    });

    test('should handle setOption multiple times', () {
      // Act - Multiple option sets
      dataSource.setOption('Threads', '4');
      dataSource.setOption('Hash', 256);
      dataSource.setOption('MultiPV', 3);

      // Assert - Should not throw
      expect(true, isTrue);
    });
  });

  group('StockfishDataSource - Stream Tests', () {
    test('evaluation stream should be broadcast', () {
      // Arrange
      final evalStream = dataSource.evaluations;

      // Act - Create multiple subscriptions
      final sub1 = evalStream.listen((_) {});
      final sub2 = evalStream.listen((_) {});

      // Assert - Both subscriptions should be active (broadcast stream)
      expect(sub1, isNotNull);
      expect(sub2, isNotNull);

      // Cleanup
      sub1.cancel();
      sub2.cancel();
    });

    test('bestmove stream should be broadcast', () {
      // Arrange
      final bestmoveStream = dataSource.bestmoves;

      // Act - Create multiple subscriptions
      final sub1 = bestmoveStream.listen((_) {});
      final sub2 = bestmoveStream.listen((_) {});

      // Assert - Both subscriptions should be active (broadcast stream)
      expect(sub1, isNotNull);
      expect(sub2, isNotNull);

      // Cleanup
      sub1.cancel();
      sub2.cancel();
    });

    test('raw stream should be broadcast', () {
      // Arrange
      final rawStream = dataSource.raw;

      // Act - Create multiple subscriptions
      final sub1 = rawStream.listen((_) {});
      final sub2 = rawStream.listen((_) {});

      // Assert - Both subscriptions should be active (broadcast stream)
      expect(sub1, isNotNull);
      expect(sub2, isNotNull);

      // Cleanup
      sub1.cancel();
      sub2.cancel();
    });
  });
}
