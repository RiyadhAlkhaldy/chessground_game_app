// lib/domain/repositories/chess_game_repository.dart

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/chess_game_entity.dart';

/// Repository interface for chess game data operations
/// واجهة المستودع لعمليات بيانات لعبة الشطرنج
abstract class ChessGameRepository {
  /// Save a chess game to local database
  /// حفظ لعبة شطرنج في قاعدة البيانات المحلية
  Future<Either<Failure, ChessGameEntity>> saveGame(ChessGameEntity game);

  /// Update existing game
  /// تحديث لعبة موجودة
  Future<Either<Failure, ChessGameEntity>> updateGame(ChessGameEntity game);

  /// Get game by UUID
  /// الحصول على لعبة باستخدام UUID
  Future<Either<Failure, ChessGameEntity>> getGameByUuid(String uuid);

  /// Get game by ID
  /// الحصول على لعبة باستخدام ID
  Future<Either<Failure, ChessGameEntity>> getGameById(int id);

  /// Get all games
  /// الحصول على جميع الألعاب
  Future<Either<Failure, List<ChessGameEntity>>> getAllGames();

  /// Get games by player
  /// الحصول على ألعاب لاعب معين
  Future<Either<Failure, List<ChessGameEntity>>> getGamesByPlayer(
    String playerUuid,
  );

  /// Get recent games (limited)
  /// الحصول على الألعاب الأخيرة (محدودة)
  Future<Either<Failure, List<ChessGameEntity>>> getRecentGames({
    int limit = 20,
  });

  /// Get ongoing games
  /// الحصول على الألعاب الجارية
  Future<Either<Failure, List<ChessGameEntity>>> getOngoingGames();

  /// Get completed games
  /// الحصول على الألعاب المنتهية
  Future<Either<Failure, List<ChessGameEntity>>> getCompletedGames();

  /// Delete game by UUID
  /// حذف لعبة باستخدام UUID
  Future<Either<Failure, bool>> deleteGame(String uuid);

  /// Delete all games
  /// حذف جميع الألعاب
  Future<Either<Failure, bool>> deleteAllGames();

  /// Search games by criteria
  /// البحث عن ألعاب باستخدام معايير محددة
  Future<Either<Failure, List<ChessGameEntity>>> searchGames({
    String? event,
    String? playerName,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? result,
  });

  /// Get games count
  /// الحصول على عدد الألعاب
  Future<Either<Failure, int>> getGamesCount();

  /// Watch game updates (stream)
  /// مراقبة تحديثات اللعبة (دفق بيانات)
  Stream<Either<Failure, ChessGameEntity>> watchGame(String uuid);

  /// Watch all games updates
  /// مراقبة تحديثات جميع الألعاب
  Stream<Either<Failure, List<ChessGameEntity>>> watchAllGames();
}
