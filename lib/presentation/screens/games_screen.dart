import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/board_theme.dart';
import '../../core/board_thumbnails.dart';
import '../controllers/games_controller.dart';
import 'board_editor_page.dart';

const screenPadding = 16.0;
const screenPortraitSplitter = screenPadding / 2;
const screenLandscapeSplitter = screenPadding;
const buttonHeight = 50.0;
const buttonsSplitter = screenPadding;
const smallButtonsSplitter = screenPadding / 2;

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key, required this.title});

  final String title;

  @override
  State<GamesScreen> createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  final controller = Get.put(GamesController());
  @override
  Widget build(BuildContext context) {
    Widget buildNewRoundButton() => FilledButton.icon(
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('New Round'),
      onPressed: () {
        setState(() {
          controller.position = Chess.initial;
          controller.fen = controller.position.fen;
          controller.validMoves = makeLegalMoves(controller.position);
          controller.lastMove = null;
          controller.lastPos = null;
        });
      },
    );

    Widget buildUndoButton() => FilledButton.icon(
      icon: const Icon(Icons.undo_rounded),
      label: const Text('Undo'),
      onPressed: controller.lastPos != null
          ? () => setState(() {
              controller.position = controller.lastPos!;
              controller.fen = controller.position.fen;
              controller.validMoves = makeLegalMoves(controller.position);
              controller.lastPos = null;
            })
          : null,
    );

    Widget buildControlButtons() => SizedBox(
      height: buttonHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: buildNewRoundButton()),
          if (controller.playMode == Mode.freePlay)
            const SizedBox(width: buttonsSplitter),
          if (controller.playMode == Mode.freePlay)
            Expanded(child: buildUndoButton()),
        ],
      ),
    );

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

    final settingsWidgets = ListView(
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
                  value: controller.dragMagnify ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      controller.dragMagnify = !controller.dragMagnify;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Drag target',
                  value: controller.dragTargetKind.name,
                  onPressed: () => controller.showChoicesPicker<DragTargetKind>(
                    context,
                    choices: DragTargetKind.values,
                    selectedItem: controller.dragTargetKind,
                    labelBuilder: (t) => Text(t.name),
                    onSelectedItemChanged: (DragTargetKind value) {
                      setState(() {
                        controller.dragTargetKind = value;
                      });
                    },
                  ),
                ),
                buildSettingsButton(
                  label: 'Orientation',
                  value: controller.orientation.name,
                  onPressed: () {
                    setState(() {
                      controller.orientation = controller.orientation.opposite;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Show border',
                  value: controller.showBorder ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      controller.showBorder = !controller.showBorder;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece set',
                  value: controller.pieceSet.label,
                  onPressed: () => controller.showChoicesPicker<PieceSet>(
                    context,
                    choices: PieceSet.values,
                    selectedItem: controller.pieceSet,
                    labelBuilder: (t) => Text(t.label),
                    onSelectedItemChanged: (PieceSet? value) {
                      setState(() {
                        if (value != null) {
                          controller.pieceSet = value;
                        }
                      });
                    },
                  ),
                ),
                buildSettingsButton(
                  label: 'Board theme',
                  value: controller.boardTheme.label,
                  onPressed: () => controller.showChoicesPicker<BoardTheme>(
                    context,
                    choices: BoardTheme.values,
                    selectedItem: controller.boardTheme,
                    labelBuilder: (t) => Text(t.label),
                    onSelectedItemChanged: (BoardTheme? value) {
                      setState(() {
                        if (value != null) {
                          controller.boardTheme = value;
                        }
                      });
                    },
                  ),
                ),
                buildSettingsButton(
                  label: 'Piece animation',
                  value: controller.pieceAnimation ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      controller.pieceAnimation = !controller.pieceAnimation;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece Shift',
                  value: pieceShiftMethodLabel(controller.pieceShiftMethod),
                  onPressed: () =>
                      controller.showChoicesPicker<PieceShiftMethod>(
                        context,
                        choices: PieceShiftMethod.values,
                        selectedItem: controller.pieceShiftMethod,
                        labelBuilder: (t) => Text(pieceShiftMethodLabel(t)),
                        onSelectedItemChanged: (PieceShiftMethod? value) {
                          setState(() {
                            if (value != null) {
                              controller.pieceShiftMethod = value;
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

    final inputMoveWidgets = TextField(
      decoration: const InputDecoration(
        labelText: 'Enter move in UCI format',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (String value) {
        final move = NormalMove.fromUci(value);
        controller.playMove(move);
        controller.tryPlayPremove();
      },
    );

    Widget buildChessBoardWidget() => Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Chessboard(
            size: min(constraints.maxWidth, constraints.maxHeight),
            settings: ChessboardSettings(
              pieceAssets: controller.pieceSet.assets,
              colorScheme: controller.boardTheme.colors,
              border: controller.showBorder
                  ? BoardBorder(
                      width: 16.0,
                      color: darken(
                        controller.boardTheme.colors.darkSquare,
                        0.2,
                      ),
                    )
                  : null,
              enableCoordinates: true,
              animationDuration: controller.pieceAnimation
                  ? const Duration(milliseconds: 200)
                  : Duration.zero,
              dragFeedbackScale: controller.dragMagnify ? 2.0 : 1.0,
              dragTargetKind: controller.dragTargetKind,
              drawShape: DrawShapeOptions(
                enable: controller.drawMode,
                onCompleteShape: controller.onCompleteShape,
                onClearShapes: () {
                  setState(() {
                    controller.shapes = ISet();
                  });
                },
              ),
              pieceShiftMethod: controller.pieceShiftMethod,
              autoQueenPromotionOnPremove: false,
              pieceOrientationBehavior: controller.playMode == Mode.freePlay
                  ? PieceOrientationBehavior.opponentUpsideDown
                  : PieceOrientationBehavior.facingUser,
            ),
            orientation: controller.orientation,
            fen: controller.fen,
            lastMove: controller.lastMove,
            game: GameData(
              playerSide:
                  (controller.playMode == Mode.botPlay ||
                      controller.playMode == Mode.inputMove)
                  ? PlayerSide.white
                  : (controller.position.turn == Side.white
                        ? PlayerSide.white
                        : PlayerSide.black),
              validMoves: controller.validMoves,
              sideToMove: controller.position.turn == Side.white
                  ? Side.white
                  : Side.black,
              isCheck: controller.position.isCheck,
              promotionMove: controller.promotionMove,
              onMove: controller.playMode == Mode.botPlay
                  ? controller.onUserMoveAgainstBot
                  : controller.playMove,
              onPromotionSelection: controller.onPromotionSelection,
              premovable: (
                onSetPremove: controller.onSetPremove,
                premove: controller.premove,
              ),
            ),
            shapes: controller.shapes.isNotEmpty ? controller.shapes : null,
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
          if (controller.playMode == Mode.inputMove)
            const SizedBox(height: screenPortraitSplitter),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: controller.playMode == Mode.inputMove
                  ? inputMoveWidgets
                  : settingsWidgets,
            ),
          ),
          if (controller.playMode != Mode.inputMove)
            const SizedBox(height: screenPortraitSplitter),
          if (controller.playMode != Mode.inputMove)
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
                  child: controller.playMode == Mode.inputMove
                      ? inputMoveWidgets
                      : settingsWidgets,
                ),
                if (controller.playMode != Mode.inputMove)
                  const SizedBox(height: screenPortraitSplitter),
                if (controller.playMode != Mode.inputMove)
                  buildControlButtons(),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: switch (controller.playMode) {
          Mode.botPlay => const Text('Random Bot'),
          Mode.inputMove => const Text('Enter opponent move'),
          Mode.freePlay => const Text('Free Play'),
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Random Bot'),
              onTap: () {
                setState(() {
                  controller.playMode = Mode.botPlay;
                });
                if (controller.position.turn == Side.black) {
                  controller.playBlackMove();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Enter opponent move'),
              onTap: () {
                setState(() {
                  controller.playMode = Mode.inputMove;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Free Play'),
              onTap: () {
                setState(() {
                  controller.playMode = Mode.freePlay;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Board Editor'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoardEditorPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Board Thumbnails'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoardThumbnailsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, const Color(0xFF000000), amount) ?? c;
}
// number linse was befor 626 line .