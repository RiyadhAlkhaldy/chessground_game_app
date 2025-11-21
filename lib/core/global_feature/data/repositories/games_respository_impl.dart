import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/move_data.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/repositories/games_repository.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart'; 
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart'; 

class GamesRepositoryImpl implements GamesRepository {
  final Isar isar;
  @override
  final ChessGameStorageService storageService;
  GamesRepositoryImpl({required this.isar, required this.storageService});

  @override
  Future<List<ChessGame>>? getAllGames() async {
    return storageService.getAllGames();
  }

  /// جلب أحدث المباريات مع دعم الـ pagination
  /// page تبدأ من 0
  @override
  Future<List<ChessGame>> getRecentGames({
    int page = 0,
    int pageSize = 20,
  }) async {
    // نرتب تنازلياً حسب التاريخ إذا متوفر وإلا حسب id
    final query = isar.chessGames.where();

    // إن كان هناك index على date يمكننا استخدام sortByDateDesc
    // لكن لتعميم: سنسحب الكل ثم نرتّب
    final results = await query.findAll();

    // ترتيب: إذا كان date متوفر استخدمه، وإلا فاعتماد على id
    results.sort((a, b) {
      final aDate = a.date;
      final bDate = b.date;
      if (aDate != null && bDate != null) {
        return bDate.compareTo(aDate);
      }
      return b.id.compareTo(a.id);
    });

    final start = page * pageSize;
    if (start >= results.length) return [];
    final end = (start + pageSize).clamp(0, results.length);
    final pageItems = results.sublist(start, end);

    // تذكير: روابط IsarLink للـ players قد تحتاج تحميل صريح
    for (final g in pageItems) {
      await g.whitePlayer.load(); // تحميل بيانات اللاعب الأبيض
      await g.blackPlayer.load(); // تحميل بيانات اللاعب الأسود
    }

    return pageItems;
  }

  /// الحصول على مباراة حسب uuid
  @override
  Future<ChessGame?> getGameByUuid(String uuid) async {
    final game = await isar.chessGames.filter().uuidEqualTo(uuid).findFirst();
    if (game != null) {
      await game.whitePlayer.load();
      await game.blackPlayer.load();
    }
    return game;
  }

  /// مراقبة التغييرات (إن أردت تحديث الواجهة تلقائياً عند إضافة مباريات)
  @override
  Stream<List<ChessGame>> watchRecentGames() {
    // Isar لا يعطي Stream مباشرة من where(). لكن يمكن استخدام watchLazy أو watchObject
    // أبسط حل: stream يبعث عند أي تغيير في collection
    return isar.chessGames.watchLazy().asyncMap((_) async {
      final all = await isar.chessGames.where().findAll();
      all.sort((a, b) {
        final aDate = a.date;
        final bDate = b.date;
        if (aDate != null && bDate != null) return bDate.compareTo(aDate);
        return b.id.compareTo(a.id);
      });
      // تحميل اللاعبين لكل نتيجة (خطر الأداء إذا عدد كبير) - هنا صغير ومحلي
      for (final g in all) {
        await g.whitePlayer.load();
        await g.blackPlayer.load();
      }
      return all;
    });
  }

  /// إدراج بيانات Mock (8-12 مباراة) إذا كانت قاعدة البيانات فارغة
  @override
  Future<void> insertMockDataIfEmpty() async {
    // final count = await isar.chessGames.count();
    // if (count > 0) return;
    final uuid1 = const Uuid().v4();
    final uuid2 = const Uuid().v4();
    // داخل transaction نُدخل لاعبين ومباريات
    await isar.writeTxn(() async {
      // أنشئ لاعبين
      final p1 = Player(uuid: uuid1, name: 'player-$uuid1', type: 'human')
        ..playerRating = 1037;
      final p2 = Player(uuid: uuid2, name: 'player-$uuid2', type: 'human')
        ..playerRating = 1072;

      // ignore: unused_local_variable
      final id1 = await isar.players.put(p1);
      // ignore: unused_local_variable
      final id2 = await isar.players.put(p2);

      // لعبة مثال
      final g1 = ChessGame()
        ..uuid = 'game-uuid-1'
        ..date = DateTime.now().subtract(const Duration(hours: 2))
        ..result = '1-0'
        ..eco = 'C20'
        ..whiteElo = 1037
        ..blackElo = 1072
        ..timeControl = '5+0'
        ..fullPgn = '[Event "Example"] 1. e4 e5 2. Nf3 Nc6 3. Bb5 a6'
        ..movesCount = 6
        ..moves = [
          MoveData()
            ..san = 'e4'
            ..fenAfter =
                'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'
            ..isWhiteMove = true,
          MoveData()
            ..san = 'e5'
            ..fenAfter =
                'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2'
            ..isWhiteMove = false,
        ];

      // ربط اللاعبين عبر IsarLink
      g1.whitePlayer.value = p1;
      g1.blackPlayer.value = p2;

      await isar.chessGames.put(g1);
      await g1.whitePlayer.save();
      await g1.blackPlayer.save();

      // يمكنك إضافة المزيد من الألعاب بنفس الأسلوب
    });
  }

  /// مفيد لو أردت حذف كل البيانات أثناء التطوير
  @override
  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.chessGames.clear();
      await isar.players.clear();
    });
  }
}
