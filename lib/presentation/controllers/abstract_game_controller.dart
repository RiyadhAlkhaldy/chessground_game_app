import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class AbstractGameController extends GetxController {
  Rx<Position> position = Chess.initial.obs;
  // late Rx<Position> position = Chess.fromSetup(Setup.parseFen(fen)).obs;

  // String _fen = kInitialFEN;

  String _fen =
      'r1bqkbnr/pppp1ppp/2n5/4p3/3P4/2N5/PPP2PPP/R1BQKBNR w KQkq - 0 4';
  // 'rnbqkbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 3';

  String get fen => _fen;

  set fen(String value) => {_fen = value};

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
