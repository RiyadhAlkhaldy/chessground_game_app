import 'package:chessground_game_app/features/online_game/domain/usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/features/online_game/presentation/controllers/online_features.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class OnlineGameController extends BaseGameController
    implements OnlineFeatures {
  final PlayMove playMoveUsecase;

  OnlineGameController({
    required super.plySound,
    required this.playMoveUsecase,
  });

  @override
  int getMaterialOnBoard(Side side) {
    throw UnimplementedError();
  }

  @override
  List<Role> getCapturedPieces(Side side) {
    throw UnimplementedError();
  }

  @override
  String getPgnString() {
    throw UnimplementedError();
  }

  @override
  Future<void> acceptDraw() {
    throw UnimplementedError();
  }

  @override
  Future<void> connectToGame(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<void> declineDraw() {
    throw UnimplementedError();
  }

  @override
  Future<void> offerDraw() {
    throw UnimplementedError();
  }

  @override
  Stream<NormalMove> receiveMoves() {
    throw UnimplementedError();
  }

  @override
  Future<void> resign(Side side) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMove(NormalMove move) {
    throw UnimplementedError();
  }

  @override
  Future<void> startNewGame({
    required String whitePlayerName,
    required String blackPlayerName,
    String? event,
    String? site,
    String? timeControl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> agreeDraw() async {
    try {
      // TODO: Send draw agreement to opponent via network
      AppLogger.gameEvent('AgreeDrawOnline');

      Get.snackbar(
        'Draw Agreed',
        'Both players agreed to a draw',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in agreeDraw',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> checkMate() async {
    try {
      final winner = gameState.turn == Side.white ? Side.black : Side.white;
      AppLogger.gameEvent('CheckmateOnline', data: {'winner': winner.name});

      // TODO: Send game end notification to server

      Get.snackbar(
        'Checkmate!',
        '${winner == Side.white ? 'White' : 'Black'} wins by checkmate!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in checkMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> draw() async {
    try {
      AppLogger.gameEvent('DrawOnline');

      // TODO: Send draw result to server

      Get.snackbar(
        'Game Drawn',
        'The game ended in a draw',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in draw',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> fiftyMoveRule() async {
    try {
      AppLogger.gameEvent('FiftyMoveRuleOnline');

      // TODO: Send game end notification to server

      Get.snackbar(
        'Draw by Fifty-Move Rule',
        'Game drawn due to fifty-move rule',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in fiftyMoveRule',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> insufficientMaterial() async {
    try {
      AppLogger.gameEvent('InsufficientMaterialOnline');

      // TODO: Send game end notification to server

      Get.snackbar(
        'Draw by Insufficient Material',
        'Game drawn due to insufficient material',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in insufficientMaterial',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> staleMate() async {
    try {
      AppLogger.gameEvent('StalemateOnline');

      // TODO: Send game end notification to server

      Get.snackbar(
        'Stalemate!',
        'Game ended in a stalemate - it\'s a draw',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in staleMate',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> threefoldRepetition() async {
    try {
      AppLogger.gameEvent('ThreefoldRepetitionOnline');

      // TODO: Send game end notification to server

      Get.snackbar(
        'Draw by Threefold Repetition',
        'Game drawn due to threefold repetition',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in threefoldRepetition',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnlineGameController',
      );
    }
  }

  @override
  Future<void> timeOut() async {
    try {
      final loser = gameState.turn;
      final winner = loser == Side.white ? Side.black : Side.white;

      AppLogger.gameEvent(
        'TimeOutOnline',
        data: {'loser': loser.name, 'winner': winner.name},
      );

      // TODO: Send timeout notification to server

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
        tag: 'OnlineGameController',
      );
    }
  }
}
