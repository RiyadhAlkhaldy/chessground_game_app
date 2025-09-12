import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/data/engine/engine.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../core/board_theme.dart';
import 'side_choosing_controller.dart';

String pieceShiftMethodLabel(PieceShiftMethod method) {
  switch (method) {
    case PieceShiftMethod.drag:
      return 'Drag';
    case PieceShiftMethod.tapTwoSquares:
      return 'Tap two squares';
    case PieceShiftMethod.either:
      return 'Either';
  }
}

enum Mode { botPlay, freePlay }

class GameComputerController extends _ChessController
    with WidgetsBindingObserver {
  final SideChoosingController sideChoosingController;

  BasicSearch basicSearch = BasicSearch();
  Rx<Side> orientation = Side.white.obs;
  NormalMove? lastMove;
  NormalMove? promotionMove;
  Rx<NormalMove?> premove = null.obs;
  Side sideToMove = Side.white;
  Rx<PieceSet> pieceSet = PieceSet.gioco.obs;
  Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;
  Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;
  Rx<BoardTheme> boardTheme = BoardTheme.brown.obs;
  bool drawMode = true;
  RxBool pieceAnimation = true.obs;
  RxBool dragMagnify = true.obs;
  Position? lastPos;
  Rx<ISet<Shape>> shapes = ISet<Shape>().obs;
  RxBool showBorder = false.obs;
  // AI settings
  bool aiEnabled = true;
  int aiDepth = 10;
  int aiSkill = 20; // optional skill level
  Side humanSide = Side.white;
  final Rx<StockfishState> stockfishState = StockfishState.disposed.obs;
  //
  // thinking flag
  final RxBool isThinking = false.obs;
  GameComputerController(this.sideChoosingController);
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    engineService.start().then((_) {
      engineService.setPosition(fen: fen);
      stockfishState.value = StockfishState.ready;
    });
    engineService.evaluations.listen((ev) {
      debugPrint('EVAL -> $ev');
    });
    debugPrint(position.value.fen);
    debugPrint(_fen);
    validMoves = makeLegalMoves(position.value);
    aiDepth = sideChoosingController.aiDepth.value;
    humanSide = sideChoosingController.choseColor.value == SideChoosing.white
        ? Side.white
        : Side.black;
    // ever(position, (_) {
    //   _handleAiTurn();
    // });
  }

  // Future<void> _handleAiTurn() async {
  //   if (position.value.turn != humanSide) {
  //     statusText.value = "AI is thinking...";
  //     playAiMove();
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      engineService.stopStockfish();
    }
  }

  void _startStockfishIfNecessary() {
    engineService.startStockfishIfNecessary
        ? update([
            engineService.start().then((_) {
              stockfishState.value = StockfishState.ready;
            }),
          ])
        : null;
  }

  @override
  void dispose() {
    engineService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///reset
  void reset() {
    past.clear();
    future.clear();
    undoEnabled = false;
    redoEnabled = false;
    position.value = Chess.initial;
    _fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    lastMove = null;
    lastPos = null;
    _moves.clear();
    engineService.ucinewgame();
    promotionMove = null;
    debugPrint('reset to $_fen');
  }

  // void tryPlayPremove() {
  //   Timer.run(() {
  //     playMove(premove.value!, isPremove: true);
  //   });
  // }

  void onCompleteShape(Shape shape) {
    if (shapes.value.any((element) => element == shape)) {
      shapes.value = shapes.value.remove(shape);

      return;
    } else {
      shapes.value = shapes.value.add(shape);
    }
  }

  void onSetPremove(NormalMove? move) {
    premove.value = move!;
  }

  void onPromotionSelection(Role? role) {
    debugPrint('onPromotionSelection: $role');
    if (role == null) {
      onPromotionCancel();
    } else {
      playMove(promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove = null;
  }

  Future<String> _playerMove(String uciMove, {int aiMoveTimeMs = 1000}) async {
    final moveObj = _uciToMoveObject(uciMove);
    final legalMoves = position.value.legalMoves;

    // if (!legalMoves.contains(moveObj)) {
    //   throw Exception('Illegal move: $uciMove');
    // }

    position.value = position.value.play(moveObj);
    _moves.add(uciMove);
    engineService.setPosition(moves: _moves);

    final best = await engineService.goMovetime(aiMoveTimeMs);

    final aiMoveObj = _uciToMoveObject(best);
    // if (!position.value.legalMoves.contains(aiMoveObj)) {
    //   throw Exception('Engine returned illegal move: $best');
    // }

    position.value = position.value.play(aiMoveObj);
    _moves.add(best);
    engineService.setPosition(moves: _moves);

    return best;
  }

  Move _uciToMoveObject(String uci) {
    final fromSq = Square.fromName(uci.substring(0, 2));
    final toSq = Square.fromName(uci.substring(2, 4));
    final promo = uci.length == 5 ? Piece.fromChar(uci[4]) : null;
    return NormalMove(from: fromSq, to: toSq, promotion: promo!.role);
  }

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    undoEnabled = false;
    redoEnabled = false;
    lastPos = position.value;

    if (isPromotionPawnMove(move)) {
      promotionMove = move;
      update();
    } else if (position.value.isLegal(move)) {
      past.add(position.value);
      future.clear();
      position.value = position.value.playUnchecked(move);
      lastMove = move;
      _fen = position.value.fen;
      validMoves = makeLegalMoves(position.value);

      promotionMove = null;
      if (isPremove == true) {
        premove.value = null;
      }
      updateTextState();
    }
    _moves.add(move.uci);
    engineService.setPosition(moves: _moves);
    playAiMove();
  }

  Future<void> playAiMove() async {
    final random = Random();
    await Future.delayed(Duration(milliseconds: 100));
    if (position.value.isGameOver) return;
    final best = await engineService.goMovetime(1300);
    debugPrint("best move from stockfish: $best");

    var bestMove = NormalMove.fromUci(best);
    if (position.value.isLegal(bestMove) == false) return;

    if (isPromotionPawnMove(bestMove)) {
      final potentialRoles = Role.values
          .where((role) => role != Role.pawn)
          .toList();
      final role = potentialRoles[random.nextInt(potentialRoles.length)];
      bestMove = bestMove.withPromotion(role);
    }

    position.value = position.value.playUnchecked(bestMove);

    lastMove = bestMove;
    _fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    _moves.add(best);
    engineService.setPosition(moves: _moves);

    lastPos = position.value;
    undoEnabled = true;
    update();

    updateTextState();
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.value.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.value.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.value.turn == Side.white));
  }

  void showChoicesPicker<T extends Enum>(
    BuildContext context, {
    required List<T> choices,
    required T selectedItem,
    required Widget Function(T choice) labelBuilder,
    required void Function(T choice) onSelectedItemChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 12),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: choices
                .map((value) {
                  return RadioListTile<T>(
                    title: labelBuilder(value),
                    value: value,
                    groupValue: selectedItem,
                    onChanged: (value) {
                      if (value != null) onSelectedItemChanged(value);
                      Navigator.of(context).pop();
                    },
                  );
                })
                .toList(growable: false),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  RxString statusText = "AI chess".obs;
  void updateTextState() {
    if (position.value.isCheckmate) {
      statusText.value = ' - كش موت!';
      switch (position.value.outcome) {
        case Outcome.blackWins:
          statusText.value += ' الفائز: لأسود';
          break;
        case Outcome.whiteWins:
          statusText.value += ' الفائز: لابيض';
          break;
        case Outcome.draw:
          statusText.value = ' - تعادل!';
          break;
      }
      return;
    } else if (position.value.isCheck) {
      statusText.value = '(كش)';
      return;
    } else if (position.value.isInsufficientMaterial) {
      statusText.value = "لا يمكن إنهاء اللعبة";
      return;
    } else if (position.value.isStalemate) {
      statusText.value = ' - طريق مسدود!';
      return;
    } else if (position.value.isGameOver) {
      statusText.value = ' - انتهت اللعبة';
      switch (position.value.outcome) {
        case Outcome.blackWins:
          statusText.value += ' الفائز: لأسود';
          break;
        case Outcome.whiteWins:
          statusText.value += ' الفائز: لابيض';
          break;
        case Outcome.draw:
          statusText.value += ' - تعادل!';
          break;
      }
      return;
    } else if (position.value.turn == Side.white) {
      statusText.value = "دور الأبيض";
      return;
    } else if (position.value.turn == Side.black) {
      statusText.value = "دور الأسود";
      return;
    } else if (position.value.isVariantEnd) {
      statusText.value = ' - انتهت اللعبة';
      return;
    }
  }

  EngineService engineService = EngineService();
  final List<String> _moves = [];
}

