import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/services/stockfish_engine_service.dart';
import '../../controllers/chess_board_settings_controller.dart';
import '../../controllers/game_computer_controller.dart';
import '../../widgets/chess_board_settings_widgets.dart';
import '../../widgets/chess_board_widget.dart';
import 'widgets/chess_clock_widget.dart';

const screenPadding = 16.0;
const screenPortraitSplitter = screenPadding / 2;
const screenLandscapeSplitter = screenPadding;
const buttonHeight = 50.0;
const buttonsSplitter = screenPadding;
const smallButtonsSplitter = screenPadding / 2;

class GameComputerScreen extends StatelessWidget {
  GameComputerScreen({super.key});

  final ctrl = Get.put(
    GameComputerController(Get.find(), Get.find(), Get.find()),
  );
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();

  Widget buildNewRoundButton() => FilledButton.icon(
    icon: const Icon(Icons.refresh_rounded),
    label: const Text('New Round'),
    onPressed: () {
      ctrl.reset();
    },
  );

  Widget buildUndoButton() => GetX<GameComputerController>(
    builder: (controller) => FilledButton.icon(
      icon: const Icon(Icons.undo_rounded),
      label: const Text('Undo'),
      onPressed: controller.canUndo.value ? controller.undoMove : null,
    ),
  );
  Widget buildRedoButton() => GetX<GameComputerController>(
    builder: (controller) => FilledButton.icon(
      icon: const Icon(Icons.redo_rounded),
      label: const Text('Redo'),
      onPressed: controller.canRedo.value ? controller.redoMove : null,
    ),
  );
  Widget buildControlButtons() => SizedBox(
    height: buttonHeight,
    child: GetBuilder<GameComputerController>(
      initState: (_) {},
      builder: (_) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: buildNewRoundButton()),
            Expanded(child: buildUndoButton()),
            Expanded(child: buildRedoButton()),
          ],
        );
      },
    ),
  );

  Widget buildPortrait() => Padding(
    padding: const EdgeInsets.only(bottom: screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // EvaluationBarWidget(),
        ctrlBoardSettings.orientation.value == Side.white
            ? ChessClockBlackWidget(chessClock: ctrl.clockCtrl!)
            : ChessClockWhiteWidget(chessClock: ctrl.clockCtrl!),

        ChessBoardWidget(
          ctrlBoardSettings: ctrlBoardSettings,
          controller: ctrl,
        ),
        ctrlBoardSettings.orientation.value == Side.white
            ? ChessClockWhiteWidget(chessClock: ctrl.clockCtrl!)
            : ChessClockBlackWidget(chessClock: ctrl.clockCtrl!),
        //   const SizedBox(height: screenPortraitSplitter),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: screenPadding),
            child: ChessBoardSettingsWidgets(controller: ctrlBoardSettings),
          ),
        ),
        const SizedBox(height: screenPortraitSplitter),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          child: buildControlButtons(),
        ),
      ],
    ),
  );

  Widget buildLandscape() => Padding(
    padding: const EdgeInsets.all(screenPadding),
    child: Row(
      children: [
        // EvaluationBarWidget(),
        ctrlBoardSettings.orientation.value == Side.white
            ? ChessClockBlackWidget(chessClock: ctrl.clockCtrl!)
            : ChessClockWhiteWidget(chessClock: ctrl.clockCtrl!),
        Expanded(
          child: ChessBoardWidget(
            ctrlBoardSettings: ctrlBoardSettings,
            controller: ctrl,
          ),
        ),
        ctrlBoardSettings.orientation.value == Side.white
            ? ChessClockWhiteWidget(chessClock: ctrl.clockCtrl!)
            : ChessClockBlackWidget(chessClock: ctrl.clockCtrl!),
        const SizedBox(width: screenLandscapeSplitter),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ChessBoardSettingsWidgets(controller: ctrlBoardSettings),
              ),
              const SizedBox(height: screenPortraitSplitter),
              buildControlButtons(),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents automatic exit

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (ctrl.getResult() != GameResult.ongoing) {
          Get.back();
        } else {
          final shouldExit = await _showExitConfirmationDialog(context);

          if (shouldExit == true) {
            if (context.mounted) {
              // If the user confirms, show the second dialog
              await _showGameOverDialog(context);
              // And then, after closing the second dialog, navigate back
              if (context.mounted) {
                Get.back();
              }
            }
          }
        }
      },
      child: Scaffold(
        primary: MediaQuery.of(context).orientation == Orientation.portrait,
        appBar: AppBar(
          title: GetX<GameComputerController>(
            builder: (_) {
              return Text(ctrl.statusText.value);
            },
          ),
        ),

        body: OrientationBuilder(
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape(),
        ),
      ),
    );
  }
} // هذه الدالة تعرض نافذة التأكيد

// Future<bool?> _showExitConfirmationDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('إنهاء اللعبة؟'),
//         content: Text('هل أنت متأكد أنك تريد الاستسلام وإنهاء اللعبة؟'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false); // لا تسمح بالخروج
//             },
//             child: Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true); // تسمح بالخروج
//             },
//             child: Text('استسلام'),
//           ),
//         ],
//       );
//     },
//   );
// }

Future<bool> _confirmExit(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('إنهاء اللعبة؟'),
      content: const Text('هل تريد الخروج من المباراة الحالية؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('خروج'),
        ),
      ],
    ),
  );
  return res ?? false;
}

// هذه الدالة تعرض نافذة تأكيد الاستسلام
Future<bool?> _showExitConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('إنهاء اللعبة؟'),
        content: Text('هل أنت متأكد أنك تريد الاستسلام وإنهاء اللعبة؟'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // لا تسمح بالخروج
            },
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // تسمح بالخروج
            },
            child: Text('استسلام'),
          ),
        ],
      );
    },
  );
}

// هذه الدالة الجديدة تعرض نافذة "نهاية اللعبة"
Future<void> _showGameOverDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // يمنع إغلاقها بالضغط خارجها
    builder: (context) {
      return AlertDialog(
        title: Text('انتهت اللعبة!'),
        content: Text(
          'لقد خسرت هذه اللعبة. يمكنك الآن العودة إلى الصفحة الرئيسية.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق النافذة المنبثقة
            },
            child: Text('حسناً'),
          ),
        ],
      );
    },
  );
}
