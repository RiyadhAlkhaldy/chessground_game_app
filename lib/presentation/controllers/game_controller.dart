import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/game_termination_enum.dart';
import '../../core/utils/dialog/constants/const.dart';
import '../../core/utils/dialog/game_result_dialog.dart';
import '../../core/utils/dialog/game_status.dart';
import '../../core/utils/dialog/status_l10n.dart';
import '../../core/utils/game_state/game_state.dart';
import '../../core/utils/logger.dart';
import '../../data/models/move_data_model.dart';
import '../../domain/converters/game_state_converter.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/services/game_service.dart';
import '../../domain/usecases/game_state/cache_game_state_usecase.dart';
import '../../domain/usecases/game_state/get_cached_game_state_usecase.dart';
import '../../domain/usecases/get_game_by_uuid_usecase.dart';
import '../../domain/usecases/get_or_create_gust_player_usecase.dart';
import '../../domain/usecases/init_chess_game.dart';
import '../../domain/usecases/play_move.dart';
import '../../domain/usecases/play_sound_usecase.dart';
import '../../domain/usecases/save_game_usecase.dart';
import '../../domain/usecases/save_player_usecase.dart';
import '../../domain/usecases/update_game_usecase.dart';

mixin InitGameMixin {
  // ========== Observable State ==========
  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));

  String get _initailLocalFen => Chess.initial.fen;

  String fen = Chess.initial.fen;

  /// Valid moves for chessground (IMap format)
  final Rx<ValidMoves> _validMoves = ValidMoves(const {}).obs;

  ValidMoves get validMoves => _validMoves.value;

  bool get isCheckmate => _gameState.value.isCheckmate;

  Rxn<PlayerEntity> whitePlayer = Rxn();
  Rxn<PlayerEntity> blackPlayer = Rxn();
  ChessGameEntity? chessGameEntity;

  bool canPop = false;

  // ========== Observable State ==========

  /// Promotion move (waiting for promotion selection)
  final Rx<NormalMove?> promotionMove = Rx<NormalMove?>(null);

  /// Premove
  final Rx<NormalMove?> premove = Rx<NormalMove?>(null);

  PlayerSide playerSide = PlayerSide.both;

  /// Current game state
  /// حالة اللعبة الحالية
  final Rx<GameState> _gameState = GameState().obs;
  GameState get gameState => _gameState.value;

  /// Current chess game entity
  /// كيان لعبة الشطرنج الحالي
  final Rx<ChessGameEntity?> _currentGame = Rx<ChessGameEntity?>(null);
  ChessGameEntity? get currentGame => _currentGame.value;

  /// Loading state
  /// حالة التحميل
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Error message
  /// رسالة الخطأ
  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  /// Current position FEN (reactive)
  /// FEN الموضع الحالي (تفاعلي)
  final RxString _currentFen = Chess.initial.fen.obs;
  String get currentFen => _currentFen.value;

  /// Current turn (reactive)
  /// الدور الحالي (تفاعلي)
  final Rx<Side> _currentTurn = Side.white.obs;
  Side get currentTurn => _currentTurn.value;

  /// Is game over (reactive)
  /// هل انتهت اللعبة (تفاعلي)
  final RxBool _isGameOver = false.obs;
  bool get isGameOver => _isGameOver.value;

  /// Game result (reactive)
  /// نتيجة اللعبة (تفاعلية)
  final RxString _gameResult = '*'.obs;
  String get gameResult => _gameResult.value;

  /// Game termination reason (reactive)
  /// سبب إنهاء اللعبة (تفاعلي)
  final Rx<GameTermination> _termination = GameTermination.ongoing.obs;
  GameTermination get termination => _termination.value;

  final Rx<GameStatus> _gameStatus = GameStatus.ongoing.obs;
  GameStatus get gameStatus => _gameStatus.value;

  /// Last move metadata (reactive)
  /// بيانات آخر حركة (تفاعلية)
  final Rx<MoveDataModel?> _lastMove = Rx<MoveDataModel?>(null);
  MoveDataModel? get lastMove => _lastMove.value;

  // /// Last move (reactive) - for chessground highlighting
  // final Rx<Move?> _lastMove = Rx<Move?>(null);
  // Move? get lastMove => _lastMove.value;

  /// Can undo (reactive)
  /// إمكانية التراجع (تفاعلي)
  final RxBool _canUndo = false.obs;
  RxBool get canUndo => _canUndo;

  /// Can redo (reactive)
  /// إمكانية الإعادة (تفاعلي)
  final RxBool _canRedo = false.obs;
  RxBool get canRedo => _canRedo;

  /// Material advantage for white (reactive)
  /// ميزة المواد للأبيض (تفاعلي)
  final RxInt _materialAdvantage = 0.obs;
  int get materialAdvantage => _materialAdvantage.value;

  /// Is position in check (reactive)
  /// هل الموضع في كش (تفاعلي)
  final RxBool _isCheck = false.obs;
  bool get isCheck => _isCheck.value;

  /// Auto-save enabled
  /// التخزين التلقائي مفعّل
  final RxBool _autoSaveEnabled = true.obs;
  bool get autoSaveEnabled => _autoSaveEnabled.value;
  set autoSaveEnabled(bool value) => _autoSaveEnabled.value = value;
}

