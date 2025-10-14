import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/helper_methodes.dart';
import '../../../domain/services/stockfish_engine_service.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/game_computer_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import '../../widgets/chess_board_widget.dart';

class GameComputerScreen extends StatelessWidget {
  GameComputerScreen({super.key});

  final ctrl = Get.find<GameComputerController>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents automatic exit

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (ctrl.getResult != GameStatus.ongoing) {
          Get.back();
        } else {
          final shouldExit = await showExitConfirmationDialog(context);

          if (shouldExit == true) {
            if (context.mounted) {
              // If the user confirms, show the second dialog
              await showGameOverDialog(context, ctrl.position.value.outcome!);
              // And then, after closing the second dialog, navigate back
              if (context.mounted) {
                Get.back();
              }
            }
          }
        }
      },
      child: Scaffold(
        primary: MediaQuery.of(context).orientation == Orientation.portrait,
        appBar: AppBar(
          title: GetX<GameComputerController>(
            builder: (_) {
              return Text(ctrl.statusText.value);
            },
          ),
        ),

        body: OrientationBuilder(
          builder:
              (context, orientation) =>
                  orientation == Orientation.portrait
                      ? BuildPortrait()
                      : BuildLandScape(),
        ),
      ),
    );
  }
}

class BuildPortrait extends StatelessWidget {
  BuildPortrait({super.key});
  final ctrl = Get.find<GameComputerController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // EvaluationBarWidget(),
          ChessBoardWidget(ctrlBoardSettings: ctrlBoardSettings),

          //   const SizedBox(height: screenPortraitSplitter),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: ChessBoardSettingsWidgets(controller: ctrlBoardSettings),
            ),
          ),
          const SizedBox(height: screenPortraitSplitter),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: screenPadding),
            child: BuildControlButtons(),
          ),
        ],
      ),
    );
  }
}

class BuildLandScape extends StatelessWidget {
  BuildLandScape({super.key});
  final ctrl = Get.find<GameComputerController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          // EvaluationBarWidget(),
          Expanded(
            child: ChessBoardWidget(ctrlBoardSettings: ctrlBoardSettings),
          ),

          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ChessBoardSettingsWidgets(
                    controller: ctrlBoardSettings,
                  ),
                ),
                const SizedBox(height: screenPortraitSplitter),
                BuildControlButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildControlButtons extends StatelessWidget {
  const BuildControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: GetBuilder<GameComputerController>(
        initState: (_) {},
        builder: (ctrl) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: buildNewRoundButton(ctrl)),
              Expanded(child: buildUndoButton()),
              Expanded(child: buildRedoButton()),
            ],
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(GameComputerController ctrl) => FilledButton.icon(
  icon: const Icon(Icons.refresh_rounded),
  label: const Text('New Round'),
  onPressed: () {
    ctrl.reset();
  },
);

Widget buildUndoButton() => GetX<GameComputerController>(
  builder:
      (controller) => FilledButton.icon(
        icon: const Icon(Icons.undo_rounded),
        label: const Text('Undo'),
        onPressed: controller.canUndo.value ? controller.undoMove : null,
      ),
);
Widget buildRedoButton() => GetX<GameComputerController>(
  builder:
      (controller) => FilledButton.icon(
        icon: const Icon(Icons.redo_rounded),
        label: const Text('Redo'),
        onPressed: controller.canRedo.value ? controller.redoMove : null,
      ),
);
