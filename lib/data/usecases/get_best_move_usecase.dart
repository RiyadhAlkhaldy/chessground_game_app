// import '../../domain/repositories/ai_repository.dart';

// // (توضيح بالعربية): هذا الـ UseCase يمثل إجراءً واحدًا: "الحصول على أفضل نقلة".
// // This class encapsulates a single, specific use case.
// class GetBestMoveUseCase {
//   // Depends on the abstraction, not the implementation.
//   // (توضيح بالعربية): يعتمد على الواجهة المجردة وليس على التنفيذ الفعلي.
//   final AIRepository _repository;

//   GetBestMoveUseCase(this._repository);

//   // The 'call' method makes the class behave like a function.
//   // (توضيح بالعربية): دالة 'call' تجعل الكلاس قابلاً للاستدعاء كدالة.
//   Future<String> call(String fen, int skillLevel) {
//     return _repository.findBestMove(fen, skillLevel);
//   }
// }
