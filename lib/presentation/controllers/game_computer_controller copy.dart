// import 'dart:async';
// import 'dart:math';

// import 'package:chessground/chessground.dart';
// import 'package:chessground_game_app/data/engine/engine.dart';
// import 'package:dartchess/dartchess.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
// import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

// import '../../core/board_theme.dart';
// import '../../core/const.dart';
// import 'side_choosing_controller.dart';

// String pieceShiftMethodLabel(PieceShiftMethod method) {
//   switch (method) {
//     case PieceShiftMethod.drag:
//       return 'Drag';
//     case PieceShiftMethod.tapTwoSquares:
//       return 'Tap two squares';
//     case PieceShiftMethod.either:
//       return 'Either';
//   }
// }

// enum Mode { botPlay, freePlay }

// class GameComputerController extends _ChessController
//     with WidgetsBindingObserver {
//   final SideChoosingController sideChoosingController;
//   // final StartEngineUseCase startEngine;
//   // final GetAiMoveStockfishUseCase getAibestMove;
//   // final StopEngineUseCase stopEngine;
//   // final SetEngineUseCase setEngine;
//   // final GetStateStockfishUseCase getStateStockfish;
//   // final MakeMoveStockfishUseCase makeMoveStockfish;
//   // final GetBestMoveUseCase getBestMoveUseCase;

//   BasicSearch basicSearch = BasicSearch();
//   Rx<Side> orientation = Side.white.obs;
//   NormalMove? lastMove;
//   NormalMove? promotionMove;
//   Rx<NormalMove?> premove = null.obs;
//   Side sideToMove = Side.white;
//   Rx<PieceSet> pieceSet = PieceSet.gioco.obs;
//   Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;
//   Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;
//   Rx<BoardTheme> boardTheme = BoardTheme.brown.obs;
//   bool drawMode = true;
//   RxBool pieceAnimation = true.obs;
//   RxBool dragMagnify = true.obs;
//   Position? lastPos;
//   Rx<ISet<Shape>> shapes = ISet<Shape>().obs;
//   RxBool showBorder = false.obs;
//   // AI settings
//   bool aiEnabled = true;
//   int aiDepth = 10;
//   int aiSkill = 20; // optional skill level
//   Side humanSide = Side.white;
//   final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
//   //
//   // thinking flag
//   final RxBool isThinking = false.obs;
//   GameComputerController(
//     this.sideChoosingController,
//     // this.startEngine,
//     // this.getAibestMove,
//     // this.stopEngine,
//     // this.setEngine,
//     // this.getStateStockfish,
//     // this.makeMoveStockfish,
//     // this.getBestMoveUseCase,
//   );
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     startEngine().then((_) {});
//     // startEngine.call().then((value) {
//     //   stockfishState.value = getStateStockfish.getState();
//     // });
//     validMoves = makeLegalMoves(position.value);
//     aiDepth = sideChoosingController.aiDepth.value;
//     humanSide = sideChoosingController.choseColor.value == SideChoosing.white
//         ? Side.white
//         : Side.black;
//     // ever(position, (_) {
//     //   _handleAiTurn();
//     // });
//   }

//   // Future<void> _handleAiTurn() async {
//   //   if (position.value.turn != humanSide) {
//   //     statusText.value = "AI is thinking...";
//   //     playAiMove();
//   //   }
//   // }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed) {
//       startEngine().then((_) {});
//       // startEngine.startStockfishIfNecessary().then((_) {});
//     } else if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       stopStockfish(Get.context!).then((_) {});
//       // stopEngine.call(Get.context!).then((_) {});
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     stopStockfish.call(Get.context!).then((_) {});
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   ///reset
//   void reset() {
//     past.clear();
//     future.clear();
//     undoEnabled = false;
//     redoEnabled = false;
//     position.value = Chess.initial;
//     fen = position.value.fen;
//     validMoves = makeLegalMoves(position.value);
//     lastMove = null;
//     lastPos = null;
//     debugPrint('reset to $fen');
//     stockfish.stdin = 'position startpos';
//     stockfish.stdin = 'ucinewgame';
//     stockfish.stdin = 'd';
//     moves = '';
//     promotionMove = null;
//   }

