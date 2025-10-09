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

  ///
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    gameCtrl = Get.find<GameController>();
    _setPlayerSide();
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
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
    engineService.start().then((_) async {
      _applyStockfishSettings();
      engineService.setPosition(fen: fen);
      stockfishState.value = StockfishState.ready;
      // clockCtrl!.start();
      // if the player is black, let the AI play the first move
      playerSide == PlayerSide.black ? playAiMove() : null;

      ///
      await onstartVsEngine();
    });
    //
    engineService.evaluations.listen((ev) {
      // debugPrint(ev.toString());
      // if (ev != null) {
      // evaluation.value = ev;
      // score.value = evaluation.value!.whiteWinPercent();
      // }
    });
    engineService.bestmoves.listen((event) {
      debugPrint('bestmoves: $event');
      _makeMoveAi(event);
    });
    ever(position, (_) {
      clockCtrl!.stop();
      clockCtrl!.switchTurn(position.value.turn);
      clockCtrl!.start();
    });
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

  @override
  void _setPlayerSide() {
    if (gameCtrl?.playerColor.value == Side.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
    } else if (gameCtrl?.playerColor.value == Side.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      debugPrint(
        'Player chose black side ${ctrlBoardSettings.orientation.value}',
      );
    }
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
