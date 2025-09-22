import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analyises_controller.dart';
import '../controllers/chess_board_settings_controller.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/control_button_widget.dart';
import '../widgets/engine_suggestion_widget.dart';
import '../widgets/evaluation_bar.dart';
import '../widgets/move_list_widget.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({super.key});
  final AnalysisController controller = Get.find<AnalysisController>();
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Analysis Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => ctrlBoardSettings.orientation.value =
                ctrlBoardSettings.orientation.value.opposite,
            tooltip: 'Flip Board',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth > 600
                ? _buildWideLayout()
                : _buildNarrowLayout();
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EngineSuggestionsWidget(),
                const SizedBox(height: 8),
                ChessBoardWidget(
                  ctrlBoardSettings: ctrlBoardSettings,
                  controller: controller,
                ),
                const SizedBox(height: 8),
                ControlButtonsWidget(),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              EvaluationBarWidget(),
              const Expanded(child: MoveListWidget()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        EvaluationBarWidget(),
        EngineSuggestionsWidget(),
        ChessBoardWidget(
          ctrlBoardSettings: ctrlBoardSettings,
          controller: controller,
        ),
        ControlButtonsWidget(),
        const Expanded(child: MoveListWidget()),
      ],
    );
  }
}
