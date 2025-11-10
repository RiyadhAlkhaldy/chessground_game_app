// lib/domain/repositories/game_state_repository.dart

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/game_state_entity.dart';

/// Repository interface for game state caching and retrieval
/// واجهة المستودع لحفظ واسترجاع حالة اللعبة
abstract class GameStateRepository {
  /// Cache current game state in memory
  /// حفظ حالة اللعبة الحالية في الذاكرة
  Future<Either<Failure, void>> cacheGameState(GameStateEntity state);

  /// Get cached game state by UUID
  /// الحصول على حالة لعبة محفوظة باستخدام UUID
  Future<Either<Failure, GameStateEntity>> getCachedGameState(String gameUuid);

  /// Remove cached game state
  /// إزالة حالة لعبة محفوظة
  Future<Either<Failure, void>> removeCachedGameState(String gameUuid);

  /// Get all active game states
  /// الحصول على جميع حالات الألعاب النشطة
  Future<Either<Failure, Map<String, GameStateEntity>>> getAllActiveStates();

  /// Clear all cached states
  /// مسح جميع حالات اللعبة المحفوظة
  Future<Either<Failure, void>> clearAllCachedStates();

  /// Check if game state exists in cache
  /// التحقق من وجود حالة لعبة في الذاكرة المؤقتة
  Future<Either<Failure, bool>> hasGameState(String gameUuid);
}
