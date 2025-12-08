// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engine_move_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EngineMoveModel _$EngineMoveModelFromJson(Map<String, dynamic> json) {
  return _EngineMoveModel.fromJson(json);
}

/// @nodoc
mixin _$EngineMoveModel {
  String get uci => throw _privateConstructorUsedError;
  String? get san => throw _privateConstructorUsedError;
  int? get evaluation => throw _privateConstructorUsedError;
  bool get isBestMove => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EngineMoveModelCopyWith<EngineMoveModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngineMoveModelCopyWith<$Res> {
  factory $EngineMoveModelCopyWith(
          EngineMoveModel value, $Res Function(EngineMoveModel) then) =
      _$EngineMoveModelCopyWithImpl<$Res, EngineMoveModel>;
  @useResult
  $Res call(
      {String uci, String? san, int? evaluation, bool isBestMove, int rank});
}

/// @nodoc
class _$EngineMoveModelCopyWithImpl<$Res, $Val extends EngineMoveModel>
    implements $EngineMoveModelCopyWith<$Res> {
  _$EngineMoveModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uci = null,
    Object? san = freezed,
    Object? evaluation = freezed,
    Object? isBestMove = null,
    Object? rank = null,
  }) {
    return _then(_value.copyWith(
      uci: null == uci
          ? _value.uci
          : uci // ignore: cast_nullable_to_non_nullable
              as String,
      san: freezed == san
          ? _value.san
          : san // ignore: cast_nullable_to_non_nullable
              as String?,
      evaluation: freezed == evaluation
          ? _value.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as int?,
      isBestMove: null == isBestMove
          ? _value.isBestMove
          : isBestMove // ignore: cast_nullable_to_non_nullable
              as bool,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EngineMoveModelImplCopyWith<$Res>
    implements $EngineMoveModelCopyWith<$Res> {
  factory _$$EngineMoveModelImplCopyWith(_$EngineMoveModelImpl value,
          $Res Function(_$EngineMoveModelImpl) then) =
      __$$EngineMoveModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uci, String? san, int? evaluation, bool isBestMove, int rank});
}

/// @nodoc
class __$$EngineMoveModelImplCopyWithImpl<$Res>
    extends _$EngineMoveModelCopyWithImpl<$Res, _$EngineMoveModelImpl>
    implements _$$EngineMoveModelImplCopyWith<$Res> {
  __$$EngineMoveModelImplCopyWithImpl(
      _$EngineMoveModelImpl _value, $Res Function(_$EngineMoveModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uci = null,
    Object? san = freezed,
    Object? evaluation = freezed,
    Object? isBestMove = null,
    Object? rank = null,
  }) {
    return _then(_$EngineMoveModelImpl(
      uci: null == uci
          ? _value.uci
          : uci // ignore: cast_nullable_to_non_nullable
              as String,
      san: freezed == san
          ? _value.san
          : san // ignore: cast_nullable_to_non_nullable
              as String?,
      evaluation: freezed == evaluation
          ? _value.evaluation
          : evaluation // ignore: cast_nullable_to_non_nullable
              as int?,
      isBestMove: null == isBestMove
          ? _value.isBestMove
          : isBestMove // ignore: cast_nullable_to_non_nullable
              as bool,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EngineMoveModelImpl implements _EngineMoveModel {
  const _$EngineMoveModelImpl(
      {required this.uci,
      this.san,
      this.evaluation,
      this.isBestMove = false,
      this.rank = 1});

  factory _$EngineMoveModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EngineMoveModelImplFromJson(json);

  @override
  final String uci;
  @override
  final String? san;
  @override
  final int? evaluation;
  @override
  @JsonKey()
  final bool isBestMove;
  @override
  @JsonKey()
  final int rank;

  @override
  String toString() {
    return 'EngineMoveModel(uci: $uci, san: $san, evaluation: $evaluation, isBestMove: $isBestMove, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EngineMoveModelImpl &&
            (identical(other.uci, uci) || other.uci == uci) &&
            (identical(other.san, san) || other.san == san) &&
            (identical(other.evaluation, evaluation) ||
                other.evaluation == evaluation) &&
            (identical(other.isBestMove, isBestMove) ||
                other.isBestMove == isBestMove) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uci, san, evaluation, isBestMove, rank);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EngineMoveModelImplCopyWith<_$EngineMoveModelImpl> get copyWith =>
      __$$EngineMoveModelImplCopyWithImpl<_$EngineMoveModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EngineMoveModelImplToJson(
      this,
    );
  }
}

abstract class _EngineMoveModel implements EngineMoveModel {
  const factory _EngineMoveModel(
      {required final String uci,
      final String? san,
      final int? evaluation,
      final bool isBestMove,
      final int rank}) = _$EngineMoveModelImpl;

  factory _EngineMoveModel.fromJson(Map<String, dynamic> json) =
      _$EngineMoveModelImpl.fromJson;

  @override
  String get uci;
  @override
  String? get san;
  @override
  int? get evaluation;
  @override
  bool get isBestMove;
  @override
  int get rank;
  @override
  @JsonKey(ignore: true)
  _$$EngineMoveModelImplCopyWith<_$EngineMoveModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
