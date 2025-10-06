import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SideChoosing { white, black, random }

class SideChoosingController extends GetxController {
  final difficultyLevel = 0.obs; // 0 = Beginner, up to 9 or more
  final showMoveHints = true.obs;
  final withTime = false.obs;
  // int get elo => 200 + difficultyLevel.value * 100;

  // Define any necessary properties and methods for the main menu
  // Reactive variable for the player's color
  Rx<SideChoosing> playerColor =
      SideChoosing.white.obs; // Reactive variable for the player's color
  // Reactive variable to track the selected game mode

  RxInt aiDepth = 4.obs; // AI depth for AI player
  // Reactive variables for player color and game options
  // final Rx<Color> choseColor = Rx<Color>(Colors.white);
  // final showMoveHints = false.obs;

  // New reactive variables for Stockfish engine options
  final skillLevel = 20.obs; // Default to max skill level
  final depth = 20.obs; // Default to depth 20
  final uciElo = 2850.obs; // Default to a high Elo
  final moveTime = 2000.obs; // Default to 2000 ms (2 seconds)
  final uciLimitStrength = false.obs;
  final playTime = 1.obs;
  @override
  void onInit() {
    super.onInit();
    withTime.value = Get.arguments['withTime'] as bool;
    debugPrint("SideChoosingController initialized");
  }

  final _random = Random();
  // Method to change the player's color
  void changeValuecolorPlayer(SideChoosing plyrClor) =>
      plyrClor != SideChoosing.white && plyrClor != SideChoosing.black
          ? () {
            // make random between SideChoosing.white and SideChoosing.black
            if (_random.nextInt(13) % 2 == 0) {
              changeValuecolorPlayer(SideChoosing.white);
            } else {
              changeValuecolorPlayer(SideChoosing.black);
            }
          }
          : playerColor.value = plyrClor;

  var timeMs = 1000.0;

  void updateThinkingTime(double newValue) {
    timeMs = newValue;
    update();
  }

  // var uciElo = 1320.0;
  void updateUciElo(double newValue) {
    uciElo.value = newValue.toInt();
    update();
  }
}
