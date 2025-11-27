import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/move_data_entity.dart';
import '../collections/move_data.dart';

part 'move_data_model.freezed.dart';
part 'move_data_model.g.dart'; // لترميز/فك ترميز JSON

@freezed
abstract class MoveDataModel with _$MoveDataModel {
  const factory MoveDataModel({
    final String? san,
    final String? lan,
    final String? comment,
    @Default([])
    final List<int> nags, // يجب جعلها غير اختيارية مع قيمة افتراضية لـ JSON
    final String? fenAfter,
    @Default([])
    final List<String> variations, // يجب جعلها غير اختيارية مع قيمة افتراضية
    @Default(false) final bool wasCapture,
    @Default(false) final bool wasCheck,
    @Default(false) final bool wasCheckmate,
    @Default(false) final bool wasPromotion,
    final bool? isWhiteMove,
    final int? halfmoveIndex,
    final int? moveNumber,
  }) = _MoveDataModel;

  // مُنشئ المصنع لتحويل JSON
  factory MoveDataModel.fromJson(Map<String, dynamic> json) =>
      _$MoveDataModelFromJson(json);
}

// ⚠️ الأهم: وظيفة التحويل (Mapper) من Model إلى Entity في طبقة البيانات
extension MoveDataModelMapper on MoveDataModel {
  // to Collection if needed in future
  // MoveDataModel can be converted to a database collection model if required
  MoveData toCollection() {
    final collection = MoveData()
      ..san = san
      ..lan = lan
      ..comment = comment
      ..nags = nags
      ..fenAfter = fenAfter
      ..variations = variations
      ..wasCapture = wasCapture
      ..wasCheck = wasCheck
      ..wasCheckmate = wasCheckmate
      ..wasPromotion = wasPromotion
      ..isWhiteMove = isWhiteMove
      ..halfmoveIndex = halfmoveIndex
      ..moveNumber = moveNumber;
    return collection;
  }

  // تحويل MoveDataModel (البيانات الخارجية) إلى MoveDataEntity (الكيان الداخلي)
  MoveDataEntity toEntity() {
    return MoveDataEntity(
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
