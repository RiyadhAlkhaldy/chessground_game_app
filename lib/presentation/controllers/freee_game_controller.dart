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

  Position get initail => Chess.fromSetup(Setup.parseFen(fen));
  // String _fen = kInitialFEN;
  // String _fen = '2b1k3/p4p2/7P/4p3/3p4/8/P1P2P1P/R2QK1NR w - - 0 4';
  // String _fen = 'k7/8/8/8/8/8/p7/K7 b - - 0 1';
  String _fen = "8/P7/8/k7/8/8/8/K7 w - - 0 1";
  // '1nbqkbn1/8/8/8/8/8/8/1NB1KBN1 w KQkq - 96 96'
  // 'rnbqkbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 3';

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

    // ever(gameState, (_) {
    //   if (gameState.position.isGameOver) {}
    // });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.result;
  }

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
              "the ${gameState.result?.winner?.opposite}resigned, the owner is ${gameState.result?.winner}";
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
  void setAgreementDraw() => gameState.setAgreementDraw();

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => gameState.resign(side);

  // GameStatus get gameStatus {
  //   if (gameState.isCheckmate) {
  //     return GameStatus.checkmate;
  //   }
  //   if (gameState.isResigned()) return GameStatus.resignation;
  //   if (gameState.isAgreedDraw()) return GameStatus.agreement;
  //   if (gameState.isFiftyMoveRule()) return GameStatus.fiftyMoveRule;
  //   if (gameState.isStalemate) return GameStatus.stalemate;
  //   if (gameState.isInsufficientMaterial) {
  //     return GameStatus.insufficientMaterial;
  //   }
  //   if (gameState.isThreefoldRepetition()) {
  //     return GameStatus.threefoldRepetition;
  //   }
  //   if (gameState.isTimeout()) return GameStatus.timeout;

  //   return GameStatus.ongoing;
  // }

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

      gameStatus;
      update();
    }
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

  RxString statusText = "free Play".obs;
  // void updateTextState() {
  //   statusText.value = "";
  //   switch (gameStatus) {
  //     case GameStatus.checkmate:
  //     case GameStatus.resignation:
  //     case GameStatus.timeout:
  //       if (gameState.result == Outcome.blackWins) {
  //         _updateGameEnd();
  //         statusText.value += 'الفائز: لابيض';
  //       }
  //       if (gameState.result == Outcome.blackWins) {
  //         _updateGameEnd();
  //         statusText.value += 'الفائز: لأسود';
  //       }
  //       return;
  //     case GameStatus.ongoing:
  //       if (gameState.isCheck) {
  //         statusText.value = '(كش)';
  //         return;
  //       }
  //       if (gameState.turn == Side.white) {
  //         statusText.value = "دور الأبيض";
  //         return;
  //       } else if (gameState.turn == Side.black) {
  //         statusText.value = "دور الأسود";
  //         return;
  //       }
  //     case GameStatus.stalemate:
  //       statusText.value += 'طريق مسدود!';
  //       return;
  //     case GameStatus.agreement:
  //       statusText.value += 'بالإتفاق';
  //       return;
  //     case GameStatus.threefoldRepetition:
  //       statusText.value += 'تكرار الوضعية ثلاث مرات';
  //       return;
  //     case GameStatus.fiftyMoveRule:
  //       statusText.value += 'خمسون نقلة متتالية';
  //       return;
  //     case GameStatus.insufficientMaterial:
  //       statusText.value += "الموارد غير كافية";
  //       return;
  //   }
  // }

  // void _updateGameEnd() {
  //   if (gameState.isCheckmate) {
  //     statusText.value = "كش موت:";
  //   } else if (gameState.isResigned()) {
  //     statusText.value = "غارد اللعب:";
  //   } else if (gameState.isTimeout()) {
  //     statusText.value = "أنتهاء الوقت:";
  //   }
  // }
}
