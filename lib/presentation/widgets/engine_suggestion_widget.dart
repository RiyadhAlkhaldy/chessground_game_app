import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analyises_controller.dart';

class EngineSuggestionsWidget extends GetView<AnalysisController> {
  const EngineSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pv = controller.evaluation.value.pv;
      if (pv.isEmpty) {
        return const SizedBox(height: 24, child: Center(child: Text("...")));
      }
      
      final bestMove = pv.split(' ').first;
      final continuation = pv.length > 1 ? pv.split('').take(4).join(' ') : '';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15),
            children: [
              TextSpan(
                text: bestMove,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                text: continuation,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}