// controller.dart

import 'package:dartchess/dartchess.dart';
import 'package:get/get.dart';

class ChessController extends GetxController {
  Rx<Position> chess = Chess.initial.obs;
  final _past = <Position>[];
  final _future = <Position>[];

  void apply(NormalMove m) {
    final c = chess.value;
    if (c.isLegal(m)) {
      _past.add(c);
      _future.clear();
      chess.value = c.playUnchecked(m);
    }
  }

  bool get isCheckmate => chess.value.isCheckmate;

  Side? get winner {
    return chess.value.outcome!.winner;
  }

  void undo() {
    if (_past.isEmpty) return;
    _future.add(chess.value);
    chess.value = _past.removeLast();
  }

  void redo() {
    if (_future.isEmpty) return;
    _past.add(chess.value);
    chess.value = _future.removeLast();
  }

  void reset([String fen = kInitialFEN]) {
    _past.clear();
    _future.clear();
    chess.value = Chess.fromSetup(Setup.parseFen(fen));
  }
}
