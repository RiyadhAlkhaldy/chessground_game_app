import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';

import '../controllers/stockfish_controller.dart';

class StockfishPage extends StatefulWidget {
  const StockfishPage({super.key});

  @override
  StockfishPageState createState() => StockfishPageState();
}

class StockfishPageState extends State<StockfishPage>
    with WidgetsBindingObserver {
  final StockfishController ctrl = Get.put(StockfishController());
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ctrl.startStockfishIfNecessary();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ctrl.stopStockfish(context).then((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stockfish Chess Engine example")),
      body: SingleChildScrollView(
        child: GetBuilder<StockfishController>(
          builder: (_) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: SimpleChessBoard(
                    engineThinking: false,
                    fen: ctrl.fen,
                    whitePlayerType: PlayerType.computer,
                    blackPlayerType: PlayerType.computer,
                    blackSideAtBottom: false,
                    cellHighlights: {},
                    chessBoardColors: ChessBoardColors(),
                    onMove: ({required move}) => {},
                    onPromote: () => Future.value(null),
                    onPromotionCommited:
                        ({required moveDone, required pieceType}) => {},
                    onTap: ({required cellCoordinate}) => {},
                  ),
                ),
                ElevatedButton(
                  onPressed: () => ctrl.editPosition(context),
                  child: const Text('Edit position'),
                ),
                Slider(
                  value: ctrl.timeMs,
                  onChanged: ctrl.updateThinkingTime,
                  min: 500,
                  max: 3000,
                ),
                Text('Thinking time : ${ctrl.timeMs.toInt()} millis'),
                ElevatedButton(
                  onPressed: ctrl.computeNextMove,
                  child: const Text('Search next move'),
                ),
                Text('Best move: ${ctrl.nextMove}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ctrl.getStockfishStatusIcon(),
                    ElevatedButton(
                      onPressed: ctrl.startStockfishIfNecessary,
                      child: const Text('Start Stockfish'),
                    ),
                    ElevatedButton(
                      onPressed: () => ctrl.stopStockfish(context),
                      child: const Text('Stop Stockfish'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 850.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(ctrl.stockfishOutputText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
