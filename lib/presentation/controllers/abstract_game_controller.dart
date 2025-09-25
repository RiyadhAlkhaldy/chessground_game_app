import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';

abstract class AbstractGameController extends GetxController {
  // Rx<Position> position = Chess.initial.obs;
  late Rx<Position> position = Chess.fromSetup(Setup.parseFen(fen)).obs;

  // String _fen = kInitialFEN;

  String _fen = '2b1k3/p4p2/7P/4p3/3p4/8/P1P2P1P/R2QK1NR w - - 0 4';
  // 'k7/8/8/8/8/8/p7/K7 b - - 0 1';
  // "8/P7/8/k7/8/8/8/K7 w - - 0 1";

  // 'rnbqkbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 3';

  String get fen => _fen;

  set fen(String value) => {_fen = value};

  ValidMoves validMoves = IMap(const {});

  /// undo/redo
  RxBool get canUndo => (past.isNotEmpty).obs;
  RxBool get canRedo => future.isNotEmpty.obs;

  final past = <Position>[];
  final future = <Position>[];

  bool get isCheckmate => position.value.isCheckmate;

  Side? get winner {
    return position.value.outcome!.winner;
  }

  void undoMove();
  //  {
  //   if (past.isEmpty) return;
  //   debugPrint('undo');
  //   future.add(position.value);
  //   position.value = past.removeLast();
  //   _fen = position.value.fen;
  //   validMoves = makeLegalMoves(position.value);
  // }

  void redoMove();
  // {
  //   if (future.isEmpty) return;
  //   past.add(position.value);
  //   position.value = future.removeLast();
  //   _fen = position.value.fen;
  //   validMoves = makeLegalMoves(position.value);
  // }
}
