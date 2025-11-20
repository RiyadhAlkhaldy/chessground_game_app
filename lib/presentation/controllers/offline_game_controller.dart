import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/game_termination_enum.dart';
import '../../core/utils/dialog/constants/const.dart';
import '../../core/utils/game_state/game_state.dart';
import '../../core/utils/logger.dart';
import '../../data/models/move_data_model.dart';
import '../../domain/converters/game_state_converter.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../../domain/services/game_service.dart';
import '../../domain/usecases/game_state/cache_game_state_usecase.dart';
import '../../domain/usecases/game_state/get_cached_game_state_usecase.dart';
import '../../domain/usecases/get_game_by_uuid_usecase.dart';
import '../../domain/usecases/get_or_create_gust_player_usecase.dart';
import '../../domain/usecases/save_game_usecase.dart';
import '../../domain/usecases/save_player_usecase.dart';
import '../../domain/usecases/update_game_usecase.dart';
import 'base_game_controller.dart';
import 'offline_features.dart';

class OfflineGameController extends BaseGameController implements OfflineFeatures {
  // ========== Dependencies (Use Cases) ==========
  final SaveGameUseCase _saveGameUseCase;
  final UpdateGameUseCase _updateGameUseCase;
  final GetGameByUuidUseCase _getGameByUuidUseCase;
  final CacheGameStateUseCase _cacheGameStateUseCase;
  final GetCachedGameStateUseCase _getCachedGameStateUseCase;
  // ignore: unused_field
  final SavePlayerUseCase _savePlayerUseCase;
  final GetOrCreateGuestPlayerUseCase _getOrCreateGuestPlayerUseCase;

  OfflineGameController({
    required super.plySound,
    required super.playMoveUsecase,
    required super.initChessGame,
    required SaveGameUseCase saveGameUseCase,
    required UpdateGameUseCase updateGameUseCase,
    required GetGameByUuidUseCase getGameByUuidUseCase,
    required CacheGameStateUseCase cacheGameStateUseCase,
    required GetCachedGameStateUseCase getCachedGameStateUseCase,
    required SavePlayerUseCase savePlayerUseCase,
    required GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase,
  }) : _saveGameUseCase = saveGameUseCase,
       _updateGameUseCase = updateGameUseCase,
       _getGameByUuidUseCase = getGameByUuidUseCase,
       _cacheGameStateUseCase = cacheGameStateUseCase,
       _getCachedGameStateUseCase = getCachedGameStateUseCase,
       _savePlayerUseCase = savePlayerUseCase,
       _getOrCreateGuestPlayerUseCase = getOrCreateGuestPlayerUseCase;

  // ========== Lifecycle Methods ==========

  @override
  void onInit() {
    super.onInit();
    startNewGame(whitePlayerName: uuidKeyForUser, blackPlayerName: uuidKeyForAI).then((_) {
      plySound.executeDongSound();
    });
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    listenToGameStatus();
    AppLogger.info('GameController initialized', tag: 'GameController');
  }

  @override
  void onClose() {
    AppLogger.info('GameController disposed', tag: 'GameController');
    gameState.dispose();
    super.onClose();
  }

  @override
  Outcome? get getResult {
    return gameState.result;
  }
  // ========== Public Methods ==========

