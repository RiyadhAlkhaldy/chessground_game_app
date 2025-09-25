// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameRecordCollection on Isar {
  IsarCollection<GameRecord> get gameRecords => this.collection();
}

const GameRecordSchema = CollectionSchema(
  name: r'GameRecord',
  id: -6532740413139521718,
  properties: {
    r'blackPlayer': PropertySchema(
      id: 0,
      name: r'blackPlayer',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'gameDurationSeconds': PropertySchema(
      id: 2,
      name: r'gameDurationSeconds',
      type: IsarType.long,
    ),
    r'initialFen': PropertySchema(
      id: 3,
      name: r'initialFen',
      type: IsarType.string,
    ),
    r'pgn': PropertySchema(
      id: 4,
      name: r'pgn',
      type: IsarType.string,
    ),
    r'result': PropertySchema(
      id: 5,
      name: r'result',
      type: IsarType.string,
    ),
    r'termination': PropertySchema(
      id: 6,
      name: r'termination',
      type: IsarType.byte,
      enumMap: _GameRecordterminationEnumValueMap,
    ),
    r'uciMoves': PropertySchema(
      id: 7,
      name: r'uciMoves',
      type: IsarType.stringList,
    ),
    r'whitePlayer': PropertySchema(
      id: 8,
      name: r'whitePlayer',
      type: IsarType.string,
    )
  },
  estimateSize: _gameRecordEstimateSize,
  serialize: _gameRecordSerialize,
  deserialize: _gameRecordDeserialize,
  deserializeProp: _gameRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _gameRecordGetId,
  getLinks: _gameRecordGetLinks,
  attach: _gameRecordAttach,
  version: '3.1.0+1',
);

int _gameRecordEstimateSize(
  GameRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.blackPlayer.length * 3;
  bytesCount += 3 + object.initialFen.length * 3;
  {
    final value = object.pgn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.result;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uciMoves.length * 3;
  {
    for (var i = 0; i < object.uciMoves.length; i++) {
      final value = object.uciMoves[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.whitePlayer.length * 3;
  return bytesCount;
}

void _gameRecordSerialize(
  GameRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.blackPlayer);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.gameDurationSeconds);
  writer.writeString(offsets[3], object.initialFen);
  writer.writeString(offsets[4], object.pgn);
  writer.writeString(offsets[5], object.result);
  writer.writeByte(offsets[6], object.termination.index);
  writer.writeStringList(offsets[7], object.uciMoves);
  writer.writeString(offsets[8], object.whitePlayer);
}

GameRecord _gameRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameRecord(
    blackPlayer: reader.readStringOrNull(offsets[0]) ?? 'Stockfish',
    date: reader.readDateTime(offsets[1]),
    gameDurationSeconds: reader.readLongOrNull(offsets[2]),
    initialFen: reader.readStringOrNull(offsets[3]) ??
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    pgn: reader.readStringOrNull(offsets[4]),
    result: reader.readStringOrNull(offsets[5]),
    termination:
        _GameRecordterminationValueEnumMap[reader.readByteOrNull(offsets[6])] ??
            GameTermination.checkmate,
    uciMoves: reader.readStringList(offsets[7]) ?? const [],
    whitePlayer: reader.readStringOrNull(offsets[8]) ?? 'Human',
  );
  object.id = id;
  return object;
}

P _gameRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? 'Stockfish') as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ??
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1') as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_GameRecordterminationValueEnumMap[
              reader.readByteOrNull(offset)] ??
          GameTermination.checkmate) as P;
    case 7:
      return (reader.readStringList(offset) ?? const []) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? 'Human') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GameRecordterminationEnumValueMap = {
  'checkmate': 0,
  'stalemate': 1,
  'timeout': 2,
  'resignation': 3,
  'agreement': 4,
  'threefoldRepetition': 5,
  'fiftyMoveRule': 6,
  'insufficientMaterial': 7,
};
const _GameRecordterminationValueEnumMap = {
  0: GameTermination.checkmate,
  1: GameTermination.stalemate,
  2: GameTermination.timeout,
  3: GameTermination.resignation,
  4: GameTermination.agreement,
  5: GameTermination.threefoldRepetition,
  6: GameTermination.fiftyMoveRule,
  7: GameTermination.insufficientMaterial,
};

