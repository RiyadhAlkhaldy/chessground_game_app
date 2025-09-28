import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/presentation/controllers/game_computer_controller.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../controllers/chess_board_settings_controller.dart';

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}

class ChessBoardWidget extends GetView<GameComputerController> {
  const ChessBoardWidget({super.key, required this.ctrlBoardSettings});

  final ChessBoardSettingsController ctrlBoardSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint('rebuild buildChessBoardWidget');

          return GetBuilder<GameComputerController>(
            builder: (controller) => Obx(() {
              return controller.stockfishState.value != StockfishState.ready
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

                      fen: controller.fen,
                      // lastMove: controller.lastMove,
                      game: GameData(
                        playerSide: controller.playerSide,
                        validMoves: controller.validMoves,
                        sideToMove: controller.position.value.turn,
                        isCheck: controller.position.value.isCheck,
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
                    );
            }),
          );
        },
      ),
    );
  }
}
