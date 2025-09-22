import 'package:chessground_game_app/domain/entities/extended_evaluation.dart';
import 'package:chessground_game_app/presentation/controllers/game_computer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvaluationBarWidget extends GetView<GameComputerController> {
  const EvaluationBarWidget({super.key});

  double _scoreToPercentage(double score) {
    final clampedScore = score.clamp(-8.0, 8.0);
    return (clampedScore + 8.0) / 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      if (controller.evaluation.value == null) return SizedBox();
      // final score = controller.evaluation!.value.cp;
      // final whiteAdvantage = controller.evaluation!.value
      //     .whiteWinPercent(); // _scoreToPercentage(score);
      // final scoreText = score > 0
      //     ? "+${score.toStringAsFixed(1)}"
      //     : score.toStringAsFixed(1);

      return Container(
        height: 24,
        color: isDark ? Colors.black : Colors.grey[800],
        child: Stack(
          children: [
            FractionallySizedBox(
              // widthFactor: whiteAdvantage,
              widthFactor: controller.evaluation.value?.blackWinPercent(),
              child: Container(color: isDark ? Colors.grey[300] : Colors.white),
            ),
            Positioned(
              left: 5,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  controller.evaluation.value!.whiteWinPercent().toString(),
                  style: TextStyle(
                    color: controller.score.value >= 0
                        ? Colors.black
                        : Colors.white,
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
