import 'package:chessground_game_app/domain/services/chess_clock_service.dart';
// import 'package:chessground_game_app/presentation/controllers/game_computer_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../../core/constants/assets_images.dart';

String formatMsToClock(int ms) {
  final Duration d = Duration(milliseconds: ms);
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class ChessClockBlackWidget extends StatelessWidget {
  final ChessClockService chessClock;
  const ChessClockBlackWidget({super.key, required this.chessClock});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _clockRow(
            label: 'White',
            timeText: formatMsToClock(chessClock.whiteTimeMs.value),
            active: chessClock.currentTurn.value == Side.white,
          ),
        ),
      ],
    );
  }
}

// class ChessClockBlackWidget extends StatelessWidget {
//   final ChessClockService chessClock;
//   ChessClockBlackWidget({super.key, required this.chessClock});
//   final userModel = Get.find<GameComputerWithTimeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(
//           () => // our data
//               ListTile(
//             leading:
//                 userModel.currentGame?.whitePlayer.value?.image == null
//                     ? CircleAvatar(
//                       radius: 25,
//                       backgroundImage: AssetImage(AssetsImages.userIcon),
//                     )
//                     : CircleAvatar(
//                       radius: 25,
//                       backgroundImage: NetworkImage(
//                         userModel.currentGame!.whitePlayer.value!.image!,
//                       ),
//                     ),
//             title: Text(userModel.currentGame!.whitePlayer.value!.name),
//             subtitle: Text(
//               'Rating: ${userModel.currentGame!.whitePlayer.value!.playerRating}',
//             ),
//             trailing: Text(
//               userModel.currentGame!.whitesTime!,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ),
//         // const SizedBox(height: 16),
//         // _controls(),
//       ],
//     );
//   }
// }

Widget _clockRow({
  required String label,
  required String timeText,
  required bool active,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: active ? Colors.blue : Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(timeText, style: const TextStyle(fontSize: 20)),
      ],
    ),
  );
}

// ignore: unused_element
Widget _controls(ChessClockService chessClock) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(onPressed: chessClock.start, child: const Text('Start')),
      const SizedBox(width: 8),
      ElevatedButton(onPressed: chessClock.pause, child: const Text('Pause')),
      const SizedBox(width: 8),
      ElevatedButton(onPressed: chessClock.resume, child: const Text('Resume')),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: () => chessClock.switchTurn(chessClock.currentTurn.value),
        child: const Text('Switch'),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed:
            () => chessClock.reset(newInitialMs: chessClock.initialTimeMs),
        child: const Text('Reset'),
      ),
    ],
  );
}
