import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/core/board_theme.dart';
import 'package:chessground_game_app/core/utils/helper/helper_methodes.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChessBoardSettingsController extends GetxController {
  Rx<Side> orientation = Side.white.obs;
  // Side sideToMove = Side.white;
  Rx<PieceSet> pieceSet = PieceSet.gioco.obs;
  Rx<PieceShiftMethod> pieceShiftMethod = PieceShiftMethod.either.obs;
  Rx<DragTargetKind> dragTargetKind = DragTargetKind.circle.obs;
  Rx<BoardTheme> boardTheme = BoardTheme.brown.obs;
  bool drawMode = true;
  RxBool pieceAnimation = true.obs;
  RxBool dragMagnify = true.obs;
  Rx<ISet<Shape>> shapes = ISet<Shape>().obs;
  RxBool showBorder = false.obs;

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
    makeShowChoicesPicker(
      context,
      choices: choices,
      selectedItem: selectedItem,
      labelBuilder: labelBuilder,
      onSelectedItemChanged: onSelectedItemChanged,
    );
  }
}
