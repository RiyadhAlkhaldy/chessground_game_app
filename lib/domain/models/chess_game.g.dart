// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess_game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChessGameCollection on Isar {
  IsarCollection<ChessGame> get chessGames => this.collection();
}

const ChessGameSchema = CollectionSchema(
  name: r'ChessGame',
  id: 6443583129619452760,
  properties: {
    r'blackElo': PropertySchema(
      id: 0,
      name: r'blackElo',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'eco': PropertySchema(
      id: 2,
      name: r'eco',
      type: IsarType.string,
    ),
    r'event': PropertySchema(
      id: 3,
      name: r'event',
      type: IsarType.string,
    ),
    r'fullPgn': PropertySchema(
      id: 4,
      name: r'fullPgn',
      type: IsarType.string,
    ),
    r'moves': PropertySchema(
      id: 5,
      name: r'moves',
      type: IsarType.objectList,
      target: r'MoveData',
    ),
    r'movesCount': PropertySchema(
      id: 6,
      name: r'movesCount',
      type: IsarType.long,
    ),
    r'result': PropertySchema(
      id: 7,
      name: r'result',
      type: IsarType.string,
    ),
    r'round': PropertySchema(
      id: 8,
      name: r'round',
      type: IsarType.string,
    ),
    r'site': PropertySchema(
      id: 9,
      name: r'site',
      type: IsarType.string,
    ),
    r'startingFen': PropertySchema(
      id: 10,
      name: r'startingFen',
      type: IsarType.string,
    ),
    r'termination': PropertySchema(
      id: 11,
      name: r'termination',
      type: IsarType.byte,
      enumMap: _ChessGameterminationEnumValueMap,
    ),
    r'timeControl': PropertySchema(
      id: 12,
      name: r'timeControl',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 13,
      name: r'userId',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 14,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'whiteElo': PropertySchema(
      id: 15,
      name: r'whiteElo',
      type: IsarType.long,
    )
  },
  estimateSize: _chessGameEstimateSize,
  serialize: _chessGameSerialize,
  deserialize: _chessGameDeserialize,
  deserializeProp: _chessGameDeserializeProp,
  idName: r'id',
  indexes: {
    r'event': IndexSchema(
      id: -6827030618885678442,
      name: r'event',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'event',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'result': IndexSchema(
      id: -2959080351604392084,
      name: r'result',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'result',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'whitePlayer': LinkSchema(
      id: 1847669505781515007,
      name: r'whitePlayer',
      target: r'Player',
      single: true,
    ),
    r'blackPlayer': LinkSchema(
      id: -1747315855020472213,
      name: r'blackPlayer',
      target: r'Player',
      single: true,
    )
  },
  embeddedSchemas: {r'MoveData': MoveDataSchema},
  getId: _chessGameGetId,
  getLinks: _chessGameGetLinks,
  attach: _chessGameAttach,
  version: '3.1.0+1',
);

int _chessGameEstimateSize(
  ChessGame object,
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
  {
    final value = object.event;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fullPgn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.moves.length * 3;
  {
    final offsets = allOffsets[MoveData]!;
    for (var i = 0; i < object.moves.length; i++) {
      final value = object.moves[i];
      bytesCount += MoveDataSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.result;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.round;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.site;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startingFen;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.timeControl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _chessGameSerialize(
  ChessGame object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blackElo);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.eco);
  writer.writeString(offsets[3], object.event);
  writer.writeString(offsets[4], object.fullPgn);
  writer.writeObjectList<MoveData>(
    offsets[5],
    allOffsets,
    MoveDataSchema.serialize,
    object.moves,
  );
  writer.writeLong(offsets[6], object.movesCount);
  writer.writeString(offsets[7], object.result);
  writer.writeString(offsets[8], object.round);
  writer.writeString(offsets[9], object.site);
  writer.writeString(offsets[10], object.startingFen);
  writer.writeByte(offsets[11], object.termination.index);
  writer.writeString(offsets[12], object.timeControl);
  writer.writeString(offsets[13], object.userId);
  writer.writeString(offsets[14], object.uuid);
  writer.writeLong(offsets[15], object.whiteElo);
}

ChessGame _chessGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChessGame();
  object.blackElo = reader.readLongOrNull(offsets[0]);
  object.date = reader.readDateTimeOrNull(offsets[1]);
  object.eco = reader.readStringOrNull(offsets[2]);
  object.event = reader.readStringOrNull(offsets[3]);
  object.fullPgn = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.moves = reader.readObjectList<MoveData>(
        offsets[5],
        MoveDataSchema.deserialize,
        allOffsets,
        MoveData(),
      ) ??
      [];
  object.movesCount = reader.readLong(offsets[6]);
  object.result = reader.readStringOrNull(offsets[7]);
  object.round = reader.readStringOrNull(offsets[8]);
  object.site = reader.readStringOrNull(offsets[9]);
  object.startingFen = reader.readStringOrNull(offsets[10]);
  object.termination =
      _ChessGameterminationValueEnumMap[reader.readByteOrNull(offsets[11])] ??
          GameTermination.checkmate;
  object.timeControl = reader.readStringOrNull(offsets[12]);
  object.userId = reader.readStringOrNull(offsets[13]);
  object.uuid = reader.readString(offsets[14]);
  object.whiteElo = reader.readLongOrNull(offsets[15]);
  return object;
}

P _chessGameDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<MoveData>(
            offset,
            MoveDataSchema.deserialize,
            allOffsets,
            MoveData(),
          ) ??
          []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (_ChessGameterminationValueEnumMap[
              reader.readByteOrNull(offset)] ??
          GameTermination.checkmate) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ChessGameterminationEnumValueMap = {
  'checkmate': 0,
  'stalemate': 1,
  'timeout': 2,
  'resignation': 3,
  'agreement': 4,
  'threefoldRepetition': 5,
  'fiftyMoveRule': 6,
  'insufficientMaterial': 7,
  'ongoing': 8,
};
const _ChessGameterminationValueEnumMap = {
  0: GameTermination.checkmate,
  1: GameTermination.stalemate,
  2: GameTermination.timeout,
  3: GameTermination.resignation,
  4: GameTermination.agreement,
  5: GameTermination.threefoldRepetition,
  6: GameTermination.fiftyMoveRule,
  7: GameTermination.insufficientMaterial,
  8: GameTermination.ongoing,
};

Id _chessGameGetId(ChessGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chessGameGetLinks(ChessGame object) {
  return [object.whitePlayer, object.blackPlayer];
}

void _chessGameAttach(IsarCollection<dynamic> col, Id id, ChessGame object) {
  object.id = id;
  object.whitePlayer
      .attach(col, col.isar.collection<Player>(), r'whitePlayer', id);
  object.blackPlayer
      .attach(col, col.isar.collection<Player>(), r'blackPlayer', id);
}

extension ChessGameQueryWhereSort
    on QueryBuilder<ChessGame, ChessGame, QWhere> {
  QueryBuilder<ChessGame, ChessGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhere> anyEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'event'),
      );
    });
  }
}

extension ChessGameQueryWhere
    on QueryBuilder<ChessGame, ChessGame, QWhereClause> {
  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> idBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'event',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'event',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventEqualTo(
      String? event) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'event',
        value: [event],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventNotEqualTo(
      String? event) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'event',
              lower: [],
              upper: [event],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'event',
              lower: [event],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'event',
              lower: [event],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'event',
              lower: [],
              upper: [event],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventGreaterThan(
    String? event, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'event',
        lower: [event],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventLessThan(
    String? event, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'event',
        lower: [],
        upper: [event],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventBetween(
    String? lowerEvent,
    String? upperEvent, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'event',
        lower: [lowerEvent],
        includeLower: includeLower,
        upper: [upperEvent],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventStartsWith(
      String EventPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'event',
        lower: [EventPrefix],
        upper: ['$EventPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'event',
        value: [''],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> eventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'event',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'event',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'event',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'event',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> resultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'result',
        value: [null],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> resultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'result',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> resultEqualTo(
      String? result) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'result',
        value: [result],
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterWhereClause> resultNotEqualTo(
      String? result) {
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
}

extension ChessGameQueryFilter
    on QueryBuilder<ChessGame, ChessGame, QFilterCondition> {
  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackEloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blackElo',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      blackEloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blackElo',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackEloEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blackElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackEloGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blackElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackEloLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blackElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackEloBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blackElo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eco',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eco',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoEqualTo(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoGreaterThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoLessThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoStartsWith(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoEndsWith(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoContains(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoMatches(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eco',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> ecoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eco',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'event',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'event',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'event',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'event',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'event',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'event',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> eventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'event',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullPgn',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullPgn',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullPgn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullPgn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullPgn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> fullPgnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullPgn',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      fullPgnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullPgn',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesLengthEqualTo(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesIsEmpty() {
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesIsNotEmpty() {
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesLengthLessThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesLengthBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      movesCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultEqualTo(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultGreaterThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultLessThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultStartsWith(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultEndsWith(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultContains(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultMatches(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> resultIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'result',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'round',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'round',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'round',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'round',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'round',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'round',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> roundIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'round',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'site',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'site',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'site',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'site',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'site',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'site',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> siteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'site',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startingFen',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startingFen',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingFen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startingFen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> startingFenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startingFen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingFen',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      startingFenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startingFen',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> terminationEqualTo(
      GameTermination value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termination',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> terminationLessThan(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> terminationBetween(
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

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeControl',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeControl',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeControl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeControl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> timeControlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeControl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeControl',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      timeControlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeControl',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whiteEloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'whiteElo',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      whiteEloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'whiteElo',
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whiteEloEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whiteEloGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whiteEloLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteElo',
        value: value,
      ));
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whiteEloBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteElo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChessGameQueryObject
    on QueryBuilder<ChessGame, ChessGame, QFilterCondition> {
  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> movesElement(
      FilterQuery<MoveData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'moves');
    });
  }
}

extension ChessGameQueryLinks
    on QueryBuilder<ChessGame, ChessGame, QFilterCondition> {
  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> whitePlayer(
      FilterQuery<Player> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'whitePlayer');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      whitePlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'whitePlayer', 0, true, 0, true);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition> blackPlayer(
      FilterQuery<Player> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'blackPlayer');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterFilterCondition>
      blackPlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blackPlayer', 0, true, 0, true);
    });
  }
}

extension ChessGameQuerySortBy on QueryBuilder<ChessGame, ChessGame, QSortBy> {
  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByBlackElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackElo', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByBlackEloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackElo', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByEco() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByEcoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'event', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'event', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByFullPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullPgn', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByFullPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullPgn', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByMovesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movesCount', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByMovesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movesCount', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByRound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'round', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByRoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'round', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortBySite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'site', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortBySiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'site', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByStartingFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFen', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByStartingFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFen', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByTerminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByTimeControl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeControl', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByTimeControlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeControl', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByWhiteElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteElo', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> sortByWhiteEloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteElo', Sort.desc);
    });
  }
}

extension ChessGameQuerySortThenBy
    on QueryBuilder<ChessGame, ChessGame, QSortThenBy> {
  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByBlackElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackElo', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByBlackEloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blackElo', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByEco() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByEcoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eco', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'event', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'event', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByFullPgn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullPgn', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByFullPgnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullPgn', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByMovesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movesCount', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByMovesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movesCount', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByRound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'round', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByRoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'round', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenBySite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'site', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenBySiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'site', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByStartingFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFen', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByStartingFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFen', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByTerminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termination', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByTimeControl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeControl', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByTimeControlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeControl', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByWhiteElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteElo', Sort.asc);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QAfterSortBy> thenByWhiteEloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteElo', Sort.desc);
    });
  }
}

extension ChessGameQueryWhereDistinct
    on QueryBuilder<ChessGame, ChessGame, QDistinct> {
  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByBlackElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blackElo');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByEco(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eco', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByEvent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'event', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByFullPgn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullPgn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByMovesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movesCount');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByResult(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'result', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByRound(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'round', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctBySite(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'site', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByStartingFen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingFen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByTermination() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termination');
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByTimeControl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeControl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChessGame, ChessGame, QDistinct> distinctByWhiteElo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteElo');
    });
  }
}

extension ChessGameQueryProperty
    on QueryBuilder<ChessGame, ChessGame, QQueryProperty> {
  QueryBuilder<ChessGame, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChessGame, int?, QQueryOperations> blackEloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blackElo');
    });
  }

  QueryBuilder<ChessGame, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> ecoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eco');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> eventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'event');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> fullPgnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullPgn');
    });
  }

  QueryBuilder<ChessGame, List<MoveData>, QQueryOperations> movesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moves');
    });
  }

  QueryBuilder<ChessGame, int, QQueryOperations> movesCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movesCount');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> resultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'result');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> roundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'round');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> siteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'site');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> startingFenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingFen');
    });
  }

  QueryBuilder<ChessGame, GameTermination, QQueryOperations>
      terminationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termination');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> timeControlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeControl');
    });
  }

  QueryBuilder<ChessGame, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<ChessGame, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<ChessGame, int?, QQueryOperations> whiteEloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteElo');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MoveDataSchema = Schema(
  name: r'MoveData',
  id: 397429291235813969,
  properties: {
    r'comment': PropertySchema(
      id: 0,
      name: r'comment',
      type: IsarType.string,
    ),
    r'fenAfter': PropertySchema(
      id: 1,
      name: r'fenAfter',
      type: IsarType.string,
    ),
    r'lan': PropertySchema(
      id: 2,
      name: r'lan',
      type: IsarType.string,
    ),
    r'nags': PropertySchema(
      id: 3,
      name: r'nags',
      type: IsarType.longList,
    ),
    r'san': PropertySchema(
      id: 4,
      name: r'san',
      type: IsarType.string,
    ),
    r'variations': PropertySchema(
      id: 5,
      name: r'variations',
      type: IsarType.stringList,
    )
  },
  estimateSize: _moveDataEstimateSize,
  serialize: _moveDataSerialize,
  deserialize: _moveDataDeserialize,
  deserializeProp: _moveDataDeserializeProp,
);

