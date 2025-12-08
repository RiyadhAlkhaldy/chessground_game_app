// lib/features/puzzle/domain/entities/chess_puzzle_entity.dart

import 'package:equatable/equatable.dart';

/// Entity representing a chess puzzle
/// كيان يمثل لغز شطرنج
class ChessPuzzleEntity extends Equatable {
  /// Unique puzzle ID
  final String id;

  /// Initial FEN position
  final String fen;

  /// Correct solution moves (UCI format)
  final List<String> solution;

  /// Puzzle rating/difficulty
  final int rating;

  /// Puzzle themes (e.g., "mate in 2", "pin", "fork")
  final List<String> themes;

  /// Number of moves in solution
  final int movesToSolve;

  /// Side to move (who should solve the puzzle)
  final String sideToMove;

  /// Puzzle title/description
  final String? description;

  /// Source (e.g., "Lichess", "Custom")
  final String? source;

  /// Creation date
  final DateTime createdAt;

  const ChessPuzzleEntity({
    required this.id,
    required this.fen,
    required this.solution,
    required this.rating,
    required this.themes,
    required this.movesToSolve,
    required this.sideToMove,
    this.description,
    this.source,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        fen,
        solution,
        rating,
        themes,
        movesToSolve,
        sideToMove,
        description,
        source,
        createdAt,
      ];

  ChessPuzzleEntity copyWith({
    String? id,
    String? fen,
    List<String>? solution,
    int? rating,
    List<String>? themes,
    int? movesToSolve,
    String? sideToMove,
    String? description,
    String? source,
    DateTime? createdAt,
  }) {
    return ChessPuzzleEntity(
      id: id ?? this.id,
      fen: fen ?? this.fen,
      solution: solution ?? this.solution,
      rating: rating ?? this.rating,
      themes: themes ?? this.themes,
      movesToSolve: movesToSolve ?? this.movesToSolve,
      sideToMove: sideToMove ?? this.sideToMove,
      description: description ?? this.description,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Entity for puzzle attempt/result
/// كيان لمحاولة/نتيجة اللغز
class PuzzleAttemptEntity extends Equatable {
  final String puzzleId;
  final bool solved;
  final int movesTaken;
  final int timeTaken; // seconds
  final DateTime attemptedAt;
  final int? ratingChange;

  const PuzzleAttemptEntity({
    required this.puzzleId,
    required this.solved,
    required this.movesTaken,
    required this.timeTaken,
    required this.attemptedAt,
    this.ratingChange,
  });

  @override
  List<Object?> get props => [
        puzzleId,
        solved,
        movesTaken,
        timeTaken,
        attemptedAt,
        ratingChange,
      ];
}
