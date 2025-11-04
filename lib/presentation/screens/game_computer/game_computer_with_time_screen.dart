import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../../core/utils/dialog/constants/const.dart';
import '../../../core/utils/styles/styles.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/game_computer_with_time_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import '../../widgets/pgn_horizontal_row.dart';
import 'widgets/chess_clock_widget.dart';

class GameComputerWithTimeScreen extends StatelessWidget {
  GameComputerWithTimeScreen({super.key});

  final ctrl = Get.find<GameComputerWithTimeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<GameComputerWithTimeController>(
          builder: (_) {
            return Text(ctrl.statusText.value);
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
  final ctrl = Get.find<GameComputerWithTimeController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GetBuilder<GameComputerWithTimeController>(
              builder: (controller) {
                return PgnHorizontalRow(
                  tokens: ctrl.pgnTokens,
                  currentHalfmoveIndex: ctrl.currentHalfmoveIndex,
                  onJumpTo: (idx) => ctrl.jumpToHalfmove(idx),
                );
              },
            ),
            GetBuilder<GameComputerWithTimeController>(
              builder: (ctrl) => Column(
                children: [
                  ShowCircleAvatarAndTimerInUp(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState,
                    clockCtrl: ctrl.clockCtrl,
                  ),
                  ChessBoardWidget(),
                  ShowCircleAvatarAndTimerInDown(
                    whitePlayer: ctrl.whitePlayer,
                    blackPlayer: ctrl.blackPlayer,
                    whiteCapturedList: ctrl.whiteCapturedList,
                    blackCapturedList: ctrl.blackCapturedList,
                    gameState: ctrl.gameState,
                    clockCtrl: ctrl.clockCtrl,
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
  final ctrl = Get.find<GameComputerWithTimeController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          Expanded(
            child: GetBuilder<GameComputerWithTimeController>(
              builder: (_) => ChessBoardWidget(),
            ),
          ),

          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<GameComputerWithTimeController>(
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
      child: GetBuilder<GameComputerWithTimeController>(
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

class ChessBoardWidget extends GetView<GameComputerWithTimeController> {
  const ChessBoardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PopScope(
            canPop: controller
                .gameState
                .isGameOverExtended, // Prevents automatic exit

            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }
              if (controller.getResult != null) {
                Get.back();
              } else {
                final shouldExit = await showExitConfirmationDialog(context)
                    .then((value) {
                      if (value != null && value == true) {
                        controller.resign(controller.gameState.turn);
                      }
                      return value;
                    });

                if (shouldExit == true) {
                  if (context.mounted) {
                    // controller.gameStatus;
                    // controller.plySound.executeResignSound();
                    controller.resign(
                      controller.playerSide == PlayerSide.white
                          ? Side.white
                          : Side.black,
                    );
                    await controller.gameStatus;
                    // And then, after closing the second dialog, navigate back
                    // if (context.mounted) {
                    //   Get.back();
                    // }
                  }
                }
              }
            },
            child: GetX<ChessBoardSettingsController>(
              builder: (ctrlBoardSettings) =>
                  controller.stockfishState.value != StockfishState.ready
                  ? const CircularProgressIndicator()
                  : Chessboard(
                      size: min(constraints.maxWidth, constraints.maxHeight),
                      settings: ChessboardSettings(
                        pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                        colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                        border: ctrlBoardSettings.showBorder.value
                            ? BoardBorder(
                                width: 10.0,
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

                      fen: controller.fen,
                      // lastMove: controller.lastMove,
                      game: GameData(
                        playerSide: controller.getResult == null
                            ? controller.playerSide
                            : PlayerSide.none,
                        validMoves: controller.validMoves,
                        sideToMove: controller.gameState.position.turn,
                        isCheck: controller.gameState.position.isCheck,
                        promotionMove: controller.promotionMove,
                        onMove: controller.onUserMoveAgainstAI,
                        onPromotionSelection: controller.onPromotionSelection,
                        premovable: (
                          onSetPremove: controller.onSetPremove,
                          premove: controller.premove,
                        ),
                      ),

                      shapes: ctrlBoardSettings.shapes.value.isNotEmpty
                          ? ctrlBoardSettings.shapes.value
                          : null,
                    ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(GameComputerWithTimeController ctrl) => IconButton(
  icon: Icon(Symbols.refresh, size: iconSize),
  onPressed: ctrl.gameState.isGameOverExtended || !ctrl.canUndo.value
      ? null
      : ctrl.reset,
);
Widget buildUndoButton() => GetX<GameComputerWithTimeController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_left, size: iconSize),
    onPressed: controller.canUndo.value ? controller.undoMove : null,
  ),
);
Widget buildRedoButton() => GetX<GameComputerWithTimeController>(
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
