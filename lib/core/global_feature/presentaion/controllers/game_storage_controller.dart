// lib/core/global_feature/presentaion/controllers/game_storage_controller.dart

import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/core/global_feature/domain/converters/game_state_converter.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/game_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/get_cached_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/get_game_by_uuid_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/update_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/save_player_usecase.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Centralized controller for all game and player storage operations
/// كنترولر مركزي لجميع عمليات تخزين اللعبة واللاعب
class GameStorageController extends GetxController {
  // ========== Game Use Cases ==========
  final SaveGameUseCase saveGameUseCase;
  final UpdateGameUseCase updateGameUseCase;
  final GetGameByUuidUseCase getGameByUuidUseCase;

  // ========== Player Use Cases ==========
  final SavePlayerUseCase savePlayerUseCase;
  final GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase;

  // ========== Cache Use Cases ==========
  final CacheGameStateUseCase cacheGameStateUseCase;
  final GetCachedGameStateUseCase getCachedGameStateUseCase;

  // ========== State ==========
  final RxBool _isSaving = false.obs;
  bool get isSaving => _isSaving.value;

  GameStorageController({
    required this.saveGameUseCase,
    required this.updateGameUseCase,
    required this.getGameByUuidUseCase,
    required this.savePlayerUseCase,
    required this.getOrCreateGuestPlayerUseCase,
    required this.cacheGameStateUseCase,
    required this.getCachedGameStateUseCase,
  });

  // ========== Player Operations ==========

