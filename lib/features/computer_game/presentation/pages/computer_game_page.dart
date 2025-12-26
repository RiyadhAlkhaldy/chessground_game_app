import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/build_move_section_widget.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' show PlayerSide;
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/loading_chess_board_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/player_game_info_widget.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/computer_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for playing against computer
/// شاشة اللعب ضد الكمبيوتر
class ComputerGamePage extends GetView<BaseGameController> {
  const ComputerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout(context);
          } else {
            return _buildLandscapeLayout(context);
          }
        },
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      title: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.computerGameVsStockfish,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              l10n.computerGameLevel(
                (controller as ComputerGameController).difficulty,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }),
      actions: [
        // Undo button
        Obx(
          () => IconButton(
            icon: const Icon(Icons.undo),
            tooltip: l10n.undoMove,
            onPressed:
                controller.canUndo.value &&
                    !((controller as ComputerGameController)).computerThinking
                ? () => controller.undoMove()
                : null,
          ),
        ),

        // Hint button
        Obx(
          () => (controller as ComputerGameController).showMoveHints.value
              ? IconButton(
                  icon: const Icon(Icons.lightbulb_outline),
                  tooltip: l10n.getHint,
                  onPressed: () => _getHint(context),
                )
              : const SizedBox.shrink(),
        ),

        // Menu
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, context),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'new', child: Text(l10n.newGame)),
            PopupMenuItem(value: 'save', child: Text(l10n.saveGame)),
            PopupMenuItem(value: 'resign', child: Text(l10n.resign)),
          ],
        ),
      ],
    );
  }

  /// Build portrait layout
  Widget _buildPortraitLayout(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top player info
          Obx(() {
            final isFlipped = controller.orientation == Side.black;
            final topSide = isFlipped ? Side.white : Side.black;
            final player = topSide == Side.white
                ? controller.currentGame?.whitePlayer
                : controller.currentGame?.blackPlayer;
            final captured = topSide == Side.white
                ? controller.whiteCapturedList
                : controller.blackCapturedList;

            return PlayerGameInfoWidget(
              side: topSide,
              player: player,
              isPlayerTurn: controller.currentTurn == topSide,
              capturedPieces: captured,
              isTop: true,
            );
          }),

          // Computer thinking indicator
          Obx(() {
            if ((controller as ComputerGameController).computerThinking) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.computerThinking,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox(height: 8);
          }),

          // Chess board
          AspectRatio(aspectRatio: 1.0, child: _buildBoardOrError(context)),

          // Bottom player info
          Obx(() {
            final isFlipped = controller.orientation == Side.black;
            final bottomSide = isFlipped ? Side.black : Side.white;
            final player = bottomSide == Side.white
                ? controller.currentGame?.whitePlayer
                : controller.currentGame?.blackPlayer;
            final captured = bottomSide == Side.white
                ? controller.whiteCapturedList
                : controller.blackCapturedList;

            return PlayerGameInfoWidget(
              side: bottomSide,
              player: player,
              isPlayerTurn: controller.currentTurn == bottomSide,
              capturedPieces: captured,
              isTop: false,
            );
          }),

          // Move list
          SizedBox(
            height: 120,
            child: Obx(() {
              if (controller.gameState.getMoveTokens.isEmpty) {
                return Center(child: Text(l10n.noMovesYet));
              }

              return const BuildMoveSectionWidget();
            }),
          ),
        ],
      ),
    );
  }

  /// Build landscape layout
  Widget _buildLandscapeLayout(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Row(
      children: [
        // Left: Board
        Expanded(
          flex: 6,
          child: Column(
            children: [
              // Top player info
              Obx(() {
                final isFlipped = controller.orientation == Side.black;
                final topSide = isFlipped ? Side.white : Side.black;
                final player = topSide == Side.white
                    ? controller.currentGame?.whitePlayer
                    : controller.currentGame?.blackPlayer;
                final captured = topSide == Side.white
                    ? controller.whiteCapturedList
                    : controller.blackCapturedList;

                return PlayerGameInfoWidget(
                  side: topSide,
                  player: player,
                  isPlayerTurn: controller.currentTurn == topSide,
                  capturedPieces: captured,
                  isTop: true,
                );
              }),

              // Board
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: _buildBoardOrError(context),
                  ),
                ),
              ),

              // Bottom player info
              Obx(() {
                final isFlipped = controller.orientation == Side.black;
                final bottomSide = isFlipped ? Side.black : Side.white;
                final player = bottomSide == Side.white
                    ? controller.currentGame?.whitePlayer
                    : controller.currentGame?.blackPlayer;
                final captured = bottomSide == Side.white
                    ? controller.whiteCapturedList
                    : controller.blackCapturedList;

                return PlayerGameInfoWidget(
                  side: bottomSide,
                  player: player,
                  isPlayerTurn: controller.currentTurn == bottomSide,
                  capturedPieces: captured,
                  isTop: false,
                );
              }),
            ],
          ),
        ),

        // Right: Info panel
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              border: Border(left: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              children: [
                // Computer thinking indicator
                Obx(() {
                  if ((controller as ComputerGameController).computerThinking) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      color: theme.colorScheme.secondaryContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.computerThinking,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Move list
                Expanded(
                  child: Obx(() {
                    if (controller.gameState.getMoveTokens.isEmpty) {
                      return Center(child: Text(l10n.noMovesYet));
                    }

                    return const BuildMoveSectionWidget();
                  }),
                ),

                // Game controls
                _buildGameControls(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build game controls
  Widget _buildGameControls(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Undo button
          Obx(
            () => ElevatedButton.icon(
              onPressed:
                  controller.canUndo.value &&
                      !((controller as ComputerGameController).computerThinking)
                  ? () => controller.undoMove()
                  : null,
              icon: const Icon(Icons.undo),
              label: Text(l10n.undoMove),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Hint button
          Obx(
            () => (controller as ComputerGameController).showMoveHints.value
                ? ElevatedButton.icon(
                    onPressed:
                        !((controller as ComputerGameController)
                            .computerThinking)
                        ? () => _getHint(context)
                        : null,
                    icon: const Icon(Icons.lightbulb),
                    label: Text(l10n.getHint),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: theme.colorScheme.onTertiary,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 8),

          // Resign button
          ElevatedButton.icon(
            onPressed: () => _confirmResign(context, l10n),
            icon: const Icon(Icons.flag),
            label: Text(l10n.resign),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }

  /// Get hint
  Future<void> _getHint(BuildContext context) async {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    if ((controller as ComputerGameController).computerThinking) {
      Get.snackbar(
        l10n.wait,
        l10n.computerThinking,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final stockfishController = Get.find<StockfishController>();
    await stockfishController.getHint(controller.currentFen);

    if (stockfishController.hintMove != null) {
      final hint = stockfishController.hintMove!;

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.lightbulb, color: theme.colorScheme.tertiary),
              const SizedBox(width: 8),
              Text(l10n.hintTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.hintSuggestedMove,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.tertiary),
                ),
                child: Text(
                  hint.san ?? hint.uci,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text(l10n.close)),
          ],
        ),
      );
    }
  }

  /// Build board or error widget
  Widget _buildBoardOrError(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Obx(() {
      final computerController = controller as ComputerGameController;
      String errorMessage = computerController.stockfishController.errorMessage;

      if (errorMessage.isNotEmpty) {
        // Translate error key if possible
        if (errorMessage == "timeoutStockfish") {
          errorMessage = l10n.timeoutStockfish;
        }

        return Container(
          color: theme.colorScheme.errorContainer,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.engineErrorTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => computerController.retryGame(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retryGame),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Show board or loading
      return computerController.isStockfishReady
          ? ChessBoardWidget()
          : const LoadingChessBoardWidget();
    });
  }

  /// Handle menu actions
  void _handleMenuAction(String action, BuildContext context) {
    final l10n = context.l10n;
    switch (action) {
      case 'new':
        _confirmNewGame(context, l10n);
        break;
      case 'save':
        (controller as ComputerGameController).saveGame();
        break;
      case 'resign':
        _confirmResign(context, l10n);
        break;
    }
  }

  /// Confirm new game
  Future<void> _confirmNewGame(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(l10n.newGame),
        content: Text(l10n.newGameConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(l10n.newGame),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.offNamed('/new-computer-game');
    }
  }

  /// Confirm resign
  Future<void> _confirmResign(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(l10n.resign),
        content: Text(l10n.resignConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              l10n.resign,
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final side = controller.playerSide == PlayerSide.white
          ? Side.white
          : Side.black;
      await controller.resign(side);
    }
  }
}