//   // void tryPlayPremove() {
//   //   Timer.run(() {
//   //     playMove(premove.value!, isPremove: true);
//   //   });
//   // }

//   void onCompleteShape(Shape shape) {
//     if (shapes.value.any((element) => element == shape)) {
//       shapes.value = shapes.value.remove(shape);

//       return;
//     } else {
//       shapes.value = shapes.value.add(shape);
//     }
//   }

//   void onSetPremove(NormalMove? move) {
//     premove.value = move!;
//   }

//   void onPromotionSelection(Role? role) {
//     debugPrint('onPromotionSelection: $role');
//     if (role == null) {
//       onPromotionCancel();
//     } else {
//       playMove(promotionMove!.withPromotion(role));
//     }
//   }

//   void onPromotionCancel() {
//     promotionMove = null;
//   }

//   void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
//     undoEnabled = false;
//     redoEnabled = false;
//     lastPos = position.value;

//     if (isPromotionPawnMove(move)) {
//       promotionMove = move;
//       // update();
//     } else if (position.value.isLegal(move)) {
//       past.add(position.value);
//       future.clear();
//       position.value = position.value.playUnchecked(move);
//       lastMove = move;
//       fen = position.value.fen;
//       validMoves = makeLegalMoves(position.value);
//       stockfishmakeMove(move.uci);
//       promotionMove = null;
//       if (isPremove == true) {
//         premove.value = null;
//       }
//       if (validMoves.isEmpty) {
//         updateTextState();
//       }
//     }
//     playAiMove();
//   }

//   Future<void> playAiMove() async {
//     final random = Random();
//     await Future.delayed(Duration(milliseconds: 100));
//     if (position.value.isGameOver) return;
//     debugPrint("best move from stockfish: $_nextMove");
//     if (_nextMove == '0000' || _nextMove.isEmpty) {
//       return;
//     }
//     await computeNextMove();
//     var bestMove = NormalMove.fromUci(_nextMove);
//     if (position.value.isLegal(bestMove) == false) return;

//     if (isPromotionPawnMove(bestMove)) {
//       final potentialRoles = Role.values
//           .where((role) => role != Role.pawn)
//           .toList();
//       final role = potentialRoles[random.nextInt(potentialRoles.length)];
//       bestMove = bestMove.withPromotion(role);
//     }

//     position.value = position.value.playUnchecked(bestMove);

//     lastMove = bestMove;
//     fen = position.value.fen;
//     validMoves = makeLegalMoves(position.value);
//     moves += " ${bestMove.uci}";
//     stockfishmakeMove(bestMove.uci);

//     lastPos = position.value;
//     undoEnabled = true;
//     _nextMove = '';
//     // update();

//     updateTextState();
//   }

//   bool isPromotionPawnMove(NormalMove move) {
//     return move.promotion == null &&
//         position.value.board.roleAt(move.from) == Role.pawn &&
//         ((move.to.rank == Rank.first && position.value.turn == Side.black) ||
//             (move.to.rank == Rank.eighth && position.value.turn == Side.white));
//   }

