import 'package:chessground_game_app/presentation/screens/side_choosing/widgets/side_choosing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/side_choosing_controller.dart';

class SideChoosingView extends StatelessWidget {
  final controller = Get.put(SideChoosingController());

  SideChoosingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(title: Text('CHECKMATE!'), centerTitle: true),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Options",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 16),

                // Color selector
                SideChosingWidget(controller: controller),
                SizedBox(height: 20),

                // ELO info
                Obx(
                  () => Column(
                    children: [
                      Text(
                        "Beginner ♟♟",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "ELO Level: ${controller.aiDepth}",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GetX<SideChoosingController>(
                  builder: (con) {
                    int aiDepth = con.aiDepth.value;
                    return Slider(
                      value: aiDepth.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 5,
                      label: 'AI Depth: ${aiDepth.round()}',
                      onChanged: (double value) {
                        debugPrint(value.toString());
                        aiDepth = value.toInt();
                        debugPrint("aiDepth $aiDepth");
                        con.aiDepth.value = aiDepth; // Update reactive variable
                      },
                    );
                  },
                ),
                const Text('AI Difficulty (Depth)'),
                GetBuilder<SideChoosingController>(
                  initState: (_) {},
                  builder: (_) {
                    return Column(
                      children: [
                        Slider(
                          value: controller.timeMs,
                          onChanged: controller.updateThinkingTime,
                          min: 500,
                          max: 3000,
                        ),
                        Text(
                          'Thinking time : ${controller.timeMs.toInt()} millis',
                        ),
                        Slider(
                          value: controller.uciElo.toDouble(),
                          onChanged: controller.updateUciElo,
                          min: 1320,
                          max: 3190,
                        ),
                        Text(
                          'UCI LimitStrength : ${controller.uciElo.toInt()} Elo',
                        ),
                      ],
                    );
                  },
                ),

                // Show move hints toggle
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Show move hints",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: controller.showMoveHints.value,
                        onChanged: (val) =>
                            controller.showMoveHints.value = val,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Play button
                ElevatedButton(
                  onPressed: () {
                    // navigate to game view
                    controller.changeValuecolorPlayer(
                      controller.choseColor.value,
                    );
                    Get.toNamed('GameComputerScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    child: Text("Play", style: TextStyle(fontSize: 18)),
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
