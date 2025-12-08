import 'package:chessground_game_app/core/global_feature/domain/entities/stockfish/engine_evaluation_entity.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to display engine evaluation
/// عنصر لعرض تقييم المحرك
class EngineEvaluationWidget extends GetView<StockfishController> {
  final bool compact;

  const EngineEvaluationWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final evaluation = controller.currentEvaluation;

      if (evaluation == null) {
        return _buildEmptyState(context);
      }

      return compact
          ? _buildCompactView(context, evaluation)
          : _buildFullView(context, evaluation);
    });
  }

  /// Build empty state when no evaluation available
  /// بناء الحالة الفارغة عند عدم وجود تقييم
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'No evaluation',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: compact ? 12 : 14,
          ),
        ),
      ),
    );
  }

  /// Build compact view (for small spaces)
  /// بناء العرض المضغوط (للمساحات الصغيرة)
  Widget _buildCompactView(
    BuildContext context,
    EngineEvaluationEntity evaluation,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getEvaluationColor(evaluation),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getEvaluationIcon(evaluation), size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            evaluation.evaluationString,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'D${evaluation.depth}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],  
      ),
    );
  }

  /// Build full view (detailed)
  /// بناء العرض الكامل (مفصل)
  Widget _buildFullView(
    BuildContext context,
    EngineEvaluationEntity evaluation,
  ) {
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
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getEvaluationIcon(evaluation),
                    color: _getEvaluationColor(evaluation),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Engine Evaluation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.isAnalyzing) {
                  return const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Evaluation score
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getEvaluationColor(evaluation).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _getEvaluationColor(evaluation),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  evaluation.evaluationString,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getEvaluationColor(evaluation),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Details
          _buildDetailRow(
            context,
            icon: Icons.analytics,
            label: 'Depth',
            value: '${evaluation.depth}',
          ),

          if (evaluation.nodes != null)
            _buildDetailRow(
              context,
              icon: Icons.hub,
              label: 'Nodes',
              value: _formatNumber(evaluation.nodes!),
            ),

          if (evaluation.time != null)
            _buildDetailRow(
              context,
              icon: Icons.timer,
              label: 'Time',
              value: '${(evaluation.time! / 1000).toStringAsFixed(2)}s',
            ),

          _buildDetailRow(
            context,
            icon: Icons.arrow_forward,
            label: 'Best Move',
            value: evaluation.bestMove,
          ),

          // Principal variation (if available)
          if (evaluation.pv.isNotEmpty && evaluation.pv.length > 1) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Principal Variation:',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: evaluation.pv.take(10).map((move) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    move,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build detail row
  /// بناء صف التفاصيل
  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Get evaluation color based on score
  /// الحصول على لون التقييم بناءً على النتيجة
  Color _getEvaluationColor(EngineEvaluationEntity evaluation) {
    if (evaluation.mate != null) {
      return evaluation.mate! > 0 ? Colors.green : Colors.red;
    }

    final cp = evaluation.centipawns ?? 0;
    if (cp > 200) return Colors.green[700]!;
    if (cp > 50) return Colors.green;
    if (cp > -50) return Colors.grey;
    if (cp > -200) return Colors.orange;
    return Colors.red;
  }

  /// Get evaluation icon
  /// الحصول على أيقونة التقييم
  IconData _getEvaluationIcon(EngineEvaluationEntity evaluation) {
    if (evaluation.mate != null) {
      return evaluation.mate! > 0 ? Icons.emoji_events : Icons.flag;
    }

    final cp = evaluation.centipawns ?? 0;
    if (cp > 100) return Icons.trending_up;
    if (cp < -100) return Icons.trending_down;
    return Icons.trending_flat;
  }

  /// Format large numbers
  /// تنسيق الأرقام الكبيرة
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
