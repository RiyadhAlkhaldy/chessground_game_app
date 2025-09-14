import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SideChoosing { white, black, random }

class SideChoosingController extends GetxController {
  var difficultyLevel = 0.obs; // 0 = Beginner, up to 9 or more
  var showMoveHints = true.obs;

  // int get elo => 200 + difficultyLevel.value * 100;

  // Define any necessary properties and methods for the main menu
  Rx<SideChoosing> meColor =
      SideChoosing.white.obs; // Reactive variable for the player's color
  Rx<SideChoosing> choseColor =
      SideChoosing.white.obs; // Reactive variable for the player's color
  // Reactive variable to track the selected game mode

  RxInt aiDepth = 4.obs; // AI depth for AI player

  void changeValuecolorPlayer(SideChoosing playerColor) {
    if (playerColor == SideChoosing.white) {
      meColor.value = playerColor;
    } else if (playerColor == SideChoosing.black) {
      meColor.value = playerColor;
    } else {
      // make random between SideChoosing.white and SideChoosing.black
      var x = Random();
      int nextNumber = x.nextInt(13);
      debugPrint('nextNumber $nextNumber');
      if (nextNumber % 2 == 0) {
        changeValuecolorPlayer(SideChoosing.white);
      } else {
        changeValuecolorPlayer(SideChoosing.black);
      }
    }
  }

  var timeMs = 1000.0;

  void updateThinkingTime(double newValue) {
    timeMs = newValue;
    update();
  }

  var uciElo = 1320.0;
  void updateUciElo(double newValue) {
    uciElo = newValue;
    update();
  }
}
