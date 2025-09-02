import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_computer_controller.dart';
import '../widgets/settings_widgets.dart';

const screenPadding = 16.0;
const screenPortraitSplitter = screenPadding / 2;
const screenLandscapeSplitter = screenPadding;
const buttonHeight = 50.0;
const buttonsSplitter = screenPadding;
const smallButtonsSplitter = screenPadding / 2;

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}

class GameComputerScreen extends StatelessWidget {
  GameComputerScreen({super.key});

  final controller = Get.find<GameComputerController>();

  Widget buildNewRoundButton() => FilledButton.icon(
    icon: const Icon(Icons.refresh_rounded),
    label: const Text('New Round'),
    onPressed: () {
      controller.reset();
    },
  );

  Widget buildUndoButton() => FilledButton.icon(
    icon: const Icon(Icons.undo_rounded),
    label: const Text('Undo'),
    onPressed: controller.undoEnabled ? controller.undo : null,
  );
  Widget buildRedoButton() => FilledButton.icon(
    icon: const Icon(Icons.redo_rounded),
    label: const Text('Redo'),
    onPressed: controller.redoEnabled ? controller.redo : null,
  );
  Widget buildControlButtons() => SizedBox(
    height: buttonHeight,
    child: GetBuilder<GameComputerController>(
      initState: (_) {},
      builder: (_) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: buildNewRoundButton()),
            Expanded(child: buildUndoButton()),
            Expanded(child: buildRedoButton()),
          ],
        );
      },
    ),
  );

  Widget buildChessBoardWidget() => Center(
    child: LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('rebuild buildChessBoardWidget');
        return GetBuilder<GameComputerController>(
          initState: (_) {},
          builder: (_) {
            return Obx(
              () => Chessboard(
                size: min(constraints.maxWidth, constraints.maxHeight),
                settings: ChessboardSettings(
                  pieceAssets: controller.pieceSet.value.assets,
                  colorScheme: controller.boardTheme.value.colors,
                  border: controller.showBorder.value
                      ? BoardBorder(
                          width: 16.0,
                          color: darken(
                            controller.boardTheme.value.colors.darkSquare,
                            0.2,
                          ),
                        )
                      : null,
                  enableCoordinates: true,
                  animationDuration: controller.pieceAnimation.value
                      ? const Duration(milliseconds: 200)
                      : Duration.zero,
                  dragFeedbackScale: controller.dragMagnify.value ? 2.0 : 1.0,
                  dragTargetKind: controller.dragTargetKind.value,
                  drawShape: DrawShapeOptions(
                    enable: controller.drawMode,
                    onCompleteShape: controller.onCompleteShape,
                    onClearShapes: () {
                      controller.shapes.value = ISet<Shape>();
                    },
                  ),
                  pieceShiftMethod: controller.pieceShiftMethod.value,
                  autoQueenPromotionOnPremove: false,
                  pieceOrientationBehavior:
                      // controller.playMode == Mode.freePlay
                      // PieceOrientationBehavior.opponentUpsideDown,
                      PieceOrientationBehavior.facingUser,
                ),
                orientation: controller.orientation.value,

                fen: controller.fen,
                lastMove: controller.lastMove,
                game: GameData(
                  playerSide: controller.position.value.turn == Side.white
                      ? PlayerSide.white
                      : PlayerSide.black,
                  validMoves: controller.validMoves,
                  sideToMove: controller.position.value.turn,
                  isCheck: controller.position.value.isCheck,
                  promotionMove: controller.promotionMove,
                  onMove: controller.playMove,
                  onPromotionSelection: controller.onPromotionSelection,
                  premovable: (
                    onSetPremove: controller.onSetPremove,
                    premove: controller.premove.value,
                  ),
                ),

                shapes: controller.shapes.value.isNotEmpty
                    ? controller.shapes.value
                    : null,
              ),
            );
          },
        );
      },
    ),
  );

  Widget buildPortrait() => Padding(
    padding: const EdgeInsets.only(bottom: screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildChessBoardWidget(),
        //   const SizedBox(height: screenPortraitSplitter),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: screenPadding),
            child: SettingsWidgets(controller: controller),
          ),
        ),
        const SizedBox(height: screenPortraitSplitter),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          child: buildControlButtons(),
        ),
      ],
    ),
  );

  Widget buildLandscape() => Padding(
    padding: const EdgeInsets.all(screenPadding),
    child: Row(
      children: [
        Expanded(child: buildChessBoardWidget()),
        const SizedBox(width: screenLandscapeSplitter),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SettingsWidgets(controller: controller)),
              const SizedBox(height: screenPortraitSplitter),
              buildControlButtons(),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(title: const Text('Random Bot')),

      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }
}
