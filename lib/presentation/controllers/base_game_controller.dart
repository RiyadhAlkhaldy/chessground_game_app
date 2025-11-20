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
  final Rx<ValidMoves> validMoves = ValidMoves(const {}).obs;

  ValidMoves get getValidMoves => validMoves.value;

  bool get isCheckmate => gameState.value.isCheckmate;

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
  final Rx<GameState> gameState = GameState().obs;
  GameState get getGameState => gameState.value;

  /// Current chess game entity
  /// كيان لعبة الشطرنج الحالي
  final Rx<ChessGameEntity?> currentGame = Rx<ChessGameEntity?>(null);
  ChessGameEntity? get getCurrentGame => currentGame.value;

  /// Loading state
  /// حالة التحميل
  final RxBool isLoading = false.obs;
  bool get getIsLoading => isLoading.value;

  /// Error message
  /// رسالة الخطأ
  final RxString errorMessage = ''.obs;
  String get getErrorMessage => errorMessage.value;

  /// Current position FEN (reactive)
  /// FEN الموضع الحالي (تفاعلي)
  final RxString currentFen = Chess.initial.fen.obs;
  String get getCurrentFen => currentFen.value;

  /// Current turn (reactive)
  /// الدور الحالي (تفاعلي)
  final Rx<Side> currentTurn = Side.white.obs;
  Side get getCurrentTurn => currentTurn.value;

  /// Is game over (reactive)
  /// هل انتهت اللعبة (تفاعلي)
  final RxBool setIsGameOver = false.obs;
  bool get isGameOver => setIsGameOver.value;

  /// Game result (reactive)
  /// نتيجة اللعبة (تفاعلية)
  final RxString gameResult = '*'.obs;
  String get getGameResult => gameResult.value;

  /// Game termination reason (reactive)
  /// سبب إنهاء اللعبة (تفاعلي)
  final Rx<GameTermination> termination = GameTermination.ongoing.obs;
  GameTermination get getTermination => termination.value;

  final Rx<GameStatus> gameStatus = GameStatus.ongoing.obs;
  GameStatus get getGameStatus => gameStatus.value;

  /// Last move metadata (reactive)
  /// بيانات آخر حركة (تفاعلية)
  final Rx<MoveDataModel?> lastMove = Rx<MoveDataModel?>(null);
  MoveDataModel? get getLastMove => lastMove.value;

  /// Can undo (reactive)
  /// إمكانية التراجع (تفاعلي)
  final RxBool setCanUndo = false.obs;
  RxBool get canUndo => setCanUndo;

  /// Can redo (reactive)
  /// إمكانية الإعادة (تفاعلي)
  final RxBool setCanRedo = false.obs;
  RxBool get canRedo => setCanRedo;

  /// Material advantage for white (reactive)
  /// ميزة المواد للأبيض (تفاعلي)
  final RxInt materialAdvantage = 0.obs;
  int get getMaterialAdvantage => materialAdvantage.value;

  /// Is position in check (reactive)
  /// هل الموضع في كش (تفاعلي)
  final RxBool setIsCheck = false.obs;
  bool get isCheck => setIsCheck.value;

  //   /// Auto-save enabled
  /// التخزين التلقائي مفعّل
  final RxBool setAutoSaveEnabled = true.obs;
  bool get autoSaveEnabled => setAutoSaveEnabled.value;
  set autoSaveEnabled(bool value) => setAutoSaveEnabled.value = value;

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
    gameState.value.gameStatus.listen((status) {
      if (gameState.value.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (gameState.value.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (gameState.value.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: getGameStatus, lastPosition: gameState.value.position, winner: gameState.value.result?.winner, isThreefoldRepetition: gameState.value.isThreefoldRepetition())} ";
        Get.dialog(GameResultDialog(gameState: gameState.value, gameStatus: status, reset: reset));
      }
    });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.value.result;
  }

  Side? get winner {
    return getResult?.winner;
  }

  RxString statusText = "free Play".obs;

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {gameState.value.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {gameState.value.resign(side), plySound.executeResignSound(), update()};

  ///reset
  void reset() {
    gameState.value = GameState(initial: initail);
    fen = gameState.value.position.fen;
    validMoves.value = makeLegalMoves(gameState.value.position);
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
      if (setIsGameOver.value) {
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
      if (gameState.value.position.isLegal(move)) {
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
      gameState.value.play(move, nags: []);

      // Update reactive state
      updateReactiveState();

      fen = gameState.value.position.fen;
      validMoves.value = makeLegalMoves(gameState.value.position);
      // validMoves.value = gameState.value.position.legalMoves ;

      // decide which sound to play based on metadata
      final meta = gameState.value.lastMoveMeta;
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
      gameState.refresh();
      getGameStatus; // to update statusText

      AppLogger.move(meta?.san ?? move.uci, fen: currentFen.value, isCheck: setIsCheck.value);
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
        gameState.value.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && gameState.value.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && gameState.value.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true

  void undoMove() {
    if (canUndo.value) {
      gameState.value.undoMove();
      fen = gameState.value.position.fen;
      validMoves.value = makeLegalMoves(gameState.value.position);
      // play a feedback sound (optional)
      plySound.executeMoveSound();
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.value.redoMove();
      fen = gameState.value.position.fen;
      validMoves.value = makeLegalMoves(gameState.value.position);
      plySound.executeMoveSound();
      update();
    }
  }

  /// expose PGN tokens for the UI
  List<MoveDataModel> get pgnTokens => gameState.value.getMoveTokens;

  int get currentHalfmoveIndex => gameState.value.currentHalfmoveIndex;

  void jumpToHalfmove(int index) {
    final allMoves = gameState.value.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState.value = newState;
    fen = gameState.value.position.fen;
    validMoves.value = makeLegalMoves(gameState.value.position);
    update();
  }

  Map<Role, int> get whiteCaptured => gameState.value.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured => gameState.value.getCapturedPieces(Side.black);
  String get whiteCapturedText => gameState.value.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons => gameState.value.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons => gameState.value.capturedPiecesAsUnicode(Side.black);

  List<Role> get whiteCapturedList =>
      gameState.value.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList => gameState.value.getCapturedPiecesList(Side.black);

  /// Update all reactive state variables
  void updateReactiveState() {
    currentFen.value = gameState.value.position.fen;
    currentTurn.value = gameState.value.turn;
    setIsGameOver.value = gameState.value.isGameOverExtended;
    if (currentGame.value != null) {
      gameResult.value = GameService.calculateResult(
        gameState.value,
        currentGame.value!.termination,
      );
      termination.value = currentGame.value!.termination;
    }
    lastMove.value = gameState.value.lastMoveMeta;
    setCanUndo.value = gameState.value.canUndo;
    setCanRedo.value = gameState.value.canRedo;
    materialAdvantage.value = gameState.value.getMaterialAdvantageSignedForWhite;
    setIsCheck.value = gameState.value.isCheck;
  }

  /// Set loading state
  void setLoading(bool value) {
    isLoading.value = value;
  }

  /// Set error message
  void setError(String message) {
    errorMessage.value = message;
    AppLogger.error(message, tag: 'GameController');
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  @override
  void dispose() {
    gameState.value.dispose();
    super.dispose();
  }

  String getPgnString();

  List<Role> getCapturedPieces(Side side);

  int getMaterialOnBoard(Side side);
}
