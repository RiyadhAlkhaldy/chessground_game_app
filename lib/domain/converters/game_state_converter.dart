// lib/domain/converters/game_state_converter.dart

import 'package:dartchess/dartchess.dart';

import '../../core/game_termination_enum.dart';
import '../../core/utils/logger.dart';
import '../entities/game_state_entity.dart';
import '../entities/move_data_entity.dart';
import '../../core/utils/game_state/game_state.dart';

/// Converter between GameState (util class) and GameStateEntity (domain entity)
/// محول بين GameState (الكلاس الأداتي) و GameStateEntity (كيان النطاق)
class GameStateConverter {
  /// Convert GameState to GameStateEntity
  /// تحويل GameState إلى GameStateEntity
  static GameStateEntity toEntity(GameState gameState, String gameUuid) {
    try {
      AppLogger.debug(
        'Converting GameState to Entity for game: $gameUuid',
        tag: 'GameStateConverter',
      );

      // Extract FEN history
      final fenHistory = gameState.positionHistory
          .map((position) => position.fen)
          .toList();

      // Convert moves to entities
      final moveEntities = gameState.getMoveTokens
          .map(
            (moveModel) => MoveDataEntity(
              san: moveModel.san,
              lan: moveModel.lan,
              comment: moveModel.comment,
              nags: moveModel.nags ?? [],
              fenAfter: moveModel.fenAfter,
              variations: moveModel.variations ?? [],
              wasCapture: moveModel.wasCapture,
              wasCheck: moveModel.wasCheck,
              wasCheckmate: moveModel.wasCheckmate,
              wasPromotion: moveModel.wasPromotion,
              isWhiteMove: moveModel.isWhiteMove,
              halfmoveIndex: moveModel.halfmoveIndex,
              moveNumber: moveModel.moveNumber,
            ),
          )
          .toList();

      // Determine result string
      String? resultString;
      if (gameState.result != null) {
        if (gameState.result == Outcome.draw) {
          resultString = '1/2-1/2';
        } else if (gameState.result!.winner == Side.white) {
          resultString = '1-0';
        } else if (gameState.result!.winner == Side.black) {
          resultString = '0-1';
        }
      }

      // Determine termination
      String termination = 'ongoing';
      if (gameState.isGameOverExtended) {
        if (gameState.isCheckmate) {
          termination = GameTermination.checkmate.name;
        } else if (gameState.isTimeout()) {
          termination = GameTermination.timeout.name;
        } else if (gameState.isResigned()) {
          termination = GameTermination.resignation.name;
        } else if (gameState.isFiftyMoveRule()) {
          termination = GameTermination.fiftyMoveRule.name;
        } else if (gameState.isStalemate) {
          termination = GameTermination.stalemate.name;
        } else if (gameState.isInsufficientMaterial) {
          termination = GameTermination.insufficientMaterial.name;
        } else if (gameState.isThreefoldRepetition()) {
          termination = GameTermination.threefoldRepetition.name;
        } else if (gameState.isAgreedDraw()) {
          termination = GameTermination.agreement.name;
        }
      }

      final entity = GameStateEntity(
        gameUuid: gameUuid,
        currentFen: gameState.position.fen,
        fenHistory: fenHistory,
        fenCounts: Map<String, int>.from(gameState.fenCounts),
        moves: moveEntities,
        currentHalfmoveIndex: gameState.currentHalfmoveIndex,
        result: resultString,
        termination: termination,
        resignationSide: gameState.resignationSide?.name,
        timeoutSide: gameState.timeoutSide?.name,
        agreementDraw: gameState.agreementFlag,
        halfmoveClock: gameState.halfmoveClock,
        materialEvaluation: gameState.materialEvaluationCentipawns(),
        lastUpdated: DateTime.now(),
      );

      AppLogger.debug(
        'Successfully converted GameState to Entity',
        tag: 'GameStateConverter',
      );

      return entity;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error converting GameState to Entity',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateConverter',
      );
      rethrow;
    }
  }

  /// Restore GameState from GameStateEntity
  /// استعادة GameState من GameStateEntity
  static GameState fromEntity(GameStateEntity entity) {
    try {
      AppLogger.debug(
        'Restoring GameState from Entity: ${entity.gameUuid}',
        tag: 'GameStateConverter',
      );

      // Parse the starting position from first FEN
      final initialFen = entity.fenHistory.isNotEmpty
          ? entity.fenHistory.first
          : Chess.initial.fen;

      final initialPosition = Chess.fromSetup(Setup.parseFen(initialFen));

      // Create GameState with initial position
      final gameState = GameState(initial: initialPosition);

      // Replay all moves to restore state
      if (entity.moves.isNotEmpty) {
        for (int i = 0; i < entity.moves.length; i++) {
          final moveEntity = entity.moves[i];

          // Parse the move from LAN or SAN
          Move? move;
          if (moveEntity.lan != null) {
            move = Move.parse(moveEntity.lan!);
          } else if (moveEntity.san != null) {
            // Try to parse from current position's legal moves
            final legalMoves = gameState.position.legalMoves;
            for (final legalMove in legalMoves.entries) {
              final from = legalMove.key;
              for (final to in legalMove.value.squares) {
                final normalMove = NormalMove(from: from, to: to);
                final testRecord = gameState.position.makeSan(normalMove);
                if (testRecord.$2 == moveEntity.san) {
                  move = normalMove;
                  break;
                }
              }
            }
          }

          if (move != null) {
            gameState.play(
              move,
              comment: moveEntity.comment,
              nags: moveEntity.nags,
            );
          }
        }
      }

      // Restore game termination states
      if (entity.resignationSide != null) {
        final side = entity.resignationSide == 'white'
            ? Side.white
            : Side.black;
        gameState.resign(side);
      } else if (entity.timeoutSide != null) {
        final side = entity.timeoutSide == 'white' ? Side.white : Side.black;
        gameState.timeout(side);
      } else if (entity.agreementDraw) {
        gameState.setAgreementDraw();
      }

      AppLogger.debug(
        'Successfully restored GameState from Entity',
        tag: 'GameStateConverter',
      );

      return gameState;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error restoring GameState from Entity',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStateConverter',
      );
      rethrow;
    }
  }

  /// Create a minimal GameStateEntity snapshot for quick storage
  /// إنشاء لقطة مبسطة من GameStateEntity للحفظ السريع
  static GameStateEntity createSnapshot(GameState gameState, String gameUuid) {
    return toEntity(gameState, gameUuid);
  }
}
