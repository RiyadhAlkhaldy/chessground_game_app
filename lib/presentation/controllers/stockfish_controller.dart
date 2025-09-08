// lib/presentation/controllers/stockfish_controller.dart
// GetX Controller لإدارة حالة المحرك وواجهة المستخدم
import 'dart:async';

import 'package:editable_chess_board/editable_chess_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine.dart';
import 'package:stockfish_chess_engine/stockfish_chess_engine_state.dart';

import '../../core/fen_validation.dart';
import '../widgets/edit_position_page.dart';

class StockfishController extends GetxController with WidgetsBindingObserver {
  late Stockfish stockfish;
  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  late StreamSubscription stockfishOutputSubsciption;
  late StreamSubscription stockfishErrorSubsciption;
  var timeMs = 1000.0;
  var nextMove = '';
  var stockfishOutputText = '';
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    doStartStockfish();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      stopStockfish(Get.context!).then((_) {});
    }
  }

  void readStockfishOutput(String output) {
    // At least now, stockfish is ready : update UI.
    stockfishOutputText += "$output\n";
    update();
    if (output.startsWith('bestmove')) {
      final parts = output.split(' ');
      nextMove = parts[1];
      update();
    }
  }

  void readStockfishError(String error) {
    // At least now, stockfish is ready : update UI.
    debugPrint("@@@$error@@@");
    update();
  }

  void editPosition(BuildContext context) async {
    final initialFen = isStrictlyValidFEN(fen)
        ? fen
        : 'RNBQKBNR/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    final controller = PositionController(initialFen);
    final resultFen = await Get.to<String>(
      () => EditPositionPage(positionController: controller),
    );
    // final resultFen = await Navigator.of(context).push(
    //   MaterialPageRoute<String>(
    //     builder: (context) {
    //       return EditPositionPage(positionController: controller);
    //     },
    //   ),
    // );
    if (resultFen != null) {
      fen = resultFen;
      update();
      if (!isStrictlyValidFEN(fen)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Illegal position : so no changes made !'),
            backgroundColor: Colors.red,
          ),
        );
        fen = initialFen;
        update();
      }
    }
  }

  void updateThinkingTime(double newValue) {
    timeMs = newValue;
    update();
  }

  void computeNextMove() {
    if (!isStrictlyValidFEN(fen)) {
      final message = "Illegal position: '$fen' !\n";
      stockfishOutputText = message;
      update();
      return;
    }
    stockfishOutputText = '';
    update();
    stockfish.stdin = 'position fen $fen';
    stockfish.stdin = 'go movetime ${timeMs.toInt()}';
  }

  // void getNextMove(String fen) {
  //   if (!isStrictlyValidFEN(fen)) {
  //     final message = "Illegal position: '$fen' !\n";
  //     stockfishOutputText = message;
  //     update();
  //     return;
  //   }
  //   stockfishOutputText = '';
  //   update();
  //   stockfish.stdin = 'position fen $fen';
  //   stockfish.stdin = 'go movetime ${timeMs.toInt()}';
  // }

  Future<void> stopStockfish(BuildContext context) async {
    if (stockfish.state.value == StockfishState.disposed ||
        stockfish.state.value == StockfishState.error) {
      return;
    }
    stockfishErrorSubsciption.cancel();
    stockfishOutputSubsciption.cancel();
    stockfish.dispose();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!context.mounted) return;
    update();
  }

  void doStartStockfish() async {
    stockfish = Stockfish();
    stockfishOutputSubsciption = stockfish.stdout.listen(readStockfishOutput);
    stockfishOutputText = '';
    update();
    stockfishErrorSubsciption = stockfish.stderr.listen(readStockfishError);
    await Future.delayed(const Duration(milliseconds: 1500));
    stockfish.stdin = 'uci';
    await Future.delayed(const Duration(milliseconds: 3000));
    stockfish.stdin = 'isready';
  }

  void startStockfishIfNecessary() {
    if (stockfish.state.value == StockfishState.ready ||
        stockfish.state.value == StockfishState.starting) {
      return;
    }
    doStartStockfish();
    update();
  }

  Icon getStockfishStatusIcon() {
    Color color;
    switch (stockfish.state.value) {
      case StockfishState.ready:
        color = Colors.green;
        break;
      case StockfishState.disposed:
      case StockfishState.error:
        color = Colors.red;
        break;
      case StockfishState.starting:
        color = Colors.orange;
    }
    return Icon(MdiIcons.circle, color: color);
  }
}
