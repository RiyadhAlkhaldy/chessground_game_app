// core/errors/failures.dart
/// الفشل - تمثيل الأخطاء بشكل موحد
abstract class Failure {
  final String message;
  final String? code;
  final dynamic details;
  Failure({required this.message, this.code, this.details});
  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class IsarCacheFailure extends CacheFailure {
  IsarCacheFailure({required super.message});
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.message});
}

class EngineFailure extends Failure {
  EngineFailure({required super.message});
}

/// Invalid game state failures
/// أخطاء متعلقة بحالة اللعبة غير الصحيحة
class GameStateFailure extends Failure {
  GameStateFailure({
    required super.message,
    super.code = 'GAME_STATE_ERROR',
    super.details,
  });
}

/// Invalid move failures
/// أخطاء متعلقة بحركات غير صالحة
class InvalidMoveFailure extends Failure {
  InvalidMoveFailure({
    required super.message,
    super.code = 'INVALID_MOVE',
    super.details,
  });
}

/// Cache failures
/// أخطاء متعلقة بالذاكرة المؤقتة
class CacheFailure extends Failure {
  CacheFailure({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.details,
  });
}

/// Database failures
/// أخطاء متعلقة بالذاكرة المؤقتة
class DatabaseFailure extends Failure {
  DatabaseFailure({
    required super.message,
    super.code = 'DataBase_ERROR',
    super.details,
  });
}

/// Not found failures
/// أخطاء عند عدم العثور على البيانات المطلوبة
class NotFoundFailure extends Failure {
  NotFoundFailure({
    required super.message,
    super.code = 'NOT_FOUND',
    super.details,
  });
}

/// Validation failures
/// أخطاء التحقق من صحة البيانات
class ValidationFailure extends Failure {
  ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}
