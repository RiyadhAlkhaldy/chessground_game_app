// lib/presentation/pages/game_screen.dart

import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:chessground_game_app/core/utils/styles/styles.dart';
import 'package:chessground_game_app/presentation/controllers/base_game_controller.dart';
import 'package:chessground_game_app/presentation/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/presentation/controllers/offline_game_controller.dart';
import 'package:chessground_game_app/presentation/widgets/captured_pieces_widget.dart';
import 'package:chessground_game_app/presentation/widgets/game_controls_widget.dart';
import 'package:chessground_game_app/presentation/widgets/game_info_widget.dart';
import 'package:chessground_game_app/presentation/widgets/move_list_widget.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// Main game screen displaying the chess board and game controls
/// شاشة اللعبة الرئيسية التي تعرض رقعة الشطرنج وعناصر التحكم
class GameScreen extends GetView<BaseGameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => Get.back(), child: const Text('Go Back')),
                ],
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
  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(() {
        final result = controller.getResult;
        if (result != null) return Text(controller.gameResult);
        final game = controller.currentGame;
        if (game == null) return const Text('Chess Game');

        return Text(
          '${game.whitePlayer.name} vs ${game.blackPlayer.name}',
          style: const TextStyle(fontSize: 16),
        );
      }),
      actions: [
        // Save button
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save Game',
          onPressed: () => (controller as OfflineGameController).saveGame(),
        ),
        // Settings button
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () => _showSettingsDialog(context),
        ),
        // Menu button
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, context),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'new_game', child: Text('New Game')),
            const PopupMenuItem(value: 'resign', child: Text('Resign')),
            const PopupMenuItem(value: 'draw', child: Text('Offer Draw')),
            const PopupMenuItem(value: 'export_pgn', child: Text('Export PGN')),
          ],
        ),
      ],
    );
  }

  /// Build portrait layout
  /// بناء تخطيط الوضع العمودي
  Widget _buildPortraitLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top player info and captured pieces
          _buildPlayerSection(context, Side.black, isTop: true),

          // Chess board
          const Padding(padding: EdgeInsetsGeometry.all(1), child: ChessBoardWidget()),

          // Bottom player info and captured pieces
          _buildPlayerSection(context, Side.white, isTop: false),
          // Game controls
          const GameControlsWidget(),

          // Move list (collapsible)
          _buildMoveListSection(context),
        ],
      ),
    );
  }

  /// Build landscape layout
  /// بناء تخطيط الوضع الأفقي
  Widget _buildLandscapeLayout(BuildContext context) {
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
              _buildPlayerSection(context, Side.black, isTop: true),
              const Expanded(
                child: Center(child: AspectRatio(aspectRatio: 1.0, child: ChessBoardWidget())),
              ),
              _buildPlayerSection(context, Side.white, isTop: false),
            ],
          ),
        ),

        // Right side: Captured pieces
        const Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Captured Pieces',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: CapturedPiecesWidget(side: Side.white)),
              Divider(),
              Expanded(child: CapturedPiecesWidget(side: Side.black)),
            ],
          ),
        ),
      ],
    );
  }

  /// Build player section with info and captured pieces
  /// بناء قسم اللاعب مع المعلومات والقطع المأسورة
  Widget _buildPlayerSection(BuildContext context, Side side, {required bool isTop}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isTop ? Colors.grey[200] : Colors.grey[100],
        border: Border(
          bottom: isTop ? const BorderSide(color: Colors.grey) : BorderSide.none,
          top: !isTop ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            backgroundColor: side == Side.white ? Colors.white : Colors.black,
            child: Text(
              side == Side.white ? 'W' : 'B',
              style: TextStyle(
                color: side == Side.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Player name and turn indicator
          Expanded(
            child: Obx(() {
              final game = controller.currentGame;
              final player = side == Side.white ? game?.whitePlayer : game?.blackPlayer;

              final isCurrentTurn = controller.currentTurn == side;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        player?.name ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCurrentTurn ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isCurrentTurn) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Turn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Rating: ${player?.playerRating ?? 1200}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            }),
          ),

          // Captured pieces preview
          Obx(() {
            final capturedPieces = (controller as OfflineGameController).getCapturedPieces(side);
            if (capturedPieces.isEmpty) {
              return const SizedBox(width: 100);
            }

            return SizedBox(width: 100, child: CapturedPiecesWidget(side: side, compact: true));
          }),
        ],
      ),
    );
  }

  /// Build move list section (collapsible)
  /// بناء قسم قائمة الحركات (قابل للطي)
  Widget _buildMoveListSection(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Move History',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  final moves = controller.gameState.getMoveTokens;
                  return Text(
                    '${moves.length} moves',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  );
                }),
              ],
            ),
          ),

          // Move list
          const Expanded(child: MoveListWidget()),
        ],
      ),
    );
  }

  /// Show settings dialog
  /// عرض مربع حوار الإعدادات
  void _showSettingsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Game Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => SwitchListTile(
                title: const Text('Auto-save'),
                subtitle: const Text('Automatically save after each move'),
                value: controller.autoSaveEnabled,
                onChanged: (value) {
                  controller.autoSaveEnabled = value;
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Close'))],
      ),
    );
  }

  /// Handle menu actions
  /// معالجة إجراءات القائمة
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
  /// تأكيد لعبة جديدة
  void _confirmNewGame(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Start New Game'),
        content: const Text(
          'Are you sure you want to start a new game? Current game will be saved.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offNamed('/new-game');
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  /// Confirm resign
  /// تأكيد الاستسلام
  void _confirmResign(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Resign'),
        content: Text(
          'Are you sure ${controller.currentTurn == Side.white ? 'White' : 'Black'} wants to resign?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resign(controller.currentTurn);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Resign'),
          ),
        ],
      ),
    );
  }

  /// Confirm draw
  /// تأكيد التعادل
  void _confirmDraw(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Offer Draw'),
        content: const Text('Do both players agree to a draw?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              (controller as OfflineGameController).agreeDrawn();
            },
            child: const Text('Agree Draw'),
          ),
        ],
      ),
    );
  }

  /// Export PGN
  /// تصدير PGN
  void _exportPgn(BuildContext context) {
    final pgn = (controller as OfflineGameController).getPgnString();

    if (pgn.isEmpty) {
      Get.snackbar('Error', 'PGN not available.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _showExportPgnDialog(context, pgn);
  }

  void _showExportPgnDialog(BuildContext context, String pgn) {
    Get.dialog(
      AlertDialog(
        title: const Text('Export PGN'),
        content: SingleChildScrollView(child: SelectableText(pgn)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () => _copyPgn(pgn),
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
          ElevatedButton.icon(
            onPressed: () => _sharePgn(pgn),
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _copyPgn(String pgn) {
    Clipboard.setData(ClipboardData(text: pgn));
    Get.back();
    Get.snackbar('PGN Copied', 'PGN copied to clipboard', snackPosition: SnackPosition.BOTTOM);
  }

  void _sharePgn(String pgn) async {
    final result = await SharePlus.instance.share(ShareParams(text: pgn));
    if (result.status == ShareResultStatus.success) {
      Get.snackbar('Success', 'Thank you for sharing PGN..', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // lib/presentation/pages/game_screen.dart - تحديث buildChessBoard method
}

class ChessBoardWidget extends GetView<BaseGameController> {
  const ChessBoardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PopScope(
            canPop: controller.gameState.isGameOverExtended, // Prevents automatic exit

            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }
              if (controller.getResult != null) {
                Get.back();
              } else {
                final shouldExit = await showExitConfirmationDialog(context).then((value) {
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
                      controller.playerSide == PlayerSide.white ? Side.white : Side.black,
                    );
                    controller.gameResult;
                    // And then, after closing the second dialog, navigate back
                    // if (context.mounted) {
                    //   Get.back();
                    // }
                  }
                }
              }
            },
            child: GetX<ChessBoardSettingsController>(
              builder: (ctrlBoardSettings) => Chessboard(
                size: min(constraints.maxWidth, constraints.maxHeight),
                settings: ChessboardSettings(
                  pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                  colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                  border: ctrlBoardSettings.showBorder.value
                      ? BoardBorder(
                          width: 10.0,
                          color: darken(ctrlBoardSettings.boardTheme.value.colors.darkSquare, 0.2),
                        )
                      : null,
                  enableCoordinates: true,
                  autoQueenPromotion: false,
                  animationDuration: ctrlBoardSettings.pieceAnimation.value
                      ? const Duration(milliseconds: 200)
                      : Duration.zero,

                  dragFeedbackScale: ctrlBoardSettings.dragMagnify.value ? 2.0 : 1.0,
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
                  pieceOrientationBehavior: PieceOrientationBehavior.facingUser,
                ),
                orientation: ctrlBoardSettings.orientation.value,

                fen: controller.currentFen,
                // lastMove: controller.lastMove,
                game: GameData(
                  playerSide: controller.gameState.isGameOverExtended
                      ? PlayerSide.none
                      : controller.gameState.position.turn == Side.white
                      ? PlayerSide.white
                      : PlayerSide.black,
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
