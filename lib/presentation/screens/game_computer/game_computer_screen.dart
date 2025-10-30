import 'package:chessground_game_app/core/const.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/presentation/widgets/pgn_horizontal_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/game_computer_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import 'widgets/chess_board_widget.dart';
import 'widgets/chess_clock_widget.dart';

class GameComputerScreen extends StatelessWidget {
  GameComputerScreen({super.key});

  final ctrl = Get.find<GameComputerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<GameComputerController>(
          builder: (_) {
            return Text(
              ctrl.statusText.value,
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ),

      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? BuildPortrait()
            : BuildLandScape(),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GetBuilder<GameComputerController>(
              builder: (controller) {
                return PgnHorizontalRow(
                  tokens: ctrl.pgnTokens,
                  currentHalfmoveIndex: ctrl.currentHalfmoveIndex,
                  onJumpTo: (idx) => ctrl.jumpToHalfmove(idx),
                );
              },
            ),
            GetBuilder<GameComputerController>(
              builder: (ctrl) => Column(
                children: [
                  ShowCircleAvatarAndTimerInUp(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState,
                  ),
                  ChessBoardWidget(),
                  ShowCircleAvatarAndTimerInDown(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState,
                  ),
                ],
              ),
            ),

            const SizedBox(height: screenPortraitSplitter),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: BuildControlButtons(),
            ),
          ],
        ),
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
          Expanded(
            child: GetBuilder<GameComputerController>(
              builder: (_) => ChessBoardWidget(),
            ),
          ),

          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<GameComputerController>(
                  builder: (controller) {
                    return PgnHorizontalRow(
                      tokens: ctrl.pgnTokens,
                      currentHalfmoveIndex: ctrl.currentHalfmoveIndex,
                      onJumpTo: (idx) => ctrl.jumpToHalfmove(idx),
                    );
                  },
                ),
                ShowCircleAvatarAndTimerInUp(
                  whitePlayer: ctrl.whitePlayer,
                  blackPlayer: ctrl.blackPlayer,
                  whiteCapturedList: ctrl.whiteCapturedList,
                  blackCapturedList: ctrl.blackCapturedList,
                  gameState: ctrl.gameState,
                ),
                ShowCircleAvatarAndTimerInDown(
                  whitePlayer: ctrl.whitePlayer,
                  blackPlayer: ctrl.blackPlayer,
                  whiteCapturedList: ctrl.whiteCapturedList,
                  blackCapturedList: ctrl.blackCapturedList,
                  gameState: ctrl.gameState,
                ),
                Expanded(child: ChessBoardSettingsWidgets()),
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

Widget buildNewRoundButton(GameComputerController ctrl) => IconButton(
  icon: Icon(Symbols.refresh, size: iconSize),
  onPressed: ctrl.gameState.isGameOverExtended || !ctrl.canUndo.value
      ? null
      : ctrl.reset,
);
Widget buildUndoButton() => GetX<GameComputerController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_left, size: iconSize),
    onPressed: controller.canUndo.value ? controller.undoMove : null,
  ),
);
Widget buildRedoButton() => GetX<GameComputerController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_right, size: iconSize),
    onPressed: controller.canRedo.value ? controller.redoMove : null,
  ),
);
Widget buildMenuButton() => IconButton(
  icon: Icon(Symbols.menu, size: iconSize),
  onPressed: () {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: ChessBoardSettingsWidgets(),
      ),
      name: Get.context!.l10n.mobileBoardSettings,
      barrierColor: Theme.of(Get.context!).dialogTheme.backgroundColor,
    );
  },
);
