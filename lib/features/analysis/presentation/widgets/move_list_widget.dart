import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/game_analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to display the list of moves with analysis
/// عنصر لعرض قائمة الحركات مع التحليل
// class MoveListWidget extends StatelessWidget {
//   final List<MoveDataModel> tokens;
//   final int? currentIndex;
//   final Function(int)? onMoveSelected;

//   const MoveListWidget({
//     super.key,
//     required this.tokens,
//     this.currentIndex,
//     this.onMoveSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (tokens.isEmpty) {
//       return const Center(
//         child: Text('No moves yet', style: TextStyle(color: Colors.grey)),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: (tokens.length / 2).ceil(),
//       itemBuilder: (context, index) {
//         final moveNumber = index + 1;
//         final whiteMove = tokens[index * 2];
//         final blackMove = (index * 2 + 1) < tokens.length
//             ? tokens[index * 2 + 1]
//             : null;

//         return _buildMoveRow(
//           context,
//           moveNumber,
//           whiteMove,
//           blackMove,
//           index * 2,
//         );
//       },
//     );
//   }

//   /// Build a row displaying one full move (white + black)
//   /// بناء صف يعرض حركة كاملة (أبيض + أسود)
//   Widget _buildMoveRow(
//     BuildContext context,
//     int moveNumber,
//     MoveDataModel whiteMove,
//     MoveDataModel? blackMove,
//     int moveIndex,
//   ) {
//     // Try to get analysis controller (may not be available)
//     final analysisController = Get.isRegistered<GameAnalysisController>()
//         ? Get.find<GameAnalysisController>()
//         : null;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           // Move number
//           Container(
//             width: 40,
//             padding: const EdgeInsets.all(8),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(4),
//                 bottomLeft: Radius.circular(4),
//               ),
//             ),
//             child: Text(
//               '$moveNumber.',
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//             ),
//           ),
//           // White move
//           Expanded(
//             child: _buildMoveCell(
//               context,
//               whiteMove,
//               moveIndex,
//               analysisController,
//             ),
//           ),

//           // Black move
//           if (blackMove != null)
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border(left: BorderSide(color: Colors.grey[300]!)),
//                 ),
//                 child: _buildMoveCell(
//                   context,
//                   blackMove,
//                   moveIndex + 1,
//                   analysisController,
//                 ),
//               ),
//             )
//           else
//             const Expanded(child: SizedBox()),
//         ],
//       ),
//     );
//   }

//   /// Build individual move cell
//   /// بناء خلية حركة فردية
//   Widget _buildMoveCell(
//     BuildContext context,
//     MoveDataModel move,
//     int moveIndex,
//     GameAnalysisController? analysisController,
//   ) {
//     final isCurrentMove = currentIndex != null && moveIndex == currentIndex;
//     final evaluation = analysisController?.getEvaluationForMove(moveIndex);

//     return InkWell(
//       onTap: onMoveSelected != null ? () => onMoveSelected!(moveIndex) : null,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         color: isCurrentMove
//             ? Colors.blue.withValues(alpha: 0.2)
//             : Colors.transparent,
//         child: Row(
//           children: [
//             // Move text
//             Expanded(
//               child: Text(
//                 move.san ?? '',
//                 style: TextStyle(
//                   fontWeight: isCurrentMove
//                       ? FontWeight.bold
//                       : FontWeight.normal,
//                   fontSize: 14,
//                   color: isCurrentMove ? Colors.blue : Colors.black,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//             ),

//             // Evaluation indicator
//             if (evaluation != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: _getEvaluationColor(evaluation.centipawns),
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//                 child: Text(
//                   _formatEvaluation(evaluation.centipawns, evaluation.mate),
//                   style: const TextStyle(
//                     fontSize: 9,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Get evaluation color
//   /// الحصول على لون التقييم
//   Color _getEvaluationColor(int? centipawns) {
//     if (centipawns == null) return Colors.grey;
//     if (centipawns > 200) return Colors.green[700]!;
//     if (centipawns > 50) return Colors.green;
//     if (centipawns > -50) return Colors.grey;
//     if (centipawns > -200) return Colors.orange;
//     return Colors.red;
//   }

//   /// Format evaluation text
//   /// تنسيق نص التقييم
//   String _formatEvaluation(int? centipawns, int? mate) {
//     if (mate != null) {
//       return mate > 0 ? 'Mmate' : 'M{-mate}';
//     }
//     if (centipawns == null) return '0.0';

//     final pawns = centipawns / 100.0;
//     return pawns.toStringAsFixed(1);
//   }
// }

/// Widget to display the list of moves with analysis support
/// عنصر لعرض قائمة الحركات مع دعم التحليل
class MoveListWidget extends StatelessWidget {
  final List<MoveDataModel>? tokens;
  final int? currentIndex;
  final Function(int)? onMoveSelected;

  const MoveListWidget({
    super.key,
    this.tokens,
    this.currentIndex,
    this.onMoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moveTokens = tokens ?? [];

    if (moveTokens.isEmpty) {
      return const Center(
        child: Text('No moves yet', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: (moveTokens.length / 2).ceil(),
      itemBuilder: (context, index) {
        final moveNumber = index + 1;
        final whiteMove = moveTokens[index * 2];
        final blackMove = (index * 2 + 1) < moveTokens.length
            ? moveTokens[index * 2 + 1]
            : null;

        return _buildMoveRow(
          context,
          moveNumber,
          whiteMove,
          blackMove,
          index * 2,
        );
      },
    );
  }

  Widget _buildMoveRow(
    BuildContext context,
    int moveNumber,
    MoveDataModel whiteMove,
    MoveDataModel? blackMove,
    int moveIndex,
  ) {
    final analysisController = Get.isRegistered<GameAnalysisController>()
        ? Get.find<GameAnalysisController>()
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              '$moveNumber.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),

          Expanded(
            child: _buildMoveCell(
              context,
              whiteMove,
              moveIndex,
              analysisController,
            ),
          ),

          if (blackMove != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey[300]!)),
                ),
                child: _buildMoveCell(
                  context,
                  blackMove,
                  moveIndex + 1,
                  analysisController,
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildMoveCell(
    BuildContext context,
    MoveDataModel move,
    int moveIndex,
    GameAnalysisController? analysisController,
  ) {
    final isCurrentMove = currentIndex != null && moveIndex == currentIndex;
    final evaluation = analysisController?.getEvaluationForMove(moveIndex);

    return InkWell(
      onTap: onMoveSelected != null ? () => onMoveSelected!(moveIndex) : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: isCurrentMove
            ? Colors.blue.withValues(alpha: 0.2)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                move.san ?? '',
                style: TextStyle(
                  fontWeight: isCurrentMove
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                  color: isCurrentMove ? Colors.blue : Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            if (evaluation != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: _getEvaluationColor(evaluation.centipawns),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _formatEvaluation(evaluation.centipawns, evaluation.mate),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getEvaluationColor(int? centipawns) {
    if (centipawns == null) return Colors.grey;

    if (centipawns > 200) return Colors.green[700]!;
    if (centipawns > 50) return Colors.green;
    if (centipawns > -50) return Colors.grey;
    if (centipawns > -200) return Colors.orange;
    return Colors.red;
  }

  String _formatEvaluation(int? centipawns, int? mate) {
    if (mate != null) {
      return mate > 0 ? 'M$mate' : 'M${-mate}';
    }

    if (centipawns == null) return '0.0';

    final pawns = centipawns / 100.0;
    return pawns >= 0
        ? '+${pawns.toStringAsFixed(1)}'
        : pawns.toStringAsFixed(1);
  }
}
