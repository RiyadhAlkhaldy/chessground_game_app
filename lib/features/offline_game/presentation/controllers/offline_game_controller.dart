import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/core/global_feature/domain/converters/game_state_converter.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/game_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/setup_game_vs_ai_mixin.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_features.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class OfflineGameController extends BaseGameController
    with StorageFeatures, SetupGameVsAiMixin
    implements OfflineFeatures {
  // ========== Dependencies (Use Cases) ==========
  final UpdateGameUseCase updateGameUseCase;
  final GetGameByUuidUseCase getGameByUuidUseCase;
  final GetCachedGameStateUseCase getCachedGameStateUseCase;
  // ignore: unused_field
  final SavePlayerUseCase savePlayerUseCase;

  OfflineGameController({
    required super.plySound,
    required SaveGameUseCase saveGameUseCase,
    required this.updateGameUseCase,
    required this.getGameByUuidUseCase,
    required CacheGameStateUseCase cacheGameStateUseCase,
    required this.getCachedGameStateUseCase,
    required this.savePlayerUseCase,
    required GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase,
  }) {
    this.saveGameUseCase = saveGameUseCase;
    this.cacheGameStateUseCase = cacheGameStateUseCase;
    this.getOrCreateGuestPlayerUseCase = getOrCreateGuestPlayerUseCase;
  }
  @override
  void onInit() {
    super.onInit();
    startNewGame(
      whitePlayerName: uuidKeyForUser,
      blackPlayerName: uuidKeyForAI,
    ).then((value) {
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      listenToGameStatus();
      plySound.executeDongSound();
      AppLogger.info('GameController initialized', tag: 'GameController');

      // Set board orientation based on player's side choice
      // if (choosingCtrl.playerColor.value == SideChoosing.black) {
      //   playerSide = PlayerSide.black;
      //   ctrlBoardSettings.orientation.value = Side.black;
      // } else if (choosingCtrl.playerColor.value == SideChoosing.white) {
      //   playerSide = PlayerSide.white;
      //   ctrlBoardSettings.orientation.value = Side.white;
      // } else {
      //   // Random was chosen, determine based on playerSide after it's set
      //   ctrlBoardSettings.orientation.value = playerSide == PlayerSide.black
      //       ? Side.black
      //       : Side.white;
      // }
    });
  }

  // ========== Lifecycle Methods ==========

  @override
  void onClose() {
    AppLogger.info('GameController disposed', tag: 'GameController');
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
  Future<void> loadGame(String gameUuid) async {
    try {
      setLoading(true);
      clearError();

      AppLogger.gameEvent('LoadGame', data: {'uuid': gameUuid});

      // Try to get from cache first
      final cachedResult = await getCachedGameStateUseCase(
        GetCachedGameStateParams(gameUuid: gameUuid),
      );

      if (cachedResult.isRight()) {
        final cachedState = cachedResult.getOrElse(() => throw Exception());
        gameState = GameStateConverter.fromEntity(cachedState);

        // Also load the game entity from database
        final gameResult = await getGameByUuidUseCase(
          GetGameByUuidParams(uuid: gameUuid),
        );

        gameResult.fold(
          (failure) => setError('Failed to load game: ${failure.message}'),
          (game) {
            currentGame = game;
            updateReactiveState();
            AppLogger.gameEvent(
              'GameLoadedFromCache',
              data: {'uuid': gameUuid},
            );
          },
        );
        return;
      }

      // Load from database
      final gameResult = await getGameByUuidUseCase(
        GetGameByUuidParams(uuid: gameUuid),
      );

      gameResult.fold(
        (failure) => setError('Failed to load game: ${failure.message}'),
        (game) {
          currentGame = game;

          // Restore GameState from entity
          final restoreResult = GameService.restoreGameStateFromEntity(game);
          restoreResult.fold(
            (failure) =>
                setError('Failed to restore game state: ${failure.message}'),
            (restoredState) {
              gameState = restoredState;
              updateReactiveState();

              // Cache the state
              final stateEntity = GameStateConverter.toEntity(
                gameState,
                gameUuid,
              );
              cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

              AppLogger.gameEvent('GameLoaded', data: {'uuid': gameUuid});
              Get.snackbar(
                'Game Loaded',
                'Loaded game: ${game.event ?? 'Untitled'}',
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
        tag: 'GameController',
      );
      setError('Unexpected error: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  @override
  void applyMove(NormalMove move) async {
    super.applyMove(move);
    // Auto-save if enabled
    if (autoSaveEnabled) {
      await _autoSaveGame();
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
          await _autoSaveGame();
        }

        AppLogger.gameEvent('MoveUndone');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error undoing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
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
          await _autoSaveGame();
        }

        AppLogger.gameEvent('MoveRedone');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error redoing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      setError('Failed to redo move: ${e.toString()}');
    }
  }

  @override
  Future<void> resign(Side side) async {
    try {
      super.resign(side);
      await _saveGameToDatabase();
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
        tag: 'GameController',
      );
      setError('Failed to resign: ${e.toString()}');
    }
  }

  @override
  Future<void> agreeDrawn() async {
    try {
      gameState.setAgreementDraw();
      updateReactiveState();

      await _saveGameToDatabase();

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
        tag: 'GameController',
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
  Future<void> saveGame() async {
    await _saveGameToDatabase();
    Get.snackbar(
      'Game Saved',
      'Game saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
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

  // ========== Private Methods ==========

  Future<void> _autoSaveGame() async {
    try {
      await _saveGameToDatabase();
      AppLogger.debug('Game auto-saved', tag: 'GameController');
    } catch (e) {
      AppLogger.warning(
        'Auto-save failed: ${e.toString()}',
        tag: 'GameController',
      );
      // Don't show error to user for auto-save failures
    }
  }

  Future<void> _saveGameToDatabase() async {
    if (currentGame == null) return;

    try {
      // Sync GameState to Entity
      final syncResult = GameService.syncGameStateToEntity(
        gameState,
        currentGame!,
      );

      syncResult.fold(
        (failure) {
          AppLogger.error(
            'Failed to sync game state: ${failure.message}',
            tag: 'GameController',
          );
        },
        (updatedGame) async {
          // Update game in database
          final updateResult = await updateGameUseCase(
            UpdateGameParams(game: updatedGame),
          );

          updateResult.fold(
            (failure) {
              AppLogger.error(
                'Failed to update game: ${failure.message}',
                tag: 'GameController',
              );
            },
            (savedGame) {
              currentGame = savedGame;

              // Cache state
              final stateEntity = GameStateConverter.toEntity(
                gameState,
                savedGame.uuid,
              );
              cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

              AppLogger.database('Game updated successfully');
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
    }
  }

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

      await _saveGameToDatabase();

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
      await _saveGameToDatabase();

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
      await _saveGameToDatabase();

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
      await _saveGameToDatabase();

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
      await _saveGameToDatabase();

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
      await _saveGameToDatabase();

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
