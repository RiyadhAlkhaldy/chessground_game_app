// file: domain/entities/game_record.dart

import 'package:isar/isar.dart';

part 'game_record.g.dart'; // ملف سيتم إنشاؤه تلقائيًا

enum GameTermination {
  checkmate,
  stalemate,
  timeout,
  resignation,
  agreement,
  threefoldRepetition,
  fiftyMoveRule,
  insufficientMaterial,
}

@collection
class GameRecord {
  Id id = Isar.autoIncrement; // مفتاح أساسي

  @Index()
  late DateTime date;

  late String whitePlayer;
  late String blackPlayer;

  // لتخزين نتيجة اللعبة
  String? result; // "1-0", "0-1", "1/2-1/2"

  @enumerated
  late GameTermination termination;

  // تخزين الحركات بصيغة PGN لسهولة العرض والمشاركة
  String? pgn;

  // تخزين الحركات بصيغة UCI لمعالجتها برمجيًا
  List<String> uciMoves;

  String initialFen;

  int? gameDurationSeconds;

  GameRecord({
    required this.date,
    this.whitePlayer = 'Human',
    this.blackPlayer = 'Stockfish',
    this.result,
    required this.termination,
    this.pgn,
    this.uciMoves = const [],
    this.initialFen =
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    this.gameDurationSeconds,
  });
}
