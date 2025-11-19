// lib/domain/services/game_service.dart

import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart' hide IMap;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../core/errors/failures.dart';
import '../../core/game_termination_enum.dart';
import '../../core/utils/game_state/game_state.dart';
import '../../core/utils/logger.dart';
import '../converters/game_state_converter.dart';
import '../entities/chess_game_entity.dart';

/// Domain service for game logic operations
/// خدمة النطاق لعمليات منطق اللعبة
class GameService {
  /// Validate if a move is legal in the current position
  /// التحقق من صحة الحركة في الموضع الحالي
  static Either<Failure, bool> validateMove(GameState gameState, Move move) {
    try {
      final isLegal = gameState.position.isLegal(move);

      if (!isLegal) {
        AppLogger.warning(
          'Illegal move attempted: ${move.uci}',
          tag: 'GameService',
        );
        return Left(InvalidMoveFailure(message: 'This move is not legal'));
      }

      return const Right(true);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error validating move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameService',
      );
      return Left(
        GameStateFailure(message: 'Failed to validate move: ${e.toString()}'),
      );
    }
  }

  /// Execute a move and return updated GameState
  /// تنفيذ حركة وإرجاع GameState المحدث
  static Either<Failure, GameState> executeMove(
    GameState gameState,
    Move move, {
    String? comment,
    List<int>? nags,
  }) {
    try {
      // Validate move first
      final validation = validateMove(gameState, move);
      if (validation.isLeft()) {
        return Left(validation.fold((l) => l, (r) => throw Exception()));
      }

      // Execute the move
      gameState.play(move, comment: comment, nags: nags ?? []);

      AppLogger.move(
        gameState.lastMoveMeta?.san ?? move.uci,
        fen: gameState.position.fen,
        isCheck: gameState.isCheck,
      );

      return Right(gameState);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error executing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameService',
      );
      return Left(
        GameStateFailure(message: 'Failed to execute move: ${e.toString()}'),
      );
    }
  }

  /// Check if game should end and determine result
  /// التحقق من ضرورة انتهاء اللعبة وتحديد النتيجة
  static Either<Failure, GameTermination> checkGameTermination(
    GameState gameState,
  ) {
    try {
      if (gameState.isCheckmate) {
        return const Right(GameTermination.checkmate);
      }

      if (gameState.isStalemate) {
        return const Right(GameTermination.stalemate);
      }

      if (gameState.isInsufficientMaterial) {
        return const Right(GameTermination.insufficientMaterial);
      }

      if (gameState.isThreefoldRepetition()) {
        return const Right(GameTermination.threefoldRepetition);
      }

      if (gameState.isFiftyMoveRule()) {
        return const Right(GameTermination.fiftyMoveRule);
      }

      if (gameState.isResigned()) {
        return const Right(GameTermination.resignation);
      }

      if (gameState.isTimeout()) {
        return const Right(GameTermination.timeout);
      }

      if (gameState.isAgreedDraw()) {
        return const Right(GameTermination.agreement);
      }

      return const Right(GameTermination.ongoing);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking game termination',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameService',
      );
      return Left(
        GameStateFailure(
          message: 'Failed to check game termination: ${e.toString()}',
        ),
      );
    }
  }

  /// Calculate game result string based on termination
  /// حساب نص نتيجة اللعبة بناءً على نوع الإنهاء
  static String calculateResult(
    GameState gameState,
    GameTermination termination,
  ) {
    if (termination == GameTermination.ongoing) {
      return '*';
    }
    if (gameState.result == null) {
      return '*';
    }

    if (gameState.result == Outcome.draw) {
      return '1/2-1/2';
    }

    if (gameState.result!.winner == Side.white) {
      return '1-0';
    }

    if (gameState.result!.winner == Side.black) {
      return '0-1';
    }

    return '*';
  }

  /// Sync GameState changes to ChessGameEntity
  /// مزامنة تغييرات GameState مع ChessGameEntity
  static Either<Failure, ChessGameEntity> syncGameStateToEntity(
    GameState gameState,
    ChessGameEntity existingGame,
  ) {
    try {
      AppLogger.debug(
        'Syncing GameState to ChessGameEntity: ${existingGame.uuid}',
        tag: 'GameService',
      );
      // Convert GameState to Entity
      final gameStateEntity = GameStateConverter.toEntity(
        gameState,
        existingGame.uuid,
      );

      // Convert move entities
      final moves = gameStateEntity.moves;

      // Determine termination
      final termination = checkGameTermination(
        gameState,
      ).fold((failure) => GameTermination.ongoing, (term) => term);

      // Calculate result
      final result = calculateResult(gameState, termination);

      // Update existing game
      final updatedGame = existingGame.copyWith(
        moves: moves,
        movesCount: moves.length,
        result: result,
        termination: termination,
        fullPgn: gameState.pgnString(
          headers: {
            'Event': existingGame.event ?? '?',
            'Site': existingGame.site ?? '?',
            'Date': existingGame.date?.toString().split(' ')[0] ?? '????.??.??',
            'Round': existingGame.round ?? '?',
            'White': existingGame.whitePlayer.name,
            'Black': existingGame.blackPlayer.name,
          },
        ),
      );

      AppLogger.debug(
        'Successfully synced GameState to Entity',
        tag: 'GameService',
      );

      return Right(updatedGame);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error syncing GameState to Entity',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameService',
      );
      return Left(
        GameStateFailure(message: 'Failed to sync game state: ${e.toString()}'),
      );
    }
  }

  /// Restore GameState from ChessGameEntity
  /// استعادة GameState من ChessGameEntity
  static Either<Failure, GameState> restoreGameStateFromEntity(
    ChessGameEntity game,
  ) {
    try {
      AppLogger.debug(
        'Restoring GameState from ChessGameEntity: ${game.uuid}',
        tag: 'GameService',
      );
      // Parse starting position
      final startingFen = game.startingFen ?? Chess.initial.fen;
      final initialPosition = Chess.fromSetup(Setup.parseFen(startingFen));

      // Create GameState
      final gameState = GameState(initial: initialPosition);

      // Replay all moves
      for (final moveEntity in game.moves) {
        if (moveEntity.lan != null) {
          final move = Move.parse(moveEntity.lan!);
          gameState.play(
            move!,
            comment: moveEntity.comment,
            nags: moveEntity.nags,
          );
        }
      }

      AppLogger.debug('Successfully restored GameState', tag: 'GameService');

      return Right(gameState);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error restoring GameState',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameService',
      );
      return Left(
        GameStateFailure(
          message: 'Failed to restore game state: ${e.toString()}',
        ),
      );
    }
  }

  /// Get legal moves for current position
  /// الحصول على الحركات القانونية للموضع الحالي
  static IMap<Square, SquareSet> getLegalMoves(GameState gameState) {
    return gameState.position.legalMoves;
  }

  /// Parse move from UCI string
  /// تحليل الحركة من نص UCI
  static Either<Failure, Move> parseMoveFromUci(
    GameState gameState,
    String uci,
  ) {
    try {
      final move = Move.parse(uci);
      // Validate if move is legal
      final validation = validateMove(gameState, move!);
      if (validation.isLeft()) {
        return Left(validation.fold((l) => l, (r) => throw Exception()));
      }

      return Right(move);
    } catch (e) {
      return Left(InvalidMoveFailure(message: 'Invalid UCI move: $uci'));
    }
  }

  /// Parse move from SAN string
  /// تحليل الحركة من نص SAN
  static Either<Failure, Move> parseMoveFromSan(
    GameState gameState,
    String san,
  ) {
    try {
      final legalMoves = getLegalMoves(gameState);
      for (final entry in legalMoves.entries) {
        final from = entry.key;
        for (final to in entry.value.squares) {
          final move = NormalMove(from: from, to: to);
          final record = gameState.position.makeSan(move);
          if (record.$2 == san) {
            return Right(move);
          }
        }
      }

      return Left(InvalidMoveFailure(message: 'Move not found: $san'));
    } catch (e) {
      return Left(InvalidMoveFailure(message: 'Invalid SAN move: $san'));
    }
  }

  /// Check if position is drawn by insufficient material
  /// التحقق من التعادل بسبب عدم كفاية المواد
  static bool isInsufficientMaterial(GameState gameState) {
    return gameState.isInsufficientMaterial;
  }

  /// Get material difference (positive = white advantage)
  /// الحصول على فارق المواد (موجب = ميزة للأبيض)
  static int getMaterialDifference(GameState gameState) {
    return gameState.getMaterialAdvantageSignedForWhite;
  }

  /// Calculate position evaluation (simple material count)
  /// حساب تقييم الموضع (عد المواد البسيط)
  static double evaluatePosition(GameState gameState) {
    return gameState.materialScore();
  }
}
