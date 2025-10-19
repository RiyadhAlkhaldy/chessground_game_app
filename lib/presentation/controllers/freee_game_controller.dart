import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/helper/helper_methodes.dart';
import '../../data/game_state/game_state.dart';
import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/services/stockfish_engine_service.dart';
import 'chess_board_settings_controller.dart';

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
    return gameState.result?.winner;
  }

  final PlaySoundUseCase plySound;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  FreeGameController(this.plySound);
  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.both;

  @override
  void onInit() {
    super.onInit();
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    update();
    // ever(gameState, (_) {
    //   if (gameState.position.isGameOver) {}
    // });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.result;
  }

  RxString statusText = "free Play".obs;

  Future<GameStatus> get gameStatus async {
    if (gameState.isGameOverExtended) {
      if (gameState.isMate) {
        statusText.value = "the owner is ${gameState.result?.winner}";
        if (gameState.isCheckmate) {
          statusText.value = "checkmate ${statusText.value}";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.checkmate;
        }
        if (gameState.isTimeout()) {
          statusText.value = "timeout ${statusText.value}";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.timeout;
        }
        if (gameState.isResigned()) {
          statusText.value =
              "the ${gameState.result?.winner?.opposite.name} resigned, the owner is ${gameState.result?.winner!.name}";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.resignation;
        }
      } else if (gameState.isDraw) {
        statusText.value = "the result is Draw,";

        if (gameState.isFiftyMoveRule()) {
          statusText.value = "${statusText.value} cause fifty move rule";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.fiftyMoveRule;
        }
        if (gameState.isStalemate) {
          statusText.value = "${statusText.value} cause stalemate";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.stalemate;
        }
        if (gameState.isInsufficientMaterial) {
          statusText.value = "${statusText.value} cause insufficient Material";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.insufficientMaterial;
        }
        if (gameState.isThreefoldRepetition()) {
          statusText.value =
              "${statusText.value} cause is threefold Repetition";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.threefoldRepetition;
        }
        if (gameState.isAgreedDraw()) {
          statusText.value = "${statusText.value} cause is Agreed Draw";
          await showGameOverDialog(Get.context!, statusText.value);
          return GameStatus.agreement;
        }
      }
    }

    ///
    if (gameState.turn == Side.white) {
      statusText.value = "دور الأبيض";
    } else if (gameState.turn == Side.black) {
      statusText.value = "دور الأسود";
    }
    if (gameState.isCheck) {
      statusText.value += '(كش)';
    }

    ///
    return GameStatus.ongoing;
  }

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {gameState.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {gameState.resign(side), update()};

  ///reset
  void reset() {
    gameState = GameState(initial: initail);

    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    promotionMove = null;
    debugPrint('reset to $fen');
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
      _capturedPiecesResult();
      gameStatus;
      update();
    }
    tryPlayPremove();
  }

  void _capturedPiecesResult() {
    final capturedWhite = gameState.getCapturedPieces(Side.white);
    final capturedBlack = gameState.getCapturedPieces(Side.black);
    List<Role> whiteRoles = [];
    List<Role> blackRoles = [];
    int whitePoints = 0;
    int blackPoints = 0;
    capturedWhite.forEach((key, value) {
      whitePoints += value;
      whiteRoles.add(key);
    });
    capturedBlack.forEach((key, value) {
      blackPoints += value;
      blackRoles.add(key);
    });
    debugPrint("Side.white $whitePoints $whiteRoles");
    debugPrint(
      "Side.black $blackPoints $blackRoles ${blackRoles.first.name.codeUnits}",
    );
    debugPrint("result = ${(whitePoints - blackPoints)}");
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) {
    gameState.play(move);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
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
    gameState.undoMove();
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    gameStatus;
    update();
  }

  void redoMove() {
    gameState.redoMove();
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    gameStatus;
    update();
  }
}
