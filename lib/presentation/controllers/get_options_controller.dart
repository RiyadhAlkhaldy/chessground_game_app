import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameOptionsController extends GetxController {
  var difficultyLevel = 0.obs; // 0 = Beginner, up to 9 or more
  var showMoveHints = true.obs;

  int get elo => 200 + difficultyLevel.value * 100;

  // Define any necessary properties and methods for the main menu
  Rx<PlayerSide> meColor =
      PlayerSide.white.obs; // Reactive variable for the player's color
  Rx<PlayerSide> choseColor =
      PlayerSide.white.obs; // Reactive variable for the player's color
  // Reactive variable to track the selected game mode

  RxInt aiDepth = 4.obs; // AI depth for AI player

  void changeValuecolorPlayer(PlayerSide playerColor) {
    if (playerColor == PlayerSide.white) {
      meColor.value = playerColor;
    } else if (playerColor == PlayerSide.black) {
      meColor.value = playerColor;
    } else {
      // make random between PlayerSide.white and PlayerSide.black
      var x = Random();
      int nextNumber = x.nextInt(13);
      debugPrint('nextNumber $nextNumber');
      if (nextNumber % 2 == 0) {
        changeValuecolorPlayer(PlayerSide.white);
      } else {
        changeValuecolorPlayer(PlayerSide.black);
      }
    }
  }
}
