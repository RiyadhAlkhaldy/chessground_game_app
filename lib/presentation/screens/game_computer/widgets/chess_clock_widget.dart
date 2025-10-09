import 'package:chessground_game_app/domain/services/chess_clock_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets_images.dart';
import '../../../controllers/chess_board_settings_controller.dart';
import '../../../controllers/game_computer_controller.dart';

String formatMsToClock(int ms) {
  final Duration d = Duration(milliseconds: ms);
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class ShowCircleAvatarAndTimerInUp extends StatelessWidget {
  const ShowCircleAvatarAndTimerInUp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    if (ctrlBoardSettings.orientation.value == Side.white) {
      return BlackPlayerClockWidget();
    } else {
      return WhitePlayerClockWidget();
    }
  }
}

class ShowCircleAvatarAndTimerInDown extends StatelessWidget {
  const ShowCircleAvatarAndTimerInDown({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
    if (ctrlBoardSettings.orientation.value == Side.white) {
      return WhitePlayerClockWidget();
    } else {
      return BlackPlayerClockWidget();
    }
  }
}

class WhitePlayerClockWidget extends StatelessWidget {
  WhitePlayerClockWidget({super.key});

  final controller = Get.find<GameComputerWithTimeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () =>
              controller.whitePlayer.value.name.isEmpty
                  ? const SizedBox()
                  : ListTile(
                    leading:
                        controller.whitePlayer.value.image == null
                            ? CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                AssetsImages.userIcon,
                              ),
                            )
                            : CircleAvatar(
                              radius: 25,

                              backgroundImage: NetworkImage(
                                controller.whitePlayer.value.image!,
                              ),
                            ),
                    title: Text(
                      controller.whitePlayer.value.name.substring(0, 6),
                    ),
                    subtitle: Text(
                      'Rating: ${controller.whitePlayer.value.playerRating}',
                    ),
                    trailing: Text(
                      formatMsToClock(controller.clockCtrl!.whiteTimeMs.value),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
        ),
      ],
    );
  }
}

class BlackPlayerClockWidget extends StatelessWidget {
  BlackPlayerClockWidget({super.key});
  final controller = Get.find<GameComputerWithTimeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () =>
              controller.blackPlayer.value.name.isEmpty
                  ? const SizedBox()
                  : ListTile(
                    leading:
                        controller.blackPlayer.value.image == null
                            ? CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                AssetsImages.userIcon,
                              ),
                            )
                            : CircleAvatar(
                              radius: 25,

                              backgroundImage: NetworkImage(
                                controller.blackPlayer.value.image!,
                              ),
                            ),
                    title: Text(
                      controller.blackPlayer.value.name.substring(0, 6),
                    ),
                    subtitle: Text(
                      'Rating: ${controller.blackPlayer.value.playerRating}',
                    ),
                    trailing: Text(
                      formatMsToClock(controller.clockCtrl!.blackTimeMs.value),

                      style: const TextStyle(fontSize: 16),
                    ),
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
        onPressed:
            () => chessClock.reset(newInitialMs: chessClock.initialTimeMs),
        child: const Text('Reset'),
      ),
    ],
  );
}
