import 'dart:async';

import 'package:get/get.dart';

import '../../domain/collections/chess_game.dart';
import '../../domain/repositories/game_repository.dart';

class GameDetailsController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();

  Rxn<ChessGame> game = Rxn<ChessGame>();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  // Replay state
  Timer? _replayTimer;
  int _currentMoveIndex = -1; // -1 => starting position
  RxString currentFen = ''.obs;
  Duration replayInterval = const Duration(milliseconds: 700);

  Future<void> loadGame(String uuid) async {
    try {
      isLoading.value = true;
      final g = await repository.getGameByUuid(uuid);
      if (g == null) {
        error.value = 'Game not found';
      } else {
        game.value = g;
        // اضبط currentFen: آخر موقف إن وُجد، أو startingFen أو الافتراضي
        if (g.moves.isNotEmpty && g.moves.last.fenAfter != null) {
          currentFen.value = g.moves.last.fenAfter!;
        } else if (g.startingFen != null && g.startingFen!.isNotEmpty) {
          currentFen.value = g.startingFen!;
        } else {
          // FEN الافتراضي لبداية اللعبة
          currentFen.value = 'startpos';
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// ابدأ إعادة تشغيل الحركات من البداية
  void startReplay() {
    stopReplay();
    _currentMoveIndex = -1;
    _replayTimer = Timer.periodic(replayInterval, (_) {
      _currentMoveIndex++;
      final g = game.value;
      if (g == null) {
        stopReplay();
        return;
      }
      if (_currentMoveIndex < g.moves.length) {
        final fen = g.moves[_currentMoveIndex].fenAfter;
        if (fen != null) {
          currentFen.value = fen;
        }
      } else {
        // انتهاء الحركات
        stopReplay();
      }
    });
  }

  void stopReplay() {
    _replayTimer?.cancel();
    _replayTimer = null;
  }

  @override
  void onClose() {
    stopReplay();
    super.onClose();
  }
}
