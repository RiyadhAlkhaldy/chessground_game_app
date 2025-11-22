import 'package:chessground_game_app/core/utils/helper/constants.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methods.dart';
import 'package:chessground_game_app/features/home/presentation/pages/game_start_up_screen.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameTimePage extends StatefulWidget {
  const GameTimePage({super.key});

  @override
  State<GameTimePage> createState() => _GameTimePageState();
}

class _GameTimePageState extends State<GameTimePage> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Get.put(GameStartUpController());

    debugPrint('VS VALUE: ${gameProvider.vsComputer}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Choose Game time', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
          ),
          itemCount: gameTimes.length,
          itemBuilder: (context, index) {
            // get the first word of the game time
            final String lable = gameTimes[index].split(' ')[0];

            // gat the second word from game time
            final String gameTime = gameTimes[index].split(' ')[1];

            return buildGameType(
              lable: lable,
              gameTime: gameTime,
              onTap: () {
                if (lable == Constants.custom) {
                  Get.to(GameStartUpPage(isCustomTime: true, gameTime: gameTime));
                } else {
                  Get.to(GameStartUpPage(isCustomTime: false, gameTime: gameTime));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
