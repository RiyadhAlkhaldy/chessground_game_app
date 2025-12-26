import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';

import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/game_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/utils/dialog/game_status.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

abstract class BaseGameController extends GetxController {
  // ========== Observable State ==========
  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));

  String get _initailLocalFen => Chess.initial.fen;

  /// Valid moves for chessground (IMap format)
  final Rx<ValidMoves> _validMoves = ValidMoves(const {}).obs;
  set validMoves(ValidMoves validMoves) => _validMoves.value = validMoves;
  ValidMoves get validMoves => _validMoves.value;
  bool get isCheckmate => gameState.isCheckmate;

  Rxn<PlayerEntity> whitePlayer = Rxn();
  Rxn<PlayerEntity> blackPlayer = Rxn();

  bool canPop = false;

  /// Promotion move (waiting for promotion selection)
  final Rx<NormalMove?> promotionMove = Rx<NormalMove?>(null);

  /// Premove
  final Rx<NormalMove?> premove = Rx<NormalMove?>(null);

  PlayerSide playerSide = PlayerSide.white;

  /// Current game state
  final Rx<GameState> _gameState = GameState().obs;
  set gameState(GameState gameState) => _gameState.value = gameState;
  GameState get gameState => _gameState.value;

  /// Current chess game entity
  final Rx<ChessGameEntity?> _currentGame = Rx<ChessGameEntity?>(null);
  set currentGame(ChessGameEntity chessGameEntity) =>
      _currentGame.value = chessGameEntity;
  ChessGameEntity? get currentGame => _currentGame.value;

  /// Loading state
  final RxBool _isLoading = false.obs;
  set isLoading(bool islooding) => _isLoading.value = islooding;
  bool get isLoading => _isLoading.value;

  /// Error message key for localization
  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  /// Current position FEN (reactive)
  final RxString _currentFen = Chess.initial.fen.obs;
  set currentFen(String fen) => _currentFen.value = fen;
  String get currentFen => _currentFen.value;

  Side get currentTurn => gameState.position.turn;

  /// Is game over (reactive)
  final RxBool _isGameOver = false.obs;
  set isGameOver(bool isGameOver) => _isGameOver.value = isGameOver;
  bool get isGameOver => _isGameOver.value;

  /// Game result (reactive)
  final RxString _gameResult = '*'.obs;
  set gameResult(String result) => _gameResult.value = result;
  String get gameResult => _gameResult.value;

  /// Game termination reason (reactive)
  final Rx<GameTermination> _termination = GameTermination.ongoing.obs;
  set termination(GameTermination termination) =>
      _termination.value = termination;
  GameTermination get termination => _termination.value;

  /// Game status (reactive) - The UI should listen to this to show dialogs
  final Rx<GameStatus> _gameStatus = GameStatus.ongoing.obs;
  set gameStatus(GameStatus gameStatus) => _gameStatus.value = gameStatus;
  GameStatus get gameStatus => _gameStatus.value;

  /// Last move metadata (reactive)
  final Rx<MoveDataModel?> _lastMove = Rx<MoveDataModel?>(null);
  set lastMove(MoveDataModel? lastMvoe) => _lastMove.value = lastMvoe;
  MoveDataModel? get lastMove => _lastMove.value;

  /// Can undo (reactive)
  final RxBool _canUndo = false.obs;
  set canUndo(bool canUndo) => _canUndo.value = canUndo;
  RxBool get canUndo => _canUndo;

  /// Can redo (reactive)
  final RxBool _canRedo = false.obs;
  set canRedo(bool canRedo) => _canRedo.value = canRedo;
  RxBool get canRedo => _canRedo;

  /// Material advantage for white (reactive)
  final RxInt _materialAdvantage = 0.obs;
  set materialAdvantage(int materialAdvant) =>
      _materialAdvantage.value = materialAdvant;
  int get materialAdvantage => _materialAdvantage.value;

  /// Is position in check (reactive)
  final RxBool _isCheck = false.obs;
  set isCheck(bool isCheck) => _isCheck.value = isCheck;
  bool get isCheck => _isCheck.value;

  final RxBool _autoSaveEnabled = true.obs;
  bool get autoSaveEnabled => _autoSaveEnabled.value;
  set autoSaveEnabled(bool value) => _autoSaveEnabled.value = value;

  // usecases
  final PlaySoundUseCase plySound;

  final RxnString error = RxnString();

  BaseGameController({required this.plySound});

  @override
  void onInit() {
    super.onInit();
    // This listener replaces the direct dialog call.
    // The view should now observe `gameStatus` to trigger the dialog.
    ever(_gameState, (GameState gs) {
      final status = gs.status();
      if (status != GameStatus.ongoing) {
        gameStatus = status;
      }
    });
  }

  Outcome? get getResult => gameState.result;
  Side? get winner => getResult?.winner;

  /// Agreement draw: set result to draw.
  void setAgreementDraw() {
    gameState.setAgreementDraw();
    updateReactiveState();
  }

  /// Resign: if side resigns, winner is the other side.
  Future<void> resign(Side side) async {
    gameState.resign(side);
    updateReactiveState();
    plySound.executeResignSound();
    AppLogger.gameEvent('PlayerResigned', data: {'side': side.name});
  }

  ///reset
  void reset() {
    gameState = GameState(initial: initail);
    updateReactiveState();
    plySound.executeDongSound();
  }

  void tryPlayPremove() {
    if (premove.value != null) {
      Timer.run(() {
        onUserMove(premove.value!, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    premove.value = move;
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove.value != null) {
      onUserMove(promotionMove.value!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove.value = null;
  }

  /// Handle move from chessground (NormalMove object)
  void onUserMove(NormalMove move, {bool? isDrop, bool? isPremove}) async {
    try {
      if (isGameOver) {
        // Replaced Get.snackbar with an error state update
        setError("gameOverMoveError");
        return;
      }
      // Check if this is a promotion pawn move
      if (isPromotionPawnMove(move)) {
        promotionMove.value = move;
        return;
      }

      // Validate and execute move
      if (gameState.position.isLegal(move)) {
        applyMove(move);
        promotionMove.value = null;
        tryPlayPremove();
      } else {
        // Replaced Get.snackbar with an error state update
        setError("invalidMoveError");
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling user move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      setError('failedToMakeMove');
    }
  }

  void applyMove(NormalMove move) async {
    try {
      gameState.play(move, nags: []);
      AppLogger.info('event status: ${gameState.status()}');

      updateReactiveState();

      final meta = gameState.lastMoveMeta;
      if (meta != null) {
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
      _gameState.refresh();

      AppLogger.move(meta?.san ?? move.uci, fen: currentFen, isCheck: isCheck);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error executing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      setError('failedToExecuteMove');
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                gameState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                gameState.position.turn == Side.white));
  }

  void undoMove() {
    if (canUndo.value) {
      gameState.undoMove();
      updateReactiveState();
      plySound.executeMoveSound();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.redoMove();
      updateReactiveState();
      plySound.executeMoveSound();
    }
  }

  List<MoveDataModel> get pgnTokens => gameState.getMoveTokens;

  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  final Rx<Side> _orientation = Side.white.obs;
  set orientation(Side side) => _orientation.value = side;
  Side get orientation => _orientation.value;

  void jumpToHalfmove(int index) {
    final allMoves = gameState.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState = newState;
    updateReactiveState();
  }

  void navigateToFirstMove() {
    if (pgnTokens.isEmpty) return;
    jumpToHalfmove(0);
  }

  void navigateToLastMove() {
    if (pgnTokens.isEmpty) return;
    jumpToHalfmove(pgnTokens.length - 1);
  }

  void navigateToMove(int index) {
    if (index < 0 || index >= pgnTokens.length) return;
    jumpToHalfmove(index);
  }

  void flipBoard() {
    orientation = orientation == Side.white ? Side.black : Side.white;
  }

  Map<Role, int> get whiteCaptured => gameState.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured => gameState.getCapturedPieces(Side.black);
  String get whiteCapturedText => gameState.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.black);

  List<Role> get whiteCapturedList =>
      gameState.getCapturedPiecesList(Side.white);
  List<Role> get blackCapturedList =>
      gameState.getCapturedPiecesList(Side.black);

  void updateReactiveState() {
    currentFen = gameState.position.fen;
    isGameOver = gameState.isGameOverExtended;
    if (currentGame != null) {
      gameResult = GameService.calculateResult(
        gameState,
        currentGame!.termination,
      );
      termination = currentGame!.termination;
    }
    lastMove = gameState.lastMoveMeta;
    canUndo.value = gameState.canUndo;
    canRedo.value = gameState.canRedo;
    materialAdvantage = gameState.getMaterialAdvantageSignedForWhite;
    isCheck = gameState.isCheck;
    validMoves = makeLegalMoves(gameState.position);
    _gameState.refresh();
  }

  void setLoading(bool value) {
    isLoading = value;
  }

  void setError(String messageKey) {
    _errorMessage.value = messageKey;
    AppLogger.error(messageKey, tag: 'GameController');
  }

  void clearError() {
    _errorMessage.value = '';
  }

  @override
  void dispose() {
    gameState.dispose();
    super.dispose();
  }
}
