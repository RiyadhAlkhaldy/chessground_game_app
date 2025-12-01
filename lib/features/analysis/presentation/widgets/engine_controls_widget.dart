
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

/// Widget for engine controls (hint, analysis, etc.)
/// عنصر لعناصر التحكم في المحرك (تلميح، تحليل، إلخ)
class EngineControlsWidget extends GetView<StockfishController> {
  final String currentFen;
  final VoidCallback? onHintReceived;

  const EngineControlsWidget({
    super.key,
    required this.currentFen,
    this.onHintReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'Engine Controls',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Hint button
          Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading || !controller.isInitialized
                    ? null
                    : () => _getHint(context),
                icon: const Icon(Icons.lightbulb),
                label: const Text('Get Hint'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              )),

          const SizedBox(height: 8),

          // Analyze button
          Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading || !controller.isInitialized
                    ? null
                    : () => _analyzePosition(context),
                icon: const Icon(Icons.analytics),
                label: const Text('Analyze Position'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                ),
              )),

          const SizedBox(height: 8),

          // Best move button
          Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading || !controller.isInitialized
                    ? null
                    : () => _getBestMove(context),
                icon: const Icon(Icons.star),
                label: const Text('Best Move'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.green,
                ),
              )),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Skill level slider
          _buildSkillLevelSlider(context),

          const SizedBox(height: 16),

          // Engine status
          _buildEngineStatus(context),
        ],
      ),
    );
  }

  /// Build skill level slider
  /// بناء شريط تمرير مستوى المهارة
  Widget _buildSkillLevelSlider(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Engine Level',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${controller.skillLevel}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: controller.skillLevel.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            label: controller.skillLevel.toString(),
            onChanged: controller.isInitialized
                ? (value) => controller.setSkillLevel(value.toInt())
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Beginner',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Master',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Build engine status
  /// بناء حالة المحرك
  Widget _buildEngineStatus(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: controller.isInitialized
              ? Colors.green[50]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: controller.isInitialized
                ? Colors.green
                : Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              controller.isInitialized
                  ? Icons.check_circle
                  : Icons.pending,
              color: controller.isInitialized
                  ? Colors.green
                  : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.isInitialized
                    ? 'Engine Ready'
                    : 'Initializing Engine...',
                style: TextStyle(
                  fontSize: 13,
                  color: controller.isInitialized
                      ? Colors.green[900]
                      : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (controller.isAnalyzing)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      );
    });
  }

  /// Get hint
  /// الحصول على تلميح
  Future<void> _getHint(BuildContext context) async {
    await controller.getHint(currentFen);
    
    if (controller.hintMove != null && onHintReceived != null) {
      onHintReceived!();
    }
  }

  /// Analyze position
  /// تحليل الموضع
  Future<void> _analyzePosition(BuildContext context) async {
    await controller.analyzePosition(currentFen, depth: 20);
  }

  /// Get best move
  /// الحصول على أفضل حركة
  Future<void> _getBestMove(BuildContext context) async {
    await controller.getBestMove(currentFen, depth: 20);
    
    if (controller.bestMove != null) {
      Get.snackbar(
        'Best Move',
        'Best move: ${controller.bestMove!.san ?? controller.bestMove!.uci}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
