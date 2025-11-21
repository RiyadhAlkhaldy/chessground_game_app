import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:isar/isar.dart';

part 'move_data.g.dart';

@Embedded()
class MoveData {
  String? san; // e.g. "Nf3", "exd5", "O-O"
  String? lan; // e.g. "g1f3", "e4d5"
  String? comment; // نص التعليق من { ... }
  List<int>? nags;
  String? fenAfter; // FEN بعد تنفيذ الحركة
  List<String>? variations; // نص المتغيرات (يمكن أن نخزنها كنصوص خام أو تبني هيكل شجري)
  bool wasCapture = false;
  bool wasCheck = false;
  bool wasCheckmate = false;
  bool wasPromotion = false;
  bool? isWhiteMove;
  int? halfmoveIndex;
  int? moveNumber;

  @override
  String toString() =>
      "MoveData{san:$san, lan:$lan, nags:$nags, comment:$comment, fenAfter:$fenAfter }";
}

// امتداد لتحويل Isar Collection إلى MoveDataModel
extension MoveDataMapper on MoveData {
  MoveDataModel toModel() {
    return MoveDataModel(
      san: san,
      lan: lan,
      comment: comment,
      nags: nags ?? [],
      fenAfter: fenAfter,
      variations: variations ?? [],
      wasCapture: wasCapture,
      wasCheck: wasCheck,
      wasCheckmate: wasCheckmate,
      wasPromotion: wasPromotion,
      isWhiteMove: isWhiteMove,
      halfmoveIndex: halfmoveIndex,
      moveNumber: moveNumber,
    );
  }
}
