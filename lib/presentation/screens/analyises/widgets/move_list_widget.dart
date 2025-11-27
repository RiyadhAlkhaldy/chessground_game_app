// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/analyises_controller.dart';
// class MoveListWidget extends GetView<AnalysisController> {
//   const MoveListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         itemCount: (controller.moveHistorySan.length / 2).ceil(),
//         itemBuilder: (context, index) {
//           final moveNumber = index + 1;
//           final whiteMoveIndex = index * 2;
//           final blackMoveIndex = index * 2 + 1;

//           final whiteMove = controller.moveHistorySan[whiteMoveIndex]['san'];
//           final blackMove = (blackMoveIndex < controller.moveHistorySan.length)
//               ? controller.moveHistorySan[blackMoveIndex]['san']
//               : '';

//           return InkWell(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: Row(
//                 children: [
//                   Text(
//                     '$moveNumber.',
//                     style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => controller.goToMove(whiteMoveIndex),
//                       child: Text(whiteMove, style: const TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => blackMove.isNotEmpty ? controller.goToMove(blackMoveIndex) : null,
//                       child: Text(blackMove, style: const TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }