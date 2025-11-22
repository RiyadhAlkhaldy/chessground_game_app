import 'dart:math';

import 'package:get/get.dart';

enum SideChoosing { white, black, random }

class SideChoosingController extends GetxController {
  final showMoveHints = true.obs;

  // Define any necessary properties and methods for the main menu
  // Reactive variable for the player's color
  Rx<SideChoosing> playerColor =
      SideChoosing.white.obs; // Reactive variable for the player's color

  RxInt aiDepth = 4.obs; // AI depth for AI player

  // New reactive variables for Stockfish engine options
  final skillLevel = 20.obs; // Default to max skill level
  final depth = 20.obs; // Default to depth 20
  final uciElo = 1320.obs; // Default to a high Elo
  final thinkingTimeForAI = 1000.obs; // Default to 1000 ms (1 second)
  final uciLimitStrength = false.obs;

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
