// lib/presentation/widgets/captured_pieces_widget.dart

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/offline_game_controller.dart';

/// Widget to display captured pieces for a player
/// عنصر لعرض القطع المأسورة للاعب
class CapturedPiecesWidget extends GetView<OfflineGameController> {
  final Side side;
  final bool compact;

  const CapturedPiecesWidget({super.key, required this.side, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final capturedPieces = controller.getCapturedPieces(side);

      if (capturedPieces.isEmpty) {
        return Center(
          child: Text(
            compact ? '' : 'No captured pieces',
            style: TextStyle(color: Colors.grey[600], fontSize: compact ? 10 : 12),
          ),
        );
      }

      // Calculate material advantage
      final materialValue = controller.gameState.capturedValue(side);
      final showAdvantage = materialValue > 0 && !compact;

      return Container(
        padding: EdgeInsets.all(compact ? 4 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Captured pieces display
            Wrap(
              spacing: compact ? 2 : 4,
              runSpacing: compact ? 2 : 4,
              children: capturedPieces.map((role) {
                return _buildPieceIcon(role, compact);
              }).toList(),
            ),

            // Material advantage indicator
            if (showAdvantage) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  '+$materialValue',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Build piece icon
  /// بناء أيقونة القطعة
  Widget _buildPieceIcon(Role role, bool isCompact) {
    // Get opponent color (captured pieces are opponent's pieces)
    final pieceColor = side == Side.white ? Side.black : Side.white;

    final symbol = _getPieceSymbol(role, pieceColor);
    final size = isCompact ? 16.0 : 24.0;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(symbol, style: TextStyle(fontSize: size, height: 1.0)),
    );
  }

  /// Get unicode symbol for piece
  /// الحصول على رمز يونيكود للقطعة
  String _getPieceSymbol(Role role, Side color) {
    const whiteSymbols = {
      Role.pawn: '♙',
      Role.knight: '♘',
      Role.bishop: '♗',
      Role.rook: '♖',
      Role.queen: '♕',
      Role.king: '♔',
    };

    const blackSymbols = {
      Role.pawn: '♟',
      Role.knight: '♞',
      Role.bishop: '♝',
      Role.rook: '♜',
      Role.queen: '♛',
      Role.king: '♚',
    };

    final symbols = color == Side.white ? whiteSymbols : blackSymbols;
    return symbols[role] ?? '';
  }
}
