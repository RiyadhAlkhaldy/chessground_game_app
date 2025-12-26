import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/game_storage_controller.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

/// Mixin providing storage features for game controllers
/// Uses GameStorageController for all storage operations
///
/// ميكسين يوفر ميزات التخزين لكنترولات اللعبة
/// يستخدم GameStorageController لجميع عمليات التخزين
mixin StorageFeatures on BaseGameController {
  /// Storage controller instance - lazy loaded
  /// كنترولر التخزين - تحميل كسول
  GameStorageController get storageController =>
      Get.find<GameStorageController>();

  /// Start a new game and save it to the database
  /// بدء لعبة جديدة وحفظها في قاعدة البيانات
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

      // Initialize GameState
      gameState = GameState(initial: Chess.initial);

      // Use storage controller to start and save the game
      final savedGame = await storageController.startAndSaveNewGame(
        whitePlayerName: whitePlayerName,
        blackPlayerName: blackPlayerName,
        gameState: gameState,
        event: event,
        site: site,
        timeControl: timeControl,
      );

      if (savedGame != null) {
        currentGame = savedGame;
        whitePlayer.value = savedGame.whitePlayer;
        blackPlayer.value = savedGame.blackPlayer;
        updateReactiveState();

        if (!Get.testMode && Get.context != null) {
          Get.snackbar(
            'Game Started',
            'New game between $whitePlayerName vs $blackPlayerName',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        setError('Failed to start new game');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting new game',
        error: e,
        stackTrace: stackTrace,
        tag: 'StorageFeatures',
      );
      setError('Unexpected error: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Save current game state to database
  /// حفظ حالة اللعبة الحالية إلى قاعدة البيانات
  Future<void> saveGame() async {
    try {
      if (currentGame == null) {
        Get.snackbar(
          'Error',
          'No active game to save',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      setLoading(true);
      clearError();

      final savedGame = await storageController.saveGame(
        currentGame!,
        gameState,
      );

      if (savedGame != null) {
        currentGame = savedGame;
        Get.snackbar(
          'Game Saved',
          'Game saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        setError('Failed to save game');
        Get.snackbar(
          'Save Failed',
          'Could not save game',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving game',
        error: e,
        stackTrace: stackTrace,
        tag: 'StorageFeatures',
      );
      setError('Unexpected error: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to save game',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Auto-save game (silent, no UI feedback)
  /// الحفظ التلقائي للعبة (صامت، بدون تنبيهات)
  Future<ChessGameEntity?> autoSaveGame() async {
    final result = await storageController.autoSaveGame(currentGame, gameState);
    if (result != null) {
      currentGame = result;
    }
    return result;
  }

  /// Load a game from the database
  /// تحميل لعبة من قاعدة البيانات
  Future<void> loadGame(String gameUuid) async {
    try {
      setLoading(true);
      clearError();

      final result = await storageController.loadGame(gameUuid);

      result.fold(
        (error) {
          setError(error);
          Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
        },
        (data) {
          final (game, state) = data;
          currentGame = game;
          gameState = state;
          whitePlayer.value = game.whitePlayer;
          blackPlayer.value = game.blackPlayer;
          updateReactiveState();

          Get.snackbar(
            'Game Loaded',
            'Loaded game: ${game.event ?? 'Untitled'}',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading game',
        error: e,
        stackTrace: stackTrace,
        tag: 'StorageFeatures',
      );
      setError('Unexpected error: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Cache game state
  /// تخزين حالة اللعبة مؤقتاً
  Future<void> cacheState() async {
    if (currentGame != null) {
      await storageController.cacheGameState(gameState, currentGame!.uuid);
    }
  }
}
