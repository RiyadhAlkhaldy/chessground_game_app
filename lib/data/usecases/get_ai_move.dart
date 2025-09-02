// lib/domain/usecases/get_ai_move.dart
import 'dart:developer';
import 'dart:isolate';

import 'package:dartchess/dartchess.dart';

import '../engine/search.dart'; // استيراد Isolates

class GetAiMove {
  // final GameRepository repository;
  final SearchEngine repository;

  GetAiMove(this.repository);

  /// تنفذ حالة الاستخدام.
  /// [board] هي اللوحة الحالية.
  /// [aiPlayerColor] هو لون القطع التي يلعب بها الذكاء الاصطناعي.
  /// تعيد [Move] المقترحة من الذكاء الاصطناعي، أو null إذا لم تكن هناك حركات ممكنة.
  Future<BestMoveResult?> execute(Position pos, int aiDepth) async {
    final ReceivePort receivePort = ReceivePort();
    final SendPort sendPort = receivePort.sendPort;

    // البدء في Isolate جديد لتشغيل منطق الذكاء الاصطناعي
    final Isolate aiIsolate = await Isolate.spawn(
      _aiEntrypoint, // الدالة التي سيتم تشغيلها في الـ Isolate
      {'sendPort': sendPort, 'pos': pos, 'aiDepth': aiDepth},
    );

    // انتظار النتيجة من الـ Isolate
    final dynamic result = await receivePort.first;

    // إغلاق الـ Isolate عندما ينتهي
    aiIsolate.kill();

    if (result is BestMoveResult && result.best != null) {
      log('GetAiMove: AI returned a move: $result -> $result');
      return result;
    } else if (result == null) {
      log('GetAiMove: AI returned null (no legal moves or game ended).');
      return null;
    } else {
      log('GetAiMove: Unexpected result from AI Isolate: $result');
      return null;
    }
  }

  /// نقطة الدخول لـ Isolate الذكاء الاصطناعي.
  /// هذه الدالة يجب أن تكون دالة على مستوى أعلى (top-level) أو ثابتة (static).
  void _aiEntrypoint(Map<String, dynamic> message) async {
    final SendPort sendPort = message['sendPort'] as SendPort;
    final Position pos = message['pos'] as Position;
    final int aiDepth = message['aiDepth'] as int;

    // استدعاء دالة الذكاء الاصطناعي من الـ repository
    final aiMove = repository.search(
      pos,
      const SearchLimits(maxDepth: 7, moveTime: Duration(milliseconds: 1500)),
    );

    // إرسال النتيجة مرة أخرى إلى الـ Isolate الرئيسي
    sendPort.send(aiMove);
  }
}

// import '../entities/board.dart';
// import '../entities/move.dart';
// import '../entities/piece.dart';
// import '../repositories/game_repository.dart';

// /// حالة استخدام لطلب حركة من الذكاء الاصطناعي.
// /// تعتمد على [GameRepository] للحصول على الحركات وتحديد الأفضل.
// class GetAiMove {
//   final GameRepository repository;

//   GetAiMove(this.repository);

//   /// تنفذ حالة الاستخدام.
//   /// [board] هي اللوحة الحالية.
//   /// [aiPlayerColor] هو لون القطع التي يلعب بها الذكاء الاصطناعي.
//   /// تعيد [Move] المقترحة من الذكاء الاصطناعي، أو null إذا لم تكن هناك حركات ممكنة.
//   Future<Move?> execute(
//     Board board,
//     PieceColor aiPlayerColor,
//     int aiDepth,
//   ) async {
//     return await repository.getAiMove(board, aiPlayerColor, aiDepth);
//   }
// }
