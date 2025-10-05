// import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chessground_game_app/presentation/controllers/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/helper/helper_methods.dart';
import '../../routes/app_pages.dart';
import '../widgets/animated_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    buildGameType(
                      lable: 'Play vs Computer',
                      icon: Icons.computer,
                      onTap: () {
                        controller.setVsComputer(value: true);
                        // navigate to setup game time screen
                        Get.toNamed(
                          RouteNames.gameTimeScreen,
                          arguments: {"withTime": false},
                        );
                      },
                    ),
                    buildGameType(
                      lable: 'Play vs Friend',
                      icon: Icons.person,
                      onTap: () {
                        controller.setVsComputer(value: false);
                        // navigate to setup game time screen
                        Get.toNamed(
                          RouteNames.gameTimeScreen,
                          arguments: {"withTime": false},
                        );
                      },
                    ),
                    buildGameType(
                      lable: 'Settings',
                      icon: Icons.settings,
                      onTap: () {
                        // navigate to settings screen

                        Get.toNamed(RouteNames.settingsScreen);
                      },
                    ),
                    buildGameType(
                      lable: 'About',
                      icon: Icons.info,
                      onTap: () {
                        // navigate to about screen
                        Get.toNamed(RouteNames.aboutScreen);
                      },
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Column(
                //     children: [
                //       Column(
                //         children: [
                //           CircleAvatar(
                //             backgroundColor: Colors.blueGrey[800],
                //             radius: 40,
                //             child: BlackKnight(),
                //           ),
                //           const SizedBox(height: 10),
                //           const Text(
                //             'كش ملك!',
                //             style: TextStyle(
                //               fontSize: 32,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             'أفضل تجربة شطرنج',
                //             style: TextStyle(color: Colors.grey[300]),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 30),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: const [
                //           Icon(Icons.brightness_2),
                //           Row(
                //             children: [
                //               Text(
                //                 '565,837',
                //                 style: TextStyle(
                //                   color: Colors.blueAccent,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               Text(' لعبة خلال 24 ساعة'),
                //               SizedBox(width: 20),
                //               Text(
                //                 '33,873',
                //                 style: TextStyle(
                //                   color: Colors.blueAccent,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               Text(' لاعب الآن'),
                //             ],
                //           ),
                //           Icon(Icons.music_note),
                //         ],
                //       ),
                //       const SizedBox(height: 30),
                //       Expanded(
                //         child: GridView.count(
                //           crossAxisCount: 2,
                //           mainAxisSpacing: 15,
                //           crossAxisSpacing: 15,
                //           childAspectRatio: 1.8,
                //           children: [
                //             _buildButton(
                //               "العب مع الكمبيوتر والوقت",
                //               Icons.smart_toy,
                //               onPressed: () => Get.toNamed(
                //                 RouteNames.sideChoosingView,
                //                 arguments: {"withTime": true},
                //               ),
                //               '',
                //               light: true,
                //             ),
                //             _buildButton(
                //               "العب مع الكمبيوتر",
                //               Icons.smart_toy,
                //               onPressed: () => Get.toNamed(
                //                 RouteNames.sideChoosingView,
                //                 arguments: {"withTime": false},
                //               ),
                //               '',
                //             ),
                //             _buildButton("العب أونلاين", Icons.public, '/online'),

                //             _buildButton(
                //               "Analyises Screen",
                //               Icons.smart_toy,
                //               onPressed: () =>
                //                   Get.toNamed(RouteNames.analysisScreen),
                //               '',
                //             ),
                //             _buildButton(
                //               "العب مع الأصدقاء",
                //               Icons.group,
                //               '/friends',
                //             ),
                //             _buildButton(
                //               "ألغاز الشطرنج",
                //               Icons.extension,
                //               '/puzzles',
                //             ),
                //             _buildButton(
                //               "الترتيب",
                //               Icons.bar_chart,
                //               '/rankings',
                //               light: true,
                //             ),
                //             _buildButton(
                //               "الإعدادات",
                //               Icons.settings,
                //               '/settings',
                //               light: true,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String title,
    IconData icon,

    String route, {
    bool light = false,
    void Function()? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: light ? Colors.blue[100] : Colors.blueGrey[700],
        foregroundColor: light ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerRight,
      ),
      icon: Icon(icon),
      label: Text(title, style: const TextStyle(fontSize: 16)),
      onPressed: onPressed ?? () => Get.toNamed(route),
    );
  }
}