//   void showChoicesPicker<T extends Enum>(
//     BuildContext context, {
//     required List<T> choices,
//     required T selectedItem,
//     required Widget Function(T choice) labelBuilder,
//     required void Function(T choice) onSelectedItemChanged,
//   }) {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.only(top: 12),
//           scrollable: true,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: choices
//                 .map((value) {
//                   return RadioListTile<T>(
//                     title: labelBuilder(value),
//                     value: value,
//                     groupValue: selectedItem,
//                     onChanged: (value) {
//                       if (value != null) onSelectedItemChanged(value);
//                       Navigator.of(context).pop();
//                     },
//                   );
//                 })
//                 .toList(growable: false),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   RxString statusText = "AI chess".obs;
//   void updateTextState() {
//     if (position.value.isCheckmate) {
//       statusText.value = ' - كش موت!';
//       switch (position.value.outcome) {
//         case Outcome.blackWins:
//           statusText.value += ' الفائز: لأسود';
//           break;
//         case Outcome.whiteWins:
//           statusText.value += ' الفائز: لابيض';
//           break;
//         case Outcome.draw:
//           statusText.value = ' - تعادل!';
//           break;
//       }
//       return;
//     } else if (position.value.isCheck) {
//       statusText.value = '(كش)';
//       return;
//     } else if (position.value.isInsufficientMaterial) {
//       statusText.value = "لا يمكن إنهاء اللعبة";
//       return;
//     } else if (position.value.isStalemate) {
//       statusText.value = ' - طريق مسدود!';
//       return;
//     } else if (position.value.isGameOver) {
//       statusText.value = ' - انتهت اللعبة';
//       switch (position.value.outcome) {
//         case Outcome.blackWins:
//           statusText.value += ' الفائز: لأسود';
//           break;
//         case Outcome.whiteWins:
//           statusText.value += ' الفائز: لابيض';
//           break;
//         case Outcome.draw:
//           statusText.value += ' - تعادل!';
//           break;
//       }
//       return;
//     } else if (position.value.turn == Side.white) {
//       statusText.value = "دور الأبيض";
//       return;
//     } else if (position.value.turn == Side.black) {
//       statusText.value = "دور الأسود";
//       return;
//     } else if (position.value.isVariantEnd) {
//       statusText.value = ' - انتهت اللعبة';
//       return;
//     }
//   }

//   // }
//   // class StockfishRepositoryImpl {
//   late Stockfish stockfish;
//   late StreamSubscription stockfishOutputSubsciption;
//   late StreamSubscription stockfishErrorSubsciption;
//   int timeMs = defaultThinkingTimeMs;
//   String _nextMove = '';
//   String stockfishOutputText = '';
//   String moves = '';
//   void readStockfishOutput(String output) {
//     debugPrint('output $output');
//     // At least now, stockfish is ready : update UI.
//     stockfishOutputText += "$output\n";
//     if (output.startsWith('readyok')) {
//       stockfishState.value = StockfishState.ready;
//       // } else if (output.startsWith('uciok')) {
//       //   stockfishState.value = StockfishState.starting;
//     } else if (output.startsWith('info')) {
//       isThinking.value = true;
//     } else if (output.startsWith('bestmove')) {
//       final parts = output.split(' ');
//       _nextMove = parts[1];
//       isThinking.value = false;
//     }
//   }

//   void readStockfishError(String error) {
//     // At least now, stockfish is ready : update UI.
//     debugPrint("@@@$error@@@");
//   }

//   void updateThinkingTime(int newValue) {
//     timeMs = newValue;
//   }

//   Future<void> computeNextMove() async {
//     // if (!isStrictlyValidFEN(fen)) {
//     //   final message = "Illegal position: '$fen' !\n";
//     //   stockfishOutputText = message;
//     //   return;
//     // }
//     stockfishOutputText = '';
//     // stockfish.stdin = 'position fen $fen';
//     stockfish.stdin = 'go movetime $timeMs';
//     await Future.delayed(Duration(milliseconds: timeMs + 100));
//   }

//   Future<void> stopStockfish(BuildContext context) async {
//     stockfish.stdin = 'stop';
//     if (stockfish.state.value == StockfishState.disposed ||
//         stockfish.state.value == StockfishState.error) {
//       return;
//     }
//     stockfishErrorSubsciption.cancel();
//     stockfishOutputSubsciption.cancel();
//     stockfish.dispose();
//     // await Future.delayed(const Duration(milliseconds: 1200));
//     // if (!context.mounted) return;
//   }

//   Future<void> startEngine() async {
//     debugPrint("_doStartStockfish");
//     stockfish = Stockfish();
//     stockfishOutputSubsciption = stockfish.stdout.listen(readStockfishOutput);
//     stockfishOutputText = '';

//     stockfishErrorSubsciption = stockfish.stderr.listen(readStockfishError);
//     await Future.delayed(const Duration(milliseconds: 1500));
//     stockfish.stdin = 'uci';
//     await Future.delayed(const Duration(milliseconds: 2000));
//     stockfish.stdin = 'isready';
//     await Future.delayed(const Duration(milliseconds: 100));
//     stockfish.stdin = 'ucinewgame';
//     debugPrint("isready _doStartStockfish");
//   }

