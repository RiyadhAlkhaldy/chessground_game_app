// core/errors/failures.dart
/// الفشل - تمثيل الأخطاء بشكل موحد
abstract class Failure {
  final String errMessage;
  Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});
}

class CacheFailure extends Failure {
  CacheFailure({required super.errMessage});
}

class IsarCacheFailure extends CacheFailure {
  IsarCacheFailure({required super.errMessage});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.errMessage});
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.errMessage});
}

class EngineFailure extends Failure {
  EngineFailure({required super.errMessage});
}
