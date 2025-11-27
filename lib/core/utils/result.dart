// lib/core/utils/result.dart
// 2. Core Layer - Result Type (Either Pattern)

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

/// Type alias for standard result type
// ignore: unintended_html_in_doc_comment
/// Either<Failure, Success> pattern لتوحيد معالجة النتائج
typedef Result<T> = Either<Failure, T>;

/// Extension methods for easier result handling
extension ResultExtension<T> on Result<T> {
  /// Execute callback on success
  void onSuccess(void Function(T data) callback) {
    fold((failure) => null, (data) => callback(data));
  }

  /// Execute callback on failure
  void onFailure(void Function(Failure failure) callback) {
    fold((failure) => callback(failure), (data) => null);
  }

  /// Get data or throw exception
  T getOrThrow() {
    return fold((failure) => throw Exception(failure.message), (data) => data);
  }

  /// Get data or return default value
  T getOrElse(T defaultValue) {
    return fold((failure) => defaultValue, (data) => data);
  }
}
