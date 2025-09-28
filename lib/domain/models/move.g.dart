// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMoveModelCollection on Isar {
  IsarCollection<MoveModel> get moveModels => this.collection();
}

const MoveModelSchema = CollectionSchema(
  name: r'MoveModel',
  id: -6782090089343288258,
  properties: {
    r'comment': PropertySchema(
      id: 0,
      name: r'comment',
      type: IsarType.string,
    ),
    r'fen': PropertySchema(
      id: 1,
      name: r'fen',
      type: IsarType.string,
    ),
    r'moveNumber': PropertySchema(
      id: 2,
      name: r'moveNumber',
      type: IsarType.long,
    ),
    r'uci': PropertySchema(
      id: 3,
      name: r'uci',
      type: IsarType.string,
    )
  },
  estimateSize: _moveModelEstimateSize,
  serialize: _moveModelSerialize,
  deserialize: _moveModelDeserialize,
  deserializeProp: _moveModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'game': LinkSchema(
      id: -5079916222131817626,
      name: r'game',
      target: r'GameModel',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _moveModelGetId,
  getLinks: _moveModelGetLinks,
  attach: _moveModelAttach,
  version: '3.1.0+1',
);

int _moveModelEstimateSize(
  MoveModel object,
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
  bytesCount += 3 + object.fen.length * 3;
  bytesCount += 3 + object.uci.length * 3;
  return bytesCount;
}

void _moveModelSerialize(
  MoveModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.comment);
  writer.writeString(offsets[1], object.fen);
  writer.writeLong(offsets[2], object.moveNumber);
  writer.writeString(offsets[3], object.uci);
}

MoveModel _moveModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoveModel(
    comment: reader.readStringOrNull(offsets[0]),
    fen: reader.readString(offsets[1]),
    moveNumber: reader.readLongOrNull(offsets[2]),
    uci: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _moveModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moveModelGetId(MoveModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moveModelGetLinks(MoveModel object) {
  return [object.game];
}

void _moveModelAttach(IsarCollection<dynamic> col, Id id, MoveModel object) {
  object.id = id;
  object.game.attach(col, col.isar.collection<GameModel>(), r'game', id);
}

extension MoveModelQueryWhereSort
    on QueryBuilder<MoveModel, MoveModel, QWhere> {
  QueryBuilder<MoveModel, MoveModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MoveModelQueryWhere
    on QueryBuilder<MoveModel, MoveModel, QWhereClause> {
  QueryBuilder<MoveModel, MoveModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MoveModel, MoveModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterWhereClause> idBetween(
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
}

extension MoveModelQueryFilter
    on QueryBuilder<MoveModel, MoveModel, QFilterCondition> {
  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentEqualTo(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentGreaterThan(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentLessThan(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentBetween(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentStartsWith(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentEndsWith(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentContains(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentMatches(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition>
      commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fen',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> fenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fen',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> moveNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moveNumber',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition>
      moveNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moveNumber',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> moveNumberEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition>
      moveNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moveNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> moveNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moveNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> moveNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moveNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uci',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uci',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uci',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uci',
        value: '',
      ));
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> uciIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uci',
        value: '',
      ));
    });
  }
}

extension MoveModelQueryObject
    on QueryBuilder<MoveModel, MoveModel, QFilterCondition> {}

extension MoveModelQueryLinks
    on QueryBuilder<MoveModel, MoveModel, QFilterCondition> {
  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> game(
      FilterQuery<GameModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'game');
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterFilterCondition> gameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'game', 0, true, 0, true);
    });
  }
}

extension MoveModelQuerySortBy on QueryBuilder<MoveModel, MoveModel, QSortBy> {
  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fen', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fen', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByMoveNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveNumber', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByMoveNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveNumber', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByUci() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uci', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> sortByUciDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uci', Sort.desc);
    });
  }
}

extension MoveModelQuerySortThenBy
    on QueryBuilder<MoveModel, MoveModel, QSortThenBy> {
  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByFen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fen', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByFenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fen', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByMoveNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveNumber', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByMoveNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveNumber', Sort.desc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByUci() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uci', Sort.asc);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QAfterSortBy> thenByUciDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uci', Sort.desc);
    });
  }
}

extension MoveModelQueryWhereDistinct
    on QueryBuilder<MoveModel, MoveModel, QDistinct> {
  QueryBuilder<MoveModel, MoveModel, QDistinct> distinctByComment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QDistinct> distinctByFen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoveModel, MoveModel, QDistinct> distinctByMoveNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveNumber');
    });
  }

  QueryBuilder<MoveModel, MoveModel, QDistinct> distinctByUci(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uci', caseSensitive: caseSensitive);
    });
  }
}

extension MoveModelQueryProperty
    on QueryBuilder<MoveModel, MoveModel, QQueryProperty> {
  QueryBuilder<MoveModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MoveModel, String?, QQueryOperations> commentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comment');
    });
  }

  QueryBuilder<MoveModel, String, QQueryOperations> fenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fen');
    });
  }

  QueryBuilder<MoveModel, int?, QQueryOperations> moveNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveNumber');
    });
  }

  QueryBuilder<MoveModel, String, QQueryOperations> uciProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uci');
    });
  }
}
