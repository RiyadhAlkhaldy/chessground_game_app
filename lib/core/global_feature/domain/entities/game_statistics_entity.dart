// lib/domain/entities/game_statistics_entity.dart

import 'package:equatable/equatable.dart';

/// Entity representing game statistics and analysis data
/// كيان يحتوي على إحصائيات وتحليلات اللعبة
class GameStatisticsEntity extends Equatable {
  /// Material counts for white
  final Map<String, int> whiteMaterial; // role name -> count

  /// Material counts for black
  final Map<String, int> blackMaterial;

  /// Captured pieces by white
  final Map<String, int> capturedByWhite;

  /// Captured pieces by black
  final Map<String, int> capturedByBlack;

  /// Total material value for white (in pawns)
  final int whiteMaterialValue;

  /// Total material value for black (in pawns)
  final int blackMaterialValue;

  /// Material advantage (positive = white, negative = black)
  final int materialAdvantage;

  /// Number of checks given by white
  final int whiteChecks;

  /// Number of checks given by black
  final int blackChecks;

  /// Number of captures by white
  final int whiteCaptures;

  /// Number of captures by black
  final int blackCaptures;

  const GameStatisticsEntity({
    required this.whiteMaterial,
    required this.blackMaterial,
    required this.capturedByWhite,
    required this.capturedByBlack,
    required this.whiteMaterialValue,
    required this.blackMaterialValue,
    required this.materialAdvantage,
    this.whiteChecks = 0,
    this.blackChecks = 0,
    this.whiteCaptures = 0,
    this.blackCaptures = 0,
  });

  /// Create initial statistics
  factory GameStatisticsEntity.initial() {
    return const GameStatisticsEntity(
      whiteMaterial: {
        'pawn': 8,
        'knight': 2,
        'bishop': 2,
        'rook': 2,
        'queen': 1,
        'king': 1,
      },
      blackMaterial: {
        'pawn': 8,
        'knight': 2,
        'bishop': 2,
        'rook': 2,
        'queen': 1,
        'king': 1,
      },
      capturedByWhite: {},
      capturedByBlack: {},
      whiteMaterialValue: 39, // 8p + 6n + 6b + 10r + 9q
      blackMaterialValue: 39,
      materialAdvantage: 0,
    );
  }

  @override
  List<Object?> get props => [
    whiteMaterial,
    blackMaterial,
    capturedByWhite,
    capturedByBlack,
    whiteMaterialValue,
    blackMaterialValue,
    materialAdvantage,
    whiteChecks,
    blackChecks,
    whiteCaptures,
    blackCaptures,
  ];

  GameStatisticsEntity copyWith({
    Map<String, int>? whiteMaterial,
    Map<String, int>? blackMaterial,
    Map<String, int>? capturedByWhite,
    Map<String, int>? capturedByBlack,
    int? whiteMaterialValue,
    int? blackMaterialValue,
    int? materialAdvantage,
    int? whiteChecks,
    int? blackChecks,
    int? whiteCaptures,
    int? blackCaptures,
  }) {
    return GameStatisticsEntity(
      whiteMaterial: whiteMaterial ?? this.whiteMaterial,
      blackMaterial: blackMaterial ?? this.blackMaterial,
      capturedByWhite: capturedByWhite ?? this.capturedByWhite,
      capturedByBlack: capturedByBlack ?? this.capturedByBlack,
      whiteMaterialValue: whiteMaterialValue ?? this.whiteMaterialValue,
      blackMaterialValue: blackMaterialValue ?? this.blackMaterialValue,
      materialAdvantage: materialAdvantage ?? this.materialAdvantage,
      whiteChecks: whiteChecks ?? this.whiteChecks,
      blackChecks: blackChecks ?? this.blackChecks,
      whiteCaptures: whiteCaptures ?? this.whiteCaptures,
      blackCaptures: blackCaptures ?? this.blackCaptures,
    );
  }
}