Id _gameRecordGetId(GameRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameRecordGetLinks(GameRecord object) {
  return [];
}

void _gameRecordAttach(IsarCollection<dynamic> col, Id id, GameRecord object) {
  object.id = id;
}

extension GameRecordQueryWhereSort
    on QueryBuilder<GameRecord, GameRecord, QWhere> {
  QueryBuilder<GameRecord, GameRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension GameRecordQueryWhere
    on QueryBuilder<GameRecord, GameRecord, QWhereClause> {
  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GameRecordQueryFilter
    on QueryBuilder<GameRecord, GameRecord, QFilterCondition> {
  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackPlayer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blackPlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blackPlayer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackPlayer',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      blackPlayerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blackPlayer',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gameDurationSeconds',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gameDurationSeconds',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      gameDurationSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> initialFenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> initialFenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialFen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'initialFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> initialFenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'initialFen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialFen',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      initialFenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'initialFen',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pgn',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pgn',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnEqualTo(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnGreaterThan(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnLessThan(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnBetween(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnStartsWith(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnEndsWith(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnContains(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnMatches(
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

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pgn',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> pgnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pgn',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      resultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'result',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'result',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition> resultIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      resultIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'result',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      terminationEqualTo(GameTermination value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termination',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      terminationGreaterThan(
    GameTermination value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'termination',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      terminationLessThan(
    GameTermination value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'termination',
        value: value,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      terminationBetween(
    GameTermination lower,
    GameTermination upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'termination',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uciMoves',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uciMoves',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uciMoves',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uciMoves',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uciMoves',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      uciMovesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uciMoves',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whitePlayer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'whitePlayer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'whitePlayer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whitePlayer',
        value: '',
      ));
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterFilterCondition>
      whitePlayerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'whitePlayer',
        value: '',
      ));
    });
  }
}

extension GameRecordQueryObject
    on QueryBuilder<GameRecord, GameRecord, QFilterCondition> {}

extension GameRecordQueryLinks
    on QueryBuilder<GameRecord, GameRecord, QFilterCondition> {}

extension GameRecordQuerySortBy
    on QueryBuilder<GameRecord, GameRecord, QSortBy> {
  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByBlackPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackPlayer', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByBlackPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackPlayer', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy>
      sortByGameDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy>
      sortByGameDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByInitialFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialFen', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByInitialFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialFen', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByTerminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByWhitePlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitePlayer', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> sortByWhitePlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitePlayer', Sort.desc);
    });
  }
}

extension GameRecordQuerySortThenBy
    on QueryBuilder<GameRecord, GameRecord, QSortThenBy> {
  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByBlackPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackPlayer', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByBlackPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackPlayer', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy>
      thenByGameDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy>
      thenByGameDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByInitialFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialFen', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByInitialFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialFen', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pgn', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByTerminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.desc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByWhitePlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitePlayer', Sort.asc);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QAfterSortBy> thenByWhitePlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whitePlayer', Sort.desc);
    });
  }
}

extension GameRecordQueryWhereDistinct
    on QueryBuilder<GameRecord, GameRecord, QDistinct> {
  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByBlackPlayer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackPlayer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct>
      distinctByGameDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameDurationSeconds');
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByInitialFen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialFen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByPgn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pgn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByResult(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'result', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termination');
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByUciMoves() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uciMoves');
    });
  }

  QueryBuilder<GameRecord, GameRecord, QDistinct> distinctByWhitePlayer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whitePlayer', caseSensitive: caseSensitive);
    });
  }
}

extension GameRecordQueryProperty
    on QueryBuilder<GameRecord, GameRecord, QQueryProperty> {
  QueryBuilder<GameRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameRecord, String, QQueryOperations> blackPlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackPlayer');
    });
  }

  QueryBuilder<GameRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<GameRecord, int?, QQueryOperations>
      gameDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameDurationSeconds');
    });
  }

  QueryBuilder<GameRecord, String, QQueryOperations> initialFenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialFen');
    });
  }

  QueryBuilder<GameRecord, String?, QQueryOperations> pgnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pgn');
    });
  }

  QueryBuilder<GameRecord, String?, QQueryOperations> resultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'result');
    });
  }

  QueryBuilder<GameRecord, GameTermination, QQueryOperations>
      terminationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termination');
    });
  }

  QueryBuilder<GameRecord, List<String>, QQueryOperations> uciMovesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uciMoves');
    });
  }

  QueryBuilder<GameRecord, String, QQueryOperations> whitePlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whitePlayer');
    });
  }
}
