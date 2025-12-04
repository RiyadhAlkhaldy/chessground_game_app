import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/base_game_controller.dart';
import 'package:chessground_game_app/core/utils/helper/constants.dart'; 
import 'package:get/get.dart';

mixin SetupGameVsAiMixin on BaseGameController {
  final skillLevel = 20.obs; // Default to max skill level
  final uciElo = 3190.obs; // Default to a high Elo
  final uciLimitStrength = true.obs;
  int thinkingTimeForAI = 2000; // default 2 seconds
  bool _aiThinking = false;
  bool _vsComputer = false;
  int _gameLevel = 1;
  int _incrementalValue = 0; 
  GameDifficulty _gameDifficulty = GameDifficulty.easy;

  bool get aiThinking => _aiThinking;

  int get gameLevel => _gameLevel;
  GameDifficulty get gameDifficulty => _gameDifficulty;

  int get incrementalValue => _incrementalValue;  
  // get method
  bool get vsComputer => _vsComputer;

  void setAiThinking(bool value) {
    _aiThinking = value;
    update();
  }

  // set incremental value
  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
    update();
  }

  // set vs computer
  void setVsComputer({required bool value}) {
    _vsComputer = value;
    update();
  }

  // set playerColor
  void setPlayerColor({required PlayerSide player}) {
    playerSide = player;
    // playerColor.value = player;
    update();
  }

  // set difficulty
  void setGameDifficulty({required int level}) {
    _gameLevel = level;
    _gameDifficulty = level == 1
        ? GameDifficulty.easy
        : level == 2
        ? GameDifficulty.medium
        : GameDifficulty.hard;
    update();
  }
}
