// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameModelCollection on Isar {
  IsarCollection<GameModel> get gameModels => this.collection();
}

const GameModelSchema = CollectionSchema(
  name: r'GameModel',
  id: 5060082259723093958,
  properties: {
    r'blacksTime': PropertySchema(
      id: 0,
      name: r'blacksTime',
      type: IsarType.string,
    ),
    r'endedAt': PropertySchema(
      id: 1,
      name: r'endedAt',
      type: IsarType.dateTime,
    ),
    r'fens': PropertySchema(
      id: 2,
      name: r'fens',
      type: IsarType.stringList,
    ),
    r'isGameOver': PropertySchema(
      id: 3,
      name: r'isGameOver',
      type: IsarType.bool,
    ),
    r'moves': PropertySchema(
      id: 4,
      name: r'moves',
      type: IsarType.stringList,
    ),
    r'movesUci': PropertySchema(
      id: 5,
      name: r'movesUci',
      type: IsarType.stringList,
    ),
    r'ownerIsWhite': PropertySchema(
      id: 6,
      name: r'ownerIsWhite',
      type: IsarType.bool,
    ),
    r'ownerUuid': PropertySchema(
      id: 7,
      name: r'ownerUuid',
      type: IsarType.string,
    ),
    r'pgn': PropertySchema(
      id: 8,
      name: r'pgn',
      type: IsarType.string,
    ),
    r'result': PropertySchema(
      id: 9,
      name: r'result',
      type: IsarType.byte,
      enumMap: _GameModelresultEnumValueMap,
    ),
    r'startedAt': PropertySchema(
      id: 10,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'whitesTime': PropertySchema(
      id: 11,
      name: r'whitesTime',
      type: IsarType.string,
    )
  },
  estimateSize: _gameModelEstimateSize,
  serialize: _gameModelSerialize,
  deserialize: _gameModelDeserialize,
  deserializeProp: _gameModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'result': IndexSchema(
      id: -2959080351604392084,
      name: r'result',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'result',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'whitePlayer': LinkSchema(
      id: -4891425989861196108,
      name: r'whitePlayer',
      target: r'Player',
      single: true,
    ),
    r'blackPlayer': LinkSchema(
      id: -8500585514346635941,
      name: r'blackPlayer',
      target: r'Player',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _gameModelGetId,
  getLinks: _gameModelGetLinks,
  attach: _gameModelAttach,
  version: '3.1.0+1',
);

int _gameModelEstimateSize(
  GameModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.blacksTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fens.length * 3;
  {
    for (var i = 0; i < object.fens.length; i++) {
      final value = object.fens[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.moves.length * 3;
  {
    for (var i = 0; i < object.moves.length; i++) {
      final value = object.moves[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.movesUci.length * 3;
  {
    for (var i = 0; i < object.movesUci.length; i++) {
      final value = object.movesUci[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.ownerUuid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pgn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.whitesTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _gameModelSerialize(
  GameModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.blacksTime);
  writer.writeDateTime(offsets[1], object.endedAt);
  writer.writeStringList(offsets[2], object.fens);
  writer.writeBool(offsets[3], object.isGameOver);
  writer.writeStringList(offsets[4], object.moves);
  writer.writeStringList(offsets[5], object.movesUci);
  writer.writeBool(offsets[6], object.ownerIsWhite);
  writer.writeString(offsets[7], object.ownerUuid);
  writer.writeString(offsets[8], object.pgn);
  writer.writeByte(offsets[9], object.result.index);
  writer.writeDateTime(offsets[10], object.startedAt);
  writer.writeString(offsets[11], object.whitesTime);
}

GameModel _gameModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameModel();
  object.blacksTime = reader.readStringOrNull(offsets[0]);
  object.endedAt = reader.readDateTimeOrNull(offsets[1]);
  object.fens = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.isGameOver = reader.readBool(offsets[3]);
  object.moves = reader.readStringList(offsets[4]) ?? [];
  object.movesUci = reader.readStringList(offsets[5]) ?? [];
  object.ownerIsWhite = reader.readBool(offsets[6]);
  object.ownerUuid = reader.readStringOrNull(offsets[7]);
  object.pgn = reader.readStringOrNull(offsets[8]);
  object.result =
      _GameModelresultValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          GameResult.ongoing;
  object.startedAt = reader.readDateTime(offsets[10]);
  object.whitesTime = reader.readStringOrNull(offsets[11]);
  return object;
}

P _gameModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_GameModelresultValueEnumMap[reader.readByteOrNull(offset)] ??
          GameResult.ongoing) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GameModelresultEnumValueMap = {
  'ongoing': 0,
  'checkmate': 1,
  'stalemate': 2,
  'draw': 3,
  'timeout': 4,
  'whiteWon': 5,
  'blackWon': 6,
};
const _GameModelresultValueEnumMap = {
  0: GameResult.ongoing,
  1: GameResult.checkmate,
  2: GameResult.stalemate,
  3: GameResult.draw,
  4: GameResult.timeout,
  5: GameResult.whiteWon,
  6: GameResult.blackWon,
};

Id _gameModelGetId(GameModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameModelGetLinks(GameModel object) {
  return [object.whitePlayer, object.blackPlayer];
}

void _gameModelAttach(IsarCollection<dynamic> col, Id id, GameModel object) {
  object.id = id;
  object.whitePlayer
      .attach(col, col.isar.collection<Player>(), r'whitePlayer', id);
  object.blackPlayer
      .attach(col, col.isar.collection<Player>(), r'blackPlayer', id);
}

extension GameModelQueryWhereSort
    on QueryBuilder<GameModel, GameModel, QWhere> {
  QueryBuilder<GameModel, GameModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhere> anyResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'result'),
      );
    });
  }
}

extension GameModelQueryWhere
    on QueryBuilder<GameModel, GameModel, QWhereClause> {
  QueryBuilder<GameModel, GameModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> resultEqualTo(
      GameResult result) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'result',
        value: [result],
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> resultNotEqualTo(
      GameResult result) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'result',
              lower: [],
              upper: [result],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'result',
              lower: [result],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'result',
              lower: [result],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'result',
              lower: [],
              upper: [result],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> resultGreaterThan(
    GameResult result, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'result',
        lower: [result],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> resultLessThan(
    GameResult result, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'result',
        lower: [],
        upper: [result],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterWhereClause> resultBetween(
    GameResult lowerResult,
    GameResult upperResult, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'result',
        lower: [lowerResult],
        includeLower: includeLower,
        upper: [upperResult],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GameModelQueryFilter
    on QueryBuilder<GameModel, GameModel, QFilterCondition> {
  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blacksTime',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blacksTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blacksTime',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blacksTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blacksTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blacksTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blacksTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blacksTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blacksTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blacksTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blacksTime',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blacksTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blacksTime',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> endedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      fensElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fens',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      fensElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fens',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      fensElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fens',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      fensElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fens',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      fensLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> fensLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fens',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> isGameOverEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGameOver',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moves',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moves',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moves',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moves',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moves',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movesUci',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'movesUci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'movesUci',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movesUci',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'movesUci',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> movesUciIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      movesUciLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movesUci',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerIsWhiteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerIsWhite',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerUuid',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      ownerUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerUuid',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      ownerUuidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> ownerUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      ownerUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pgn',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pgn',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pgn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pgn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pgn',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> pgnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pgn',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> resultEqualTo(
      GameResult value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> resultGreaterThan(
    GameResult value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'result',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> resultLessThan(
    GameResult value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'result',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> resultBetween(
    GameResult lower,
    GameResult upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'result',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> startedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'whitesTime',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitesTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'whitesTime',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitesTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whitesTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitesTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'whitesTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitesTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'whitesTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitesTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whitesTime',
        value: '',
      ));
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitesTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'whitesTime',
        value: '',
      ));
    });
  }
}

extension GameModelQueryObject
    on QueryBuilder<GameModel, GameModel, QFilterCondition> {}

extension GameModelQueryLinks
    on QueryBuilder<GameModel, GameModel, QFilterCondition> {
  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> whitePlayer(
      FilterQuery<Player> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'whitePlayer');
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      whitePlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'whitePlayer', 0, true, 0, true);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition> blackPlayer(
      FilterQuery<Player> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'blackPlayer');
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterFilterCondition>
      blackPlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blackPlayer', 0, true, 0, true);
    });
  }
}

extension GameModelQuerySortBy on QueryBuilder<GameModel, GameModel, QSortBy> {
  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByBlacksTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blacksTime', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByBlacksTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blacksTime', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByIsGameOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGameOver', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByIsGameOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGameOver', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByOwnerIsWhite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerIsWhite', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByOwnerIsWhiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerIsWhite', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByOwnerUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUuid', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByOwnerUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUuid', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByWhitesTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitesTime', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> sortByWhitesTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitesTime', Sort.desc);
    });
  }
}

