part of 'game_computer_controller.dart';

class GameComputerWithTimeController extends GameAiController {
  ChessClockService? clockCtrl;
  GameController? gameCtrl;

  ///constructer
  GameComputerWithTimeController(
    super.gameCtrl,
    super.engineService,
    super.plySound,
  );

  /// حفظ اللعبة الحالية في Isar
  @override
  Future<void> saveCurrentGame() async {
    _headers['TimeControl'] =
        "${gameCtrl!.whitesTime.inMinutes}+${gameCtrl!.incrementalValue}";
    super.saveCurrentGame();
  }

  @override
  void onInit() {
    gameCtrl = Get.find<GameController>();
    debugPrint("whitesTime ${gameCtrl!.whitesTime.inSeconds}");
    clockCtrl = Get.put(
      ChessClockService(
        initialTimeMs: (gameCtrl!.whitesTime.inMinutes * 60 * 1000).toInt(),
        incrementMs: gameCtrl!.incrementalValue * 1000,
        onTimeout: (player) {
          debugPrint('time over the ${player.opposite.name} player is winner');
          _handleTimeout(player);
        },
      ),
    );
    clockCtrl!.setIncrementalValue(value: gameCtrl!.incrementalValue);
    super.onInit();

    ever(position, (_) {
      clockCtrl!.stop();
      clockCtrl!.switchTurn(position.value.turn);
      clockCtrl!.start();
    });
  }

  @override
  Future<void> _initPlayers() async {
    if (gameCtrl?.playerColor.value == Side.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
      await createPlayerIfNotExists(
        storage,
      ).then((value) => whitePlayer.value = value!);
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!);
    } else if (gameCtrl?.playerColor.value == Side.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      await createAIPlayerIfNotExists(
        storage,
      ).then((value) => whitePlayer.value = value!);

      await createPlayerIfNotExists(
        storage,
      ).then((value) => blackPlayer.value = value!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    clockCtrl!.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    super.onClose();
    clockCtrl!.onClose();
  }

  @override
  void reset() {
    clockCtrl!.reset();
    super.reset();
  }

  /// عند انتهاء الوقت — نفعل هذه الدالة (clockService يجب أن يمرّر الجانب الذي انتهى الوقت له)
  void _handleTimeout(Side timedOutSide) async {
    debugPrint('Handling timeout for side: $timedOutSide');
    // من انتهى وقته يخسر، والآخر يفوز (ما لم تكن الحالة تمنع ذلك)
    final winnerSide = timedOutSide == Side.white ? Side.black : Side.white;
    final resultText = winnerSide == Side.white ? '1-0' : '0-1';
    debugPrint('Game over by timeout, result: $resultText');
    // نوقف المحرك والساعة
    engineService.stop();
    clockCtrl?.stop();

    statusText.value =
        'انتهى وقت ${timedOutSide == Side.white ? "الأبيض" : "الأسود"}.';
    update();

    // احفظ اللعبة في الـ DB عبر GameStorageService
    try {} catch (e) {
      debugPrint('Error saving game on timeout: $e');
    }

    // حدث واجهة المستخدم إن لزم
    update();
  }

  /// ضبط إعدادات المحرك وفق اختيار المستخدم

  // Method to apply the settings from SideChoosingController
  @override
  void _applyStockfishSettings() {
    // thinkingTimeForAI = gameCtrl!.thinkingTimeForAI;
    thinkingTimeForAI = 5000;

    // final skillLevel = gameCtrl!.skillLevel.value;
    // final uciElo = gameCtrl!.uciElo.value;

    // Use Skill Level and Depth if UCI_LimitStrength is disabled
    // engineService.setOption('Skill Level', skillLevel);
    // engineService.setOption('Depth', depth);
  }
}
