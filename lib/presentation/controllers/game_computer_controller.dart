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

class GameComputerController extends GetxController {
  final eval = Evaluator();
  final mm = MiniMax(Evaluator());
  final ab = AlphaBeta(Evaluator());
  final eng = SearchEngine(eval: Evaluator());
  final GetAiMove getAiMove;
  BasicSearch basicSearch = BasicSearch();
  Rx<Position> position = Chess.initial.obs;
  Rx<Side> orientation = Side.white.obs;
  String fen = kInitialBoardFEN;
  NormalMove? lastMove;
  NormalMove? promotionMove;
  NormalMove? premove;
  ValidMoves validMoves = IMap(const {});
  Side sideToMove = Side.white;
  Rx<PieceSet> pieceSet = PieceSet.gioco.obs;
  Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;
  Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;
  Rx<BoardTheme> boardTheme = BoardTheme.brown.obs;
  bool drawMode = true;
  RxBool pieceAnimation = true.obs;
  RxBool dragMagnify = true.obs;
  Mode playMode = Mode.botPlay;
  Position? lastPos;
  ISet<Shape> shapes = ISet();
  RxBool showBorder = false.obs;
  GameComputerController(this.getAiMove);

  /// undo
  void undo() {
    if (lastPos != null) {
      position.value = lastPos!;
      fen = position.value.fen;
      validMoves = makeLegalMoves(position.value);
      lastPos = null;
      update();
    }
  }

  ///reset
  void reset() {
    position.value = Chess.initial;
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);
    lastMove = null;
    lastPos = null;
  }

  void tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        playMove(premove!, isPremove: true);
      });
    }
  }

  void onCompleteShape(Shape shape) {
    if (shapes.any((element) => element == shape)) {
      // setState(() {
      shapes = shapes.remove(shape);
      // });
      return;
    } else {
      // setState(() {
      shapes = shapes.add(shape);
      // });
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
    // setState(() {
    premove = move;
    // });
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove != null) {
      if (playMode == Mode.botPlay) {
        // basicSearch.bestMove(position.value);
        onUserMoveAgainstBot(promotionMove!.withPromotion(role));
      } else {
        playMove(promotionMove!.withPromotion(role));
      }
    }
  }

  void onPromotionCancel() {
    // setState(() {
    promotionMove = null;
    // });
  }

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    lastPos = position.value;
    if (isPromotionPawnMove(move)) {
      // setState(() {
      promotionMove = move;
      // });
    } else if (position.value.isLegal(move)) {
      // setState(() {
      position.value = position.value.playUnchecked(move);
      lastMove = move;
      fen = position.value.fen;
      validMoves = makeLegalMoves(position.value);
      promotionMove = null;
      if (isPremove == true) {
        premove = null;
      }
      // });
    }
  }

  void onUserMoveAgainstBot(NormalMove move, {isDrop}) async {
    lastPos = position.value;
    if (isPromotionPawnMove(move)) {
      // setState(() {
      promotionMove = move;
      // });
    } else {
      // setState(() {
      position.value = position.value.playUnchecked(move);
      lastMove = move;
      fen = position.value.fen;
      validMoves = IMap(const {});
      promotionMove = null;
      // });
      await playBlackMove();
      // tryPlayPremove();
    }
  }

  Future<void> playBlackMove() async {
    // position.value = position.value.copyWith(
    //   board: position.value.board.copyWith(),
    // );
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
    // if (isPromotionPawnMove(mv)) {
    //   final potentialRoles = Role.values
    //       .where((role) => role != Role.pawn)
    //       .toList();
    //   final role = potentialRoles[random.nextInt(potentialRoles.length)];
    //   mv = mv.withPromotion(role);
    // }
    var best = r3!.best;
    if (best == null) return;
    var mv = NormalMove.fromUci(best.uci);
    position.value = position.value.playUnchecked(mv);
    lastMove = NormalMove(from: mv.from, to: mv.to, promotion: mv.promotion);
    fen = position.value.fen;
    validMoves = makeLegalMoves(position.value);

    lastPos = position.value;
    // }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.value.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.value.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.value.turn == Side.white));
  }
}
