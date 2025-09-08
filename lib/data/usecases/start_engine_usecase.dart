// lib/data/usecases/start_engine_usecase.dart
import '../../domain/repositories/stockfish_repository.dart';

class StartEngineUseCase {
  final StockfishRepository repository;
  StartEngineUseCase(this.repository);

  Future<void> call() async {
    await repository.startEngine();
  }

  /// يبدأ محرك Stockfish إذا لم يكن قيد التشغيل.
  Future<void> startStockfishIfNecessary() async {
    await repository.startStockfishIfNecessary();
  }
}
