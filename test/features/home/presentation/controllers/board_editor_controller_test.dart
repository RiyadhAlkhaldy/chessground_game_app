import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/features/home/presentation/controllers/board_editor_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BoardEditorController controller;

  setUp(() {
    controller = BoardEditorController();
  });

  group('BoardEditorController', () {
    test('initial state is standard position', () {
      expect(controller.pieces.value.length, 32);
      expect(controller.pointerMode.value, EditorPointerMode.drag);
    });

    test('selectPiece updates mode and target piece', () {
      controller.selectPiece(Role.queen, Side.white);
      expect(controller.pointerMode.value, EditorPointerMode.edit);
      expect(controller.pieceToAddOnTouch.value?.role, Role.queen);
      expect(controller.pieceToAddOnTouch.value?.color, Side.white);
    });

    test('clearBoard removes all pieces', () {
      controller.clearBoard();
      expect(controller.pieces.value.isEmpty, true);
      expect(controller.fen, '8/8/8/8/8/8/8/8');
    });

    test('onEditedSquare adds piece when in edit mode', () {
      controller.selectPiece(Role.pawn, Side.white);
      controller.onEditedSquare(Square.e4);
      expect(controller.pieces.value[Square.e4], const Piece(role: Role.pawn, color: Side.white));
    });
  });
}
