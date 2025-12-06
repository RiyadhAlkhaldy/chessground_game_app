import 'dart:async';

import 'package:chessground_game_app/core/global_feature/domain/services/chess_clock_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/stockfish_engine_service.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/interfaces/end_game_interfaces.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/game_computer_controller.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameComputerWithTimeController extends GameComputerController
    implements TimeOutInterface {
  final ChessClockService clockCtrl;
  GameStartUpController? gameCtrl;

  GameComputerWithTimeController({
    required super.choosingCtrl,
    required super.engineService,
    required super.plySound,
    required this.clockCtrl,
    required super.saveGameUseCase,
    required super.cacheGameStateUseCase,
    required super.getOrCreateGuestPlayerUseCase,
  });

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
      engineService.setPosition(fen: currentFen);

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

  @override
  Future<void> timeOut() async {
    try {
      final loser = gameState.turn;
      final winner = loser == Side.white ? Side.black : Side.white;

      AppLogger.gameEvent(
        'TimeOut',
        data: {'loser': loser.name, 'winner': winner.name},
      );

      // await _saveGameToDatabase();

      Get.snackbar(
        'Time Out!',
        '${loser == Side.white ? 'White' : 'Black'} lost on time. ${winner == Side.white ? 'White' : 'Black'} wins!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in timeOut',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
    }
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