//   Future<void> startStockfishIfNecessary() async {
//     if (stockfish.state.value == StockfishState.ready ||
//         stockfish.state.value == StockfishState.starting) {
//       debugPrint("startStockfishIfNecessary");
//       return;
//     }
//     await startEngine();
//   }

//   Stream<String> outputStream() {
//     return stockfish.stdout;
//   }

//   void setPositionFen(String fen) {
//     stockfish.stdin = 'position fen $fen';
//   }

//   void stockfishmakeMove(String move) {
//     moves += " $move";
//     debugPrint(moves);
//     stockfish.stdin = 'position startpos move $moves';
//     // stockfish.stdin = 'd';
//   }

//   void stockfishmakeMoves(String moves) {
//     debugPrint(moves);
//     this.moves += " $moves";
//     stockfish.stdin = 'position startpos moves ${this.moves}';
//   }
// }

// abstract class _ChessController extends GetxController {
//   Rx<Position> position = Chess.initial.obs;
//   ValidMoves validMoves = IMap(const {});
//   String fen = kInitialFEN;

//   /// undo/redo
//   bool _undoEnabled = false;
//   bool _redoEnabled = false;
//   set undoEnabled(bool value) {
//     if (past.isEmpty) {
//       _undoEnabled = false;
//       update();
//       return;
//     }
//     _undoEnabled = value;
//     update();
//   }

//   set redoEnabled(bool value) {
//     if (future.isEmpty) {
//       _redoEnabled = false;
//       update();
//       return;
//     }
//     _redoEnabled = value;
//     update();
//   }

//   bool get undoEnabled {
//     if (past.isEmpty) {
//       _undoEnabled = false;
//       return false;
//     }
//     return _undoEnabled;
//   }

//   bool get redoEnabled {
//     if (future.isEmpty) {
//       _redoEnabled = false;
//       return false;
//     }
//     return _redoEnabled;
//   }

//   final past = <Position>[];
//   final future = <Position>[];

//   bool get isCheckmate => position.value.isCheckmate;

//   Side? get winner {
//     return position.value.outcome!.winner;
//   }

//   void undo() {
//     if (past.isEmpty) return;
//     debugPrint('undo');
//     future.add(position.value);
//     redoEnabled = true;
//     position.value = past.removeLast();
//     fen = position.value.fen;
//     validMoves = makeLegalMoves(position.value);
//   }

//   void redo() {
//     if (future.isEmpty) return;
//     past.add(position.value);
//     redoEnabled = true;
//     undoEnabled = true;
//     position.value = future.removeLast();
//     fen = position.value.fen;
//     validMoves = makeLegalMoves(position.value);
//   }
// }

// /// طبقة البيانات: تغليف مباشر لمحرّك Stockfish عبر الحزمة stockfish_chess_engine
// class EngineService {
//   final Stockfish _stockfish = Stockfish();
//   StreamSubscription<String>? _stdoutSub;
//   StreamSubscription<String>? _stderrSub;

//   final StreamController<String> _raw = StreamController.broadcast();
//   final StreamController<Evaluation> _eval = StreamController.broadcast();
//   final StreamController<String> _bestmove = StreamController.broadcast();

//   Stream<String> get raw => _raw.stream;
//   Stream<Evaluation> get evaluations => _eval.stream;
//   Stream<String> get bestmoves => _bestmove.stream;

//   Future<void> start({
//     Duration waitBeforeUci = const Duration(milliseconds: 1500),
//   }) async {
//     // _stockfish = Stockfish();

//     _stdoutSub = _stockfish.stdout.listen((line) {
//       debugPrint('stdout line $line...');

//       _raw.add(line);
//       _handleLine(line);
//     });

//     _stderrSub = _stockfish.stderr.listen((err) {
//       debugPrint('stderr $err...');

//       _raw.add('ERR: $err');
//     });

//     await Future.delayed(waitBeforeUci);

//     _stockfish.stdin = 'uci';
//     debugPrint(' befor _waitFor...');

