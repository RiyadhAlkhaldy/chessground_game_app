import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/data/engine/engine.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/board_theme.dart';
import '../../data/engine/alphabeta.dart';
import '../../data/engine/eval.dart';
import '../../data/engine/minimax.dart';
import '../../data/engine/search.dart';
import '../../data/usecases/get_ai_move.dart';

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

class GameComputerController extends ChessController {
  final eval = Evaluator();
  final mm = MiniMax(Evaluator());
  final ab = AlphaBeta(Evaluator());
  final eng = SearchEngine(eval: Evaluator());
  final GetAiMove getAiMove;
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
  GameComputerController(this.getAiMove);

  /// undo
  // void undo() {
  //   if (lastPos != null) {
  //     position.value = lastPos!;
  //     fen = position.value.fen;
  //     validMoves = makeLegalMoves(position.value);
  //     lastPos = null;
  //   }
  // }

  ///reset
  void reset() {
    past.clear();
    future.clear();
    undoEnabled = false;
    redoEnabled = false;
    position.value = Chess.initial;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    lastMove = null;
    lastPos = null;
    debugPrint('reset to $fen');
    promotionMove = null;
  }

  void tryPlayPremove() {
    Timer.run(() {
      playMove(premove.value!, isPremove: true);
    });
  }

  void onCompleteShape(Shape shape) {
    if (shapes.value.any((element) => element == shape)) {
      shapes.value = shapes.value.remove(shape);

      return;
    } else {
      shapes.value = shapes.value.add(shape);
    }
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

  @override
  void onInit() {
    super.onInit();
    validMoves = makeLegalMoves(position.value);
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

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    undoEnabled = false;
    lastPos = position.value;

    if (isPromotionPawnMove(move)) {
      promotionMove = move;
      update();
    } else if (position.value.isLegal(move)) {
      past.add(position.value);
      future.clear();
      position.value = position.value.playUnchecked(move);
      lastMove = move;
      fen = position.value.fen;
      validMoves = makeLegalMoves(position.value);
      promotionMove = null;
      if (isPremove == true) {
        premove.value = null;
      }
      playBlackMove();
    }
  }

  Future<void> playBlackMove() async {
    await Future.delayed(const Duration(milliseconds: 100)).then((value) {});
    if (position.value.isGameOver) return;
    final r3 = await getAiMove.execute(position.value, 5);
    final random = Random();
    await Future.delayed(Duration(milliseconds: random.nextInt(1000) + 500));
    // final allMoves = [
    //   for (final entry in position.value.legalMoves.entries)
    //     for (final dest in entry.value.squares)
    //       NormalMove(from: entry.key, to: dest),
    // ];
    // if (allMoves.isNotEmpty) {
    // NormalMove mv = (allMoves..shuffle()).first;
    // Auto promote to a random non-pawn role
    var best = r3!.best;
    if (best == null) return;
    var mv = NormalMove.fromUci(best.uci);
    if (isPromotionPawnMove(mv)) {
      final potentialRoles = Role.values
          .where((role) => role != Role.pawn)
          .toList();
      final role = potentialRoles[random.nextInt(potentialRoles.length)];
      mv = mv.withPromotion(role);
    }
    // past.add(position.value);
    // future.clear();
    position.value = position.value.playUnchecked(mv);
    lastMove = NormalMove(from: mv.from, to: mv.to, promotion: mv.promotion);
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    lastPos = position.value;
    undoEnabled = true;
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.value.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.value.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.value.turn == Side.white));
  }
}

abstract class ChessController extends GetxController {
  Rx<Position> position = Chess.initial.obs;
  ValidMoves validMoves = IMap(const {});
  String fen = kInitialBoardFEN;

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

  // void apply(NormalMove m) {
  //   final c = position.value;
  //   if (c.isLegal(m)) {
  //     past.add(c);
  //     future.clear();
  //     position.value = c.playUnchecked(m);
  //   }
  // }

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
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
  }

  void redo() {
    if (future.isEmpty) return;
    past.add(position.value);
    redoEnabled = true;
    position.value = future.removeLast();
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
  }
}
