import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingChessBoardWidget extends StatefulWidget {
  const LoadingChessBoardWidget({super.key});

  @override
  State<LoadingChessBoardWidget> createState() =>
      _LoadingChessBoardWidgetState();
}

class _LoadingChessBoardWidgetState extends State<LoadingChessBoardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get board settings to match theme
    final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Empty Board Background
            Obx(
              () => Chessboard(
                size: size,
                fen: '8/8/8/8/8/8/8/8 w - - 0 1', // Empty board
                settings: ChessboardSettings(
                  colorScheme: ctrlBoardSettings.boardTheme.value.colors,
                  pieceAssets: ctrlBoardSettings.pieceSet.value.assets,
                  enableCoordinates: false, // Hide coords for clean look
                ),
                orientation: ctrlBoardSettings.orientation.value,
                game: GameData(
                  playerSide: PlayerSide.none,
                  validMoves: const IMapConst({}),
                  sideToMove: Side.white,
                  isCheck: false,
                  promotionMove: null,
                  onMove: (move, {isDrop, isPremove}) {},
                  onPromotionSelection: (role) {},
                ),
              ),
            ),

            // Overlay with Blur/Color
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),

            // Animated Loading Content
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Glowing Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sports_esports,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Preparing Game...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
