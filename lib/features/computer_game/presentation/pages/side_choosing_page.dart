import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:chessground_game_app/features/computer_game/presentation/widgets/side_choosing_widget.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideChoosingPage extends StatelessWidget {
  final controller = Get.find<SideChoosingController>();

  SideChoosingPage({super.key});
  final sizedBox = const SizedBox(height: 15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(title: const Text('CHECKMATE!'), centerTitle: true),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "اختر خيارات اللعب",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                sizedBox,

                // Player Color Selector
                const Text(
                  "اختر لونك",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                sizedBox,
                SideChosingWidget(controller: controller),
                sizedBox,

                // UCI_LimitStrength toggle
                Obx(
                  () => CheckboxListTile(
                    title: const Text(
                      'Limit Engine Strength UCI_LimitStrength',
                    ),
                    value: controller.uciLimitStrength.value,
                    onChanged: (bool? value) {
                      controller.uciLimitStrength.value = value!;
                    },
                  ),
                ),
                sizedBox,

                // Sliders for engine options
                Obx(
                  () => Opacity(
                    opacity: controller.uciLimitStrength.value ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: !controller.uciLimitStrength.value,
                      child: Column(
                        children: [
                          // UCI_Elo Slider
                          Text('UCI Elo: ${controller.uciElo.value}'),
                          Slider(
                            value: controller.uciElo.value.toDouble(),
                            min: 1320,
                            max: 3190,
                            divisions: 300,
                            label: controller.uciElo.value.toString(),
                            onChanged: (double value) {
                              controller.uciElo.value = value.toInt();
                            },
                            activeColor: Colors.orangeAccent,
                            inactiveColor: Colors.orange.shade200.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                sizedBox,
                Obx(
                  () => Opacity(
                    opacity: controller.uciLimitStrength.value ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: controller.uciLimitStrength.value,
                      child: Column(
                        children: [
                          // Skill Level Slider
                          Text('Skill Level: ${controller.skillLevel.value}'),
                          Slider(
                            value: controller.skillLevel.value.toDouble(),
                            min: 0,
                            max: 20,
                            divisions: 20,
                            label: controller.skillLevel.value.toString(),
                            onChanged: (double value) {
                              controller.skillLevel.value = value.toInt();
                            },
                            activeColor: Colors.tealAccent,
                            inactiveColor: Colors.teal.shade200.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Move Time Slider (always available)
                Obx(
                  () => Column(
                    children: [
                      // Depth Slider
                      Text('Depth: ${controller.depth.value}'),
                      Slider(
                        value: controller.depth.value.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: 29,
                        label: controller.depth.value.toString(),
                        onChanged: (double value) {
                          controller.depth.value = value.toInt();
                        },
                        activeColor: Colors.deepPurpleAccent,
                        inactiveColor: Colors.deepPurple.shade200.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      Text(
                        'Thinking Time for AI (ms): ${controller.thinkingTimeForAI.value}',
                      ),
                      Slider(
                        value: controller.thinkingTimeForAI.value.toDouble(),
                        min: 100,
                        max: 5000,
                        divisions: 49,
                        label: controller.thinkingTimeForAI.value.toString(),
                        onChanged: (double value) {
                          controller.thinkingTimeForAI.value = value.toInt();
                        },
                        activeColor: Colors.cyanAccent,
                        inactiveColor: Colors.cyan.shade200.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "إظهار المساعدات",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: controller.showMoveHints.value,
                        onChanged: (val) =>
                            controller.showMoveHints.value = val,
                        activeThumbColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Play button
                ElevatedButton(
                  onPressed: () {
                    controller.changeValuecolorPlayer(
                      controller.playerColor.value,
                    );
                    Get.toNamed(AppRoutes.gameComputerPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    "ابدأ اللعب",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
