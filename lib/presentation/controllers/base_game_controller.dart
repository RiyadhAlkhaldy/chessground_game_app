import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

import '../../core/game_termination_enum.dart';
import '../../core/utils/dialog/game_result_dialog.dart';
import '../../core/utils/dialog/game_status.dart';
import '../../core/utils/dialog/status_l10n.dart';
import '../../core/utils/game_state/game_state.dart';
import '../../core/utils/logger.dart';
import '../../data/models/move_data_model.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/services/game_service.dart';
import '../../domain/usecases/init_chess_game.dart';
import '../../domain/usecases/play_move.dart';
import '../../domain/usecases/play_sound_usecase.dart';

abstract class BaseGameController extends GetxController {
  // ========== Observable State ==========
  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));

  String get _initailLocalFen => Chess.initial.fen;

  String fen = Chess.initial.fen;

  /// Valid moves for chessground (IMap format)
  final Rx<ValidMoves> _validMoves = ValidMoves(const {}).obs;
  set validMoves(ValidMoves validMoves) => _validMoves.value = validMoves;
  ValidMoves get validMoves => _validMoves.value;
  bool get isCheckmate => gameState.isCheckmate;

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
  set gameState(GameState gameState) => _gameState.value = gameState;
  GameState get gameState => _gameState.value;

  /// Current chess game entity
  /// كيان لعبة الشطرنج الحالي
  final Rx<ChessGameEntity?> _currentGame = Rx<ChessGameEntity?>(null);
  set currentGame(ChessGameEntity chessGameEntity) => _currentGame.value = chessGameEntity;
  ChessGameEntity? get currentGame => _currentGame.value;

  /// Loading state
  /// حالة التحميل
  final RxBool _isLoading = false.obs;
  set isLoading(bool islooding) => _isLoading.value = islooding;
  bool get isLoading => _isLoading.value;

  /// Error message
  /// رسالة الخطأ
  final RxString _errorMessage = ''.obs;
  set errorMessage(String message) => _errorMessage.value = message;
  String get errorMessage => _errorMessage.value;

  /// Current position FEN (reactive)
  /// FEN الموضع الحالي (تفاعلي)
  final RxString _currentFen = Chess.initial.fen.obs;
  set currentFen(String fen) => _currentFen.value = fen;
  String get currentFen => _currentFen.value;

  /// Current turn (reactive)
  /// الدور الحالي (تفاعلي)
  final Rx<Side> _currentTurn = Side.white.obs;
  set currentTurn(Side turn) => _currentTurn.value = turn;
  Side get currentTurn => _currentTurn.value;

  /// Is game over (reactive)
  /// هل انتهت اللعبة (تفاعلي)
  final RxBool _isGameOver = false.obs;
  set isGameOver(bool isGameOver) => _isGameOver.value = isGameOver;
  bool get isGameOver => _isGameOver.value;

  /// Game result (reactive)
  /// نتيجة اللعبة (تفاعلية)
  final RxString _gameResult = '*'.obs;
  set gameResult(String result) => _gameResult.value = result;
  String get gameResult => _gameResult.value;

  /// Game termination reason (reactive)
  /// سبب إنهاء اللعبة (تفاعلي)
  final Rx<GameTermination> _termination = GameTermination.ongoing.obs;
  set termination(GameTermination termination) => _termination.value = termination;
  GameTermination get termination => _termination.value;

  final Rx<GameStatus> _gameStatus = GameStatus.ongoing.obs;
  set gameStatus(GameStatus gameStatus) => _gameStatus.value = gameStatus;
  GameStatus get gameStatus => _gameStatus.value;

  /// Last move metadata (reactive)
  /// بيانات آخر حركة (تفاعلية)
  final Rx<MoveDataModel?> _lastMove = Rx<MoveDataModel?>(null);
  set lastMove(MoveDataModel? lastMvoe) => _lastMove.value = lastMvoe;
  MoveDataModel? get lastMove => _lastMove.value;

  /// Can undo (reactive)
  /// إمكانية التراجع (تفاعلي)
  final RxBool _canUndo = false.obs;
  set canUndo(bool canUndo) => _canUndo.value = canUndo;
  RxBool get canUndo => _canUndo;

  /// Can redo (reactive)
  /// إمكانية الإعادة (تفاعلي)
  final RxBool _canRedo = false.obs;
  set canRedo(bool canRedo) => _canRedo.value = canRedo;
  RxBool get canRedo => _canRedo;

  /// Material advantage for white (reactive)
  /// ميزة المواد للأبيض (تفاعلي)
  final RxInt _materialAdvantage = 0.obs;
  set materialAdvantage(int materialAdvant) => _materialAdvantage.value = materialAdvant;
  int get materialAdvantage => _materialAdvantage.value;

  /// Is position in check (reactive)
  /// هل الموضع في كش (تفاعلي)
  final RxBool _isCheck = false.obs;
  set isCheck(bool isCheck) => _isCheck.value = isCheck;
  bool get isCheck => _isCheck.value;

  //   /// Auto-save enabled
  /// التخزين التلقائي مفعّل
  final RxBool _autoSaveEnabled = true.obs;
  bool get autoSaveEnabled => _autoSaveEnabled.value;
  set autoSaveEnabled(bool value) => _autoSaveEnabled.value = value;

  // usecases
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

  void listenToGameStatus() {
    gameState.gameStatus.listen((status) {
      if (gameState.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (gameState.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (gameState.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: gameState.position, winner: gameState.result?.winner, isThreefoldRepetition: gameState.isThreefoldRepetition())} ";
        Get.dialog(GameResultDialog(gameState: gameState, gameStatus: status, reset: reset));
      }
    });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.result;
  }

  Side? get winner {
    return getResult?.winner;
  }

  RxString statusText = "free Play".obs;

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {gameState.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {gameState.resign(side), plySound.executeResignSound(), update()};

  ///reset
  void reset() {
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    promotionMove.value = null;
    plySound.executeDongSound();
    statusText.value = "free Play";

    update();
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
    update();
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
    update();
  }

  /// Handle move from chessground (NormalMove object)
  /// This is the main method called by chessground
  void onUserMove(NormalMove move, {bool? isDrop, bool? isPremove}) async {
    try {
      if (isGameOver) {
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
      if (gameState.position.isLegal(move)) {
        applyMove(move);
        promotionMove.value = null;
        update();
        tryPlayPremove();
      } else {
        Get.snackbar('Invalid Move', 'This move is not legal', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling user move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      setError('Failed to make move: ${e.toString()}');
    }
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void applyMove(NormalMove move) async {
    try {
      // Play the move
      gameState.play(move, nags: []);

      // Update reactive state
      updateReactiveState();

      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      // validMoves = gameState.position.legalMoves ;

      // decide which sound to play based on metadata
      final meta = gameState.lastMoveMeta;
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
      // update observed gameState! (GameState mutated in-place)
      _gameState.refresh();
      gameStatus; // to update statusText

      AppLogger.move(meta?.san ?? move.uci, fen: currentFen, isCheck: isCheck);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error executing move',
        error: e,
        stackTrace: stackTrace,
        tag: 'GameController',
      );
      setError('Failed to execute move: ${e.toString()}');
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && gameState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && gameState.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true

  void undoMove() {
    if (canUndo.value) {
      gameState.undoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      // play a feedback sound (optional)
      plySound.executeMoveSound();
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.redoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      plySound.executeMoveSound();
      update();
    }
  }

  /// expose PGN tokens for the UI
  List<MoveDataModel> get pgnTokens => gameState.getMoveTokens;

  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  void jumpToHalfmove(int index) {
    final allMoves = gameState.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState = newState;
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    update();
  }

  Map<Role, int> get whiteCaptured => gameState.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured => gameState.getCapturedPieces(Side.black);
  String get whiteCapturedText => gameState.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons => gameState.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons => gameState.capturedPiecesAsUnicode(Side.black);

  List<Role> get whiteCapturedList =>
      gameState.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList => gameState.getCapturedPiecesList(Side.black);

  /// Update all reactive state variables
  void updateReactiveState() {
    currentFen = gameState.position.fen;
    currentTurn = gameState.turn;
    isGameOver = gameState.isGameOverExtended;
    if (currentGame != null) {
      gameResult = GameService.calculateResult(gameState, currentGame!.termination);
      termination = currentGame!.termination;
    }
    lastMove = gameState.lastMoveMeta!;
    canUndo = gameState.canUndo;
    canRedo = gameState.canRedo;
    materialAdvantage = gameState.getMaterialAdvantageSignedForWhite;
    isCheck = gameState.isCheck;
  }

  /// Set loading state
  void setLoading(bool value) {
    isLoading = value;
  }

  /// Set error message
  void setError(String message) {
    errorMessage = message;
    AppLogger.error(message, tag: 'GameController');
  }

  /// Clear error message
  void clearError() {
    errorMessage = '';
  }

  @override
  void dispose() {
    gameState.dispose();
    super.dispose();
  }

  String getPgnString();

  List<Role> getCapturedPieces(Side side);

  int getMaterialOnBoard(Side side);
}
