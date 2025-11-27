class MoveDataEntity {
  final String? san; // e.g. "Nf3", "exd5", "O-O"
  final String? lan; // e.g. "g1f3", "e4d5"
  final String? comment; // نص التعليق من { ... }
  final List<int> nags;
  final String? fenAfter; // FEN بعد تنفيذ الحركة
  final List<String> variations; // نص المتغيرات
  final bool wasCapture;
  final bool wasCheck;
  final bool wasCheckmate;
  final bool wasPromotion;
  final bool? isWhiteMove;
  final int? halfmoveIndex;
  final int? moveNumber;

  const MoveDataEntity({
    this.san,
    this.lan,
    this.comment,
    this.nags = const [], // يجب أن تكون القوائم غير اختيارية في Entity
    this.fenAfter,
    this.variations = const [], // يجب أن تكون القوائم غير اختيارية في Entity
    this.wasCapture = false,
    this.wasCheck = false,
    this.wasCheckmate = false,
    this.wasPromotion = false,
    this.isWhiteMove,
    this.halfmoveIndex,
    this.moveNumber,
  });

  // إضافة copyWith ضرورية للحفاظ على خاصية عدم القابلية للتغيير في Entity
  MoveDataEntity copyWith({
    String? san,
    String? lan,
    String? comment,
    List<int>? nags,
    String? fenAfter,
    List<String>? variations,
    bool? wasCapture,
    bool? wasCheck,
    bool? wasCheckmate,
    bool? wasPromotion,
    bool? isWhiteMove,
    int? halfmoveIndex,
    int? moveNumber,
  }) {
    return MoveDataEntity(
      san: san ?? this.san,
      lan: lan ?? this.lan,
      comment: comment ?? this.comment,
      nags: nags ?? this.nags,
      fenAfter: fenAfter ?? this.fenAfter,
      variations: variations ?? this.variations,
      wasCapture: wasCapture ?? this.wasCapture,
      wasCheck: wasCheck ?? this.wasCheck,
      wasCheckmate: wasCheckmate ?? this.wasCheckmate,
      wasPromotion: wasPromotion ?? this.wasPromotion,
      isWhiteMove: isWhiteMove ?? this.isWhiteMove,
      halfmoveIndex: halfmoveIndex ?? this.halfmoveIndex,
      moveNumber: moveNumber ?? this.moveNumber,
    );
  }
}
