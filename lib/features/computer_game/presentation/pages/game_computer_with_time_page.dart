import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/orientation/build_landscape.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/orientation/build_portrait.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameComputerWithTimePage extends StatelessWidget {
  GameComputerWithTimePage({super.key});

  final ctrl = Get.find<BaseGameController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: GetX<BaseGameController>(
          builder: (_) {
            return Text(ctrl.statusText.value);
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
