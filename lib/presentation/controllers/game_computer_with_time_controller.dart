part of 'game_computer_controller.dart';

class GameComputerWithTimeController extends GameAiController {
  ChessClockService? clockCtrl;
  GameController? gameCtrl;

  ///constructer
  GameComputerWithTimeController(super.choosingCtrl, super.plySound);

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
    // debugPrint(position.value.fen);
    // debugPrint(fen);
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
}
