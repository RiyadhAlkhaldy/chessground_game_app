import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/setup_game_vs_ai_mixin.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/storage_features.dart';
import 'package:chessground_game_app/core/utils/game_state/game_state.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_features.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OfflineGameController extends BaseGameController
    with StorageFeatures, SetupGameVsAiMixin
    implements OfflineFeatures {
  OfflineGameController({required super.plySound});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final playerName = args['playerName'] as String;
      final playerSide = args['playerSide'] as PlayerSide;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        startOfflineGame(playerName: playerName, playerSide: playerSide);
      });
    }
  }

  Future<void> startOfflineGame({
    required String playerName,
    required PlayerSide playerSide,
  }) async {
    try {
      isLoading = true;
      this.playerSide = playerSide;

      AppLogger.gameEvent(
        'StartOfflineGame',
        data: {'playerName': playerName, 'playerSide': playerSide.name},
      );

      await startNewGame(
        whitePlayerName: playerSide == PlayerSide.white ? playerName : 'Player 2',
        blackPlayerName: playerSide == PlayerSide.black ? playerName : 'Player 2',
        event: 'Offline Game',
        site: 'Local',
      );

      isLoading = false;
      updateReactiveState();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error starting offline game',
        error: e,
        stackTrace: stackTrace,
        tag: 'OfflineGameController',
      );
      setError(e.toString());
    }
  }

  @override
  void onClose() {
    AppLogger.info('OfflineGameController disposed', tag: 'OfflineGameController');
    super.onClose();
  }

  @override
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) async {
    await super.startNewGame(
      whitePlayerName: whitePlayerName,
      blackPlayerName: blackPlayerName,
      event: event,
      site: site,
      timeControl: timeControl,
    );

    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    ctrlBoardSettings.orientation.value =
        playerSide == PlayerSide.black ? Side.black : Side.white;
  }

  @override
  void applyMove(NormalMove move) async {
    super.applyMove(move);
    if (autoSaveEnabled) {
      await autoSaveGame();
    }
  }

  @override
  Future<void> undoMove() async {
    if (!gameState.canUndo) {
      setError('noMovesToUndo');
      return;
    }
    super.undoMove();
    if (autoSaveEnabled) {
      await autoSaveGame();
    }
  }

  @override
  Future<void> redoMove() async {
    if (!gameState.canRedo) {
      setError('noMovesToRedo');
      return;
    }
    super.redoMove();
    if (autoSaveEnabled) {
      await autoSaveGame();
    }
  }

  @override
  Future<void> resign(Side side) async {
    super.resign(side);
    if (currentGame != null) {
      await storageController.updateGame(currentGame!, gameState);
    }
  }

  @override
  Future<void> agreeDrawn() async {
    setAgreementDraw();
    if (currentGame != null) {
      await storageController.updateGame(currentGame!, gameState);
    }
    AppLogger.gameEvent('DrawByAgreement');
  }

  @override
  void reset() {
    gameState = GameState(); // Use default constructor for initial position
    updateReactiveState();
    promotionMove.value = null;
    premove.value = null;
    AppLogger.gameEvent('GameReset');
  }

  @override
  String getPgnString() {
    if (currentGame == null) return '';
    return gameState.pgnString(
      headers: {
        'Event': currentGame!.event ?? '?',
        'Site': currentGame!.site ?? '?',
        'Date': currentGame!.date?.toString().split(' ')[0] ?? '????.??.??',
        'Round': currentGame!.round ?? '?',
        'White': currentGame!.whitePlayer.name,
        'Black': currentGame!.blackPlayer.name,
      },
    );
  }
  
  @override
  List<Role> getCapturedPieces(Side side) => gameState.getCapturedPiecesList(side);

  @override
  int getMaterialOnBoard(Side side) => gameState.materialOnBoard(side);

  

  
  @override
  Future<void> agreeDraw() => agreeDrawn();

  @override
  Future<void> checkMate() async {
     if (currentGame != null) await storageController.updateGame(currentGame!, gameState);
  }

  @override
  Future<void> draw() => agreeDrawn();

  @override
  Future<void> fiftyMoveRule() async {
     if (currentGame != null) await storageController.updateGame(currentGame!, gameState);
  }

  @override
  Future<void> insufficientMaterial() async {
     if (currentGame != null) await storageController.updateGame(currentGame!, gameState);
  }

  @override
  Future<void> staleMate() async {
     if (currentGame != null) await storageController.updateGame(currentGame!, gameState);
  }

  @override
  Future<void> threefoldRepetition() async {
     if (currentGame != null) await storageController.updateGame(currentGame!, gameState);
  }
}
