// إضافات مطلوبة
import 'dart:math' as math;

// هذا الكائن يمثل نتيجة تقييم واحدة من المحرك
// وهو مطابق للكائن Evaluation الموجود في الكود المرجعي
import 'package:freezed_annotation/freezed_annotation.dart';

part 'extended_evaluation.freezed.dart';
part 'extended_evaluation.g.dart';

// نموذج تقييم موسّع
@freezed
abstract class ExtendedEvaluation with _$ExtendedEvaluation {
  const factory ExtendedEvaluation({
    required int depth,
    int? cp, // centipawns (من منظور white عادةً)
    int? mate, // mate in N (±)
    @Default('') String pv,
    int? wdlWin, // permille: 500 => 50.0%
    int? wdlDraw,
    int? wdlLoss,
  }) = _ExtendedEvaluation;

  factory ExtendedEvaluation.fromJson(Map<String, dynamic> json) =>
      _$ExtendedEvaluationFromJson(json);
  factory ExtendedEvaluation.initial() => const ExtendedEvaluation(depth: 0);
}

extension ExtendedEvaluationComplete on ExtendedEvaluation {
  double whiteWinPercent({double k = 0.00368208}) {
    if (wdlWin != null) return (wdlWin!.toDouble() / 10.0);
    final int effectiveCp;
    if (cp != null) {
      effectiveCp = cp!;
    } else if (mate != null) {
      effectiveCp = mate! > 0 ? 100000 : -100000; // تمثيل كبير لمات
    } else {
      effectiveCp = 0;
    }
    final p = 100.0 / (1.0 + math.exp(-k * effectiveCp));
    return p.clamp(0.0, 100.0);
  }

  double blackWinPercent({double k = 0.00368208}) {
    return 100.0 - whiteWinPercent(k: k);
  }
}
