// lib/domain/usecases/get_ai_move.dart
import 'package:flutter/material.dart';

import '../../domain/repositories/stockfish_repository.dart';

class GetAiMoveStockfishUseCase {
  final StockfishRepository repository;

  GetAiMoveStockfishUseCase(this.repository);

  Future<String?> execute(
    String fen,
    // int moveTimeMs = defaultThinkingTimeMs,
  ) async {
    debugPrint('@@@ befor Isolate');
    repository.setPositionFen(fen);
    // await repository.startStockfishIfNecessary();
    await repository.getBestMove();
    debugPrint('@@@ nextMove from Stockfish: ${repository.nextMove} @@@');
    return repository.nextMove;
  }
}