abstract class _ChessController extends GetxController {
  // Rx<Position> position = Chess.initial.obs;
  late Rx<Position> position = Chess.fromSetup(Setup.parseFen(fen)).obs;
  // String fen = kInitialFEN;
  String _fen =
      'r1bqkbnr/pppp1ppp/2n5/4p3/3P4/2N5/PPP2PPP/R1BQKBNR w KQkq - 0 4';
  String get fen => _fen;
  // 'rnbqkbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 3';
  ValidMoves validMoves = IMap(const {});

  /// undo/redo
  bool _undoEnabled = false;
  bool _redoEnabled = false;
  set undoEnabled(bool value) {
    if (past.isEmpty) {
      _undoEnabled = false;
      update();
      return;
    }
    _undoEnabled = value;
    update();
  }

  set redoEnabled(bool value) {
    if (future.isEmpty) {
      _redoEnabled = false;
      update();
      return;
    }
    _redoEnabled = value;
    update();
  }

  bool get undoEnabled {
    if (past.isEmpty) {
      _undoEnabled = false;
      return false;
    }
    return _undoEnabled;
  }

  bool get redoEnabled {
    if (future.isEmpty) {
      _redoEnabled = false;
      return false;
    }
    return _redoEnabled;
  }

  final past = <Position>[];
  final future = <Position>[];

