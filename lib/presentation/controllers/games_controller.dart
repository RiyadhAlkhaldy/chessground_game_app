import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/board_theme.dart';

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

enum Mode { botPlay, inputMove, freePlay }

class GamesController extends GetxController {
  Position position = Chess.initial;
  Side orientation = Side.white;
  String fen = kInitialBoardFEN;
  NormalMove? lastMove;
  NormalMove? promotionMove;
  NormalMove? premove;
  ValidMoves validMoves = IMap(const {});
  Side sideToMove = Side.white;
  PieceSet pieceSet = PieceSet.gioco;
  PieceShiftMethod pieceShiftMethod = PieceShiftMethod.either;
  DragTargetKind dragTargetKind = DragTargetKind.circle;
  BoardTheme boardTheme = BoardTheme.brown;
  bool drawMode = true;
  bool pieceAnimation = true;
  bool dragMagnify = true;
  Mode playMode = Mode.botPlay;
  Position? lastPos;
  ISet<Shape> shapes = ISet();
  bool showBorder = false;

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
    validMoves = makeLegalMoves(position);
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
    lastPos = position;
    if (isPromotionPawnMove(move)) {
      // setState(() {
      promotionMove = move;
      // });
    } else if (position.isLegal(move)) {
      // setState(() {
      position = position.playUnchecked(move);
      lastMove = move;
      fen = position.fen;
      validMoves = makeLegalMoves(position);
      promotionMove = null;
      if (isPremove == true) {
        premove = null;
      }
      // });
    }
  }

  void onUserMoveAgainstBot(NormalMove move, {isDrop}) async {
    lastPos = position;
    if (isPromotionPawnMove(move)) {
      // setState(() {
      promotionMove = move;
      // });
    } else {
      // setState(() {
      position = position.playUnchecked(move);
      lastMove = move;
      fen = position.fen;
      validMoves = IMap(const {});
      promotionMove = null;
      // });
      await playBlackMove();
      tryPlayPremove();
    }
  }

  Future<void> playBlackMove() async {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      // setState(() {});
    });
    if (position.isGameOver) return;

    final random = Random();
    await Future.delayed(Duration(milliseconds: random.nextInt(1000) + 500));
    final allMoves = [
      for (final entry in position.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];
    if (allMoves.isNotEmpty) {
      NormalMove mv = (allMoves..shuffle()).first;
      // Auto promote to a random non-pawn role
      if (isPromotionPawnMove(mv)) {
        final potentialRoles = Role.values
            .where((role) => role != Role.pawn)
            .toList();
        final role = potentialRoles[random.nextInt(potentialRoles.length)];
        mv = mv.withPromotion(role);
      }

      // setState(() {
      position = position.playUnchecked(mv);
      lastMove = NormalMove(from: mv.from, to: mv.to, promotion: mv.promotion);
      fen = position.fen;
      validMoves = makeLegalMoves(position);
      // });
      lastPos = position;
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.turn == Side.white));
  }
}