int _moveDataEstimateSize(
  MoveData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.comment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fenAfter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lan;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nags;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.san;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.variations;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _moveDataSerialize(
  MoveData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.comment);
  writer.writeString(offsets[1], object.fenAfter);
  writer.writeString(offsets[2], object.lan);
  writer.writeLongList(offsets[3], object.nags);
  writer.writeString(offsets[4], object.san);
  writer.writeStringList(offsets[5], object.variations);
}

MoveData _moveDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoveData();
  object.comment = reader.readStringOrNull(offsets[0]);
  object.fenAfter = reader.readStringOrNull(offsets[1]);
  object.lan = reader.readStringOrNull(offsets[2]);
  object.nags = reader.readLongList(offsets[3]);
  object.san = reader.readStringOrNull(offsets[4]);
  object.variations = reader.readStringList(offsets[5]);
  return object;
}

P _moveDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MoveDataQueryFilter
    on QueryBuilder<MoveData, MoveData, QFilterCondition> {
  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fenAfter',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fenAfter',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fenAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fenAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fenAfter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fenAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fenAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lan',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lan',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lan',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lan',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nags',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nags',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nags',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      nagsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nags',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nags',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'san',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'san',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'san',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'san',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'san',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'san',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'san',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> variationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'variations',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'variations',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'variations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'variations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'variations',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variations',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'variations',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> variationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
      variationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'variations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MoveDataQueryObject
    on QueryBuilder<MoveData, MoveData, QFilterCondition> {}
