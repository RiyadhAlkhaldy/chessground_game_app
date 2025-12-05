// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_analysis.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameAnalysisCollection on Isar {
  IsarCollection<GameAnalysis> get gameAnalysis => this.collection();
}

const GameAnalysisSchema = CollectionSchema(
  name: r'GameAnalysis',
  id: -4742286922586306817,
  properties: {
    r'analyzedAt': PropertySchema(
      id: 0,
      name: r'analyzedAt',
      type: IsarType.dateTime,
    ),
    r'blackAccuracy': PropertySchema(
      id: 1,
      name: r'blackAccuracy',
      type: IsarType.double,
    ),
    r'blackBlunders': PropertySchema(
      id: 2,
      name: r'blackBlunders',
      type: IsarType.long,
    ),
    r'blackInaccuracies': PropertySchema(
      id: 3,
      name: r'blackInaccuracies',
      type: IsarType.long,
    ),
    r'blackMistakes': PropertySchema(
      id: 4,
      name: r'blackMistakes',
      type: IsarType.long,
    ),
    r'completionPercentage': PropertySchema(
      id: 5,
      name: r'completionPercentage',
      type: IsarType.double,
    ),
    r'eco': PropertySchema(
      id: 6,
      name: r'eco',
      type: IsarType.string,
    ),
    r'gameUuid': PropertySchema(
      id: 7,
      name: r'gameUuid',
      type: IsarType.string,
    ),
    r'moveEvaluationsJson': PropertySchema(
      id: 8,
      name: r'moveEvaluationsJson',
      type: IsarType.string,
    ),
    r'openingName': PropertySchema(
      id: 9,
      name: r'openingName',
      type: IsarType.string,
    ),
    r'whiteAccuracy': PropertySchema(
      id: 10,
      name: r'whiteAccuracy',
      type: IsarType.double,
    ),
    r'whiteBlunders': PropertySchema(
      id: 11,
      name: r'whiteBlunders',
      type: IsarType.long,
    ),
    r'whiteInaccuracies': PropertySchema(
      id: 12,
      name: r'whiteInaccuracies',
      type: IsarType.long,
    ),
    r'whiteMistakes': PropertySchema(
      id: 13,
      name: r'whiteMistakes',
      type: IsarType.long,
    )
  },
  estimateSize: _gameAnalysisEstimateSize,
  serialize: _gameAnalysisSerialize,
  deserialize: _gameAnalysisDeserialize,
  deserializeProp: _gameAnalysisDeserializeProp,
  idName: r'id',
  indexes: {
    r'gameUuid': IndexSchema(
      id: 6587011174316830407,
      name: r'gameUuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'gameUuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _gameAnalysisGetId,
  getLinks: _gameAnalysisGetLinks,
  attach: _gameAnalysisAttach,
  version: '3.1.0+1',
);

int _gameAnalysisEstimateSize(
  GameAnalysis object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.eco;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.gameUuid.length * 3;
  bytesCount += 3 + object.moveEvaluationsJson.length * 3;
  {
    final value = object.openingName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _gameAnalysisSerialize(
  GameAnalysis object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.analyzedAt);
  writer.writeDouble(offsets[1], object.blackAccuracy);
  writer.writeLong(offsets[2], object.blackBlunders);
  writer.writeLong(offsets[3], object.blackInaccuracies);
  writer.writeLong(offsets[4], object.blackMistakes);
  writer.writeDouble(offsets[5], object.completionPercentage);
  writer.writeString(offsets[6], object.eco);
  writer.writeString(offsets[7], object.gameUuid);
  writer.writeString(offsets[8], object.moveEvaluationsJson);
  writer.writeString(offsets[9], object.openingName);
  writer.writeDouble(offsets[10], object.whiteAccuracy);
  writer.writeLong(offsets[11], object.whiteBlunders);
  writer.writeLong(offsets[12], object.whiteInaccuracies);
  writer.writeLong(offsets[13], object.whiteMistakes);
}

GameAnalysis _gameAnalysisDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameAnalysis();
  object.analyzedAt = reader.readDateTime(offsets[0]);
  object.blackAccuracy = reader.readDoubleOrNull(offsets[1]);
  object.blackBlunders = reader.readLong(offsets[2]);
  object.blackInaccuracies = reader.readLong(offsets[3]);
  object.blackMistakes = reader.readLong(offsets[4]);
  object.completionPercentage = reader.readDouble(offsets[5]);
  object.eco = reader.readStringOrNull(offsets[6]);
  object.gameUuid = reader.readString(offsets[7]);
  object.id = id;
  object.moveEvaluationsJson = reader.readString(offsets[8]);
  object.openingName = reader.readStringOrNull(offsets[9]);
  object.whiteAccuracy = reader.readDoubleOrNull(offsets[10]);
  object.whiteBlunders = reader.readLong(offsets[11]);
  object.whiteInaccuracies = reader.readLong(offsets[12]);
  object.whiteMistakes = reader.readLong(offsets[13]);
  return object;
}

P _gameAnalysisDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameAnalysisGetId(GameAnalysis object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameAnalysisGetLinks(GameAnalysis object) {
  return [];
}

void _gameAnalysisAttach(
    IsarCollection<dynamic> col, Id id, GameAnalysis object) {
  object.id = id;
}

extension GameAnalysisByIndex on IsarCollection<GameAnalysis> {
  Future<GameAnalysis?> getByGameUuid(String gameUuid) {
    return getByIndex(r'gameUuid', [gameUuid]);
  }

  GameAnalysis? getByGameUuidSync(String gameUuid) {
    return getByIndexSync(r'gameUuid', [gameUuid]);
  }

  Future<bool> deleteByGameUuid(String gameUuid) {
    return deleteByIndex(r'gameUuid', [gameUuid]);
  }

  bool deleteByGameUuidSync(String gameUuid) {
    return deleteByIndexSync(r'gameUuid', [gameUuid]);
  }

  Future<List<GameAnalysis?>> getAllByGameUuid(List<String> gameUuidValues) {
    final values = gameUuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'gameUuid', values);
  }

  List<GameAnalysis?> getAllByGameUuidSync(List<String> gameUuidValues) {
    final values = gameUuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'gameUuid', values);
  }

  Future<int> deleteAllByGameUuid(List<String> gameUuidValues) {
    final values = gameUuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'gameUuid', values);
  }

  int deleteAllByGameUuidSync(List<String> gameUuidValues) {
    final values = gameUuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'gameUuid', values);
  }

  Future<Id> putByGameUuid(GameAnalysis object) {
    return putByIndex(r'gameUuid', object);
  }

  Id putByGameUuidSync(GameAnalysis object, {bool saveLinks = true}) {
    return putByIndexSync(r'gameUuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGameUuid(List<GameAnalysis> objects) {
    return putAllByIndex(r'gameUuid', objects);
  }

  List<Id> putAllByGameUuidSync(List<GameAnalysis> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'gameUuid', objects, saveLinks: saveLinks);
  }
}

