import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart'; 
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/chess_board_settings_widgets.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class BuildControlButtons extends StatelessWidget {
  const BuildControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: GetBuilder<BaseGameController>(
        initState: (_) {},
        builder: (ctrl) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: buildNewRoundButton(ctrl)),
              Expanded(child: buildUndoButton()),
              Expanded(child: buildRedoButton()),
              Expanded(child: buildMenuButton()),
            ],
          );
        },
      ),
    );
  }
}

Widget buildNewRoundButton(BaseGameController ctrl) => IconButton(
  icon: Icon(Symbols.refresh, size: iconSize),
  onPressed: ctrl.gameState.isGameOverExtended || !ctrl.canUndo.value
      ? null
      : ctrl.reset,
);

Widget buildUndoButton() => GetX<BaseGameController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_left, size: iconSize),
    onPressed: controller.canUndo.value ? controller.undoMove : null,
  ),
);
Widget buildRedoButton() => GetX<BaseGameController>(
  builder: (controller) => IconButton(
    icon: Icon(Symbols.chevron_right, size: iconSize),
    onPressed: controller.canRedo.value ? controller.redoMove : null,
  ),
);
Widget buildMenuButton() => IconButton(
  icon: Icon(Symbols.menu, size: iconSize),
  onPressed: () {
    Get.dialog(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: ChessBoardSettingsWidgets(),
      ),
      name: Get.context!.l10n.mobileBoardSettings,
      barrierColor: Theme.of(Get.context!).dialogTheme.backgroundColor,
    );
  },
);
