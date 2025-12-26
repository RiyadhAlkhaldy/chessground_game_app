import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class BoardEditorController extends GetxController {
  final RxMap<Square, Piece> pieces = readFen(kInitialFEN).obs;
  final Rx<Piece?> pieceToAddOnTouch = Rx<Piece?>(null);
  final Rx<EditorPointerMode> pointerMode = EditorPointerMode.drag.obs;

  void onEditedSquare(Square squareId) {
    if (pieceToAddOnTouch.value != null) {
      pieces[squareId] = pieceToAddOnTouch.value!;
    } else {
      pieces.remove(squareId);
    }
  }

  void onDiscardedPiece(Square squareId) {
    pieces.remove(squareId);
  }

  void onDroppedPiece(Square? origin, Square destination, Piece piece) {
    pieces[destination] = piece;
    if (origin != null && origin != destination) {
      pieces.remove(origin);
    }
  }

  void selectPiece(Role role, Side side) {
    pieceToAddOnTouch.value = Piece(role: role, color: side);
    pointerMode.value = EditorPointerMode.edit;
  }

  void selectDelete() {
    pieceToAddOnTouch.value = null;
    pointerMode.value = EditorPointerMode.edit;
  }

  void selectDrag() {
    pointerMode.value = EditorPointerMode.drag;
  }

  void clearBoard() {
    pieces.clear();
  }

  void resetToInitial() {
    pieces.assignAll(readFen(kInitialFEN));
  }

  String get fen => writeFen(pieces);
}