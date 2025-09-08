// lib/data/usecases/start_engine_usecase.dart
import '../../domain/repositories/stockfish_repository.dart';

class SetEngineUseCase {
  final StockfishRepository repository;
  SetEngineUseCase(this.repository);

  void call(String fen) {
    repository.setPositionFen(fen);
  }
}