//     await _waitFor((l) => l.contains('uciok'), Duration(seconds: 5));

//     await isReady();
//   }

//   Future<void> _waitFor(
//     bool Function(String) predicate,
//     Duration timeout,
//   ) async {
//     debugPrint(' _waitFor...');

//     await raw.firstWhere(predicate).timeout(timeout);
//   }

//   Future<void> isReady() async {
//     _stockfish.stdin = 'isready';
//     await _waitFor((l) => l.contains('readyok'), Duration(seconds: 5));
//   }

//   Future<void> ucinewgame() async {
//     _stockfish.stdin = 'ucinewgame';
//     await isReady();
//   }

//   void setPosition({String? fen, List<String>? moves}) {
//     var cmd = fen != null ? 'position fen $fen' : 'position startpos';
//     if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
//     _stockfish.stdin = cmd;
//   }

//   Future<String> goDepth(
//     int depth, {
//     Duration timeout = const Duration(seconds: 30),
//   }) async {
//     _stockfish.stdin = 'go depth $depth';
//     final line = await raw
//         .firstWhere((l) => l.startsWith('bestmove'))
//         .timeout(timeout);
//     return _parseBestmove(line);
//   }

//   Future<String> goMovetime(
//     int ms, {
//     Duration timeout = const Duration(seconds: 30),
//   }) async {
//     _stockfish.stdin = 'go movetime $ms';
//     final line = await raw
//         .firstWhere((l) => l.startsWith('bestmove'))
//         .timeout(timeout);
//     return _parseBestmove(line);
//   }

//   void stop() {
//     _stockfish.stdin = 'stop';
//   }

//   String _parseBestmove(String line) {
//     final parts = line.split(RegExp(r"\s+"));
//     if (parts.length >= 2) {
//       final bm = parts[1].trim();
//       _bestmove.add(bm);
//       return bm;
//     }
//     return '';
//   }

//   void _handleLine(String line) {
//     debugPrint('_handleLine: $line');

//     if (line.startsWith('info')) {
//       final eval = _parseInfoLine(line);
//       if (eval != null) _eval.add(eval);
//     } else if (line.startsWith('bestmove')) {
//       _parseBestmove(line);
//     }
//   }

//   Evaluation? _parseInfoLine(String line) {
//     try {
//       final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
//       final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;

//       final cpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);
//       final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);

//       final pvMatch = RegExp(r'pv\s+(.+)\$').firstMatch(line);
//       final pv = pvMatch != null ? pvMatch.group(1)!.trim() : '';

//       if (cpMatch != null) {
//         final cp = int.parse(cpMatch.group(1)!);
//         return Evaluation(depth: depth, cp: cp, pv: pv);
//       }
//       if (mateMatch != null) {
//         final mate = int.parse(mateMatch.group(1)!);
//         return Evaluation(depth: depth, mate: mate, pv: pv);
//       }
//       return Evaluation(depth: depth, pv: pv);
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> dispose() async {
//     _stdoutSub?.cancel();
//     _stderrSub?.cancel();
//     try {
//       _stockfish.stdin = 'quit';
//     } catch (e) {}
//     try {
//       _stockfish.dispose();
//     } catch (e) {}
//     await _raw.close();
//     await _eval.close();
//     await _bestmove.close();
//   }
// }

// /// كائن يعرض نتيجة تقييم من Stockfish (مقتطف من سطر "info ...")
// class Evaluation {
//   final int depth;
//   final int? cp; // centipawns
//   final int? mate; // mate in N (positive or negative)
//   final String pv; // principal variation (أفضل خط)

//   Evaluation({required this.depth, this.cp, this.mate, this.pv = ''});

//   @override
//   String toString() {
//     if (mate != null) return 'depth:$depth mate:$mate pv:$pv';
//     if (cp != null) return 'depth:$depth cp:$cp pv:$pv';
//     return 'depth:$depth pv:$pv';
//   }
// }

// /// حالة اللعبة المستخلصة محليًا (نستخدم dartchess للتحقق)
// enum GameResult { ongoing, checkmate, stalemate, draw }
