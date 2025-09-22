import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analyises_controller.dart';

class EvaluationBarWidget extends GetView<AnalysisController> {
  const EvaluationBarWidget({super.key});

  double _scoreToPercentage(double score) {
    final clampedScore = score.clamp(-8.0, 8.0);
    return (clampedScore + 8.0) / 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final score = controller.evaluation.value.cp;
      final whiteAdvantage = _scoreToPercentage(score!.toDouble());
      final scoreText = score! > 0
          ? "+${score!.toStringAsFixed(1)}"
          : score!.toStringAsFixed(1);

      return Container(
        height: 24,
        color: isDark ? Colors.black : Colors.grey[800],
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: whiteAdvantage,
              child: Container(color: isDark ? Colors.grey[300] : Colors.white),
            ),
            Positioned(
              left: 5,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  scoreText,
                  style: TextStyle(
                    color: score >= 0 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
