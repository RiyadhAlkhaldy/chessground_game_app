import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chessground_game_app/features/computer_game/presentation/controllers/side_choosing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideChosingWidget extends StatelessWidget {
  final SideChoosingController controller;

  const SideChosingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: SideChoosing.values.map((color) {
          // if (SideChoosing.both == color) ;
          Widget? widget;
          String? label;
          switch (color) {
            case SideChoosing.white:
              label = 'White';
              widget = WhitePawn(size: 50);
              break;
            case SideChoosing.random:
              label = 'Random';
              widget = Row(children: [BlackPawn(size: 30), WhitePawn(size: 30)]);
              break;
            case SideChoosing.black:
              label = 'Black';
              widget = BlackPawn(size: 50);
              break;
          }
          return GestureDetector(
            onTap: () => controller.playerColor.value = color,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: controller.playerColor.value == color
                      ? Colors.blue.shade100
                      : Colors.grey,
                  radius: 30,
                  child: widget,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: controller.playerColor.value == color
                        ? Colors.blue.shade200
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
