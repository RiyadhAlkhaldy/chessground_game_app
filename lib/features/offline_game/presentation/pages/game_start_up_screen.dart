// import 'package:flutter_chess/providers/authentication_provider.dart';

import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/widgets.dart';
import 'package:chessground_game_app/core/utils/helper/constants.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/offline_game_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({
    super.key,
    required this.isCustomTime,
    required this.gameTime,
  });

  final bool isCustomTime;
  final String gameTime;

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  Side playerColorGroup = Side.white;
  GameDifficulty gameLevelGroup = GameDifficulty.easy;

  int whiteTimeInMenutes = 0;
  int blackTimeInMenutes = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaseGameController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Setup Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: GetBuilder<BaseGameController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // radioListTile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: PlayerColorRadioButton(
                        title: 'Play as ${Side.white.name}',
                        value: Side.white,
                        groupValue: (controller as OfflineGameController)
                            .playerColor
                            .value,
                        onChanged: (value) {
                          controller.setPlayerColor(player: Side.white);
                        },
                      ),
                    ),
                    widget.isCustomTime
                        ? BuildCustomTime(
                            time: whiteTimeInMenutes.toString(),
                            onLeftArrowCricked: () {
                              setState(() {
                                whiteTimeInMenutes--;
                              });
                            },
                            onRightArrowCricked: () {
                              setState(() {
                                whiteTimeInMenutes++;
                              });
                            },
                          )
                        : Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: Text(
                                  widget.gameTime,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      //
                      child: PlayerColorRadioButton(
                        title: 'Play as ${Side.black.name}',
                        value: Side.black,
                        groupValue: controller.playerColor.value,
                        onChanged: (value) {
                          controller.setPlayerColor(player: Side.black);
                        },
                      ),
                    ),
                    widget.isCustomTime
                        ? BuildCustomTime(
                            time: blackTimeInMenutes.toString(),
                            onLeftArrowCricked: () {
                              setState(() {
                                blackTimeInMenutes--;
                              });
                            },
                            onRightArrowCricked: () {
                              setState(() {
                                blackTimeInMenutes++;
                              });
                            },
                          )
                        : Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: Text(
                                  widget.gameTime,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GameLevelRadioButton(
                      onChanged: (value) {
                        controller.setGameDifficulty(level: 1);
                      },
                      value: GameDifficulty.easy,
                      groupValue: controller.gameDifficulty,
                      title: GameDifficulty.medium.name,
                    ),
                    GameLevelRadioButton(
                      onChanged: (value) {
                        controller.setGameDifficulty(level: 2);
                      },

                      value: GameDifficulty.medium,
                      groupValue: controller.gameDifficulty,
                      title: GameDifficulty.medium.name,
                    ),
                    GameLevelRadioButton(
                      onChanged: (value) {
                        controller.setGameDifficulty(level: 3);
                      },
                      value: GameDifficulty.hard,
                      groupValue: controller.gameDifficulty,
                      title: GameDifficulty.hard.name,
                    ),
                  ],
                ),

                controller.vsComputer
                    ? Obx(
                        () => Opacity(
                          opacity: controller.uciLimitStrength.value
                              ? 1.0
                              : 0.5,
                          child: AbsorbPointer(
                            absorbing: !controller.uciLimitStrength.value,
                            child: Column(
                              children: [
                                // UCI_Elo Slider
                                Text(
                                  'UCI Elo: ${controller.uciElo.value}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Slider(
                                  value: controller.uciElo.value.toDouble(),
                                  min: 1320,
                                  max: 3190,
                                  divisions: 300,
                                  label: controller.uciElo.value.toString(),
                                  onChanged: (double value) {
                                    controller.uciElo.value = value.toInt();
                                  },
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.orange.shade200
                                      .withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),

                controller.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.offlineGamePage,
                            arguments: {"withTime": true},
                          );
                        },
                        child: const Text('Play'),
                      ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
