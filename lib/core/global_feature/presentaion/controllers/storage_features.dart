import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/domain/converters/game_state_converter.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_state/cache_game_state_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/save_game_usecase.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/player_usecases/get_or_create_gust_player_usecase.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

mixin StorageFeatures on BaseGameController {
  late final SaveGameUseCase saveGameUseCase;
  late final CacheGameStateUseCase cacheGameStateUseCase;
  late final GetOrCreateGuestPlayerUseCase getOrCreateGuestPlayerUseCase;
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
      final whitePlayerResult = await getOrCreateGuestPlayerUseCase(
        GetOrCreateGuestPlayerParams(name: whitePlayerName),
      );

      final blackPlayerResult = await getOrCreateGuestPlayerUseCase(
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
      final saveResult = await saveGameUseCase(SaveGameParams(game: newGame));

      saveResult.fold(
        (failure) {
          setError('Failed to save game: ${failure.message}');
          AppLogger.error('Failed to save game', tag: 'GameController');
        },
        (savedGame) async {
          currentGame = savedGame;

          // Cache game state
          final stateEntity = GameStateConverter.toEntity(gameState, gameUuid);
          await cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

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

  
}
