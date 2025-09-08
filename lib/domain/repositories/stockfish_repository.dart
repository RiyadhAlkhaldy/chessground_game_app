// lib/domain/repositories/stockfish_repository.dart
// العقدة (abstract) لتعامل الطبقة العليا (Domain) مع Stockfish / مصدر الصوت
// import 'package:dartz/dartz.dart';

import 'package:flutter/widgets.dart';

abstract class StockfishRepository {
  Future<void> startEngine();
  Future<void> startStockfishIfNecessary();
  Future<void> stopEngine(BuildContext context);
  void setPositionFen(String fen);
  Future<void> getBestMove();
  // Stream<String> outputStream(); // لإيصال مخرجات المحرك (logs/analysis)
  void updateThinkingTime(int newValue);
  String get nextMove;
}
