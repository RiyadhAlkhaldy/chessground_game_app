import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/helper/constants.dart';
import '../../core/utils/helper/helper_methods.dart';
import '../controllers/game_controllerr.dart';
import 'game_start_up_screen.dart';

class GameTimeScreen extends StatefulWidget {
  const GameTimeScreen({super.key});

  @override
  State<GameTimeScreen> createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Get.put(GameControllerr());

    debugPrint('VS VALUE: ${gameProvider.vsComputer}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Choose Game time',
          style: TextStyle(color: Colors.white),
        ),
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
                  Get.to(
                    GameStartUpScreen(isCustomTime: true, gameTime: gameTime),
                  );
                } else {
                  Get.to(
                    GameStartUpScreen(isCustomTime: false, gameTime: gameTime),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
