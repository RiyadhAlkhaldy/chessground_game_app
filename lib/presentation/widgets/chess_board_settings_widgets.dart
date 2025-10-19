import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/board_theme.dart';
import '../controllers/chess_board_settings_controller.dart';

const screenPadding = 16.0;
const screenPortraitSplitter = screenPadding / 2;
const screenLandscapeSplitter = screenPadding;
const buttonHeight = 50.0;
const buttonsSplitter = screenPadding;
const smallButtonsSplitter = screenPadding / 2;

class ChessBoardSettingsWidgets extends StatelessWidget {
  const ChessBoardSettingsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ChessBoardSettingsController>(
      init: ChessBoardSettingsController(),
      builder:
          (controller) => ListView(
            children: [
              ExpansionTile(
                title: const Text('Settings'),
                initiallyExpanded: true,
                shape: const RoundedRectangleBorder(),
                minTileHeight: 0,
                children: [
                  Wrap(
                    spacing: smallButtonsSplitter,
                    runSpacing: smallButtonsSplitter,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      buildSettingsButton(
                        label: 'Magnify drag',
                        value: controller.dragMagnify.value ? 'ON' : 'OFF',
                        onPressed: () {
                          // setState(() {
                          controller.dragMagnify.value =
                              !controller.dragMagnify.value;
                          // });
                        },
                      ),
                      buildSettingsButton(
                        label: 'Drag target',
                        value: controller.dragTargetKind.value.name,
                        onPressed:
                            () => controller.showChoicesPicker<DragTargetKind>(
                              context,
                              choices: DragTargetKind.values,
                              selectedItem: controller.dragTargetKind.value,
                              labelBuilder: (t) => Text(t.name),
                              onSelectedItemChanged: (DragTargetKind value) {
                                // setState(() {
                                controller.dragTargetKind.value = value;
                                // });
                              },
                            ),
                      ),
                      buildSettingsButton(
                        label: 'Show border',
                        value: controller.showBorder.value ? 'ON' : 'OFF',
                        onPressed: () {
                          // setState(() {
                          controller.showBorder.value =
                              !controller.showBorder.value;
                          // });
                        },
                      ),
                      buildSettingsButton(
                        label: 'Piece set',
                        value: controller.pieceSet.value.label,
                        onPressed:
                            () => controller.showChoicesPicker<PieceSet>(
                              context,
                              choices: PieceSet.values,
                              selectedItem: controller.pieceSet.value,
                              labelBuilder: (t) => Text(t.label),
                              onSelectedItemChanged: (PieceSet? value) {
                                // setState(() {
                                if (value != null) {
                                  controller.pieceSet.value = value;
                                }
                                // });
                              },
                            ),
                      ),
                      buildSettingsButton(
                        label: 'Board theme',
                        value: controller.boardTheme.value.label,
                        onPressed:
                            () => controller.showChoicesPicker<BoardTheme>(
                              context,
                              choices: BoardTheme.values,
                              selectedItem: controller.boardTheme.value,
                              labelBuilder: (t) => Text(t.label),
                              onSelectedItemChanged: (BoardTheme? value) {
                                // setState(() {
                                if (value != null) {
                                  controller.boardTheme.value = value;
                                }
                                // });
                              },
                            ),
                      ),
                      buildSettingsButton(
                        label: 'Piece animation',
                        value: controller.pieceAnimation.value ? 'ON' : 'OFF',
                        onPressed: () {
                          // setState(() {
                          controller.pieceAnimation.value =
                              !controller.pieceAnimation.value;
                          // });
                        },
                      ),
                      buildSettingsButton(
                        label: 'Piece Shift',
                        value: pieceShiftMethodLabel(
                          controller.pieceShiftMethod.value,
                        ),
                        onPressed:
                            () =>
                                controller.showChoicesPicker<PieceShiftMethod>(
                                  context,
                                  choices: PieceShiftMethod.values,
                                  selectedItem:
                                      controller.pieceShiftMethod.value,
                                  labelBuilder:
                                      (t) => Text(pieceShiftMethodLabel(t)),
                                  onSelectedItemChanged: (
                                    PieceShiftMethod? value,
                                  ) {
                                    // setState(() {
                                    if (value != null) {
                                      controller.pieceShiftMethod.value = value;
                                    }
                                    // });
                                  },
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
    );
  }
}

Widget buildSettingsButton({
  required String label,
  required String value,
  required VoidCallback onPressed,
}) => ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
  ),
  onPressed: onPressed,
  child: Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      Text(value, style: const TextStyle(fontSize: 12)),
    ],
  ),
);
String pieceShiftMethodLabel(PieceShiftMethod method) {
  switch (method) {
    case PieceShiftMethod.drag:
      return 'Drag';
    case PieceShiftMethod.tapTwoSquares:
      return 'Tap two squares';
    case PieceShiftMethod.either:
      return 'Either';
  }
}
