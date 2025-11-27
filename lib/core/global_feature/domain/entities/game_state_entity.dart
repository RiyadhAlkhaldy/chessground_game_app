// lib/domain/entities/game_state_entity.dart

import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/move_data_entity.dart';
import 'package:dartchess/dartchess.dart';
import 'package:equatable/equatable.dart';

/// Entity representing the complete game state
/// كيان يمثل حالة اللعبة الكاملة مع جميع البيانات اللازمة
class GameStateEntity extends Equatable {
  /// Unique identifier for this game state
  final String gameUuid;

  /// Current position FEN
  final String currentFen;

  /// Complete position history (FENs)
  final List<String> fenHistory;

  /// FEN occurrence counts for repetition detection
  final Map<String, int> fenCounts;

  /// List of all moves played
  final List<MoveDataEntity> moves;

  /// Current half-move index (for navigation)
  final int currentHalfmoveIndex;

  /// Game result if finished
  final String? result; // "1-0", "0-1", "1/2-1/2", null

  /// Game termination reason
  final GameTermination termination; // من GameTermination enum

  /// Resignation side if applicable
  final String? resignationSide; // "white" or "black"

  /// Timeout side if applicable
  final String? timeoutSide; // "white" or "black"

  /// Agreement draw flag
  final bool agreementDraw;

  /// Half-move clock (for fifty-move rule)
  final int halfmoveClock;

  /// Material evaluation in centipawns
  final int materialEvaluation;

  /// Timestamp of last update
  final DateTime lastUpdated;

  const GameStateEntity({
    required this.gameUuid,
    required this.currentFen,
    required this.fenHistory,
    required this.fenCounts,
    required this.moves,
    this.currentHalfmoveIndex = 0,
    this.result,
    this.termination = GameTermination.ongoing,
    this.resignationSide,
    this.timeoutSide,
    this.agreementDraw = false,
    this.halfmoveClock = 0,
    this.materialEvaluation = 0,
    required this.lastUpdated,
  });

  /// Create initial game state
  factory GameStateEntity.initial(String gameUuid) {
    return GameStateEntity(
      gameUuid: gameUuid,
      currentFen: Chess.initial.fen,
      fenHistory: [Chess.initial.fen],
      fenCounts: {_normalizeFen(Chess.initial.fen): 1},
      moves: const [],
      lastUpdated: DateTime.now(),
    );
  }

  /// Normalize FEN for repetition detection
  static String _normalizeFen(String fen) {
    final parts = fen.split(' ');
    if (parts.length < 4) return fen;
    return '${parts[0]} ${parts[1]} ${parts[2]} ${parts[3]}';
  }

  /// Check if game is over
  bool get isGameOver => result != null || termination != GameTermination.ongoing;

  /// Check if current position is threefold repetition
  bool get isThreefoldRepetition {
    final normalized = _normalizeFen(currentFen);
    return (fenCounts[normalized] ?? 0) >= 3;
  }

  /// Check if fifty-move rule applies
  bool get isFiftyMoveRule => halfmoveClock >= 100;

  /// Get current turn from FEN
  Side get currentTurn {
    final parts = currentFen.split(' ');
    return parts.length > 1 && parts[1] == 'b' ? Side.black : Side.white;
  }

  @override
  List<Object?> get props => [
    gameUuid,
    currentFen,
    fenHistory,
    fenCounts,
    moves,
    currentHalfmoveIndex,
    result,
    termination,
    resignationSide,
    timeoutSide,
    agreementDraw,
    halfmoveClock,
    materialEvaluation,
    lastUpdated,
  ];

  /// Copy with method for immutability
  GameStateEntity copyWith({
    String? gameUuid,
    String? currentFen,
    List<String>? fenHistory,
    Map<String, int>? fenCounts,
    List<MoveDataEntity>? moves,
    int? currentHalfmoveIndex,
    String? result,
    GameTermination? termination,
    String? resignationSide,
    String? timeoutSide,
    bool? agreementDraw,
    int? halfmoveClock,
    int? materialEvaluation,
    DateTime? lastUpdated,
  }) {
    return GameStateEntity(
      gameUuid: gameUuid ?? this.gameUuid,
      currentFen: currentFen ?? this.currentFen,
      fenHistory: fenHistory ?? this.fenHistory,
      fenCounts: fenCounts ?? this.fenCounts,
      moves: moves ?? this.moves,
      currentHalfmoveIndex: currentHalfmoveIndex ?? this.currentHalfmoveIndex,
      result: result ?? this.result,
      termination: termination ?? this.termination,
      resignationSide: resignationSide ?? this.resignationSide,
      timeoutSide: timeoutSide ?? this.timeoutSide,
      agreementDraw: agreementDraw ?? this.agreementDraw,
      halfmoveClock: halfmoveClock ?? this.halfmoveClock,
      materialEvaluation: materialEvaluation ?? this.materialEvaluation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
