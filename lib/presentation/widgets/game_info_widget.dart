// lib/presentation/widgets/game_info_widget.dart

import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/presentation/controllers/base_game_controller.dart';
import 'package:chessground_game_app/presentation/controllers/offline_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Widget to display game information
/// عنصر لعرض معلومات اللعبة
class GameInfoWidget extends GetView<BaseGameController> {
  const GameInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final game = controller.currentGame;

      if (game == null) {
        return const Center(child: Text('No game loaded'));
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game title
            Text(
              game.event ?? 'Casual Game',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Game details
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: game.date != null ? DateFormat('yyyy-MM-dd').format(game.date!) : 'Unknown',
            ),

            _buildInfoRow(icon: Icons.location_on, label: 'Site', value: game.site ?? 'Local'),

            if (game.timeControl != null)
              _buildInfoRow(icon: Icons.timer, label: 'Time Control', value: game.timeControl!),

            const Divider(height: 16),

            // Game status
            _buildStatusSection(),

            const Divider(height: 16),

            // Material evaluation
            _buildMaterialSection(),
          ],
        ),
      );
    });
  }

  /// Build info row
  /// بناء صف المعلومات
  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build status section
  /// بناء قسم الحالة
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Game Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Status indicator
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: controller.isGameOver ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              controller.isGameOver ? 'Finished' : 'Ongoing',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        // Result
        if (controller.isGameOver) ...[
          const SizedBox(height: 4),
          Text(
            'Result: ${controller.gameResult}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            'Termination: ${_getTerminationText()}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],

        // Current turn
        if (!controller.isGameOver) ...[
          const SizedBox(height: 4),
          Text(
            'Turn: ${controller.currentTurn == Side.white ? 'White' : 'Black'}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],

        // Check indicator
        if (controller.isCheck && !controller.isGameOver) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.orange),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 14, color: Colors.orange),
                SizedBox(width: 4),
                Text(
                  'Check!',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Build material section
  /// بناء قسم المواد
  Widget _buildMaterialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Material Balance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('White', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  Text(
                    '${(controller as OfflineGameController).getMaterialOnBoard(Side.white)} points',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Advantage indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAdvantageColor(),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getAdvantageText(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Black', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  Text(
                    '${(controller as OfflineGameController).getMaterialOnBoard(Side.black)} points',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Get termination text
  /// الحصول على نص الإنهاء
  String _getTerminationText() {
    switch (controller.termination) {
      case GameTermination.checkmate:
        return 'Checkmate';
      case GameTermination.stalemate:
        return 'Stalemate';
      case GameTermination.resignation:
        return 'Resignation';
      case GameTermination.timeout:
        return 'Timeout';
      case GameTermination.agreement:
        return 'Draw by agreement';
      case GameTermination.fiftyMoveRule:
        return 'Fifty-move rule';
      case GameTermination.threefoldRepetition:
        return 'Threefold repetition';
      case GameTermination.insufficientMaterial:
        return 'Insufficient material';
      default:
        return 'Ongoing';
    }
  }

  /// Get advantage color
  /// الحصول على لون الميزة
  Color _getAdvantageColor() {
    final advantage = controller.materialAdvantage;
    if (advantage > 0) return Colors.green;
    if (advantage < 0) return Colors.blue;
    return Colors.grey;
  }

  /// Get advantage text
  /// الحصول على نص الميزة
  String _getAdvantageText() {
    final advantage = controller.materialAdvantage;
    if (advantage == 0) return '=';
    if (advantage > 0) return '+$advantage';
    return '$advantage';
  }
}
