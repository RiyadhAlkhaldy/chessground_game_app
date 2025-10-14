import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/domain/services/stockfish_engine_service.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/helper_methodes.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/freee_game_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChessBoardWidget(ctrlBoardSettings: ctrlBoardSettings),

          const SizedBox(height: 40),
          const SizedBox(height: screenPortraitSplitter),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: screenPadding),
            child: BuildControlButtons(),
          ),
          // const SizedBox(height: screenPortraitSplitter),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          //   child: BuildControlButtons(),
          // ),
        ],
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
      child: GetBuilder<FreeGameController>(
        initState: (_) {},
        builder: (ctrl) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: buildNewRoundButton(ctrl))],
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(FreeGameController ctrl) => FilledButton.icon(
  icon: const Icon(Icons.refresh_rounded),
  label: const Text('New Round'),
  onPressed: () {
    ctrl.reset();
  },
);

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}

class ChessBoardWidget extends GetView<FreeGameController> {
  const ChessBoardWidget({super.key, required this.ctrlBoardSettings});

  final ChessBoardSettingsController ctrlBoardSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GetBuilder<FreeGameController>(
            builder: (controller) {
              debugPrint("gameStatus: ${controller.gameStatus}");
              debugPrint("getResult: ${controller.getResult}");
              debugPrint(
                "getResult:: ${controller.gameState.position.outcome}",
              );

              return PopScope(
                canPop:
                    controller.gameStatus !=
                    GameStatus.ongoing, // Prevents automatic exit

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
                        // If the user confirms, show the second dialog
                        await showGameOverDialog(context, controller.getResult);
                        // And then, after closing the second dialog, navigate back
                        if (context.mounted) {
                          Get.back();
                        }
                      }
                    }
                  }
                },
                child: Chessboard(
                  size: min(constraints.maxWidth, constraints.maxHeight),
                  settings: ChessboardSettings(
                    pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                    colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                    border:
                        ctrlBoardSettings.showBorder.value
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
                    pieceShiftMethod: ctrlBoardSettings.pieceShiftMethod.value,
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
                        controller.gameStatus != GameStatus.ongoing
                            ? PlayerSide.none
                            : PlayerSide.both,
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
              );
            },
          );
        },
      ),
    );
  }
}
