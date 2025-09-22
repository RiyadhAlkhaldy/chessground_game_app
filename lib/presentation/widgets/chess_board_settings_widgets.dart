import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';

import '../../core/board_theme.dart';
import '../controllers/chess_board_settings_controller.dart';
import '../controllers/game_computer_controller.dart';
import '../screens/game_computer/game_computer_screen.dart';

class ChessBoardSettingsWidgets extends StatefulWidget {
  const ChessBoardSettingsWidgets({super.key, required this.controller});
  final ChessBoardSettingsController controller;

  @override
  State<ChessBoardSettingsWidgets> createState() =>
      _ChessBoardSettingsWidgetsState();
}

class _ChessBoardSettingsWidgetsState extends State<ChessBoardSettingsWidgets> {
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

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                  value: widget.controller.dragMagnify.value ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      widget.controller.dragMagnify.value =
                          !widget.controller.dragMagnify.value;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Drag target',
                  value: widget.controller.dragTargetKind.value.name,
                  onPressed: () =>
                      widget.controller.showChoicesPicker<DragTargetKind>(
                        context,
                        choices: DragTargetKind.values,
                        selectedItem: widget.controller.dragTargetKind.value,
                        labelBuilder: (t) => Text(t.name),
                        onSelectedItemChanged: (DragTargetKind value) {
                          setState(() {
                            widget.controller.dragTargetKind.value = value;
                          });
                        },
                      ),
                ),
                buildSettingsButton(
                  label: 'Orientation',
                  value: widget.controller.orientation.value.name,
                  onPressed: () {
                    setState(() {
                      widget.controller.orientation.value =
                          widget.controller.orientation.value.opposite;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Show border',
                  value: widget.controller.showBorder.value ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      widget.controller.showBorder.value =
                          !widget.controller.showBorder.value;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece set',
                  value: widget.controller.pieceSet.value.label,
                  onPressed: () =>
                      widget.controller.showChoicesPicker<PieceSet>(
                        context,
                        choices: PieceSet.values,
                        selectedItem: widget.controller.pieceSet.value,
                        labelBuilder: (t) => Text(t.label),
                        onSelectedItemChanged: (PieceSet? value) {
                          setState(() {
                            if (value != null) {
                              widget.controller.pieceSet.value = value;
                            }
                          });
                        },
                      ),
                ),
                buildSettingsButton(
                  label: 'Board theme',
                  value: widget.controller.boardTheme.value.label,
                  onPressed: () =>
                      widget.controller.showChoicesPicker<BoardTheme>(
                        context,
                        choices: BoardTheme.values,
                        selectedItem: widget.controller.boardTheme.value,
                        labelBuilder: (t) => Text(t.label),
                        onSelectedItemChanged: (BoardTheme? value) {
                          setState(() {
                            if (value != null) {
                              widget.controller.boardTheme.value = value;
                            }
                          });
                        },
                      ),
                ),
                buildSettingsButton(
                  label: 'Piece animation',
                  value: widget.controller.pieceAnimation.value ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      widget.controller.pieceAnimation.value =
                          !widget.controller.pieceAnimation.value;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece Shift',
                  value: pieceShiftMethodLabel(
                    widget.controller.pieceShiftMethod.value,
                  ),
                  onPressed: () =>
                      widget.controller.showChoicesPicker<PieceShiftMethod>(
                        context,
                        choices: PieceShiftMethod.values,
                        selectedItem: widget.controller.pieceShiftMethod.value,
                        labelBuilder: (t) => Text(pieceShiftMethodLabel(t)),
                        onSelectedItemChanged: (PieceShiftMethod? value) {
                          setState(() {
                            if (value != null) {
                              widget.controller.pieceShiftMethod.value = value;
                            }
                          });
                        },
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
