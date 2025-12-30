import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_controls_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/build_player_section_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/captured_pieces_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/game_info_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/move_list_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/enhanced_horizontal_move_list_widget.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// Main game screen displaying the chess board and game controls
/// شاشة اللعبة الرئيسية التي تعرض رقعة الشطرنج وعناصر التحكم
class OfflineGamePage extends GetView<BaseGameController> {
  const OfflineGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Obx(() {
          // Show loading indicator
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.goBack),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show game board
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortraitLayout(context);
              } else {
                return _buildLandscapeLayout(context);
              }
            },
          );
        }),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      title: Obx(() {
        final result = controller.getResult;
        if (result != null) return Text(controller.gameResult);
        final game = controller.currentGame;
        if (game == null) return Text(l10n.chessGame);

        return Text(
          '${game.whitePlayer.name} vs ${game.blackPlayer.name}',
          style: const TextStyle(fontSize: 16),
        );
      }),
      actions: [
        // Save button
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: l10n.saveGame,
          onPressed: () => (controller as OfflineGameController).saveGame(),
        ),
        // Settings button
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: l10n.settings,
          onPressed: () => _showSettingsDialog(context),
        ),
        // Menu button
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, context),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'new_game', child: Text(l10n.newGame)),
            PopupMenuItem(value: 'resign', child: Text(l10n.resign)),
            PopupMenuItem(value: 'draw', child: Text(l10n.offerDraw)),
            PopupMenuItem(value: 'export_pgn', child: Text(l10n.exportPgn)),
          ],
        ),
      ],
    );
  }

  /// Build portrait layout
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Top player info and captured pieces
        const BuildPlayerSectionWidget(side: Side.black, isTop: true),

        // Chess board
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ChessBoardWidget(),
          ),
        ),

        // Bottom player info and captured pieces
        const BuildPlayerSectionWidget(side: Side.white, isTop: false),

        // Enhanced horizontal move list
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: EnhancedHorizontalMoveListWidget(),
        ),

        // Game controls
        const GameControlsWidget(),
      ],
    );
  }

  /// Build landscape layout
  Widget _buildLandscapeLayout(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        // Left side: Game info and move list
        const Expanded(
          flex: 3,
          child: Column(
            children: [
              GameInfoWidget(),
              Divider(),
              Expanded(child: MoveListWidget()),
              Divider(),
              GameControlsWidget(),
            ],
          ),
        ),

        // Center: Chess board
        Expanded(
          flex: 5,
          child: Column(
            children: [
              const BuildPlayerSectionWidget(side: Side.black, isTop: true),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ChessBoardWidget(),
                  ),
                ),
              ),
              const BuildPlayerSectionWidget(side: Side.white, isTop: false),
            ],
          ),
        ),

        // Right side: Captured pieces
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.capturedPieces,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: CapturedPiecesWidget(side: Side.white)),
              const Divider(),
              const Expanded(child: CapturedPiecesWidget(side: Side.black)),
            ],
          ),
        ),
      ],
    );
  }

  /// Show settings dialog
  void _showSettingsDialog(BuildContext context) {
    final l10n = context.l10n;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.gameSettings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => SwitchListTile(
                title: Text(l10n.autoSave),
                subtitle: Text(l10n.autoSaveDesc),
                value: controller.autoSaveEnabled,
                onChanged: (value) {
                  controller.autoSaveEnabled = value;
                },
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

  /// Handle menu actions
  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'new_game':
        _confirmNewGame(context);
        break;
      case 'resign':
        _confirmResign(context);
        break;
      case 'draw':
        _confirmDraw(context);
        break;
      case 'export_pgn':
        _exportPgn(context);
        break;
    }
  }

  /// Confirm new game
  void _confirmNewGame(BuildContext context) {
    final l10n = context.l10n;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.startNewGameTitle),
        content: Text(l10n.startNewGameConfirm),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offNamed(AppRoutes.offlineGamePage);
            },
            child: Text(l10n.newGame),
          ),
        ],
      ),
    );
  }

  /// Confirm resign
  void _confirmResign(BuildContext context) {
    final l10n = context.l10n;
    final sideText = controller.currentTurn == Side.white
        ? l10n.white
        : l10n.black;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.resign),
        content: Text(l10n.resignConfirm(sideText)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resign(controller.currentTurn);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.resign),
          ),
        ],
      ),
    );
  }

  /// Confirm draw
  void _confirmDraw(BuildContext context) {
    final l10n = context.l10n;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.offerDrawTitle),
        content: Text(l10n.offerDrawConfirm),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              (controller as OfflineGameController).agreeDrawn();
            },
            child: Text(l10n.agreeDraw),
          ),
        ],
      ),
    );
  }

  /// Export PGN
  void _exportPgn(BuildContext context) {
    final l10n = context.l10n;
    final pgn = (controller as OfflineGameController).getPgnString();

    if (pgn.isEmpty) {
      Get.snackbar(
        l10n.errorTitle,
        l10n.pgnNotAvailable,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _showExportPgnDialog(context, pgn);
  }

  void _showExportPgnDialog(BuildContext context, String pgn) {
    final l10n = context.l10n;
    Get.dialog(
      AlertDialog(
        title: Text(l10n.exportPgn),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(child: SelectableText(pgn)),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(l10n.close)),
          ElevatedButton.icon(
            onPressed: () => _copyPgn(context, pgn),
            icon: const Icon(Icons.copy),
            label: Text(l10n.copy),
          ),
          ElevatedButton.icon(
            onPressed: () => _sharePgn(context, pgn),
            icon: const Icon(Icons.share),
            label: Text(l10n.share),
          ),
        ],
      ),
    );
  }

  void _copyPgn(BuildContext context, String pgn) {
    final l10n = context.l10n;
    Clipboard.setData(ClipboardData(text: pgn));
    Get.back();
    Get.snackbar(
      l10n.pgnCopied,
      l10n.pgnCopiedToClipboard,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _sharePgn(BuildContext context, String pgn) async {
    final l10n = context.l10n;
    final result = await Share.share(pgn);
    if (result.status == ShareResultStatus.success) {
      Get.snackbar(
        l10n.success,
        l10n.sharePgnSuccess,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
