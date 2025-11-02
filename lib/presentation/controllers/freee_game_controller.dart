import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/domain/collections/player.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/dialog/game_result_dialog.dart';
import '../../core/dialog/game_status.dart';
import '../../core/helper/helper_methodes.dart';
import '../../core/dialog/status_l10n.dart';
import '../../data/game_state/game_state.dart';
import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/collections/chess_game.dart';
import '../../domain/models/player_model.dart';
import 'chess_board_settings_controller.dart';
import 'get_storage_controller.dart';

class FreeGameController extends GetxController {
  GameState gameState = GameState();

  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));
  String get _initailLocalFen => Chess.initial.fen;
  // String get _initailLocalFen => "8/P7/8/k7/8/8/8/K7 w - - 0 1";
  late String _fen;

  // ignore: unnecessary_getters_setters
  String get fen => _fen;

  set fen(String value) => _fen = value;

  ValidMoves validMoves = IMap(const {});

  bool get isCheckmate => gameState.isCheckmate;

  Side? get winner {
    return getResult!.winner;
  }

  final PlaySoundUseCase plySound;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storage = Get.find<GetStorageControllerImp>();

  Rx<PlayerModel> whitePlayer = PlayerModel(
    id: 1,
    uuid: 'White_Player',
    name: 'White Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;
  Rx<PlayerModel> blackPlayer = PlayerModel(
    id: 2,
    uuid: 'Black Player',
    name: 'Black Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;
  FreeGameController(this.plySound);
  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.both;
  Future<void> _initPlayer() async {
    final wPlayer = await createPlayerIfNotExists(storage);
    final bPlayer = await createPlayerIfNotExists(storage, 'ai_user_uuid');
    whitePlayer.value = wPlayer!.toModel();
    blackPlayer.value = bPlayer!.toModel();
  }

  @override
  void onInit() {
    super.onInit();
    _initPlayer().then((_) async {
      await plySound.executeDongSound();
    });
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    _listenToGameStatus();
  }

  void _listenToGameStatus() {
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
        Get.dialog(
          GameResultDialog(
            gameState: gameState,
            gameStatus: status,
            reset: reset,
          ),
        );
      }
    });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.result;
  }

  RxString statusText = "free Play".obs;

  GameStatus get gameStatus => gameState.status();

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {gameState.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {
    gameState.resign(side),
    plySound.executeResignSound(),
    update(),
  };

  ///reset
  void reset() {
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    promotionMove = null;
    debugPrint('reset to $fen');
    plySound.executeDongSound();
    statusText.value = "free Play";

    update();
  }

  void tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        onUserMoveAgainstAI(premove!, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    debugPrint("onSetPremove $move");
    premove = move;
    update();
  }

  void onPromotionSelection(Role? role) {
    debugPrint('onPromotionSelection: $role');
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove != null) {
      debugPrint('promotionMove != null');
      onUserMoveAgainstAI(promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove = null;
    update();
  }

  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    if (isPromotionPawnMove(move)) {
      promotionMove = move;
      update();
    } else if (gameState.position.isLegal(move)) {
      _applyMove(move);
      // validMoves = IMap(const {});
      promotionMove = null;
      debugPrint("gameState.position.fen: ${gameState.position.fen}");
      update();
    }
    tryPlayPremove();
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) {
    gameState.play(move);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);

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
    } else {
      // fallback
      plySound.executeMoveSound();
    }
    gameStatus; // to update statusText
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                gameState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                gameState.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true
  RxBool get canUndo =>
      (!gameState.isGameOverExtended && gameState.canUndo).obs;
  RxBool get canRedo =>
      (!gameState.isGameOverExtended && gameState.canRedo).obs;

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
  List<MoveData> get pgnTokens => gameState.getMoveTokens;

  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  /// jump to a halfmove index (0-based). This will rebuild the game state up to that halfmove.
  /// Implementation: get a copy of move objects from gameState, construct a fresh GameState
  /// and replay moves up to `index` then replace controller.gameState with rebuilt one.
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
  String get whiteCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.black);

  // في controller أو widget بعد استدعاء setState/update
  List<Role> get whiteCapturedList =>
      gameState.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList =>
      gameState.getCapturedPiecesList(Side.black);

  @override
  void dispose() {
    gameState.dispose();
    super.dispose();
  }
}
