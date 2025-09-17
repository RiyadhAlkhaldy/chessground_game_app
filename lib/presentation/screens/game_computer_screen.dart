import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../controllers/chess_board_settings_controller.dart';
import '../controllers/game_computer_controller.dart';
import '../widgets/chess_board_settings_widgets.dart';

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

  final ctrl = Get.put(
    GameComputerController(Get.find(), Get.find(), Get.find()),
  );
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

  Widget buildNewRoundButton() => FilledButton.icon(
    icon: const Icon(Icons.refresh_rounded),
    label: const Text('New Round'),
    onPressed: () {
      ctrl.reset();
    },
  );

  Widget buildUndoButton() => GetX<GameComputerController>(
    builder: (controller) => FilledButton.icon(
      icon: const Icon(Icons.undo_rounded),
      label: const Text('Undo'),
      onPressed: controller.canUndo.value ? controller.undoMove : null,
    ),
  );
  Widget buildRedoButton() => GetX<GameComputerController>(
    builder: (controller) => FilledButton.icon(
      icon: const Icon(Icons.redo_rounded),
      label: const Text('Redo'),
      onPressed: controller.canRedo.value ? controller.redoMove : null,
    ),
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
          builder: (_) {
            return Obx(() {
              return ctrl.stockfishState.value != StockfishState.ready
                  ? const CircularProgressIndicator()
                  : Chessboard(
                      size: min(constraints.maxWidth, constraints.maxHeight),
                      settings: ChessboardSettings(
                        pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                        colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                        border: ctrlBoardSettings.showBorder.value
                            ? BoardBorder(
                                width: 16.0,
                                color: darken(
                                  ctrlBoardSettings
                                      .boardTheme
                                      .value
                                      .colors
                                      .darkSquare,
                                  0.2,
                                ),
                              )
                            : null,
                        enableCoordinates: true,

                        // showLastMove: true,
                        // enablePremoveCastling: true,
                        // showValidMoves: true,
                        autoQueenPromotion: false,
                        animationDuration:
                            ctrlBoardSettings.pieceAnimation.value
                            ? const Duration(milliseconds: 200)
                            : Duration.zero,

                        dragFeedbackScale: ctrlBoardSettings.dragMagnify.value
                            ? 2.0
                            : 1.0,
                        dragTargetKind: ctrlBoardSettings.dragTargetKind.value,
                        drawShape: DrawShapeOptions(
                          enable: ctrlBoardSettings.drawMode,
                          onCompleteShape: ctrlBoardSettings.onCompleteShape,
                          onClearShapes: () {
                            ctrlBoardSettings.shapes.value = ISet<Shape>();
                          },
                        ),
                        pieceShiftMethod:
                            ctrlBoardSettings.pieceShiftMethod.value,
                        autoQueenPromotionOnPremove: false,
                        pieceOrientationBehavior:
                            // controller.playMode == Mode.freePlay
                            // PieceOrientationBehavior.opponentUpsideDown,
                            PieceOrientationBehavior.facingUser,
                      ),
                      orientation: ctrlBoardSettings.orientation.value,

                      fen: ctrl.fen,
                      lastMove: ctrl.lastMove,
                      game: GameData(
                        playerSide: ctrl.playerSide,
                        validMoves: ctrl.validMoves,
                        sideToMove: ctrl.position.value.turn,
                        isCheck: ctrl.position.value.isCheck,
                        promotionMove: ctrl.promotionMove.value,
                        onMove: ctrl.playMove,
                        onPromotionSelection: ctrl.onPromotionSelection,
                        premovable: (
                          onSetPremove: ctrl.onSetPremove,
                          premove: ctrl.premove?.value,
                        ),
                      ),

                      shapes: ctrlBoardSettings.shapes.value.isNotEmpty
                          ? ctrlBoardSettings.shapes.value
                          : null,
                    );
            });
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
            child: ChessBoardSettingsWidgets(controller: ctrlBoardSettings),
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
              Expanded(
                child: ChessBoardSettingsWidgets(controller: ctrlBoardSettings),
              ),
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
      appBar: AppBar(
        title: GetX<GameComputerController>(
          builder: (_) {
            return Text(ctrl.statusText.value);
          },
        ),
      ),

      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }
}