  @override
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) async {
    try {
      setLoading(true);
      clearError();

      AppLogger.gameEvent(
        'StartNewGame',
        data: {'white': whitePlayerName, 'black': blackPlayerName},
      );

      // Create or get players
      final whitePlayerResult = await _getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: whitePlayerName),
      );

      final blackPlayerResult = await _getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: blackPlayerName),
      );

      if (whitePlayerResult.isLeft() || blackPlayerResult.isLeft()) {
        setError('Failed to create players');
        return;
      }

      final whitePlayer = whitePlayerResult.getOrElse(() => throw Exception());
      final blackPlayer = blackPlayerResult.getOrElse(() => throw Exception());

      // Generate UUID for new game
      final gameUuid = const Uuid().v4();

      // Initialize GameState
      gameState = GameState(initial: Chess.initial);

      // Create ChessGameEntity
      final newGame = ChessGameEntity(
        uuid: gameUuid,
        event: event ?? 'Casual Game',
        site: site ?? 'Local',
        date: DateTime.now(),
        round: '1',
        whitePlayer: whitePlayer,
        blackPlayer: blackPlayer,
        result: '*',
        termination: GameTermination.ongoing,
        timeControl: timeControl,
        startingFen: Chess.initial.fen,
        moves: const [],
        movesCount: 0,
      );

      // Save game to database
      final saveResult = await _saveGameUseCase(SaveGameParams(game: newGame));

      saveResult.fold(
        (failure) {
          setError('Failed to save game: ${failure.message}');
          AppLogger.error('Failed to save game', tag: 'GameController');
        },
        (savedGame) async {
          currentGame = savedGame;

          // Cache game state
          final stateEntity = GameStateConverter.toEntity(gameState, gameUuid);
          await _cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

          updateReactiveState();

          AppLogger.gameEvent('NewGameStarted', data: {'uuid': gameUuid});
          Get.snackbar(
            'Game Started',
            'New game between $whitePlayerName vs $blackPlayerName',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting new game',
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
  Future<void> loadGame(String gameUuid) async {
    try {
      setLoading(true);
      clearError();

      AppLogger.gameEvent('LoadGame', data: {'uuid': gameUuid});

      // Try to get from cache first
      final cachedResult = await _getCachedGameStateUseCase(
        GetCachedGameStateParams(gameUuid: gameUuid),
      );

      if (cachedResult.isRight()) {
        final cachedState = cachedResult.getOrElse(() => throw Exception());
        gameState = GameStateConverter.fromEntity(cachedState);

        // Also load the game entity from database
        final gameResult = await _getGameByUuidUseCase(GetGameByUuidParams(uuid: gameUuid));

        gameResult.fold((failure) => setError('Failed to load game: ${failure.message}'), (game) {
          currentGame = game;
          updateReactiveState();
          AppLogger.gameEvent('GameLoadedFromCache', data: {'uuid': gameUuid});
        });
        return;
      }

      // Load from database
      final gameResult = await _getGameByUuidUseCase(GetGameByUuidParams(uuid: gameUuid));

      gameResult.fold((failure) => setError('Failed to load game: ${failure.message}'), (game) {
        currentGame = game;

        // Restore GameState from entity
        final restoreResult = GameService.restoreGameStateFromEntity(game);
        restoreResult.fold(
          (failure) => setError('Failed to restore game state: ${failure.message}'),
          (restoredState) {
            gameState = restoredState;
            updateReactiveState();

            // Cache the state
            final stateEntity = GameStateConverter.toEntity(gameState, gameUuid);
            _cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

            AppLogger.gameEvent('GameLoaded', data: {'uuid': gameUuid});
            Get.snackbar(
              'Game Loaded',
              'Loaded game: ${game.event ?? 'Untitled'}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
      });
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
        Get.snackbar('Cannot Undo', 'No moves to undo', snackPosition: SnackPosition.BOTTOM);
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
        Get.snackbar('Cannot Redo', 'No moves to redo', snackPosition: SnackPosition.BOTTOM);
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
      gameState.resign(side);
      updateReactiveState();

      await _saveGameToDatabase();

      AppLogger.gameEvent('PlayerResigned', data: {'side': side.name});

      Get.snackbar(
        'Game Over',
        '${side == Side.white ? 'White' : 'Black'} resigned',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error resigning', error: e, stackTrace: stackTrace, tag: 'GameController');
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

      Get.snackbar('Game Over', 'Draw by agreement', snackPosition: SnackPosition.BOTTOM);
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
    Get.snackbar('Game Saved', 'Game saved successfully', snackPosition: SnackPosition.BOTTOM);
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
      AppLogger.warning('Auto-save failed: ${e.toString()}', tag: 'GameController');
      // Don't show error to user for auto-save failures
    }
  }

  Future<void> _saveGameToDatabase() async {
    if (currentGame == null) return;

    try {
      // Sync GameState to Entity
      final syncResult = GameService.syncGameStateToEntity(gameState, currentGame!);

      syncResult.fold(
        (failure) {
          AppLogger.error('Failed to sync game state: ${failure.message}', tag: 'GameController');
        },
        (updatedGame) async {
          // Update game in database
          final updateResult = await _updateGameUseCase(UpdateGameParams(game: updatedGame));

          updateResult.fold(
            (failure) {
              AppLogger.error('Failed to update game: ${failure.message}', tag: 'GameController');
            },
            (savedGame) {
              currentGame = savedGame;

              // Cache state
              final stateEntity = GameStateConverter.toEntity(gameState, savedGame.uuid);
              _cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

              AppLogger.database('Game updated successfully');
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error saving game', error: e, stackTrace: stackTrace, tag: 'GameController');
    }
  }
}
