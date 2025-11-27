// lib/domain/repositories/player_repository.dart

import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:dartz/dartz.dart'; 

/// Repository interface for player data operations
/// واجهة المستودع لعمليات بيانات اللاعبين
abstract class PlayerRepository {
  /// Save a player to local database
  /// حفظ لاعب في قاعدة البيانات المحلية
  Future<Either<Failure, PlayerEntity>> savePlayer(PlayerEntity player);

  /// Update existing player
  /// تحديث لاعب موجود
  Future<Either<Failure, PlayerEntity>> updatePlayer(PlayerEntity player);

  /// Get player by UUID
  /// الحصول على لاعب باستخدام UUID
  Future<Either<Failure, PlayerEntity>> getPlayerByUuid(String uuid);

  /// Get player by ID
  /// الحصول على لاعب باستخدام ID
  Future<Either<Failure, PlayerEntity>> getPlayerById(int id);

  /// Get all players
  /// الحصول على جميع اللاعبين
  Future<Either<Failure, List<PlayerEntity>>> getAllPlayers();

  /// Get players by type
  /// الحصول على لاعبين حسب النوع
  Future<Either<Failure, List<PlayerEntity>>> getPlayersByType(String type);

  /// Delete player by UUID
  /// حذف لاعب باستخدام UUID
  Future<Either<Failure, bool>> deletePlayer(String uuid);

  /// Search players by name
  /// البحث عن لاعبين بالاسم
  Future<Either<Failure, List<PlayerEntity>>> searchPlayersByName(String name);

  /// Update player rating
  /// تحديث تصنيف اللاعب
  Future<Either<Failure, PlayerEntity>> updatePlayerRating(
    String uuid,
    int newRating,
  );

  /// Get or create guest player
  /// الحصول على لاعب ضيف أو إنشاؤه
  Future<Either<Failure, PlayerEntity>> getOrCreateGuestPlayer(String name);

  /// Watch player updates
  /// مراقبة تحديثات اللاعب
  Stream<Either<Failure, PlayerEntity>> watchPlayer(String uuid);
}