extension GameModelQuerySortThenBy
    on QueryBuilder<GameModel, GameModel, QSortThenBy> {
  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByBlacksTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blacksTime', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByBlacksTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blacksTime', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByIsGameOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGameOver', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByIsGameOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGameOver', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByOwnerIsWhite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerIsWhite', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByOwnerIsWhiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerIsWhite', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByOwnerUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUuid', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByOwnerUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUuid', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByWhitesTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitesTime', Sort.asc);
    });
  }

  QueryBuilder<GameModel, GameModel, QAfterSortBy> thenByWhitesTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitesTime', Sort.desc);
    });
  }
}

extension GameModelQueryWhereDistinct
    on QueryBuilder<GameModel, GameModel, QDistinct> {
  QueryBuilder<GameModel, GameModel, QDistinct> distinctByBlacksTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blacksTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endedAt');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByFens() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fens');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByIsGameOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGameOver');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByMoves() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moves');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByMovesUci() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movesUci');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByOwnerIsWhite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerIsWhite');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByOwnerUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByPgn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pgn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'result');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<GameModel, GameModel, QDistinct> distinctByWhitesTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whitesTime', caseSensitive: caseSensitive);
    });
  }
}

extension GameModelQueryProperty
    on QueryBuilder<GameModel, GameModel, QQueryProperty> {
  QueryBuilder<GameModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameModel, String?, QQueryOperations> blacksTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blacksTime');
    });
  }

  QueryBuilder<GameModel, DateTime?, QQueryOperations> endedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endedAt');
    });
  }

  QueryBuilder<GameModel, List<String>, QQueryOperations> fensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fens');
    });
  }

  QueryBuilder<GameModel, bool, QQueryOperations> isGameOverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGameOver');
    });
  }

  QueryBuilder<GameModel, List<String>, QQueryOperations> movesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moves');
    });
  }

  QueryBuilder<GameModel, List<String>, QQueryOperations> movesUciProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movesUci');
    });
  }

  QueryBuilder<GameModel, bool, QQueryOperations> ownerIsWhiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerIsWhite');
    });
  }

  QueryBuilder<GameModel, String?, QQueryOperations> ownerUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUuid');
    });
  }

  QueryBuilder<GameModel, String?, QQueryOperations> pgnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pgn');
    });
  }

  QueryBuilder<GameModel, GameResult, QQueryOperations> resultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'result');
    });
  }

  QueryBuilder<GameModel, DateTime, QQueryOperations> startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<GameModel, String?, QQueryOperations> whitesTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whitesTime');
    });
  }
}
