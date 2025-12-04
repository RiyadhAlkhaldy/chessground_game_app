// import 'package:flutter_chess/providers/authentication_provider.dart';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/widgets/widgets.dart';
import 'package:chessground_game_app/core/utils/helper/constants.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/game_start_up_controller.dart';
import 'package:chessground_game_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameStartUpPage extends StatefulWidget {
  const GameStartUpPage({
    super.key,
    required this.isCustomTime,
    required this.gameTime,
  });

  final bool isCustomTime;
  final String gameTime;

  @override
  State<GameStartUpPage> createState() => _GameStartUpPageState();
}

class _GameStartUpPageState extends State<GameStartUpPage> {
  PlayerSide playerColorGroup = PlayerSide.white;
  GameDifficulty gameLevelGroup = GameDifficulty.easy;

  int whiteTimeInMenutes = 0;
  int blackTimeInMenutes = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameStartUpController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Setup Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: GetBuilder<GameStartUpController>(
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
                        title: 'Play as ${PlayerSide.white.name}',
                        value: PlayerSide.white,
                        groupValue: controller.playerColor.value,
                        onChanged: (value) {
                          controller.setPlayerColor(player: PlayerSide.white);
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
                        title: 'Play as ${PlayerSide.black.name}',
                        value: PlayerSide.black,
                        groupValue: controller.playerColor.value,
                        onChanged: (value) {
                          controller.setPlayerColor(player: PlayerSide.black);
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
                          // navigate to game screen
                          playGame(controller: controller);
                        },
                        child: const Text('Play'),
                      ),

                const SizedBox(height: 20),

                controller.vsComputer
                    ? const SizedBox.shrink()
                    : Text(controller.waitingText),
              ],
            ),
          );
        },
      ),
    );
  }

  void playGame({required GameStartUpController controller}) async {
    // final userModel = context.read<AuthenticationProvider>().userModel;
    // check if is custome time
    if (widget.isCustomTime) {
      // check all timer are greater than 0
      if (whiteTimeInMenutes <= 0 || blackTimeInMenutes <= 0) {
        // show snackbar
        showSnackBar(context: context, content: 'Time cannot be 0');
        return;
      }

      // 1. start loading dialog
      controller.setIsLoading(value: true);
      controller.setWhitesTime(
        Duration(minutes: int.parse(whiteTimeInMenutes.toString())),
      );
      controller.setBlacksTime(
        Duration(minutes: int.parse(blackTimeInMenutes.toString())),
      );

      // 2. save time and player color for both players
      if (controller.vsComputer) {
        controller.setIsLoading(value: false);
        // 3. navigate to game screen
        Get.toNamed(
          AppRoutes.gameComputerWithTimePage,
          arguments: {"withTime": true},
        );
      } else {
        // search for players
      }
      // await controller
      //     .setGameTime(
      //       newSavedWhitesTime: whiteTimeInMenutes.toString(),
      //       newSavedBlacksTime: blackTimeInMenutes.toString(),
      //     )
      //     .whenComplete(() {
      //       if (controller.vsComputer) {
      //         controller.setIsLoading(value: false);
      //         // 3. navigate to game screen
      //         Get.toNamed(
      //           RouteNames.gameComputerWithTimeScreen,
      //           arguments: {"withTime": true},
      //         );
      //       } else {
      //         // search for players
      //       }
      // });
    } else {
      // not custom time
      // check if its incremental time
      // get the value after the + sign
      final String incrementalTime = widget.gameTime.split('+')[1];

      // get the value before the + sign
      final String gameTime = widget.gameTime.split('+')[0];

      // check if incremental is equal to 0
      if (incrementalTime != '0') {
        controller.setIsLoading(value: true);
        // save the incremental value
        controller.setIncrementalValue(value: int.parse(incrementalTime));
      }

      controller.setWhitesTime(Duration(minutes: int.parse(gameTime)));
      controller.setBlacksTime(Duration(minutes: int.parse(gameTime)));
      if (controller.vsComputer) {
        controller.setIsLoading(value: false);
        // 3. navigate to game screen
        Get.toNamed(
          AppRoutes.gameComputerWithTimePage,
          arguments: {"withTime": true},
        );
      } else {
        // search for players
      }

      // await controller
      //     .setGameTime(
      //       newSavedWhitesTime: gameTime,
      //       newSavedBlacksTime: gameTime,
      //     )
      //     .whenComplete(() {
      //       if (controller.vsComputer) {
      //         controller.setIsLoading(value: false);
      //         // 3. navigate to game screen
      //         Get.toNamed(
      //           RouteNames.gameComputerWithTimeScreen,
      //           arguments: {"withTime": true},
      //         );
      //       } else {
      //         // search for players
      //         // controller.searchPlayer(
      //         //   userModel: userModel!,
      //         //   onSuccess: () {
      //         //     if (controller.waitingText ==
      //         //         Constants.searchingPlayerText) {
      //         //       controller.checkIfOpponentJoined(
      //         //         userModel: userModel,
      //         //         onSuccess: () {
      //         //           controller.setIsLoading(value: false);
      //         //           Navigator.pushNamed(context, Constants.gameScreen);
      //         //         },
      //         //       );
      //         //     } else {
      //         //       controller.setIsLoading(value: false);
      //         //       // navigate to gameScreen
      //         //       Navigator.pushNamed(context, Constants.gameScreen);
      //         //     }
      //         //   },
      //         //   onFail: (error) {
      //         //     controller.setIsLoading(value: false);
      //         //     showSnackBar(context: context, content: error);
      //         //   },
      //         // );
      //       }
      //     });
    }
  }
}
