// import 'dart:async';

// import 'package:chessground/chessground.dart';
// import 'package:dartchess/dartchess.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../domain/repositories/i_engine_repository.dart';
// import '../../domain/services/engine_evaluation.dart';

// class ChessController extends GetxController with WidgetsBindingObserver {
//   final IEngineRepository _engineRepository;

//   ChessController(this._engineRepository);

//   // Game State
//   final _game = Chess.initial.obs;
//   final RxString fen = Chess.initial.fen.obs;
//   final RxList<String> moveHistory = <String>[].obs;

//   // UI State
//   final Rx<Side> orientation = Side.white.obs;
//   late ChessgroundController cgController;

//   // Engine Analysis State
//   final Rx<EngineEvaluation> evaluation = EngineEvaluation.initial().obs;
//   StreamSubscription? _evaluationSubscription;

//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     cgController = ChessgroundController(
//       fen: fen.value,
//       onMove: _handleUserMove,
//     );
//     _initializeEngine();
//   }

//   Future<void> _initializeEngine() async {
//     await _engineRepository.initialize();
//     _evaluationSubscription = _engineRepository.evaluationStream.listen((eval) {
//       evaluation.value = eval;
//       _updateBoardWithAnalysis(eval);
//     });
//     // Start analysis for the initial position
//     startAnalysis();
//   }

//   void _handleUserMove(Move move) {
//     final result = _game.value.playUnchecked(move);

//     // if (result) {
//     _updateGameState();
//     // }
//   }

//   void _updateGameState() {
//     fen.value = _game.value.fen;
//     cgController.setFen(fen.value);
//     // After a move, start analyzing the new position
//     startAnalysis();
//   }

//   void startAnalysis() {
//     _engineRepository.analyzePosition(fen.value);
//   }

//   void _updateBoardWithAnalysis(EngineEvaluation eval) {
//     if (eval.bestMove.length >= 4) {
//       final from = eval.bestMove.substring(0, 2);
//       final to = eval.bestMove.substring(2, 4);
//       cgController.setShapes([
//         // Shape.arrow(color: HighlightColor.blue, orig: from, dest: to),
//       ]);
//     } else {
//       cgController.setShapes([]);
//     }
//   }

//   void flipBoard() {
//     orientation.value = orientation.value == Side.white
//         ? Side.black
//         : Side.white;
//     cgController.setOrientation(orientation.value);
//   }

//   void newGame() {
//     _game.value = Chess.initial;
//     _updateGameState();
//   }

//   void undoMove() {
//     // _game.value.undo();
//     _updateGameState();
//   }

//   // Game history navigation
//   void navigateToStart() {
//     // _game.value.reset();
//     // Temporarily load history to navigate
//     final history = List<String>.from(moveHistory);
//     for (final move in history) {
//       // _game.value.playUnchecked(Move(to: Square.fromName(move)));
//     }
//     // _game.value.reset();
//     _updateGameState();
//   }

//   void navigateBack() {
//     undoMove();
//   }

//   void navigateForward() {
//     // This requires storing the full move objects, not just SAN strings.
//     // For simplicity, we'll leave this unimplemented, but you'd store and replay moves.
//     print("Navigate Forward: Not implemented in this simple example.");
//   }

//   void navigateToEnd() {
//     // Reload the game to the last state
//     final history = List<String>.from(moveHistory);
//     // _game.value.reset();
//     for (final move in history) {
//       // _game.value.move(move);
//     }
//     _updateGameState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       _engineRepository.stopAnalysis();
//     }
//     if (state == AppLifecycleState.resumed) {
//       startAnalysis();
//     }
//   }

//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _evaluationSubscription?.cancel();
//     _engineRepository.dispose();
//     super.onClose();
//   }
// }
