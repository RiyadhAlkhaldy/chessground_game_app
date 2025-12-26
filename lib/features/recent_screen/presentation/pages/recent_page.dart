import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/controllers/recent_games_controller.dart';
import 'package:chessground_game_app/features/recent_screen/presentation/widgets/game_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentGamesPage extends StatelessWidget {
  const RecentGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RecentGamesController c = Get.isRegistered<RecentGamesController>()
        ? Get.find<RecentGamesController>()
        : Get.put(RecentGamesController());
    final RefreshController refreshController = RefreshController();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recentGames),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.recentGames.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noGamesYet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => c.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
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
          header: const WaterDropHeader(),
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
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}