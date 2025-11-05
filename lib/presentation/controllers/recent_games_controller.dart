import 'package:get/get.dart';

import '../../data/collections/chess_game.dart';
import '../../domain/repositories/game_repository.dart';

class RecentGamesController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();

  // القوائم والحالات
  RxList<ChessGame> recentGames = <ChessGame>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString error = ''.obs;

  // Pagination
  int page = 0;
  final int pageSize = 20; // يمكنك تعديلها لاحقًا

  @override
  void onInit() {
    super.onInit();
    loadInitial().then((_) {
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
      repository.insertMockDataIfEmpty();
    });
    // اختياري: الاستماع للتغييرات التلقائية
    // repository.watchRecentGames().listen((list) {
    //   recentGames.value = list;
    // });
  }

  /// تحميل الصفحة الأولى
  Future<void> loadInitial() async {
    try {
      isLoading.value = true;
      page = 0;
      final list = await repository.getRecentGames(
        page: page,
        pageSize: pageSize,
      );
      recentGames.value = list;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = e.toString();
    }
  }

  /// تحميل المزيد عند التمرير
  Future<void> loadMore() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      page += 1;
      final more = await repository.getRecentGames(
        page: page,
        pageSize: pageSize,
      );
      if (more.isEmpty) {
        // لا مزيد من العناصر
      } else {
        recentGames.addAll(more);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadInitial();
  }

  /// فتح تفاصيل المباراة
  void openGame(String uuid) {
    // نستخدم Get.toNamed ونمرر uuid كـ argument
    Get.toNamed('/game-details', arguments: {'uuid': uuid});
  }
}
