import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_settings_widgets.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/build_player_section_widget.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/game_info/pgn_horizontal_row.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/orientation/build_control_buttons.dart'; 
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildPortrait extends GetView<BaseGameController> {
  BuildPortrait({super.key});
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GetBuilder<BaseGameController>(
              builder: (controller) {
                return PgnHorizontalRow(
                  tokens: controller.pgnTokens,
                  currentHalfmoveIndex: controller.currentHalfmoveIndex,
                  onJumpTo: (idx) => controller.jumpToHalfmove(idx),
                );
              },
            ),
            Column(
              children: [
                const BuildPlayerSectionWidget(side: Side.white, isTop: true),
                ChessBoardWidget(),
                const BuildPlayerSectionWidget(side: Side.black, isTop: false),
              ],
            ),

            const SizedBox(height: screenPortraitSplitter),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: BuildControlButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
