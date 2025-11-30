import 'package:chessground_game_app/core/utils/helper/constants.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

mixin SetupGameVsAiMixin on GetxController {
  final skillLevel = 20.obs; // Default to max skill level
  final uciElo = 3190.obs; // Default to a high Elo
  final uciLimitStrength = true.obs;
  int thinkingTimeForAI = 2000; // default 2 seconds
  bool _aiThinking = false;
  bool _vsComputer = false;
  int _gameLevel = 1;
  int _incrementalValue = 0;
  Side _player = Side.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;

  bool get aiThinking => _aiThinking;

  int get gameLevel => _gameLevel;
  GameDifficulty get gameDifficulty => _gameDifficulty;

  int get incrementalValue => _incrementalValue;
  Side get player => _player;
  Rx<Side> playerColor = Side.white.obs;

  // get method
  bool get vsComputer => _vsComputer;

  // make squre move
  bool makeSquaresMove(Move move) {
    // bool result = game.makeSquaresMove(move);
    update();
    // return result;
    return true;
  }

  // make squre move
  bool makeStringMove(String bestMove) {
    // bool result = game.makeMoveString(bestMove);
    update();
    // return result;
    return true;
  }

  // set sqaures state
  Future<void> setSquaresState() async {
    // _state = game.squaresState(player);
    update();
  }

  // make random move
  void makeRandomMove() {
    // _game.makeRandomMove();
    update();
  }

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
  void setPlayerColor({required Side player}) {
    _player = player;
    playerColor.value = player;
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
