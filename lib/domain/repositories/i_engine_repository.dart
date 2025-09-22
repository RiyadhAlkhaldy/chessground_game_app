// واجهة مجردة لضمان قابلية تبديل المحرك مستقبلاً
import '../entities/extended_evaluation.dart';

abstract class IEngineRepository {
  Stream<ExtendedEvaluation> get evaluations;
  Future<void> initialize();
  void setPosition({String? fen, List<String>? moves});
  Future<void> go();
  void stop();
  void dispose();
}