extension GameAnalysisQueryWhereSort
    on QueryBuilder<GameAnalysis, GameAnalysis, QWhere> {
  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameAnalysisQueryWhere
    on QueryBuilder<GameAnalysis, GameAnalysis, QWhereClause> {
  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause> gameUuidEqualTo(
      String gameUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'gameUuid',
        value: [gameUuid],
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterWhereClause>
      gameUuidNotEqualTo(String gameUuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gameUuid',
              lower: [],
              upper: [gameUuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gameUuid',
              lower: [gameUuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gameUuid',
              lower: [gameUuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gameUuid',
              lower: [],
              upper: [gameUuid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GameAnalysisQueryFilter
    on QueryBuilder<GameAnalysis, GameAnalysis, QFilterCondition> {
  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      analyzedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'analyzedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      analyzedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'analyzedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      analyzedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'analyzedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      analyzedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'analyzedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blackAccuracy',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blackAccuracy',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackAccuracyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackAccuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackBlundersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackBlundersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackBlundersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackBlundersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackBlunders',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackInaccuraciesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackInaccuraciesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackInaccuraciesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackInaccuraciesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackInaccuracies',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackMistakesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackMistakesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackMistakesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      blackMistakesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackMistakes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      completionPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      completionPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      completionPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      completionPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eco',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      ecoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eco',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      ecoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eco',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eco',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eco',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> ecoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eco',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      ecoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eco',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gameUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gameUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      gameUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gameUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moveEvaluationsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moveEvaluationsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moveEvaluationsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveEvaluationsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      moveEvaluationsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moveEvaluationsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openingName',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openingName',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openingName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'openingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'openingName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openingName',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      openingNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'openingName',
        value: '',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'whiteAccuracy',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'whiteAccuracy',
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteAccuracyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteAccuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteBlundersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteBlundersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteBlundersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteBlunders',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteBlundersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteBlunders',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteInaccuraciesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteInaccuraciesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteInaccuraciesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteInaccuracies',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteInaccuraciesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteInaccuracies',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteMistakesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteMistakesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteMistakesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterFilterCondition>
      whiteMistakesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteMistakes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GameAnalysisQueryObject
    on QueryBuilder<GameAnalysis, GameAnalysis, QFilterCondition> {}

extension GameAnalysisQueryLinks
    on QueryBuilder<GameAnalysis, GameAnalysis, QFilterCondition> {}

extension GameAnalysisQuerySortBy
    on QueryBuilder<GameAnalysis, GameAnalysis, QSortBy> {
  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByAnalyzedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyzedAt', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByAnalyzedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyzedAt', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByBlackAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackAccuracy', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByBlackAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackAccuracy', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByBlackBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackBlunders', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByBlackBlundersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackBlunders', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByBlackInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackInaccuracies', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByBlackInaccuraciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackInaccuracies', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByBlackMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackMistakes', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByBlackMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackMistakes', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByEco() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByEcoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByGameUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameUuid', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByGameUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameUuid', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByMoveEvaluationsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveEvaluationsJson', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByMoveEvaluationsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveEvaluationsJson', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByOpeningName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingName', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByOpeningNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingName', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByWhiteAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteAccuracy', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByWhiteAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteAccuracy', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByWhiteBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteBlunders', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByWhiteBlundersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteBlunders', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByWhiteInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteInaccuracies', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByWhiteInaccuraciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteInaccuracies', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> sortByWhiteMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteMistakes', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      sortByWhiteMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteMistakes', Sort.desc);
    });
  }
}

extension GameAnalysisQuerySortThenBy
    on QueryBuilder<GameAnalysis, GameAnalysis, QSortThenBy> {
  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByAnalyzedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyzedAt', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByAnalyzedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyzedAt', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByBlackAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackAccuracy', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByBlackAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackAccuracy', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByBlackBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackBlunders', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByBlackBlundersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackBlunders', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByBlackInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackInaccuracies', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByBlackInaccuraciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackInaccuracies', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByBlackMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackMistakes', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByBlackMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackMistakes', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByEco() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByEcoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByGameUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameUuid', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByGameUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameUuid', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByMoveEvaluationsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveEvaluationsJson', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByMoveEvaluationsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveEvaluationsJson', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByOpeningName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingName', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByOpeningNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingName', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByWhiteAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteAccuracy', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByWhiteAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteAccuracy', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByWhiteBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteBlunders', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByWhiteBlundersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteBlunders', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByWhiteInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteInaccuracies', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByWhiteInaccuraciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteInaccuracies', Sort.desc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy> thenByWhiteMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteMistakes', Sort.asc);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QAfterSortBy>
      thenByWhiteMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteMistakes', Sort.desc);
    });
  }
}

extension GameAnalysisQueryWhereDistinct
    on QueryBuilder<GameAnalysis, GameAnalysis, QDistinct> {
  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct> distinctByAnalyzedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'analyzedAt');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByBlackAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackAccuracy');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByBlackBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackBlunders');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByBlackInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackInaccuracies');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByBlackMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackMistakes');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionPercentage');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct> distinctByEco(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eco', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct> distinctByGameUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByMoveEvaluationsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveEvaluationsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct> distinctByOpeningName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByWhiteAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteAccuracy');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByWhiteBlunders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteBlunders');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByWhiteInaccuracies() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteInaccuracies');
    });
  }

  QueryBuilder<GameAnalysis, GameAnalysis, QDistinct>
      distinctByWhiteMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteMistakes');
    });
  }
}

