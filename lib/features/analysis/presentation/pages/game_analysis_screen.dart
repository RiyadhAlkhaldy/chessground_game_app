import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/game_analysis_controller.dart';
import 'package:chessground_game_app/features/analysis/presentation/widgets/engine_evaluation_widget.dart';
import 'package:chessground_game_app/features/analysis/presentation/widgets/move_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chessground/chessground.dart';

/// Screen for analyzing past games
/// شاشة لتحليل الألعاب السابقة
class GameAnalysisScreen extends GetView<GameAnalysisController> {
  const GameAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get gameUuid from arguments
    final String gameUuid = Get.arguments['gameUuid'] as String;

    // Load game on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadGame(gameUuid);
    });

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading && controller.game == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.game == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

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
    );
  }

  /// Build app bar
  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(() {
        final game = controller.game;
        if (game == null) return const Text('Game Analysis');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Analysis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${game.whitePlayer.name} vs ${game.blackPlayer.name}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }),
      actions: [
        // Toggle analysis
        Obx(
          () => IconButton(
            icon: Icon(
              controller.analysisEnabled
                  ? Icons.pause_circle
                  : Icons.play_circle,
            ),
            tooltip: controller.analysisEnabled
                ? 'Stop Analysis'
                : 'Start Analysis',
            onPressed: controller.toggleAnalysis,
          ),
        ),

        // Analyze all moves
        IconButton(
          icon: const Icon(Icons.analytics),
          tooltip: 'Analyze All Moves',
          onPressed: () => _confirmAnalyzeAll(context),
        ),

        // Menu
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, context),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'export', child: Text('Export PGN')),
            const PopupMenuItem(value: 'share', child: Text('Share Analysis')),
          ],
        ),
      ],
    );
  }

  /// Build portrait layout
  /// بناء تخطيط الوضع العمودي
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Engine evaluation
        const Padding(
          padding: EdgeInsets.all(16),
          child: EngineEvaluationWidget(compact: false),
        ),

        // Chess board
        const Expanded(
          child: Center(
            child: AspectRatio(aspectRatio: 1.0, child: ChessBoardWidget()),
          ),
        ),

        // Move list
        SizedBox(
          height: 150,
          child: Obx(() {
            if (controller.gameState == null) {
              return const Center(child: Text('No moves'));
            }

            return MoveListWidget(
              tokens: controller.gameState!.getMoveTokens,
              currentIndex: controller.currentMoveIndex,
              onMoveSelected: controller.goToMove,
            );
          }),
        ),

        // Navigation controls
        _buildNavigationControls(context),
      ],
    );
  }

  /// Build landscape layout
  /// بناء تخطيط الوضع الأفقي
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        // Left: Board
        Expanded(
          flex: 5,
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ChessBoardWidget(),
                  ),
                ),
              ),
              _buildNavigationControls(context),
            ],
          ),
        ),

        // Right: Analysis panel
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(left: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              children: [
                // Engine evaluation
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: EngineEvaluationWidget(compact: false),
                ),

                const Divider(),

                // Move list
                Expanded(
                  child: Obx(() {
                    if (controller.gameState == null) {
                      return const Center(child: Text('No moves'));
                    }

                    return MoveListWidget(
                      tokens: controller.gameState!.getMoveTokens,
                      currentIndex: controller.currentMoveIndex,
                      onMoveSelected: controller.goToMove,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build chess board
  /// بناء رقعة الشطرنج
  // Widget _buildChessBoard(BuildContext context) {
  //   return Obx(() {
  //     if (controller.gameState == null) {
  //       return const Center(child: CircularProgressIndicator());
  //     }

  //     return Board(
  //       size: MediaQuery.of(context).size.width,
  //       data: BoardData(
  //         interactableSide: InteractableSide.none, // View only
  //         orientation: Side.white,
  //         fen: controller.currentFen,
  //         settings: BoardSettings(
  //           colorScheme: BoardColorScheme(
  //             lightSquare: const Color(0xFFF0D9B5),
  //             darkSquare: const Color(0xFFB58863),
  //           ),
  //           pieceAssets: PieceSet.merida.assets,
  //           enableCoordinates: true,
  //         ),
  //       ),
  //     );
  //   });
  // }

  /// Build navigation controls
  /// بناء عناصر التحكم في التنقل
  Widget _buildNavigationControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First move
          IconButton(
            icon: const Icon(Icons.first_page),
            tooltip: 'First Move',
            onPressed: controller.firstMove,
          ),

          // Previous move
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous Move',
            onPressed: controller.previousMove,
          ),

          // Move counter
          Obx(() {
            if (controller.gameState == null) {
              return const Text('0/0');
            }

            final total = controller.gameState!.getMoveTokens.length;
            final current = controller.currentMoveIndex + 1;

            return Text(
              '$current/$total',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }),

          // Next move
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next Move',
            onPressed: controller.nextMove,
          ),

          // Last move
          IconButton(
            icon: const Icon(Icons.last_page),
            tooltip: 'Last Move',
            onPressed: controller.lastMove,
          ),
        ],
      ),
    );
  }

  /// Confirm analyze all moves
  /// تأكيد تحليل جميع الحركات
  Future<void> _confirmAnalyzeAll(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Analyze All Moves'),
        content: const Text(
          'This will analyze all moves in the game. This may take several minutes. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Analyze'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.analyzeAllMoves();
    }
  }

  /// Handle menu actions
  /// معالجة إجراءات القائمة
  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'export':
        // TODO: Implement PGN export
        Get.snackbar(
          'Export PGN',
          'Feature coming soon',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'share':
        // TODO: Implement share analysis
        Get.snackbar(
          'Share Analysis',
          'Feature coming soon',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
    }
  }
}
