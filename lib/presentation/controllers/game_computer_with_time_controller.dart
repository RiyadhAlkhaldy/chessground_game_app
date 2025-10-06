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

  @override
  Future<void> onstartVsEngine() async {}

  /// حفظ اللعبة الحالية في Isar
  @override
  Future<void> saveCurrentGame(Player white, Player black) async {
    _headers['TimeControl'] =
        "${gameCtrl!.whitesTime.inMinutes}+${gameCtrl!.incrementalValue}";
    super.saveCurrentGame(white, black);
  }

  ///
  @override
  void onInit() {
    super.onInit();
    gameCtrl = Get.find<GameController>();
    WidgetsBinding.instance.addObserver(this);
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
      clockCtrl!.start();
      _setPlayerSide();

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
    // ever(position, (_) {
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    clockCtrl!.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    clockCtrl!.onClose();
    super.onClose();
  }

  @override
  void reset() {
    clockCtrl!.reset();
    super.reset();
  }

  @override
  void _applyMove(NormalMove move) {
    clockCtrl!.switchTurn(position.value.turn);
    super._applyMove(move);
  }

  /// عند انتهاء الوقت — نفعل هذه الدالة (clockService يجب أن يمرّر الجانب الذي انتهى الوقت له)
  void _handleTimeout(Side timedOutSide) async {
    // من انتهى وقته يخسر، والآخر يفوز (ما لم تكن الحالة تمنع ذلك)
    final winnerSide = timedOutSide == Side.white ? Side.black : Side.white;
    final resultText = winnerSide == Side.white ? '1-0' : '0-1';

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

  void _setPlayerSide() {
    if (gameCtrl!.playerColor == Side.white) {
      playerSide = PlayerSide.white;
      ctrlBoardSettings.orientation.value = Side.white;
    } else if (gameCtrl!.playerColor == Side.black) {
      playerSide = PlayerSide.black;
      ctrlBoardSettings.orientation.value = Side.black;
      playAiMove();
    }
  }

  // Method to apply the settings from SideChoosingController
  void _applyStockfishSettings() {
    final skillLevel = gameCtrl!.skillLevel.value;
    // final depth = gameCtrl.depth.value;
    final uciLimitStrength = gameCtrl!.uciLimitStrength.value;
    final uciElo = gameCtrl!.uciElo.value;
    // final moveTime = gameCtrl!.moveTime.value;
    debugPrint("uciElo $uciElo");

    // Apply UCI_Elo if UCI_LimitStrength is enabled
    if (uciLimitStrength) {
      // Apply UCI_LimitStrength option
      engineService.setOption('UCI_LimitStrength', uciLimitStrength);
      engineService.setOption('UCI_Elo', uciElo);
      // Optional: Set depth to a low value as it's not the primary control
      // when UCI_LimitStrength is true
      engineService.setOption(
        'Skill Level',
        20,
      ); // Setting a high skill level by default
    } else {
      // Use Skill Level and Depth if UCI_LimitStrength is disabled
      engineService.setOption('Skill Level', skillLevel);
      // engineService.setOption('Depth', depth);
    }
  }
}
