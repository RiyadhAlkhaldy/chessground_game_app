import 'package:chessground_game_app/presentation/controllers/side_choosing_controller.dart';
import 'package:chessground_game_app/presentation/screens/side_choosing/widgets/side_choosing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SideChoosingView extends StatelessWidget {
  final controller = Get.put(SideChoosingController());

  SideChoosingView({super.key});
  final sizedBox = SizedBox(height: 15);
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
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
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
                /// to play with time and computer
                controller.withTime.value
                    ? Obx(
                        () => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Determine Playing Time (Minute): ${controller.playTime.value}',
                            ),

                            Slider(
                              value: controller.playTime.value.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 10,
                              label: controller.playTime.value.toString(),
                              onChanged: (double value) {
                                controller.playTime.value = value.toInt();
                              },
                              activeColor: Colors.cyanAccent,
                              inactiveColor: Colors.cyan.shade200.withOpacity(
                                0.3,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),

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
                      'Limit Engine Strength (UCI_LimitStrength)',
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
                            inactiveColor: Colors.teal.shade200.withOpacity(
                              0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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
                            min: 1350,
                            max: 2850,
                            divisions: 300,
                            label: controller.uciElo.value.toString(),
                            onChanged: (double value) {
                              controller.uciElo.value = value.toInt();
                            },
                            activeColor: Colors.orangeAccent,
                            inactiveColor: Colors.orange.shade200.withOpacity(
                              0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                sizedBox,

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
                        inactiveColor: Colors.deepPurple.shade200.withOpacity(
                          0.3,
                        ),
                      ),
                      Text('Move Time (ms): ${controller.moveTime.value}'),
                      Slider(
                        value: controller.moveTime.value.toDouble(),
                        min: 100,
                        max: 5000,
                        divisions: 49,
                        label: controller.moveTime.value.toString(),
                        onChanged: (double value) {
                          controller.moveTime.value = value.toInt();
                        },
                        activeColor: Colors.cyanAccent,
                        inactiveColor: Colors.cyan.shade200.withOpacity(0.3),
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
                      controller.choseColor.value,
                    );

                    /// to play with time and computer or just with computer
                    controller.withTime.value
                        ? Get.toNamed(RouteNames.gameComputerWithTimeScreen)
                        : Get.toNamed(RouteNames.gameComputerScreen);
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
