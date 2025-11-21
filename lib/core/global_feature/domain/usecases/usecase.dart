// lib/domain/usecases/usecase.dart
import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Base class for all use cases
/// الكلاس الأساسي لجميع حالات الاستخدام
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  /// Execute the use case
  /// تنفيذ حالة الاستخدام
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
/// حالة استخدام بدون معاملات
// ignore: avoid_types_as_parameter_names
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// Use case that returns a stream
/// حالة استخدام تُرجع دفق بيانات
// ignore: avoid_types_as_parameter_names
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// No parameters class for use cases
/// كلاس خاص بحالات الاستخدام التي لا تحتاج معاملات
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