  /// Get or create a guest player by name
  /// إنشاء أو جلب لاعب ضيف بالاسم
  Future<PlayerEntity?> getOrCreatePlayer(String name) async {
    try {
      AppLogger.info(
        'Getting or creating player: $name',
        tag: 'GameStorageController',
      );

      final result = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: name),
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'Failed to get/create player: ${failure.message}',
            tag: 'GameStorageController',
          );
          return null;
        },
        (player) {
          AppLogger.info(
            'Player ready: ${player.name} (${player.uuid})',
            tag: 'GameStorageController',
          );
          return player;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting/creating player',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return null;
    }
  }

  /// Save a new player
  /// حفظ لاعب جديد
  Future<PlayerEntity?> savePlayer(PlayerEntity player) async {
    try {
      AppLogger.info(
        'Saving player: ${player.name}',
        tag: 'GameStorageController',
      );

      final result = await savePlayerUseCase(SavePlayerParams(player: player));

      return result.fold((failure) {
        AppLogger.error(
          'Failed to save player: ${failure.message}',
          tag: 'GameStorageController',
        );
        return null;
      }, (savedPlayer) => savedPlayer);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving player',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return null;
    }
  }

  // ========== Game Operations ==========

  /// Start a new game and save it to the database
  /// بدء لعبة جديدة وحفظها في قاعدة البيانات
  Future<ChessGameEntity?> startAndSaveNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    required GameState gameState,
    String? event,
    String? site,
    String? timeControl,
  }) async {
    try {
      _isSaving.value = true;

      AppLogger.gameEvent(
        'StartNewGame',
        data: {'white': whitePlayerName, 'black': blackPlayerName},
      );

      // Get or create players
      final whitePlayer = await getOrCreatePlayer(whitePlayerName);
      final blackPlayer = await getOrCreatePlayer(blackPlayerName);

      if (whitePlayer == null || blackPlayer == null) {
        AppLogger.error(
          'Failed to create players',
          tag: 'GameStorageController',
        );
        return null;
      }

      // Generate UUID for new game
      final gameUuid = const Uuid().v4();

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
      final saveResult = await saveGameUseCase(SaveGameParams(game: newGame));

      return saveResult.fold(
        (failure) {
          AppLogger.error(
            'Failed to save game: ${failure.message}',
            tag: 'GameStorageController',
          );
          return null;
        },
        (savedGame) async {
          // Cache game state
          await cacheGameState(gameState, gameUuid);

          AppLogger.gameEvent('NewGameStarted', data: {'uuid': gameUuid});
          return savedGame;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting new game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return null;
    } finally {
      _isSaving.value = false;
    }
  }

  /// Save/Update a game to the database
  /// حفظ/تحديث لعبة في قاعدة البيانات
  Future<ChessGameEntity?> saveGame(
    ChessGameEntity game,
    GameState gameState,
  ) async {
    try {
      _isSaving.value = true;

      AppLogger.info('Saving game: ${game.uuid}', tag: 'GameStorageController');

      // Convert moves from GameState
      final moveEntities = gameState.getMoveTokens
          .map((move) => move.toEntity())
          .toList();

      // Get result string
      final String resultString = gameState.resultToPgnString(gameState.result);

      // Update game entity with current state
      final updatedGame = game.copyWith(
        moves: moveEntities,
        movesCount: gameState.getMoveTokens.length,
        result: resultString,
        termination: _getGameTermination(gameState),
      );

      // Save to database
      final saveResult = await saveGameUseCase(
        SaveGameParams(game: updatedGame),
      );

      return saveResult.fold(
        (failure) {
          AppLogger.error(
            'Failed to save game: ${failure.message}',
            tag: 'GameStorageController',
          );
          return null;
        },
        (savedGame) async {
          // Cache game state
          await cacheGameState(gameState, savedGame.uuid);

          AppLogger.gameEvent('GameSaved', data: {'uuid': savedGame.uuid});
          return savedGame;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return null;
    } finally {
      _isSaving.value = false;
    }
  }

  /// Update an existing game in the database
  /// تحديث لعبة موجودة في قاعدة البيانات
  Future<ChessGameEntity?> updateGame(
    ChessGameEntity game,
    GameState gameState,
  ) async {
    try {
      _isSaving.value = true;

      AppLogger.info(
        'Updating game: ${game.uuid}',
        tag: 'GameStorageController',
      );

      // Sync GameState to Entity
      final syncResult = GameService.syncGameStateToEntity(gameState, game);

      return syncResult.fold(
        (failure) {
          AppLogger.error(
            'Failed to sync game state: ${failure.message}',
            tag: 'GameStorageController',
          );
          return null;
        },
        (updatedGame) async {
          // Update game in database
          final updateResult = await updateGameUseCase(
            UpdateGameParams(game: updatedGame),
          );

          return updateResult.fold(
            (failure) {
              AppLogger.error(
                'Failed to update game: ${failure.message}',
                tag: 'GameStorageController',
              );
              return null;
            },
            (savedGame) async {
              // Cache state
              await cacheGameState(gameState, savedGame.uuid);

              AppLogger.database('Game updated successfully');
              return savedGame;
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return null;
    } finally {
      _isSaving.value = false;
    }
  }

  /// Auto-save game (silent, no error messages to user)
  /// الحفظ التلقائي للعبة (صامت، بدون رسائل خطأ للمستخدم)
  Future<ChessGameEntity?> autoSaveGame(
    ChessGameEntity? game,
    GameState gameState,
  ) async {
    if (game == null) return null;

    try {
      final result = await updateGame(game, gameState);
      if (result != null) {
        AppLogger.debug('Game auto-saved', tag: 'GameStorageController');
      }
      return result;
    } catch (e) {
      AppLogger.warning(
        'Auto-save failed: ${e.toString()}',
        tag: 'GameStorageController',
      );
      return null;
    }
  }

  /// Load a game from the database
  /// تحميل لعبة من قاعدة البيانات
  Future<Either<String, (ChessGameEntity, GameState)>> loadGame(
    String uuid,
  ) async {
    try {
      AppLogger.gameEvent('LoadGame', data: {'uuid': uuid});

      // Try to get from cache first
      final cachedResult = await getCachedGameStateUseCase(
        GetCachedGameStateParams(gameUuid: uuid),
      );

      if (cachedResult.isRight()) {
        final cachedState = cachedResult.getOrElse(() => throw Exception());
        final gameState = GameStateConverter.fromEntity(cachedState);

        // Also load the game entity from database
        final gameResult = await getGameByUuidUseCase(
          GetGameByUuidParams(uuid: uuid),
        );

        return gameResult.fold(
          (failure) => Left('Failed to load game: ${failure.message}'),
          (game) {
            AppLogger.gameEvent('GameLoadedFromCache', data: {'uuid': uuid});
            return Right((game, gameState));
          },
        );
      }

      // Load from database
      final gameResult = await getGameByUuidUseCase(
        GetGameByUuidParams(uuid: uuid),
      );

      return gameResult.fold(
        (failure) => Left('Failed to load game: ${failure.message}'),
        (game) {
          // Restore GameState from entity
          final restoreResult = GameService.restoreGameStateFromEntity(game);

          return restoreResult.fold(
            (failure) =>
                Left('Failed to restore game state: ${failure.message}'),
            (restoredState) {
              // Cache the state
              cacheGameState(restoredState, uuid);

              AppLogger.gameEvent('GameLoaded', data: {'uuid': uuid});
              return Right((game, restoredState));
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading game',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameStorageController',
      );
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  // ========== Cache Operations ==========

  /// Cache game state
  /// تخزين حالة اللعبة مؤقتاً
  Future<void> cacheGameState(GameState gameState, String gameUuid) async {
    try {
      final stateEntity = GameStateConverter.toEntity(gameState, gameUuid);
      await cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));
      AppLogger.debug(
        'Game state cached: $gameUuid',
        tag: 'GameStorageController',
      );
    } catch (e) {
      AppLogger.warning(
        'Failed to cache game state: $e',
        tag: 'GameStorageController',
      );
    }
  }

  /// Get cached game state
  /// جلب حالة اللعبة المخزنة مؤقتاً
  Future<GameState?> getCachedGameState(String gameUuid) async {
    try {
      final result = await getCachedGameStateUseCase(
        GetCachedGameStateParams(gameUuid: gameUuid),
      );

      return result.fold(
        (failure) => null,
        (entity) => GameStateConverter.fromEntity(entity),
      );
    } catch (e) {
      AppLogger.warning(
        'Failed to get cached game state: $e',
        tag: 'GameStorageController',
      );
      return null;
    }
  }

  // ========== Helper Methods ==========

  /// Get current game termination status
  /// الحصول على حالة إنهاء اللعبة الحالية
  GameTermination _getGameTermination(GameState gameState) {
    if (gameState.isGameOver) {
      if (gameState.isCheckmate) {
        return GameTermination.checkmate;
      } else if (gameState.isStalemate) {
        return GameTermination.stalemate;
      } else if (gameState.isInsufficientMaterial) {
        return GameTermination.insufficientMaterial;
      } else if (gameState.isThreefoldRepetition()) {
        return GameTermination.threefoldRepetition;
      } else if (gameState.isFiftyMoveRule()) {
        return GameTermination.fiftyMoveRule;
      }
      // Default to agreement for other draws
      return GameTermination.agreement;
    }
    return GameTermination.ongoing;
  }
}