abstract class BaseGameController extends GetxController with InitGameMixin {
  final PlaySoundUseCase plySound;
  final PlayMove playMoveUsecase;
  final InitChessGame initChessGame;

  // final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  BaseGameController({
    required this.plySound,
    required this.playMoveUsecase,
    required this.initChessGame,
  });

  void _listenToGameStatus() {
    _gameState.value.gameStatus.listen((status) {
      if (_gameState.value.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (_gameState.value.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (_gameState.value.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: _gameState.value.position, winner: _gameState.value.result?.winner, isThreefoldRepetition: _gameState.value.isThreefoldRepetition())} ";
        Get.dialog(
          GameResultDialog(
            gameState: _gameState.value,
            gameStatus: status,
            reset: reset,
          ),
        );
      }
    });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return _gameState.value.result;
  }

  Side? get winner {
    return getResult?.winner;
  }

  /// Game result (reactive)
  /// نتيجة اللعبة (تفاعلية)
  // final RxString _gameResult = '*'.obs;
  // String get gameResult => _gameResult.value;

  RxString statusText = "free Play".obs;

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {_gameState.value.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {
    _gameState.value.resign(side),
    plySound.executeResignSound(),
    update(),
  };

  ///reset
  void reset() {
    _gameState.value = GameState(initial: initail);
    fen = _gameState.value.position.fen;
    _validMoves.value = makeLegalMoves(_gameState.value.position);
    promotionMove.value = null;
    plySound.executeDongSound();
    statusText.value = "free Play";

    update();
  }

  void tryPlayPremove() {
    if (premove.value != null) {
      Timer.run(() {
        onUserMoveAgainstAI(premove.value!, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    premove.value = move;
    update();
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove.value != null) {
      onUserMoveAgainstAI(promotionMove.value!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove.value = null;
    update();
  }

  /// Handle move from chessground (NormalMove object)
  /// This is the main method called by chessground
  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    try {
      if (_isGameOver.value) {
        Get.snackbar(
          'Game Over',
          'Cannot make moves in a finished game',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      // Check if this is a promotion pawn move
      if (isPromotionPawnMove(move)) {
        promotionMove.value = move;
        update();
        return;
      }

      // Validate and execute move
      if (_gameState.value.position.isLegal(move)) {
        _applyMove(move);
        promotionMove.value = null;
        update();
        tryPlayPremove();
      } else {
        Get.snackbar(
          'Invalid Move',
          'This move is not legal',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling user move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      _setError('Failed to make move: ${e.toString()}');
    }
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) async {
    try {
      // Play the move
      _gameState.value.play(move, nags: []);

      // Update reactive state
      _updateReactiveState();

      fen = _gameState.value.position.fen;
      _validMoves.value = makeLegalMoves(_gameState.value.position);
      // _validMoves.value = _gameState.value.position.legalMoves ;

      // decide which sound to play based on metadata
      final meta = _gameState.value.lastMoveMeta;
      if (meta != null) {
        // capture has priority (play capture instead of plain move)
        if (meta.wasCapture) {
          plySound.executeCaptureSound();
        } else {
          plySound.executeMoveSound();
        }
        if (meta.wasPromotion) {
          plySound.executePromoteSound();
        }
        if (meta.wasCheckmate) {
          plySound.executeCheckmateSound();
        } else if (meta.wasCheck) {
          plySound.executeCheckSound();
        }
      }
      // update observed gameState.value! (GameState mutated in-place)
      _gameState.refresh();
      gameStatus; // to update statusText

      AppLogger.move(
        meta?.san ?? move.uci,
        fen: _currentFen.value,
        isCheck: _isCheck.value,
      );

      // Try to execute premove if any
      _tryPlayPremove();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error executing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      _setError('Failed to execute move: ${e.toString()}');
    }
  }

  /// Try to play premove
  void _tryPlayPremove() {
    if (premove.value != null) {
      final prmove = premove.value!;
      premove.value = null;
      onUserMoveAgainstAI(prmove, isPremove: true);
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        _gameState.value.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                _gameState.value.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                _gameState.value.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true

  void undoMove() {
    if (canUndo.value) {
      _gameState.value.undoMove();
      fen = _gameState.value.position.fen;
      _validMoves.value = makeLegalMoves(_gameState.value.position);
      // play a feedback sound (optional)
      plySound.executeMoveSound();
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      _gameState.value.redoMove();
      fen = _gameState.value.position.fen;
      _validMoves.value = makeLegalMoves(_gameState.value.position);
      plySound.executeMoveSound();
      update();
    }
  }

  /// expose PGN tokens for the UI
  List<MoveDataModel> get pgnTokens => _gameState.value.getMoveTokens;

  int get currentHalfmoveIndex => _gameState.value.currentHalfmoveIndex;

  /// jump to a halfmove index (0-based). This will rebuild the game state up to that halfmove.
  /// Implementation: get a copy of move objects from gameState.value!, construct a fresh GameState
  /// and replay moves up to `index` then replace controller.gameState.value! with rebuilt one.
  void jumpToHalfmove(int index) {
    final allMoves = _gameState.value.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    _gameState.value = newState;
    fen = _gameState.value.position.fen;
    _validMoves.value = makeLegalMoves(_gameState.value.position);
    update();
  }

  Map<Role, int> get whiteCaptured =>
      _gameState.value.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured =>
      _gameState.value.getCapturedPieces(Side.black);
  String get whiteCapturedText =>
      _gameState.value.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons =>
      _gameState.value.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      _gameState.value.capturedPiecesAsUnicode(Side.black);

  // في controller أو widget بعد استدعاء setState/update
  List<Role> get whiteCapturedList =>
      _gameState.value.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList =>
      _gameState.value.getCapturedPiecesList(Side.black);

  /// Update all reactive state variables
  /// تحديث جميع متغيرات الحالة التفاعلية
  void _updateReactiveState() {
    _currentFen.value = _gameState.value.position.fen;
    _currentTurn.value = _gameState.value.turn;
    _isGameOver.value = _gameState.value.isGameOverExtended;
    _gameResult.value = GameService.calculateResult(
      _gameState.value,
      _currentGame.value!.termination,
      //   _gameState.value.status(),
    );
    _termination.value = _currentGame.value!.termination;
    // _termination.value = _gameState.value.status();
    _lastMove.value = _gameState.value.lastMoveMeta;
    // _validMoves.value = _makeLegalMoves();
    _canUndo.value = _gameState.value.canUndo;
    _canRedo.value = _gameState.value.canRedo;
    _materialAdvantage.value =
        _gameState.value.getMaterialAdvantageSignedForWhite;
    _isCheck.value = _gameState.value.isCheck;
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage.value = message;
    AppLogger.error(message, tag: 'GameController');
  }

  /// Clear error message
  void _clearError() {
    _errorMessage.value = '';
  }

  @override
  void dispose() {
    _gameState.value.dispose();
    super.dispose();
  }
}

/// Main game controller managing game state and business logic
/// المتحكم الرئيسي لإدارة حالة اللعبة ومنطق الأعمال
class GameController extends BaseGameController {
  // ========== Dependencies (Use Cases) ==========
  final SaveGameUseCase _saveGameUseCase;
  final UpdateGameUseCase _updateGameUseCase;
  final GetGameByUuidUseCase _getGameByUuidUseCase;
  final CacheGameStateUseCase _cacheGameStateUseCase;
  final GetCachedGameStateUseCase _getCachedGameStateUseCase;
  // ignore: unused_field
  final SavePlayerUseCase _savePlayerUseCase;
  final GetOrCreateGuestPlayerUseCase _getOrCreateGuestPlayerUseCase;

  GameController({
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
    startNewGame(
      whitePlayerName: uuidKeyForUser,
      blackPlayerName: uuidKeyForAI,
    ).then((_) {
      plySound.executeDongSound();
    });
    fen = _gameState.value.position.fen;
    _validMoves.value = makeLegalMoves(_gameState.value.position);
    _listenToGameStatus();
    AppLogger.info('GameController initialized', tag: 'GameController');
  }

  @override
  void onClose() {
    AppLogger.info('GameController disposed', tag: 'GameController');
    _gameState.value.dispose();
    super.onClose();
  }

  @override
  Outcome? get getResult {
    return gameState.result;
  }
  // ========== Public Methods ==========

  /// Initialize a new game
  /// تهيئة لعبة جديدة
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

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
        _setError('Failed to create players');
        return;
      }

      final whitePlayer = whitePlayerResult.getOrElse(() => throw Exception());
      final blackPlayer = blackPlayerResult.getOrElse(() => throw Exception());

      // Generate UUID for new game
      final gameUuid = const Uuid().v4();

      // Initialize GameState
      _gameState.value = GameState(initial: Chess.initial);

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
          _setError('Failed to save game: ${failure.message}');
          AppLogger.error('Failed to save game', tag: 'GameController');
        },
        (savedGame) async {
          _currentGame.value = savedGame;

          // Cache game state
          final stateEntity = GameStateConverter.toEntity(
            _gameState.value,
            gameUuid,
          );
          await _cacheGameStateUseCase(
            CacheGameStateParams(state: stateEntity),
          );

          _updateReactiveState();

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
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Load existing game by UUID
  /// تحميل لعبة موجودة باستخدام UUID
  Future<void> loadGame(String gameUuid) async {
    try {
      _setLoading(true);
      _clearError();

      AppLogger.gameEvent('LoadGame', data: {'uuid': gameUuid});

      // Try to get from cache first
      final cachedResult = await _getCachedGameStateUseCase(
        GetCachedGameStateParams(gameUuid: gameUuid),
      );

      if (cachedResult.isRight()) {
        final cachedState = cachedResult.getOrElse(() => throw Exception());
        _gameState.value = GameStateConverter.fromEntity(cachedState);

        // Also load the game entity from database
        final gameResult = await _getGameByUuidUseCase(
          GetGameByUuidParams(uuid: gameUuid),
        );

        gameResult.fold(
          (failure) => _setError('Failed to load game: ${failure.message}'),
          (game) {
            _currentGame.value = game;
            _updateReactiveState();
            AppLogger.gameEvent(
              'GameLoadedFromCache',
              data: {'uuid': gameUuid},
            );
          },
        );
        return;
      }

      // Load from database
      final gameResult = await _getGameByUuidUseCase(
        GetGameByUuidParams(uuid: gameUuid),
      );

      gameResult.fold(
        (failure) => _setError('Failed to load game: ${failure.message}'),
        (game) {
          _currentGame.value = game;

          // Restore GameState from entity
          final restoreResult = GameService.restoreGameStateFromEntity(game);
          restoreResult.fold(
            (failure) =>
                _setError('Failed to restore game state: ${failure.message}'),
            (restoredState) {
              _gameState.value = restoredState;
              _updateReactiveState();

              // Cache the state
              final stateEntity = GameStateConverter.toEntity(
                _gameState.value,
                gameUuid,
              );
              _cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

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
      _setError('Unexpected error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  void _applyMove(NormalMove move) async {
    super._applyMove(move);
    // Auto-save if enabled
    if (_autoSaveEnabled.value) {
      await _autoSaveGame();
    }
  }

  /// Undo last move
  @override
  Future<void> undoMove() async {
    try {
      if (!_gameState.value.canUndo) {
        Get.snackbar(
          'Cannot Undo',
          'No moves to undo',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = _gameState.value.undoMove();

      if (success) {
        _updateReactiveState();

        // Auto-save if enabled
        if (_autoSaveEnabled.value) {
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
      _setError('Failed to undo move: ${e.toString()}');
    }
  }

  /// Redo previously undone move
  @override
  Future<void> redoMove() async {
    try {
      if (!_gameState.value.canRedo) {
        Get.snackbar(
          'Cannot Redo',
          'No moves to redo',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final success = _gameState.value.redoMove();

      if (success) {
        _updateReactiveState();

        // Auto-save if enabled
        if (_autoSaveEnabled.value) {
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
      _setError('Failed to redo move: ${e.toString()}');
    }
  }

  /// Resign the game
  @override
  Future<void> resign(Side side) async {
    try {
      _gameState.value.resign(side);
      _updateReactiveState();

      await _saveGameToDatabase();

      AppLogger.gameEvent('PlayerResigned', data: {'side': side.name});

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
      _setError('Failed to resign: ${e.toString()}');
    }
  }

  /// Offer/accept draw by agreement
  Future<void> agreeDrawn() async {
    try {
      _gameState.value.setAgreementDraw();
      _updateReactiveState();

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
      _setError('Failed to set draw: ${e.toString()}');
    }
  }

  /// Reset game
  @override
  void reset() {
    _gameState.value = GameState(initial: Chess.initial);
    _updateReactiveState();
    promotionMove.value = null;
    premove.value = null;
    AppLogger.gameEvent('GameReset');
  }

  /// Get PGN string of current game
  String getPgnString() {
    if (_currentGame.value == null) return '';

    return _gameState.value.pgnString(
      headers: {
        'Event': _currentGame.value!.event ?? '?',
        'Site': _currentGame.value!.site ?? '?',
        'Date':
            _currentGame.value!.date?.toString().split(' ')[0] ?? '????.??.??',
        'Round': _currentGame.value!.round ?? '?',
        'White': _currentGame.value!.whitePlayer.name,
        'Black': _currentGame.value!.blackPlayer.name,
      },
    );
  }

  /// Get captured pieces for a side
  /// الحصول على القطع المأسورة لجهة
  List<Role> getCapturedPieces(Side side) {
    return _gameState.value.getCapturedPiecesList(side);
  }

  /// Get material count on board for a side
  /// الحصول على عدد المواد على اللوحة لجهة
  int getMaterialOnBoard(Side side) {
    return _gameState.value.materialOnBoard(side);
  }

  /// Save current game manually
  /// حفظ اللعبة الحالية يدوياً
  Future<void> saveGame() async {
    await _saveGameToDatabase();
    Get.snackbar(
      'Game Saved',
      'Game saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Jump to specific halfmove
  @override
  void jumpToHalfmove(int index) {
    final allMoves = _gameState.value.getMoveObjectsCopy();
    final newState = GameState(initial: Chess.initial);

    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }

    _gameState.value = newState;
    _updateReactiveState();
  }

  /// Get move tokens for PGN display
  @override
  List<MoveDataModel> get pgnTokens => _gameState.value.getMoveTokens;

  /// Get current halfmove index
  @override
  int get currentHalfmoveIndex => _gameState.value.currentHalfmoveIndex;

  // ========== Private Methods ==========

  /// Auto-save game after each move
  /// الحفظ التلقائي للعبة بعد كل حركة
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

  /// Save game to database
  /// حفظ اللعبة في قاعدة البيانات
  Future<void> _saveGameToDatabase() async {
    if (_currentGame.value == null) return;

    try {
      // Sync GameState to Entity
      final syncResult = GameService.syncGameStateToEntity(
        _gameState.value,
        _currentGame.value!,
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
          final updateResult = await _updateGameUseCase(
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
              _currentGame.value = savedGame;

              // Cache state
              final stateEntity = GameStateConverter.toEntity(
                _gameState.value,
                savedGame.uuid,
              );
              _cacheGameStateUseCase(CacheGameStateParams(state: stateEntity));

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
