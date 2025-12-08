// lib/presentation/pages/computer_game_screen.dart

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/game_info_widget.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:chessground_game_app/features/analysis/presentation/widgets/move_list_widget.dart';
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
    return AppBar(
      title: Obx(() {
        // if (controller.game == null) {
        //   return const Text('vs Computer');
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'vs Stockfish',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Level ${(controller as ComputerGameController).difficulty}',
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
            tooltip: 'Undo Move',
            onPressed:
                controller.canUndo.value &&
                    !((controller as ComputerGameController)).computerThinking
                ? () => controller.undoMove()
                : null,
          ),
        ),

        // Hint button
        IconButton(
          icon: const Icon(Icons.lightbulb_outline),
          tooltip: 'Get Hint',
          onPressed: () => _getHint(context),
        ),

        // Menu
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, context),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'new', child: Text('New Game')),
            const PopupMenuItem(value: 'save', child: Text('Save Game')),
            const PopupMenuItem(value: 'resign', child: Text('Resign')),
          ],
        ),
      ],
    );
  }

  /// Build portrait layout
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Top player info (computer)
        Obx(
          () => const GameInfoWidget(
            // player: controller.game?.blackPlayer,
            // isPlayerTurn: controller.currentTurn == Side.black,
            // capturedPieces: controller.capturedPieces['white'] ?? [],
            // timeRemaining: null,
            // isTop: true,
          ),
        ),

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
                    'Computer is thinking...',
                    style: TextStyle(
                      color: Colors.grey[600],
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
        Expanded(
          child: Center(
            child: AspectRatio(aspectRatio: 1.0, child: ChessBoardWidget()),
          ),
        ),

        // Bottom player info (human)
        Obx(
          () => const GameInfoWidget(
            // player: controller.game?.whitePlayer,
            // isPlayerTurn: controller.currentTurn == Side.white,
            // capturedPieces: controller.capturedPieces['black'] ?? [],
            // timeRemaining: null,
            // isTop: false,
          ),
        ),

        // Move list
        SizedBox(
          height: 120,
          child: Obx(() {
            if (controller.gameState.getMoveTokens.isEmpty) {
              return const Center(child: Text('No moves yet'));
            }

            return MoveListWidget(
              tokens: controller.gameState.getMoveTokens,
              currentIndex: controller.gameState.getMoveTokens.length - 1,
            );
          }),
        ),
      ],
    );
  }

  /// Build landscape layout
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        // Left: Board
        Expanded(
          flex: 6,
          child: Column(
            children: [
              // Computer info
              Obx(
                () => const GameInfoWidget(
                  // player: controller.game?.blackPlayer,
                  // isPlayerTurn: controller.currentTurn == Side.black,
                  // capturedPieces: controller.capturedPieces['white'] ?? [],
                  // timeRemaining: null,
                  // isTop: true,
                ),
              ),

              // Board
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ChessBoardWidget(),
                  ),
                ),
              ),

              // Player info
              Obx(
                () => const GameInfoWidget(
                  // player: controller.game?.whitePlayer,
                  // isPlayerTurn: controller.currentTurn == Side.white,
                  // capturedPieces: controller.capturedPieces['black'] ?? [],
                  // timeRemaining: null,
                  // isTop: false,
                ),
              ),
            ],
          ),
        ),

        // Right: Info panel
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(left: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              children: [
                // Computer thinking indicator
                Obx(() {
                  if ((controller as ComputerGameController).computerThinking) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue[50],
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Computer is thinking...',
                            style: TextStyle(fontWeight: FontWeight.w500),
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
                      return const Center(child: Text('No moves yet'));
                    }

                    return MoveListWidget(
                      tokens: controller.gameState.getMoveTokens,
                      currentIndex:
                          controller.gameState.getMoveTokens.length - 1,
                    );
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
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
              label: const Text('Undo Move'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),

          const SizedBox(height: 8),

          // Hint button
          ElevatedButton.icon(
            onPressed:
                !((controller as ComputerGameController).computerThinking)
                ? () => _getHint(context)
                : null,
            icon: const Icon(Icons.lightbulb),
            label: const Text('Get Hint'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          // Resign button
          ElevatedButton.icon(
            onPressed: () => _confirmResign(context),
            icon: const Icon(Icons.flag),
            label: const Text('Resign'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  /// Get hint
  Future<void> _getHint(BuildContext context) async {
    if ((controller as ComputerGameController).computerThinking) {
      Get.snackbar(
        'Please Wait',
        'Computer is thinking...',
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
          title: const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber),
              SizedBox(width: 8),
              Text('Hint'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suggested move:',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Text(
                  hint.san ?? hint.uci,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ],
        ),
      );
    }
  }

  /// Handle menu actions
  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'new':
        _confirmNewGame(context);
        break;
      case 'save':
        (controller as ComputerGameController).saveGame();
        break;
      case 'resign':
        _confirmResign(context);
        break;
    }
  }

  /// Confirm new game
  Future<void> _confirmNewGame(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('New Game'),
        content: const Text(
          'Start a new game? Current game will be lost if not saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('New Game'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.offNamed('/new-computer-game');
    }
  }

  /// Confirm resign
  Future<void> _confirmResign(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Resign'),
        content: const Text('Are you sure you want to resign?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Resign'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement resign logic
      Get.back();
    }
  }
}
