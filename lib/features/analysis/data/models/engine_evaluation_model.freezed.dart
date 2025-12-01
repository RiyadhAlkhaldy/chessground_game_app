// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engine_evaluation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EngineEvaluationModel _$EngineEvaluationModelFromJson(
    Map<String, dynamic> json) {
  return _EngineEvaluationModel.fromJson(json);
}

/// @nodoc
mixin _$EngineEvaluationModel {
  int? get centipawns => throw _privateConstructorUsedError;
  int? get mate => throw _privateConstructorUsedError;
  int get depth => throw _privateConstructorUsedError;
  int? get nodes => throw _privateConstructorUsedError;
  String get bestMove => throw _privateConstructorUsedError;
  List<String> get pv => throw _privateConstructorUsedError;
  int? get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EngineEvaluationModelCopyWith<EngineEvaluationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngineEvaluationModelCopyWith<$Res> {
  factory $EngineEvaluationModelCopyWith(EngineEvaluationModel value,
          $Res Function(EngineEvaluationModel) then) =
      _$EngineEvaluationModelCopyWithImpl<$Res, EngineEvaluationModel>;
  @useResult
  $Res call(
      {int? centipawns,
      int? mate,
      int depth,
      int? nodes,
      String bestMove,
      List<String> pv,
      int? time});
}

/// @nodoc
class _$EngineEvaluationModelCopyWithImpl<$Res,
        $Val extends EngineEvaluationModel>
    implements $EngineEvaluationModelCopyWith<$Res> {
  _$EngineEvaluationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? centipawns = freezed,
    Object? mate = freezed,
    Object? depth = null,
    Object? nodes = freezed,
    Object? bestMove = null,
    Object? pv = null,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      centipawns: freezed == centipawns
          ? _value.centipawns
          : centipawns // ignore: cast_nullable_to_non_nullable
              as int?,
      mate: freezed == mate
          ? _value.mate
          : mate // ignore: cast_nullable_to_non_nullable
              as int?,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      nodes: freezed == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as int?,
      bestMove: null == bestMove
          ? _value.bestMove
          : bestMove // ignore: cast_nullable_to_non_nullable
              as String,
      pv: null == pv
          ? _value.pv
          : pv // ignore: cast_nullable_to_non_nullable
              as List<String>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EngineEvaluationModelImplCopyWith<$Res>
    implements $EngineEvaluationModelCopyWith<$Res> {
  factory _$$EngineEvaluationModelImplCopyWith(
          _$EngineEvaluationModelImpl value,
          $Res Function(_$EngineEvaluationModelImpl) then) =
      __$$EngineEvaluationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? centipawns,
      int? mate,
      int depth,
      int? nodes,
      String bestMove,
      List<String> pv,
      int? time});
}

/// @nodoc
class __$$EngineEvaluationModelImplCopyWithImpl<$Res>
    extends _$EngineEvaluationModelCopyWithImpl<$Res,
        _$EngineEvaluationModelImpl>
    implements _$$EngineEvaluationModelImplCopyWith<$Res> {
  __$$EngineEvaluationModelImplCopyWithImpl(_$EngineEvaluationModelImpl _value,
      $Res Function(_$EngineEvaluationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? centipawns = freezed,
    Object? mate = freezed,
    Object? depth = null,
    Object? nodes = freezed,
    Object? bestMove = null,
    Object? pv = null,
    Object? time = freezed,
  }) {
    return _then(_$EngineEvaluationModelImpl(
      centipawns: freezed == centipawns
          ? _value.centipawns
          : centipawns // ignore: cast_nullable_to_non_nullable
              as int?,
      mate: freezed == mate
          ? _value.mate
          : mate // ignore: cast_nullable_to_non_nullable
              as int?,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      nodes: freezed == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as int?,
      bestMove: null == bestMove
          ? _value.bestMove
          : bestMove // ignore: cast_nullable_to_non_nullable
              as String,
      pv: null == pv
          ? _value._pv
          : pv // ignore: cast_nullable_to_non_nullable
              as List<String>,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EngineEvaluationModelImpl implements _EngineEvaluationModel {
  const _$EngineEvaluationModelImpl(
      {this.centipawns,
      this.mate,
      required this.depth,
      this.nodes,
      required this.bestMove,
      final List<String> pv = const [],
      this.time})
      : _pv = pv;

  factory _$EngineEvaluationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EngineEvaluationModelImplFromJson(json);

  @override
  final int? centipawns;
  @override
  final int? mate;
  @override
  final int depth;
  @override
  final int? nodes;
  @override
  final String bestMove;
  final List<String> _pv;
  @override
  @JsonKey()
  List<String> get pv {
    if (_pv is EqualUnmodifiableListView) return _pv;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pv);
  }

  @override
  final int? time;

  @override
  String toString() {
    return 'EngineEvaluationModel(centipawns: $centipawns, mate: $mate, depth: $depth, nodes: $nodes, bestMove: $bestMove, pv: $pv, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EngineEvaluationModelImpl &&
            (identical(other.centipawns, centipawns) ||
                other.centipawns == centipawns) &&
            (identical(other.mate, mate) || other.mate == mate) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.nodes, nodes) || other.nodes == nodes) &&
            (identical(other.bestMove, bestMove) ||
                other.bestMove == bestMove) &&
            const DeepCollectionEquality().equals(other._pv, _pv) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, centipawns, mate, depth, nodes,
      bestMove, const DeepCollectionEquality().hash(_pv), time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EngineEvaluationModelImplCopyWith<_$EngineEvaluationModelImpl>
      get copyWith => __$$EngineEvaluationModelImplCopyWithImpl<
          _$EngineEvaluationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EngineEvaluationModelImplToJson(
      this,
    );
  }
}

abstract class _EngineEvaluationModel implements EngineEvaluationModel {
  const factory _EngineEvaluationModel(
      {final int? centipawns,
      final int? mate,
      required final int depth,
      final int? nodes,
      required final String bestMove,
      final List<String> pv,
      final int? time}) = _$EngineEvaluationModelImpl;

  factory _EngineEvaluationModel.fromJson(Map<String, dynamic> json) =
      _$EngineEvaluationModelImpl.fromJson;

  @override
  int? get centipawns;
  @override
  int? get mate;
  @override
  int get depth;
  @override
  int? get nodes;
  @override
  String get bestMove;
  @override
  List<String> get pv;
  @override
  int? get time;
  @override
  @JsonKey(ignore: true)
  _$$EngineEvaluationModelImplCopyWith<_$EngineEvaluationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
