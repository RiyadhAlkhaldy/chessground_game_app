import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/freee_game_controller.dart';
import 'package:chessground_game_app/features/offline_game/presentation/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/features/offline_game/presentation/widgets/chess_clock_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_settings_widgets.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/pgn_horizontal_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class FreeGamePage extends StatelessWidget {
  FreeGamePage({super.key});

  final ctrl = Get.find<FreeGameController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<FreeGameController>(
          builder: (_) {
            return Text(ctrl.statusText.value, style: Theme.of(context).textTheme.titleMedium);
          },
        ),
      ),

      body: OrientationBuilder(
        builder: (context, orientation) =>
            orientation == Orientation.portrait ? BuildPortrait() : BuildLandScape(),
      ),
    );
  }
}

class BuildPortrait extends StatelessWidget {
  BuildPortrait({super.key});
  final ctrl = Get.find<FreeGameController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GetBuilder<FreeGameController>(
              builder: (controller) {
                return PgnHorizontalRow(
                  tokens: ctrl.pgnTokens,
                  currentHalfmoveIndex: ctrl.currentHalfmoveIndex,
                  onJumpTo: (idx) => ctrl.jumpToHalfmove(idx),
                );
              },
            ),
            GetBuilder<FreeGameController>(
              builder: (ctrl) => Column(
                children: [
                  ShowCircleAvatarAndTimerInUp(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState.value,
                  ),
                  const ChessBoardWidget(),
                  ShowCircleAvatarAndTimerInDown(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState.value,
                  ),
                ],
              ),
            ),

            const SizedBox(height: screenPortraitSplitter),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
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
  final ctrl = Get.find<FreeGameController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          Expanded(child: GetBuilder<FreeGameController>(builder: (_) => const ChessBoardWidget())),

          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<FreeGameController>(
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
                  gameState: ctrl.gameState.value,
                ),
                ShowCircleAvatarAndTimerInDown(
                  whitePlayer: ctrl.whitePlayer,
                  blackPlayer: ctrl.blackPlayer,
                  whiteCapturedList: ctrl.whiteCapturedList,
                  blackCapturedList: ctrl.blackCapturedList,
                  gameState: ctrl.gameState.value,
                ),
                const Expanded(child: ChessBoardSettingsWidgets()),
                const SizedBox(height: screenPortraitSplitter),
                const BuildControlButtons(),
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
      child: GetBuilder<FreeGameController>(
        initState: (_) {},
        builder: (ctrl) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: buildNewRoundButton(ctrl)),
              Expanded(child: buildUndoButton()),
              Expanded(child: buildRedoButton()),
              Expanded(child: buildMenuButton()),
            ],
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(FreeGameController ctrl) => IconButton(
  icon: Icon(Symbols.refresh, size: iconSize),
  onPressed: ctrl.gameState.value!.isGameOverExtended || !ctrl.canUndo.value ? null : ctrl.reset,
);

Widget buildUndoButton() => GetX<FreeGameController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_left, size: iconSize),
    onPressed: controller.canUndo.value ? controller.undoMove : null,
  ),
);
Widget buildRedoButton() => GetX<FreeGameController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_right, size: iconSize),
    onPressed: controller.canRedo.value ? controller.redoMove : null,
  ),
);
Widget buildMenuButton() => IconButton(
  icon: Icon(Symbols.menu, size: iconSize),
  onPressed: () {
    Get.dialog(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: ChessBoardSettingsWidgets(),
      ),
      name: Get.context!.l10n.mobileBoardSettings,
      barrierColor: Theme.of(Get.context!).dialogTheme.backgroundColor,
    );
  },
);
