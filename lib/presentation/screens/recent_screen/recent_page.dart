import 'package:chessground_game_app/presentation/controllers/recent_games_controller.dart';
import 'package:chessground_game_app/presentation/screens/recent_screen/widgets/game_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentGamesPage extends StatelessWidget {
  const RecentGamesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final RecentGamesController c = Get.put(RecentGamesController());
    final RefreshController refreshController = RefreshController();
    return Directionality(
      textDirection: TextDirection.rtl, // دعم RTL
      child: Scaffold(
        appBar: AppBar(title: const Text('أحدث المباريات'), centerTitle: true),
        body: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.recentGames.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('لا توجد مباريات بعد'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () => c.refresh(), child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }

          return SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            onRefresh: () async {
              await c.refresh();
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await c.loadMore();
              refreshController.loadComplete();
            },
            enablePullUp: true,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: c.recentGames.length + (c.isLoadingMore.value ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index < c.recentGames.length) {
                  final game = c.recentGames[index];
                  return GestureDetector(
                    onTap: () => c.openGame(game.uuid),
                    child: GameCardWidget(game: game),
                  );
                } else {
                  // مؤشر تحميل أسفل القائمة
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
