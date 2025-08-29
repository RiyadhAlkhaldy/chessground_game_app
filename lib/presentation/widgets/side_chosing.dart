import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../package/src/models.dart';
import '../controllers/get_options_controller.dart';

class SideChosing extends StatelessWidget {
  final GameOptionsController controller;

  const SideChosing({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: PlayerSide.values.map((color) {
          // if (PlayerSide.both == color) ;
          Widget? widget;
          String? label;
          switch (color) {
            case PlayerSide.white:
              label = 'White';
              widget = WhitePawn(size: 50);
              break;
            case PlayerSide.none:
              label = 'Random';
              widget = Row(
                children: [BlackPawn(size: 30), WhitePawn(size: 30)],
              );
              break;
            case PlayerSide.black:
              label = 'Black';
              widget = BlackPawn(size: 50);
              break;
            case PlayerSide.both:
              return Center();
          }
          return GestureDetector(
            onTap: () => controller.choseColor.value == color,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: controller.choseColor.value == color
                      ? Colors.blue.shade100
                      : Colors.grey,
                  radius: 30,
                  child: widget,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: controller.choseColor.value == color
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