extension GameAnalysisQueryProperty
    on QueryBuilder<GameAnalysis, GameAnalysis, QQueryProperty> {
  QueryBuilder<GameAnalysis, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameAnalysis, DateTime, QQueryOperations> analyzedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'analyzedAt');
    });
  }

  QueryBuilder<GameAnalysis, double?, QQueryOperations>
      blackAccuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackAccuracy');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations> blackBlundersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackBlunders');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations>
      blackInaccuraciesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackInaccuracies');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations> blackMistakesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackMistakes');
    });
  }

  QueryBuilder<GameAnalysis, double, QQueryOperations>
      completionPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionPercentage');
    });
  }

  QueryBuilder<GameAnalysis, String?, QQueryOperations> ecoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eco');
    });
  }

  QueryBuilder<GameAnalysis, String, QQueryOperations> gameUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameUuid');
    });
  }

  QueryBuilder<GameAnalysis, String, QQueryOperations>
      moveEvaluationsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveEvaluationsJson');
    });
  }

  QueryBuilder<GameAnalysis, String?, QQueryOperations> openingNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingName');
    });
  }

  QueryBuilder<GameAnalysis, double?, QQueryOperations>
      whiteAccuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteAccuracy');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations> whiteBlundersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteBlunders');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations>
      whiteInaccuraciesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteInaccuracies');
    });
  }

  QueryBuilder<GameAnalysis, int, QQueryOperations> whiteMistakesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteMistakes');
    });
  }
}
