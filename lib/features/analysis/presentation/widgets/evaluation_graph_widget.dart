import 'package:chessground_game_app/features/analysis/presentation/controllers/game_analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
// اكمل للخطوات المتبقية (2-5)
// إكمال الخطوات المتبقية (2-5)
// 📊 الخطوة المقترحة 2: تحسين UI للتحليل (رسوم بيانية)
// 📝 A. إنشاء Evaluation Graph Widget

/// Widget to display evaluation graph over moves
/// عنصر لعرض رسم بياني للتقييم عبر الحركات
class EvaluationGraphWidget extends GetView<GameAnalysisController> {
  const EvaluationGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.moveEvaluations.isEmpty) {
        return _buildEmptyState(context);
      }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evaluation Graph',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildLegend(context),
              ],
            ),

            const SizedBox(height: 16),

            // Graph
            SizedBox(height: 200, child: _buildLineChart(context)),

            const SizedBox(height: 8),

            // Info text
            Text(
              'Tap on the graph to jump to that position',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No evaluation data',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Analyze moves to see graph',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _buildLegendItem('White', Colors.white, Colors.black),
        const SizedBox(width: 12),
        _buildLegendItem('Black', Colors.black, Colors.white),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color bgColor, Color textColor) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: textColor)),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final spots = _getChartSpots();

    if (spots.isEmpty) {
      return const Center(child: Text('No data'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  // axisSide: meta.axisSide,
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('0');
                return Text(
                  value > 0 ? '+${value.toInt()}' : value.toInt().toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!),
        ),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: -10,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isCurrentMove = index == controller.currentMoveIndex;
                return FlDotCirclePainter(
                  radius: isCurrentMove ? 6 : 3,
                  color: isCurrentMove ? Colors.red : Colors.blue,
                  strokeWidth: isCurrentMove ? 2 : 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
              cutOffY: 0,
              applyCutOffY: true,
            ),
            aboveBarData: BarAreaData(
              show: true,
              color: Colors.grey.withOpacity(0.1),
              cutOffY: 0,
              applyCutOffY: true,
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (event, response) {
            if (event is FlTapUpEvent && response?.lineBarSpots != null) {
              final spot = response!.lineBarSpots!.first;
              controller.goToMove(spot.x.toInt());
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.blueGrey,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final eval = barSpot.y;
                return LineTooltipItem(
                  'Move ${barSpot.x.toInt() + 1}\n${eval >= 0 ? '+' : ''}${eval.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getChartSpots() {
    final List<FlSpot> spots = [];

    controller.moveEvaluations.forEach((index, evaluation) {
      double yValue;

      if (evaluation.mate != null) {
        // Mate in X: cap at ±10
        yValue = evaluation.mate! > 0 ? 10.0 : -10.0;
      } else {
        // Convert centipawns to pawns, cap at ±10
        yValue = (evaluation.centipawns ?? 0) / 100.0;
        yValue = yValue.clamp(-10.0, 10.0);
      }

      spots.add(FlSpot(index.toDouble(), yValue));
    });

    return spots;
  }
}
