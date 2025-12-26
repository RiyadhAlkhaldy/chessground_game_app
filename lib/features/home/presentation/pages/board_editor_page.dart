import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/board_theme.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/board_editor_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardEditorPage extends GetView<BoardEditorController> {
  const BoardEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    // Use a fixed piece set for now or get from settings
    const PieceSet pieceSet = PieceSet.merida;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.boardEditor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.startPosition,
            onPressed: () => controller.resetToInitial(),
          ),
          IconButton(
            icon: const Icon(Icons.layers_clear),
            tooltip: l10n.clearBoard,
            onPressed: () => controller.clearBoard(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Obx(() => _buildPieceMenu(context, Side.black, pieceSet)),
            const SizedBox(height: 16),
            Obx(() {
              final settings = ChessboardSettings(
                pieceAssets: pieceSet.assets,
                colorScheme: BoardTheme.blue.colors,
                enableCoordinates: true,
              );
              return ChessboardEditor(
                size: screenWidth > 600 ? 600 : screenWidth,
                orientation: Side.white,
                pieces: controller.pieces.value,
                settings: settings,
                pointerMode: controller.pointerMode.value,
                onEditedSquare: controller.onEditedSquare,
                onDiscardedPiece: controller.onDiscardedPiece,
                onDroppedPiece: controller.onDroppedPiece,
              );
            }),
            const SizedBox(height: 16),
            Obx(() => _buildPieceMenu(context, Side.white, pieceSet)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FEN:',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => SelectableText(
                        controller.fen,
                        style: const TextStyle(fontFamily: 'monospace'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPieceMenu(BuildContext context, Side side, PieceSet pieceSet) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToolButton(
            icon: Icons.pan_tool_alt_outlined,
            isSelected: controller.pointerMode.value == EditorPointerMode.drag,
            onTap: () => controller.selectDrag(),
            color: Colors.green,
          ),
          const VerticalDivider(),
          ...Role.values.mapIndexed((i, role) {
            final piece = Piece(role: role, color: side);
            final isSelected = controller.pointerMode.value == EditorPointerMode.edit &&
                controller.pieceToAddOnTouch.value == piece;

            return _buildPieceButton(piece, pieceSet, isSelected, () {
              controller.selectPiece(role, side);
            });
          }),
          const VerticalDivider(),
          _buildToolButton(
            icon: Icons.delete_outline,
            isSelected: controller.pointerMode.value == EditorPointerMode.edit &&
                controller.pieceToAddOnTouch.value == null,
            onTap: () => controller.selectDelete(),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Icon(icon, color: isSelected ? color : null, size: 32),
      ),
    );
  }

  Widget _buildPieceButton(Piece piece, PieceSet pieceSet, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
        ),
        child: PieceWidget(
          piece: piece,
          size: 32,
          pieceAssets: pieceSet.assets,
        ),
      ),
    );
  }
}