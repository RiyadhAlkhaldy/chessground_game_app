// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_data.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MoveDataSchema = Schema(
  name: r'MoveData',
  id: 397429291235813969,
  properties: {
    r'comment': PropertySchema(id: 0, name: r'comment', type: IsarType.string),
    r'fenAfter': PropertySchema(
      id: 1,
      name: r'fenAfter',
      type: IsarType.string,
    ),
    r'halfmoveIndex': PropertySchema(
      id: 2,
      name: r'halfmoveIndex',
      type: IsarType.long,
    ),
    r'isWhiteMove': PropertySchema(
      id: 3,
      name: r'isWhiteMove',
      type: IsarType.bool,
    ),
    r'lan': PropertySchema(id: 4, name: r'lan', type: IsarType.string),
    r'moveNumber': PropertySchema(
      id: 5,
      name: r'moveNumber',
      type: IsarType.long,
    ),
    r'nags': PropertySchema(id: 6, name: r'nags', type: IsarType.longList),
    r'san': PropertySchema(id: 7, name: r'san', type: IsarType.string),
    r'variations': PropertySchema(
      id: 8,
      name: r'variations',
      type: IsarType.stringList,
    ),
    r'wasCapture': PropertySchema(
      id: 9,
      name: r'wasCapture',
      type: IsarType.bool,
    ),
    r'wasCheck': PropertySchema(id: 10, name: r'wasCheck', type: IsarType.bool),
    r'wasCheckmate': PropertySchema(
      id: 11,
      name: r'wasCheckmate',
      type: IsarType.bool,
    ),
    r'wasPromotion': PropertySchema(
      id: 12,
      name: r'wasPromotion',
      type: IsarType.bool,
    ),
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
  writer.writeLong(offsets[2], object.halfmoveIndex);
  writer.writeBool(offsets[3], object.isWhiteMove);
  writer.writeString(offsets[4], object.lan);
  writer.writeLong(offsets[5], object.moveNumber);
  writer.writeLongList(offsets[6], object.nags);
  writer.writeString(offsets[7], object.san);
  writer.writeStringList(offsets[8], object.variations);
  writer.writeBool(offsets[9], object.wasCapture);
  writer.writeBool(offsets[10], object.wasCheck);
  writer.writeBool(offsets[11], object.wasCheckmate);
  writer.writeBool(offsets[12], object.wasPromotion);
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
  object.halfmoveIndex = reader.readLongOrNull(offsets[2]);
  object.isWhiteMove = reader.readBoolOrNull(offsets[3]);
  object.lan = reader.readStringOrNull(offsets[4]);
  object.moveNumber = reader.readLongOrNull(offsets[5]);
  object.nags = reader.readLongList(offsets[6]);
  object.san = reader.readStringOrNull(offsets[7]);
  object.variations = reader.readStringList(offsets[8]);
  object.wasCapture = reader.readBool(offsets[9]);
  object.wasCheck = reader.readBool(offsets[10]);
  object.wasCheckmate = reader.readBool(offsets[11]);
  object.wasPromotion = reader.readBool(offsets[12]);
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongList(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MoveDataQueryFilter
    on QueryBuilder<MoveData, MoveData, QFilterCondition> {
  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'comment'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'comment'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'comment',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'comment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'comment',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'comment', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'comment', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fenAfter'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fenAfter'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fenAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fenAfter',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fenAfter',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fenAfter', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> fenAfterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fenAfter', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  halfmoveIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'halfmoveIndex'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  halfmoveIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'halfmoveIndex'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> halfmoveIndexEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'halfmoveIndex', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  halfmoveIndexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'halfmoveIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> halfmoveIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'halfmoveIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> halfmoveIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'halfmoveIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> isWhiteMoveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isWhiteMove'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  isWhiteMoveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isWhiteMove'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> isWhiteMoveEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isWhiteMove', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lan'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lan'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lan',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lan',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lan', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> lanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lan', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> moveNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'moveNumber'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  moveNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'moveNumber'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> moveNumberEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'moveNumber', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> moveNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'moveNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> moveNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'moveNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> moveNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'moveNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nags'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nags'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nags', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  nagsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nags',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nags',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nags',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'nags', length, true, length, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'nags', 0, true, 0, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'nags', 0, false, 999999, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'nags', 0, true, length, include);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> nagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'nags', length, include, 999999, true);
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'san'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'san'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'san',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'san',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'san',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'san', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> sanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'san', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> variationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'variations'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'variations'),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'variations',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'variations',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'variations',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'variations', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'variations', value: ''),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'variations', length, true, length, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> variationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'variations', 0, true, 0, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'variations', 0, false, 999999, true);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'variations', 0, true, length, include);
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition>
  variationsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'variations', length, include, 999999, true);
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

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> wasCaptureEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasCapture', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> wasCheckEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasCheck', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> wasCheckmateEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasCheckmate', value: value),
      );
    });
  }

  QueryBuilder<MoveData, MoveData, QAfterFilterCondition> wasPromotionEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasPromotion', value: value),
      );
    });
  }
}

extension MoveDataQueryObject
    on QueryBuilder<MoveData, MoveData, QFilterCondition> {}
