import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_clock_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/stockfish_engine_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/init_chess_game.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/game_usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameComputerWithTimeController extends GameComputerController {
  final ChessClockService clockCtrl;
  GameStartUpController? gameCtrl;

  GameComputerWithTimeController(
    SideChoosingController choosingCtrl,
    StockfishEngineService engineService,
    PlaySoundUseCase plySound,
    InitChessGame initChessGame,
    this.clockCtrl,
  ) : super(choosingCtrl, engineService, plySound, initChessGame) {
    gameCtrl = Get.find<GameStartUpController>();
  }

  @override
  void onInit() {
    super.onInit();
    clockCtrl.start();
  }

  @override
  void onClose() {
    clockCtrl.onClose();
    super.onClose();
  }

  @override
  Future<void> initPlayers() async {
    if (gameCtrl?.playerColor.value == Side.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
      await createOrGetGustPlayer().then(
        (value) => whitePlayer.value = value!.toModel(),
      );
      await createOrGetGustPlayer(
        uuidKeyForAI,
      ).then((value) => blackPlayer.value = value!.toModel());
    } else if (gameCtrl?.playerColor.value == Side.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      await createOrGetGustPlayer(
        uuidKeyForAI,
      ).then((value) => whitePlayer.value = value!.toModel());

      await createOrGetGustPlayer().then(
        (value) => blackPlayer.value = value!.toModel(),
      );
    }
  }

  @override
  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    if (isPromotionPawnMove(move)) {
      promotionMove.value = move;
      update();
    } else if (gameState.position.isLegal(move)) {
      // Use base class applyMove method
      applyMove(move);
      validMoves = ValidMoves(const {});
      promotionMove.value = null;

      // Update Stockfish position
      engineService.setPosition(fen: fen);
      update();

      // Switch clock
      clockCtrl.switchTurn(gameState.turn.opposite);

      await playAiMove();
      update();
    }
    tryPlayPremove();
  }

  @override
  Future<void> playAiMove() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (gameState.isGameOver) return;

    final allMoves = [
      for (final entry in gameState.position.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];

    if (allMoves.isNotEmpty) {
      engineService.goMovetime(thinkingTimeForAI);
    }
  }

  @override
  void makeMoveAi(String best) async {
    debugPrint("best move from stockfish: $best");

    final bestMove = NormalMove.fromUci(best);
    if (gameState.position.isLegal(bestMove) == false) return;

    if (gameState.position.isLegal(bestMove)) {
      // Use base class applyMove
      applyMove(bestMove);

      // Update Stockfish position
      engineService.setPosition(fen: fen);

      // Switch clock
      clockCtrl.switchTurn(gameState.turn.opposite);

      update();
      tryPlayPremove();
    }
  }

  // Method to apply the settings from SideChoosingController
  @override
  void applyStockfishSettings() {
    // Override to use settings from gameCtrl if needed, or just call super
    super.applyStockfishSettings();
  }
}

/// عند انتهاء الوقت — نفعل هذه الدالة (clockService يجب أن يمرّر الجانب الذي انتهى الوقت له)
void handleTimeout(Side timedOutSide) async {
  final clockCtrl = Get.find<ChessClockService>();
  final engineService = Get.find<StockfishEngineService>();
  final gameComputerWithTimeController =
      Get.find<GameComputerWithTimeController>();
  debugPrint('Handling timeout for side: $timedOutSide');
  // من انتهى وقته يخسر، والآخر يفوز (ما لم تكن الحالة تمنع ذلك)
  final winnerSide = timedOutSide == Side.white ? Side.black : Side.white;
  final resultText = winnerSide == Side.white ? '1-0' : '0-1';
  debugPrint('Game over by timeout, result: $resultText');
  // نوقف المحرك والساعة
  engineService.stop();
  clockCtrl.stop();

  gameComputerWithTimeController.statusText.value =
      'انتهى وقت ${timedOutSide == Side.white ? "الأبيض" : "الأسود"}.';
  // gameComputerWithTimeController.whitePlayer.refresh();
  // gameComputerWithTimeController.blackPlayer.refresh();
  gameComputerWithTimeController.update();
  clockCtrl.blackTimeMs.refresh();
  clockCtrl.whiteTimeMs.refresh();
  // احفظ اللعبة في الـ DB عبر GameStorageService
  try {} catch (e) {
    debugPrint('Error saving game on timeout: handleTimeout $e');
  }
}
