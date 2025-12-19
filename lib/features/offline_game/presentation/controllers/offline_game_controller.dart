import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/setup_game_vs_ai_mixin.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_features.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for offline (2-player pass-and-play) games
/// كنترولر للعب المحلي (لاعبان على نفس الجهاز)
class OfflineGameController extends BaseGameController
    with StorageFeatures, SetupGameVsAiMixin
    implements OfflineFeatures {
  OfflineGameController({required super.plySound});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final playerName = args['playerName'] as String;
      final playerSide = args['playerSide'] as PlayerSide;

      // Start game automatically with provided arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startOfflineGame(playerName: playerName, playerSide: playerSide);
      });
    }
  }

  /// Start new offline game
  /// بدء لعبة جديدة
  Future<void> _startOfflineGame({
    required String playerName,
    required PlayerSide playerSide,
  }) async {
    try {
      isLoading = true;
      this.playerSide = playerSide;

      AppLogger.gameEvent(
        'StartOfflineGame',
        data: {'playerName': playerName, 'playerSide': playerSide.name},
      );

      // Start game with player and opponent
      await startNewGame(
        whitePlayerName: playerSide == PlayerSide.white
            ? playerName
            : 'Player 2',
        blackPlayerName: playerSide == PlayerSide.black
            ? playerName
            : 'Player 2',
        event: 'Offline Game',
        site: 'Local',
      );

      // Show board immediately after setup is done
      isLoading = false;

      currentFen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);

      debugPrint('Offline game started');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting offline game',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  // ========== Lifecycle Methods ==========

  @override
  void onClose() {
    AppLogger.info(
      'OfflineGameController disposed',
      tag: 'OfflineGameController',
    );
    gameState.dispose();
    super.onClose();
  }

  // ========== Public Methods ==========

  /// Override startNewGame to set board orientation based on player color
  @override
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) async {
    // Call parent implementation to initialize the game
    await super.startNewGame(
      whitePlayerName: whitePlayerName,
      blackPlayerName: blackPlayerName,
      event: event,
      site: site,
      timeControl: timeControl,
    );

    // Set board orientation based on player color choice
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    if (playerSide == PlayerSide.black) {
      ctrlBoardSettings.orientation.value = Side.black;
      AppLogger.debug(
        'Board orientation set to black',
        tag: 'OfflineGameController',
      );
    } else {
      ctrlBoardSettings.orientation.value = Side.white;
      AppLogger.debug(
        'Board orientation set to white',
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  void applyMove(NormalMove move) async {
    super.applyMove(move);
    // Auto-save if enabled
    if (autoSaveEnabled) {
      await autoSaveGame();
    }
  }

  @override
  Future<void> undoMove() async {
    try {
      if (!gameState.canUndo) {
        Get.snackbar(
          'Cannot Undo',
          'No moves to undo',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = gameState.undoMove();

      if (success) {
        updateReactiveState();

        // Auto-save if enabled
        if (autoSaveEnabled) {
          await autoSaveGame();
        }

        AppLogger.gameEvent('MoveUndone');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error undoing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
      setError('Failed to undo move: ${e.toString()}');
    }
  }

  @override
  Future<void> redoMove() async {
    try {
      if (!gameState.canRedo) {
        Get.snackbar(
          'Cannot Redo',
          'No moves to redo',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = gameState.redoMove();

      if (success) {
        updateReactiveState();

        // Auto-save if enabled
        if (autoSaveEnabled) {
          await autoSaveGame();
        }

        AppLogger.gameEvent('MoveRedone');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error redoing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
      setError('Failed to redo move: ${e.toString()}');
    }
  }

  @override
  Future<void> resign(Side side) async {
    try {
      super.resign(side);
      await storageController.updateGame(currentGame!, gameState);
      Get.snackbar(
        'Game Over',
        '${side == Side.white ? 'White' : 'Black'} resigned',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error resigning',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
      setError('Failed to resign: ${e.toString()}');
    }
  }

  @override
  Future<void> agreeDrawn() async {
    try {
      gameState.setAgreementDraw();
      updateReactiveState();

      await storageController.updateGame(currentGame!, gameState);

      AppLogger.gameEvent('DrawByAgreement');

      Get.snackbar(
        'Game Over',
        'Draw by agreement',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error setting draw',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
      setError('Failed to set draw: ${e.toString()}');
    }
  }

  @override
  void reset() {
    gameState = GameState(initial: Chess.initial);
    updateReactiveState();
    promotionMove.value = null;
    premove.value = null;
    AppLogger.gameEvent('GameReset');
  }

  @override
  String getPgnString() {
    if (currentGame == null) return '';

    return gameState.pgnString(
      headers: {
        'Event': currentGame!.event ?? '?',
        'Site': currentGame!.site ?? '?',
        'Date': currentGame!.date?.toString().split(' ')[0] ?? '????.??.??',
        'Round': currentGame!.round ?? '?',
        'White': currentGame!.whitePlayer.name,
        'Black': currentGame!.blackPlayer.name,
      },
    );
  }

  @override
  List<Role> getCapturedPieces(Side side) {
    return gameState.getCapturedPiecesList(side);
  }

  @override
  int getMaterialOnBoard(Side side) {
    return gameState.materialOnBoard(side);
  }

  @override
  void jumpToHalfmove(int index) {
    final allMoves = gameState.getMoveObjectsCopy();
    final newState = GameState(initial: Chess.initial);

    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }

    gameState = newState;
    updateReactiveState();
  }

  @override
  List<MoveDataModel> get pgnTokens => gameState.getMoveTokens;

  @override
  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  // ========== End Game Interface Methods ==========

  @override
  Future<void> agreeDraw() async {
    try {
      await agreeDrawn();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in agreeDraw',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> checkMate() async {
    try {
      final winner = gameState.turn == Side.white ? Side.black : Side.white;
      AppLogger.gameEvent('Checkmate', data: {'winner': winner.name});

      await storageController.updateGame(currentGame!, gameState);

      Get.snackbar(
        'Checkmate!',
        '${winner == Side.white ? 'White' : 'Black'} wins by checkmate!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in checkMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> draw() async {
    try {
      gameState.setAgreementDraw();
      updateReactiveState();
      await storageController.updateGame(currentGame!, gameState);

      AppLogger.gameEvent('Draw');

      Get.snackbar(
        'Game Drawn',
        'The game ended in a draw',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in draw',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> fiftyMoveRule() async {
    try {
      AppLogger.gameEvent('FiftyMoveRule');
      await storageController.updateGame(currentGame!, gameState);

      Get.snackbar(
        'Draw by Fifty-Move Rule',
        'Game drawn due to fifty-move rule',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in fiftyMoveRule',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> insufficientMaterial() async {
    try {
      AppLogger.gameEvent('InsufficientMaterial');
      await storageController.updateGame(currentGame!, gameState);

      Get.snackbar(
        'Draw by Insufficient Material',
        'Game drawn due to insufficient material',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in insufficientMaterial',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> staleMate() async {
    try {
      AppLogger.gameEvent('Stalemate');
      await storageController.updateGame(currentGame!, gameState);

      Get.snackbar(
        'Stalemate!',
        'Game ended in a stalemate - it\'s a draw',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in staleMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }

  @override
  Future<void> threefoldRepetition() async {
    try {
      AppLogger.gameEvent('ThreefoldRepetition');
      await storageController.updateGame(currentGame!, gameState);

      Get.snackbar(
        'Draw by Threefold Repetition',
        'Game drawn due to threefold repetition',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in threefoldRepetition',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
  }
}