  bool get isCheckmate => position.value.isCheckmate;

  Side? get winner {
    return position.value.outcome!.winner;
  }

  void undo() {
    if (past.isEmpty) return;
    debugPrint('undo');
    future.add(position.value);
    redoEnabled = true;
    position.value = past.removeLast();
    _fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
  }

  void redo() {
    if (future.isEmpty) return;
    past.add(position.value);
    redoEnabled = true;
    undoEnabled = true;
    position.value = future.removeLast();
    _fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
  }
}

/// طبقة البيانات: تغليف مباشر لمحرّك Stockfish عبر الحزمة stockfish_chess_engine
class EngineService {
  late Stockfish _stockfish;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final StreamController<String> _raw = StreamController.broadcast();
  final StreamController<Evaluation> _eval = StreamController.broadcast();
  final StreamController<String> _bestmove = StreamController.broadcast();

  Stream<String> get raw => _raw.stream;
  Stream<Evaluation> get evaluations => _eval.stream;
  Stream<String> get bestmoves => _bestmove.stream;

  Future<void> start({
    Duration waitBeforeUci = const Duration(milliseconds: 1500),
  }) async {
    _stockfish = Stockfish();

    _stdoutSub = _stockfish.stdout.listen((line) {
      debugPrint('###stdout line $line ###');

      _raw.add(line);
      _handleLine(line);
    });

    _stderrSub = _stockfish.stderr.listen((err) {
      // debugPrint('*** stderr line $err ***');

      _raw.add('ERR: $err');
    });

    await Future.delayed(waitBeforeUci);

    _stockfish.stdin = 'uci';
    debugPrint(' befor _waitFor...');
    await _waitFor((l) => l.contains('uciok'), Duration(seconds: 2));

    await isReady();
  }

  bool get startStockfishIfNecessary {
    if (_stockfish.state.value == StockfishState.ready ||
        _stockfish.state.value == StockfishState.starting) {
      return false;
    }
    return true;
  }

  Future<void> _waitFor(
    bool Function(String) predicate,
    Duration timeout,
  ) async {
    debugPrint(' _waitFor...');
    await raw.firstWhere(predicate).timeout(timeout);
  }

