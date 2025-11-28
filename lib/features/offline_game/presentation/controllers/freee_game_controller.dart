import 'dart:async';

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
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class FreeGameController extends BaseGameController with StorageFeatures {
  // ========== Dependencies (Use Cases) ==========
  final UpdateGameUseCase updateGameUseCase;
  final GetGameByUuidUseCase getGameByUuidUseCase;
  final GetCachedGameStateUseCase getCachedGameStateUseCase;
  // ignore: unused_field
  final SavePlayerUseCase savePlayerUseCase;

  FreeGameController({
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
    listenToGameStatus();
  }

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

  List<Role> getCapturedPieces(Side side) {
    return gameState.getCapturedPiecesList(side);
  }

  int getMaterialOnBoard(Side side) {
    return gameState.materialOnBoard(side);
  }

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

  // ========== Private Methods ==========
  // ignore: unused_element
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
}
