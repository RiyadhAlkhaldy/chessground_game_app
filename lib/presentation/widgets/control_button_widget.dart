import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analyises_controller.dart';

class ControlButtonsWidget extends GetView<AnalysisController> {
  const ControlButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: controller.canUndo.value ? controller.goToStart : null,
            tooltip: 'Go to Start',
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: controller.canUndo.value ? controller.undoMove : null,
            tooltip: 'Undo Move',
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: controller.canRedo.value ? controller.redoMove : null,
            tooltip: 'Redo Move',
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: controller.canRedo.value
                ? () => {}
                : null, // Logic to go to end can be added
            tooltip: 'Go to End',
          ),
        ],
      ),
    );
  }
}
