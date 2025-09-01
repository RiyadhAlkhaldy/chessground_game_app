// // lib/ui/ai_controller.dart
// import 'package:dartchess/dartchess.dart';
// import 'package:get/get.dart';

// import '../../data/engine/eval.dart';
// import '../../data/engine/search.dart';

// class AIController extends GetxController {
//   Rx<Position> position = Chess.initial.obs; // Position
//   final engine = SearchEngine(eval: Evaluator());

//   // إعداد مستوى الصعوبة
//   int maxDepth = 5;
//   Duration perMove = const Duration(milliseconds: 1500);

//   void onUserMove(Move m) {
//     position.value = position.value.play(m);
//     if (!position.value.isGameOver) _thinkAndPlay();
//   }

//   void _thinkAndPlay() async {
//     // حدد الوقت النهائي لهذه النقلة
//     final res = engine.search(
//       position.value,
//       SearchLimits(maxDepth: maxDepth, moveTime: perMove),
//     );
//     final best = res.best;
//     if (best != null) position.value = position.value.play(best);
//   }
// }