  Future<void> isReady() async {
    _stockfish.stdin = 'isready';
    await _waitFor((l) => l.contains('readyok'), Duration(seconds: 1));
  }

  Future<void> ucinewgame() async {
    _stockfish.stdin = 'ucinewgame';
    await isReady();
  }

  void setPosition({String? fen, List<String>? moves}) {
    var cmd = fen != null ? 'position fen $fen' : 'position startpos';
    if (moves != null && moves.isNotEmpty) cmd += ' moves ${moves.join(' ')}';
    debugPrint("cccmd $cmd cccmd");
    _stockfish.stdin = cmd;
    // _stockfish.stdin = 'd';
  }

  Future<String> goDepth(
    int depth, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    _stockfish.stdin = 'go depth $depth';
    final line = await raw
        .firstWhere((l) => l.startsWith('bestmove'))
        .timeout(timeout);
    return _parseBestmove(line);
  }

  Future<String> goMovetime(
    int ms, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    _stockfish.stdin = 'go movetime $ms';
    final line = await raw
        .firstWhere((l) => l.startsWith('bestmove'))
        .timeout(timeout);
    return _parseBestmove(line);
  }

  Future<void> stop() async {
    _stockfish.stdin = 'stop';
  }

  Future<void> stopStockfish() async {
    if (_stockfish.state.value == StockfishState.disposed ||
        _stockfish.state.value == StockfishState.error) {
      return;
    }
    _stderrSub?.cancel();
    _stdoutSub?.cancel();
    _stockfish.dispose();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (Get.context!.mounted) return;
  }

  String _parseBestmove(String line) {
    final parts = line.split(RegExp(r"\s+"));
    if (parts.length >= 2) {
      final bm = parts[1].trim();
      _bestmove.add(bm);
      return bm;
    }
    return '';
  }

  void _handleLine(String line) {
    debugPrint('_handleLine: $line');

    if (line.startsWith('info')) {
      final eval = _parseInfoLine(line);
      if (eval != null) _eval.add(eval);
    } else if (line.startsWith('bestmove')) {
      _parseBestmove(line);
    }
  }

  Evaluation? _parseInfoLine(String line) {
    try {
      final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
      final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;

      final cpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);
      final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);

      final pvMatch = RegExp(r'pv\s+(.+)\$').firstMatch(line);
      final pv = pvMatch != null ? pvMatch.group(1)!.trim() : '';

      if (cpMatch != null) {
        final cp = int.parse(cpMatch.group(1)!);
        return Evaluation(depth: depth, cp: cp, pv: pv);
      }
      if (mateMatch != null) {
        final mate = int.parse(mateMatch.group(1)!);
        return Evaluation(depth: depth, mate: mate, pv: pv);
      }
      return Evaluation(depth: depth, pv: pv);
    } catch (e) {
      debugPrint("error _parseInfoLine $e");
      return null;
    }
  }

  Future<void> dispose() async {
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    try {
      _stockfish.stdin = 'quit';
    } catch (e) {
      debugPrint("error dispose $e");
    }
    try {
      _stockfish.dispose();
    } catch (e) {
      debugPrint("error dispose $e");
    }
    await _raw.close();
    await _eval.close();
    await _bestmove.close();
  }
}

/// كائن يعرض نتيجة تقييم من Stockfish (مقتطف من سطر "info ...")
class Evaluation {
  final int depth;
  final int? cp; // centipawns
  final int? mate; // mate in N (positive or negative)
  final String pv; // principal variation (أفضل خط)

  Evaluation({required this.depth, this.cp, this.mate, this.pv = ''});

  @override
  String toString() {
    if (mate != null) return 'depth:$depth mate:$mate pv:$pv';
    if (cp != null) return 'depth:$depth cp:$cp pv:$pv';
    return 'depth:$depth pv:$pv';
  }
}

/// حالة اللعبة المستخلصة محليًا (نستخدم dartchess للتحقق)
enum GameResult { ongoing, checkmate, stalemate, draw }
