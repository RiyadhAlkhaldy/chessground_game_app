import 'package:chessground_game_app/data/game_state/game_state.dart';
import 'package:chessground_game_app/domain/services/chess_clock_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets_images.dart';
import '../../../../domain/models/player_model.dart';
import '../../../controllers/chess_board_settings_controller.dart';

String formatMsToClock(int ms) {
  final Duration d = Duration(milliseconds: ms);
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class ShowCircleAvatarAndTimerInUp extends StatelessWidget {
  const ShowCircleAvatarAndTimerInUp({
    super.key,
    required this.whitePlayer,
    required this.blackPlayer,
    this.clockCtrl,
    this.whiteCapturedList,
    this.blackCapturedList,
    this.gameState,
  });

  final Rx<PlayerModel> whitePlayer;
  final Rx<PlayerModel> blackPlayer;
  final ChessClockService? clockCtrl;
  final List<Role>? whiteCapturedList;
  final List<Role>? blackCapturedList;
  final GameState? gameState;
  @override
  Widget build(BuildContext context) {
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    if (ctrlBoardSettings.orientation.value == Side.white) {
      return BlackPlayerClockWidget(
        blackPlayer: blackPlayer,
        clockCtrl: clockCtrl,
        blackCapturedList: blackCapturedList,
        gameState: gameState,
      );
    } else {
      return WhitePlayerClockWidget(
        whitePlayer: whitePlayer,
        clockCtrl: clockCtrl,
        whiteCapturedList: whiteCapturedList,
        gameState: gameState,
      );
    }
  }
}

class ShowCircleAvatarAndTimerInDown extends StatelessWidget {
  const ShowCircleAvatarAndTimerInDown({
    super.key,
    required this.whitePlayer,
    required this.blackPlayer,
    this.clockCtrl,

    this.whiteCapturedList,
    this.blackCapturedList,
    this.gameState,
  });
  final Rx<PlayerModel> whitePlayer;
  final Rx<PlayerModel> blackPlayer;
  final ChessClockService? clockCtrl;

  final List<Role>? whiteCapturedList;
  final List<Role>? blackCapturedList;
  final GameState? gameState;
  @override
  Widget build(BuildContext context) {
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    if (ctrlBoardSettings.orientation.value == Side.white) {
      return WhitePlayerClockWidget(
        whitePlayer: whitePlayer,
        clockCtrl: clockCtrl,
        whiteCapturedList: whiteCapturedList,
        gameState: gameState,
      );
    } else {
      return BlackPlayerClockWidget(
        blackPlayer: blackPlayer,
        clockCtrl: clockCtrl,
        blackCapturedList: blackCapturedList,
        gameState: gameState,
      );
    }
  }
}

class WhitePlayerClockWidget extends StatelessWidget {
  const WhitePlayerClockWidget({
    super.key,
    required this.whitePlayer,
    this.clockCtrl,
    this.whiteCapturedList,
    this.gameState,
  });

  final Rx<PlayerModel> whitePlayer;
  final ChessClockService? clockCtrl;
  final List<Role>? whiteCapturedList;
  final GameState? gameState;
  @override
  Widget build(BuildContext context) {
    final materialAdvantge = gameState!.getMaterialAdvantageSignedForWhite;
    final materialAdvantgeWhite = materialAdvantge > 0 ? materialAdvantge : '';

    return Column(
      children: [
        Obx(
          () => whitePlayer.value.name.isEmpty
              ? const SizedBox()
              : ListTile(
                  leading: whitePlayer.value.image == null
                      ? CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(AssetsImages.userIcon),
                        )
                      : CircleAvatar(
                          radius: 25,

                          backgroundImage: NetworkImage(
                            whitePlayer.value.image!,
                          ),
                        ),
                  title: Text(whitePlayer.value.name.substring(0, 6)),
                  subtitle: Row(
                    children: [
                      Text('Rating: ${whitePlayer.value.playerRating}'),
                      if (whiteCapturedList != null)
                        Text(
                          "${whiteCapturedList!.map((r) => gameState!.roleUnicode(r, isWhite: true)).toList().join()}$materialAdvantgeWhite",
                        ),
                    ],
                  ),
                  trailing: clockCtrl != null
                      ? Text(
                          formatMsToClock(clockCtrl!.whiteTimeMs.value),
                          style: const TextStyle(fontSize: 16),
                        )
                      : null,
                ),
        ),
      ],
    );
  }
}

class BlackPlayerClockWidget extends StatelessWidget {
  const BlackPlayerClockWidget({
    super.key,
    required this.blackPlayer,
    this.clockCtrl,
    this.blackCapturedList,
    this.gameState,
  });

  final Rx<PlayerModel> blackPlayer;
  final ChessClockService? clockCtrl;
  final List<Role>? blackCapturedList;
  final GameState? gameState;
  @override
  Widget build(BuildContext context) {
    final materialAdvantge = gameState!.getMaterialAdvantageSignedForBlack;
    final materialAdvantgeBlack = materialAdvantge > 0 ? materialAdvantge : '';
    return Column(
      children: [
        Obx(
          () => blackPlayer.value.name.isEmpty
              ? const SizedBox()
              : ListTile(
                  leading: blackPlayer.value.image == null
                      ? CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(AssetsImages.userIcon),
                        )
                      : CircleAvatar(
                          radius: 25,

                          backgroundImage: NetworkImage(
                            blackPlayer.value.image!,
                          ),
                        ),
                  title: Text(blackPlayer.value.name.substring(0, 6)),
                  subtitle: Row(
                    children: [
                      Text('Rating: ${blackPlayer.value.playerRating}'),
                      if (blackCapturedList != null)
                        Text(
                          "${blackCapturedList!.map((r) => gameState!.roleUnicode(r, isWhite: false)).toList().join()}$materialAdvantgeBlack",
                        ),
                    ],
                  ),
                  trailing: clockCtrl != null
                      ? Text(
                          formatMsToClock(clockCtrl!.blackTimeMs.value),

                          style: const TextStyle(fontSize: 16),
                        )
                      : null,
                ),
        ),
        // const SizedBox(height: 16),
        // _controls(controller.clockCtrl!),
      ],
    );
  }
}

// ignore: unused_element
Widget _controls(ChessClockService chessClock) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(onPressed: chessClock.start, child: const Text('Start')),
      const SizedBox(width: 2),
      ElevatedButton(onPressed: chessClock.pause, child: const Text('Pause')),
      const SizedBox(width: 2),
      ElevatedButton(onPressed: chessClock.resume, child: const Text('Resume')),
      const SizedBox(width: 2),
      ElevatedButton(
        onPressed: () => chessClock.switchTurn(chessClock.currentTurn.value),
        child: const Text('Switch'),
      ),
      const SizedBox(width: 2),
      ElevatedButton(
        onPressed: () =>
            chessClock.reset(newInitialMs: chessClock.initialTimeMs),
        child: const Text('Reset'),
      ),
    ],
  );
}
