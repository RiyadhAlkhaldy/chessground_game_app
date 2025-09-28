part of 'game_computer_controller.dart';

// part '';
class GameComputerWithTimeController extends GameAiController {
  ChessClockService? clockCtrl;

  ///constructer
  GameComputerWithTimeController(super.choosingCtrl, super.plySound);
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // debugPrint(position.value.fen);
    // debugPrint(fen);
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    clockCtrl = Get.put(
      ChessClockService(
        initialTimeMs: (choosingCtrl.playTime.value * 60 * 1000).toInt(),
        incrementMs: 1000,
        onTimeout: (player) {
          debugPrint('time over the ${player.opposite.name} player is winner');
          _handleTimeout(player);
        },
      ),
    );
    engineService.start().then((_) {
      _applyStockfishSettings();
      engineService.setPosition(fen: fen);
      stockfishState.value = StockfishState.ready;
      clockCtrl!.start();
      _setPlayerSide();
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

  // void _handleTimeout(Side timedOutPlayer) {
  //   // أوقف أي عمليات أخرى في اللعبة
  //   engineService.stop(); // إيقاف تفكير المحرك
  //   clockCtrl!.stop();

  //   final winner = timedOutPlayer.opposite;

  //   // تحديث نص الحالة
  //   statusText.value =
  //       'انتهى الوقت! الفائز هو: ${winner == Side.white ? 'الأبيض' : 'الأسود'}';
  //   update(); // لتحديث الواجهة

  //   // هنا يمكنك إضافة منطق حفظ اللعبة في قاعدة البيانات
  //   // GameHistoryService.saveGame(...)
  // }
  String? pgn;
  String? generatePgnFromPosition() {
    return position.value.fen;
  }

  List<MoveModel> buildMoveModelsFromHistory() {
    final out = <MoveModel>[];
    int mvNum = 1;
    Position pos = past.first;
    for (final move in pastMoves) {
      pos = pos.playUnchecked(NormalMove.fromUci(move));
      // افترض أن لديك pos.lastMoveUci و pos.fen
      out.add(MoveModel(uci: move, fen: pos.fen, moveNumber: mvNum++));
      mvNum++;
    }
    return out;
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
    try {
      final storage = GameStorageService();
      // افترض أن لديك PGN مُكوّن أو يمكن استخراجه من dartchess
      final pgnText =
          pgn ?? generatePgnFromPosition(); // إذا كان لديك وظيفة للتوليد
      await storage.saveFinishedGame(
        pgn: pgnText ?? '',
        result: resultText,
        startedAt: gameStartedAt ?? DateTime.now(),
        endedAt: DateTime.now(),
        timeControl: clockCtrl?.initialTimeMs.toString(),
        whiteName: playersWhiteName ?? 'White',
        blackName: playersBlackName ?? 'Black',
        moves: buildMoveModelsFromHistory(), // حوِّل history إلى MoveModel list
      );
    } catch (e) {
      debugPrint('Error saving game on timeout: $e');
    }

    // حدث واجهة المستخدم إن لزم
    update();
  }

  Future<void> agreeToDraw() async {
    if (position.value.isGameOver) return;

    engineService.stop();
    clockCtrl?.stop();

    statusText.value = 'تعادل بالاتفاق بين الطرفين.';
    update();

    // حفظ اللعبة كتساوي
    try {
      final storage = GameStorageService();
      final pgnText = pgn ?? generatePgnFromPosition();
      await storage.saveFinishedGame(
        pgn: pgnText ?? '',
        result: '1/2-1/2',
        startedAt: gameStartedAt ?? DateTime.now(),
        endedAt: DateTime.now(),
        timeControl: clockCtrl?.initialTimeMs.toString(),

        whiteName: playersWhiteName ?? 'White',
        blackName: playersBlackName ?? 'Black',
        moves: buildMoveModelsFromHistory(),
      );
    } catch (e) {
      debugPrint('Error saving game on agreeToDraw: $e');
    }
  }
}
