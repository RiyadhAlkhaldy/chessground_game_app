import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/extended_evaluation.dart';
import '../../domain/repositories/i_engine_repository.dart';
import 'game_computer_controller.dart';

class AnalysisController extends GameComputerController {
  final IEngineRepository engineRepository;
  AnalysisController(
    super.choosingCtrl,
    super.engineService,
    super.plySound,
    this.engineRepository,
  );

  final RxList<String> movesUci = <String>[].obs;
  final RxList<Map<String, dynamic>> moveHistorySan =
      <Map<String, dynamic>>[].obs;

  // --- Engine Analysis State ---
  @override
  final Rx<ExtendedEvaluation> evaluation = ExtendedEvaluation.initial().obs;
  StreamSubscription? _evalSubscription;

  // @override
  // void onInit() {
  //   super.onInit();
  //   WidgetsBinding.instance.addObserver(this);

  //   // -- تصحيح --: الاستماع لتغيرات الوضع وتحديث النقلات المتاحة تلقائيًا
  //   ever(position, (newPosition) {
  //     validMoves = makeLegalMoves(newPosition);
  //     fen = newPosition.fen;
  //   });

  //   validMoves = makeLegalMoves(position.value);
  //   // الإعداد الأولي
  //   _initializeAndAnalyze();
  // }

  Future<void> _initializeAndAnalyze() async {
    await engineRepository.initialize();
    _evalSubscription = engineRepository.evaluations.listen((eval) {
      evaluation.value = eval;
      // لا نرسم الأسهم هنا لتجنب التعارض مع ChessgroundController
    });
    _analyzeCurrentPosition();
  }

  void _analyzeCurrentPosition() {
    engineRepository.setPosition(moves: movesUci.toList());
    engineRepository.go();
  }

  // -- تصحيح --: دالة جديدة لاستقبال النقلات من ويدجت Chessboard
  void onUserMove(NormalMove move) {
    if (position.value.isLegal(move)) {
      _makeMove(move);
    }
  }

  // -- تصحيح --: اعتماد نمط تحديث الحالة الصحيح من الكود المرجعي
  void _makeMove(NormalMove move) {
    // 1. أضف الوضع الحالي إلى سجل الـ Undo
    past.add(position.value);
    // 2. امسح سجل الـ Redo
    future.clear();

    // 3. قم بتطبيق النقلة بإنشاء كائن جديد (Immutable pattern)
    position.value = position.value.playUnchecked(move);

    // 4. تحديث باقي متغيرات الحالة
    lastMove = move;
    movesUci.add(move.uci);
    moveHistorySan.add({'san': move.uci, 'fen': position.value.fen});

    _analyzeCurrentPosition();
  }

  // @override
  // void undoMove() {
  //   if (!canUndo.value) return;
  //   future.add(position.value);
  //   position.value = past.removeLast();

  //   movesUci.removeLast();
  //   moveHistorySan.removeLast();
  //   // lastMove.value = position.value.history().isNotEmpty
  //   //     ? NormalMove.fromUci(position.value.history().last.uci)
  //   //     : null;

  //   _analyzeCurrentPosition();
  // }

  // @override
  // void redoMove() {
  //   if (!canRedo.value) return;
  //   past.add(position.value);
  //   position.value = future.removeLast();

  //   // final move = NormalMove.fromUci(position.value.history().last.uci);
  //   // lastMove.value = move;
  //   // movesUci.add(move.uci);
  //   moveHistorySan.add({
  //     // 'san': position.value.history().last.san,
  //     // 'fen': position.value.fen,
  //   });

  //   _analyzeCurrentPosition();
  // }

  // باقي الدوال تبقى كما هي...
  void goToMove(int moveIndex) {
    position.value = Chess.initial;
    past.clear();
    future.clear();
    final fullHistory = List<Map<String, dynamic>>.from(moveHistorySan);
    moveHistorySan.clear();
    movesUci.clear();
    for (int i = 0; i <= moveIndex; i++) {
      final san = fullHistory[i]['san'];
      past.add(position.value);
      // position.value.move(san);
      // movesUci.add(position.value.history().last.uci);
      moveHistorySan.add(fullHistory[i]);
    }
    // lastMove.value = NormalMove.fromUci(position.value.history().last.uci);
    _analyzeCurrentPosition();
  }

  void goToStart() {
    position.value = Chess.initial;
    past.clear();
    future.clear();
    movesUci.clear();
    moveHistorySan.clear();
    lastMove = null;
    _analyzeCurrentPosition();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      engineRepository.stop();
    }
    if (state == AppLifecycleState.resumed) {
      _analyzeCurrentPosition();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _evalSubscription?.cancel();
    engineRepository.dispose();
    super.onClose();
  }
}
