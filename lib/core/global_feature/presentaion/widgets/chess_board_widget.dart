import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/core/utils/styles/styles.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChessBoardWidget extends GetView<BaseGameController> {
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
                    controller.gameStatus;
                    // And then, after closing the second dialog, navigate back
                    // if (context.mounted) {
                    //   Get.back();
                    // }
                  }
                }
              }
            },
            child: GetX<ChessBoardSettingsController>(
              builder: (ctrlBoardSettings) => controller.isLoading
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
                        promotionMove: controller.promotionMove.value,
                        onMove: controller.onUserMove,
                        onPromotionSelection: controller.onPromotionSelection,
                        premovable: (
                          onSetPremove: controller.onSetPremove,
                          premove: controller.premove.value,
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
