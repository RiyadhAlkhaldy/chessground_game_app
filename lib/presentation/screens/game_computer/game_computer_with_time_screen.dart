import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../../core/helper/helper_methodes.dart';
import '../../../domain/services/stockfish_engine_service.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/game_computer_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import 'widgets/chess_clock_widget.dart';

class GameComputerWithTimeScreen extends StatelessWidget {
  GameComputerWithTimeScreen({super.key});

  final ctrl = Get.find<GameComputerWithTimeController>();
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
              //TODO Fix outcome
              var outcome = ctrl.position.value.outcome;
              var outcomeText =
                  '${"الفائز هو :${outcome?.winner == Side.white ? 'الأبيض' : 'الأسود'}"} لقد خسرت هذه اللعبة. يمكنك الآن العودة إلى الصفحة الرئيسية.';
              // If the user confirms, show the second dialog
              await showGameOverDialog(context, outcomeText);
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
          title: GetX<GameComputerWithTimeController>(
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
  final ctrl = Get.find<GameComputerWithTimeController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // EvaluationBarWidget(),
          ShowCircleAvatarAndTimerInUp(),
          ChessBoardWidget(ctrlBoardSettings: ctrlBoardSettings),
          ShowCircleAvatarAndTimerInDown(),

          const SizedBox(height: screenPortraitSplitter),
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
  final ctrl = Get.find<GameComputerWithTimeController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          // EvaluationBarWidget(),
          // ctrlBoardSettings.orientation.value == Side.white
          //     ? ChessClockBlackWidget(chessClock: ctrl.clockCtrl!)
          //     : ChessClockBlackWidget(chessClock: ctrl.clockCtrl!),
          Expanded(
            child: ChessBoardWidget(ctrlBoardSettings: ctrlBoardSettings),
          ),
          // ctrlBoardSettings.orientation.value == Side.white
          //     ? ChessClockBlackWidget(chessClock: ctrl.clockCtrl!)
          //     : ChessClockBlackWidget(chessClock: ctrl.clockCtrl!),
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

Widget buildNewRoundButton(GameComputerWithTimeController ctrl) =>
    FilledButton.icon(
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('New Round'),
      onPressed: () {
        ctrl.reset();
      },
    );

Widget buildUndoButton() => GetX<GameComputerWithTimeController>(
  builder:
      (controller) => FilledButton.icon(
        icon: const Icon(Icons.undo_rounded),
        label: const Text('Undo'),
        onPressed: controller.canUndo.value ? controller.undoMove : null,
      ),
);
Widget buildRedoButton() => GetX<GameComputerWithTimeController>(
  builder:
      (controller) => FilledButton.icon(
        icon: const Icon(Icons.redo_rounded),
        label: const Text('Redo'),
        onPressed: controller.canRedo.value ? controller.redoMove : null,
      ),
);

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}

class ChessBoardWidget extends GetView<GameComputerWithTimeController> {
  const ChessBoardWidget({super.key, required this.ctrlBoardSettings});

  final ChessBoardSettingsController ctrlBoardSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint('rebuild buildChessBoardWidget');

          return GetBuilder<GameComputerWithTimeController>(
            builder:
                (controller) => Obx(() {
                  return controller.stockfishState.value != StockfishState.ready
                      ? const CircularProgressIndicator()
                      : Chessboard(
                        size: min(constraints.maxWidth, constraints.maxHeight),
                        settings: ChessboardSettings(
                          pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                          colorScheme:
                              ctrlBoardSettings.boardTheme.value.colors,
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
                          dragTargetKind:
                              ctrlBoardSettings.dragTargetKind.value,
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

                        shapes:
                            ctrlBoardSettings.shapes.value.isNotEmpty
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
