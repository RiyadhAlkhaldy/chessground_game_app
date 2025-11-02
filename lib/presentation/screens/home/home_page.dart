// import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/presentation/controllers/game_controller.dart';
import 'package:chessground_game_app/core/dialog/platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/helper/helper_methods.dart';
import '../../../routes/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.mobileSettingsHomeWidgets),
      ),
      body: Stack(
        children: [
          // AnimatedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                // physics: FixedExtentScrollPhysics(),
                children: [
                  buildGameType(
                    lable: '${context.l10n.playAgainstComputer} Time',
                    icon: Icons.computer,
                    onTap: () {
                      controller.setVsComputer(value: true);
                      // navigate to setup game time screen
                      Get.toNamed(
                        RouteNames.gameTimeScreen,
                        arguments: {"withTime": false},
                      );
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.playONline,
                    icon: Icons.person,
                    onTap: () {
                      controller.setVsComputer(value: false);
                      // navigate to setup game time screen
                      Get.toNamed(
                        RouteNames.gameTimeScreen,
                        arguments: {"withTime": false},
                      );
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.playAgainstComputer,
                    icon: Icons.computer,
                    onTap: () {
                      controller.setVsComputer(value: true);
                      // navigate to setup game time screen
                      Get.toNamed(
                        RouteNames.sideChoosingView,
                        arguments: {"withTime": false},
                      );
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.freePlay,
                    icon: Icons.gamepad_outlined,
                    onTap: () {
                      controller.setVsComputer(value: true);
                      // navigate to setup game time screen
                      Get.toNamed(RouteNames.freeGameScreen);
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.mobileSettingsTab,
                    icon: Symbols.settings,
                    onTap: () {
                      // navigate to settings screen

                      Get.toNamed(RouteNames.settingsScreen);
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.recentGames,
                    icon: Symbols.history,

                    onTap: () {
                      // navigate to recent games screen
                      Get.toNamed(RouteNames.recentGamesPage);
                    },
                  ),
                  buildGameType(
                    lable: context.l10n.about,
                    icon: Symbols.info,
                    onTap: () {
                      // navigate to about screen
                      Get.toNamed(RouteNames.aboutScreen);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
