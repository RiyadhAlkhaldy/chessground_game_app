import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/helper/helper_methodes.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/freee_game_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import '../../widgets/pgn_horizontal_row.dart';
import 'widgets/chess_clock_widget.dart';

double iconSize = 30;

class FreeGameScreen extends StatelessWidget {
  FreeGameScreen({super.key});

  final ctrl = Get.find<FreeGameController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<FreeGameController>(
          builder: (_) {
            return Text(
              ctrl.statusText.value,
              style: Theme.of(context).textTheme.titleMedium,
            );
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
              builder:
                  (ctrl) => Column(
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
  final ctrl = Get.find<FreeGameController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          Expanded(child: ChessBoardWidget()),

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
      child: GetBuilder<FreeGameController>(
        initState: (_) {},
        builder: (ctrl) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: buildNewRoundButton(ctrl)),
              Expanded(child: buildUndoButton()),
              Expanded(child: buildRedoButton()),
              // Expanded(child: buildMenuButton()),
            ],
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(FreeGameController ctrl) => IconButton(
  icon: Icon(Symbols.refresh, size: iconSize),
  onPressed:
      ctrl.gameState.isGameOverExtended || !ctrl.canUndo.value
          ? null
          : ctrl.reset,
);

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}

class ChessBoardWidget extends GetView<FreeGameController> {
  const ChessBoardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // debugPrint("gameStatus: ${controller.gameStatus}");
          // debugPrint("getResult: ${controller.getResult}");
          // debugPrint(
          //   "getResult:: ${controller.gameState.position.outcome}",
          // );

          return PopScope(
            canPop:
                controller
                    .gameState
                    .isGameOverExtended, // Prevents automatic exit

            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }
              if (controller.getResult != null) {
                Get.back();
              } else {
                final shouldExit = await showExitConfirmationDialog(
                  context,
                ).then((value) {
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
              builder:
                  (ctrlBoardSettings) => Chessboard(
                    size: min(constraints.maxWidth, constraints.maxHeight),
                    settings: ChessboardSettings(
                      pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                      colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                      border:
                          ctrlBoardSettings.showBorder.value
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

                      dragFeedbackScale:
                          ctrlBoardSettings.dragMagnify.value ? 2.0 : 1.0,
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
                      playerSide:
                          controller.gameState.isGameOverExtended
                              ? PlayerSide.none
                              : controller.gameState.position.turn == Side.white
                              ? PlayerSide.white
                              : PlayerSide.black,
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

                    shapes:
                        ctrlBoardSettings.shapes.value.isNotEmpty
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

Widget buildUndoButton() => GetX<FreeGameController>(
  builder:
      (controller) => IconButton(
        icon: Icon(Symbols.chevron_left, size: iconSize),
        onPressed: controller.canUndo.value ? controller.undoMove : null,
      ),
);
Widget buildRedoButton() => GetX<FreeGameController>(
  builder:
      (controller) => IconButton(
        icon: Icon(Symbols.chevron_right, size: iconSize),
        onPressed: controller.canRedo.value ? controller.redoMove : null,
      ),
);
Widget buildMenuButton() => GetX<FreeGameController>(
  builder:
      (controller) => IconButton(
        icon: Icon(Symbols.menu, size: iconSize),
        onPressed: () {
          Get.generalDialog(
            pageBuilder:
                (context, animation, secondaryAnimation) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: screenPadding,
                  ),
                  child: ChessBoardSettingsWidgets(),
                ),
          );
        },
      ),
);
