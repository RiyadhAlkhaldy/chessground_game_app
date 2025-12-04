import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/orientation/build_landscape.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/orientation/build_portrait.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameComputerPage extends StatelessWidget {
  const GameComputerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<BaseGameController>(
          builder: (ctrl) {
            return Text(
              ctrl.statusText.value,
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ),

      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? BuildPortrait()
            : BuildLandScape(),
      ),
    );
  }
}
