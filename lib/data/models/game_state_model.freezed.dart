// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameStateModel _$GameStateModelFromJson(Map<String, dynamic> json) {
  return _GameStateModel.fromJson(json);
}

/// @nodoc
mixin _$GameStateModel {
  String get gameUuid => throw _privateConstructorUsedError;
  String get currentFen => throw _privateConstructorUsedError;
  List<String> get fenHistory => throw _privateConstructorUsedError;
  Map<String, int> get fenCounts => throw _privateConstructorUsedError;
  List<MoveDataModel> get moves => throw _privateConstructorUsedError;
  int get currentHalfmoveIndex => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  String get termination => throw _privateConstructorUsedError;
  String? get resignationSide => throw _privateConstructorUsedError;
  String? get timeoutSide => throw _privateConstructorUsedError;
  bool get agreementDraw => throw _privateConstructorUsedError;
  int get halfmoveClock => throw _privateConstructorUsedError;
  int get materialEvaluation => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameStateModelCopyWith<GameStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateModelCopyWith<$Res> {
  factory $GameStateModelCopyWith(
          GameStateModel value, $Res Function(GameStateModel) then) =
      _$GameStateModelCopyWithImpl<$Res, GameStateModel>;
  @useResult
  $Res call(
      {String gameUuid,
      String currentFen,
      List<String> fenHistory,
      Map<String, int> fenCounts,
      List<MoveDataModel> moves,
      int currentHalfmoveIndex,
      String? result,
      String termination,
      String? resignationSide,
      String? timeoutSide,
      bool agreementDraw,
      int halfmoveClock,
      int materialEvaluation,
      DateTime lastUpdated});
}

/// @nodoc
class _$GameStateModelCopyWithImpl<$Res, $Val extends GameStateModel>
    implements $GameStateModelCopyWith<$Res> {
  _$GameStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameUuid = null,
    Object? currentFen = null,
    Object? fenHistory = null,
    Object? fenCounts = null,
    Object? moves = null,
    Object? currentHalfmoveIndex = null,
    Object? result = freezed,
    Object? termination = null,
    Object? resignationSide = freezed,
    Object? timeoutSide = freezed,
    Object? agreementDraw = null,
    Object? halfmoveClock = null,
    Object? materialEvaluation = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      gameUuid: null == gameUuid
          ? _value.gameUuid
          : gameUuid // ignore: cast_nullable_to_non_nullable
              as String,
      currentFen: null == currentFen
          ? _value.currentFen
          : currentFen // ignore: cast_nullable_to_non_nullable
              as String,
      fenHistory: null == fenHistory
          ? _value.fenHistory
          : fenHistory // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fenCounts: null == fenCounts
          ? _value.fenCounts
          : fenCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      moves: null == moves
          ? _value.moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveDataModel>,
      currentHalfmoveIndex: null == currentHalfmoveIndex
          ? _value.currentHalfmoveIndex
          : currentHalfmoveIndex // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      termination: null == termination
          ? _value.termination
          : termination // ignore: cast_nullable_to_non_nullable
              as String,
      resignationSide: freezed == resignationSide
          ? _value.resignationSide
          : resignationSide // ignore: cast_nullable_to_non_nullable
              as String?,
      timeoutSide: freezed == timeoutSide
          ? _value.timeoutSide
          : timeoutSide // ignore: cast_nullable_to_non_nullable
              as String?,
      agreementDraw: null == agreementDraw
          ? _value.agreementDraw
          : agreementDraw // ignore: cast_nullable_to_non_nullable
              as bool,
      halfmoveClock: null == halfmoveClock
          ? _value.halfmoveClock
          : halfmoveClock // ignore: cast_nullable_to_non_nullable
              as int,
      materialEvaluation: null == materialEvaluation
          ? _value.materialEvaluation
          : materialEvaluation // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameStateModelImplCopyWith<$Res>
    implements $GameStateModelCopyWith<$Res> {
  factory _$$GameStateModelImplCopyWith(_$GameStateModelImpl value,
          $Res Function(_$GameStateModelImpl) then) =
      __$$GameStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gameUuid,
      String currentFen,
      List<String> fenHistory,
      Map<String, int> fenCounts,
      List<MoveDataModel> moves,
      int currentHalfmoveIndex,
      String? result,
      String termination,
      String? resignationSide,
      String? timeoutSide,
      bool agreementDraw,
      int halfmoveClock,
      int materialEvaluation,
      DateTime lastUpdated});
}

/// @nodoc
class __$$GameStateModelImplCopyWithImpl<$Res>
    extends _$GameStateModelCopyWithImpl<$Res, _$GameStateModelImpl>
    implements _$$GameStateModelImplCopyWith<$Res> {
  __$$GameStateModelImplCopyWithImpl(
      _$GameStateModelImpl _value, $Res Function(_$GameStateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameUuid = null,
    Object? currentFen = null,
    Object? fenHistory = null,
    Object? fenCounts = null,
    Object? moves = null,
    Object? currentHalfmoveIndex = null,
    Object? result = freezed,
    Object? termination = null,
    Object? resignationSide = freezed,
    Object? timeoutSide = freezed,
    Object? agreementDraw = null,
    Object? halfmoveClock = null,
    Object? materialEvaluation = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$GameStateModelImpl(
      gameUuid: null == gameUuid
          ? _value.gameUuid
          : gameUuid // ignore: cast_nullable_to_non_nullable
              as String,
      currentFen: null == currentFen
          ? _value.currentFen
          : currentFen // ignore: cast_nullable_to_non_nullable
              as String,
      fenHistory: null == fenHistory
          ? _value._fenHistory
          : fenHistory // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fenCounts: null == fenCounts
          ? _value._fenCounts
          : fenCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      moves: null == moves
          ? _value._moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveDataModel>,
      currentHalfmoveIndex: null == currentHalfmoveIndex
          ? _value.currentHalfmoveIndex
          : currentHalfmoveIndex // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      termination: null == termination
          ? _value.termination
          : termination // ignore: cast_nullable_to_non_nullable
              as String,
      resignationSide: freezed == resignationSide
          ? _value.resignationSide
          : resignationSide // ignore: cast_nullable_to_non_nullable
              as String?,
      timeoutSide: freezed == timeoutSide
          ? _value.timeoutSide
          : timeoutSide // ignore: cast_nullable_to_non_nullable
              as String?,
      agreementDraw: null == agreementDraw
          ? _value.agreementDraw
          : agreementDraw // ignore: cast_nullable_to_non_nullable
              as bool,
      halfmoveClock: null == halfmoveClock
          ? _value.halfmoveClock
          : halfmoveClock // ignore: cast_nullable_to_non_nullable
              as int,
      materialEvaluation: null == materialEvaluation
          ? _value.materialEvaluation
          : materialEvaluation // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateModelImpl implements _GameStateModel {
  const _$GameStateModelImpl(
      {required this.gameUuid,
      required this.currentFen,
      required final List<String> fenHistory,
      required final Map<String, int> fenCounts,
      required final List<MoveDataModel> moves,
      this.currentHalfmoveIndex = 0,
      this.result,
      this.termination = 'ongoing',
      this.resignationSide,
      this.timeoutSide,
      this.agreementDraw = false,
      this.halfmoveClock = 0,
      this.materialEvaluation = 0,
      required this.lastUpdated})
      : _fenHistory = fenHistory,
        _fenCounts = fenCounts,
        _moves = moves;

  factory _$GameStateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateModelImplFromJson(json);

  @override
  final String gameUuid;
  @override
  final String currentFen;
  final List<String> _fenHistory;
  @override
  List<String> get fenHistory {
    if (_fenHistory is EqualUnmodifiableListView) return _fenHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fenHistory);
  }

  final Map<String, int> _fenCounts;
  @override
  Map<String, int> get fenCounts {
    if (_fenCounts is EqualUnmodifiableMapView) return _fenCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fenCounts);
  }

  final List<MoveDataModel> _moves;
  @override
  List<MoveDataModel> get moves {
    if (_moves is EqualUnmodifiableListView) return _moves;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moves);
  }

  @override
  @JsonKey()
  final int currentHalfmoveIndex;
  @override
  final String? result;
  @override
  @JsonKey()
  final String termination;
  @override
  final String? resignationSide;
  @override
  final String? timeoutSide;
  @override
  @JsonKey()
  final bool agreementDraw;
  @override
  @JsonKey()
  final int halfmoveClock;
  @override
  @JsonKey()
  final int materialEvaluation;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'GameStateModel(gameUuid: $gameUuid, currentFen: $currentFen, fenHistory: $fenHistory, fenCounts: $fenCounts, moves: $moves, currentHalfmoveIndex: $currentHalfmoveIndex, result: $result, termination: $termination, resignationSide: $resignationSide, timeoutSide: $timeoutSide, agreementDraw: $agreementDraw, halfmoveClock: $halfmoveClock, materialEvaluation: $materialEvaluation, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateModelImpl &&
            (identical(other.gameUuid, gameUuid) ||
                other.gameUuid == gameUuid) &&
            (identical(other.currentFen, currentFen) ||
                other.currentFen == currentFen) &&
            const DeepCollectionEquality()
                .equals(other._fenHistory, _fenHistory) &&
            const DeepCollectionEquality()
                .equals(other._fenCounts, _fenCounts) &&
            const DeepCollectionEquality().equals(other._moves, _moves) &&
            (identical(other.currentHalfmoveIndex, currentHalfmoveIndex) ||
                other.currentHalfmoveIndex == currentHalfmoveIndex) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.termination, termination) ||
                other.termination == termination) &&
            (identical(other.resignationSide, resignationSide) ||
                other.resignationSide == resignationSide) &&
            (identical(other.timeoutSide, timeoutSide) ||
                other.timeoutSide == timeoutSide) &&
            (identical(other.agreementDraw, agreementDraw) ||
                other.agreementDraw == agreementDraw) &&
            (identical(other.halfmoveClock, halfmoveClock) ||
                other.halfmoveClock == halfmoveClock) &&
            (identical(other.materialEvaluation, materialEvaluation) ||
                other.materialEvaluation == materialEvaluation) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      gameUuid,
      currentFen,
      const DeepCollectionEquality().hash(_fenHistory),
      const DeepCollectionEquality().hash(_fenCounts),
      const DeepCollectionEquality().hash(_moves),
      currentHalfmoveIndex,
      result,
      termination,
      resignationSide,
      timeoutSide,
      agreementDraw,
      halfmoveClock,
      materialEvaluation,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateModelImplCopyWith<_$GameStateModelImpl> get copyWith =>
      __$$GameStateModelImplCopyWithImpl<_$GameStateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateModelImplToJson(
      this,
    );
  }
}

abstract class _GameStateModel implements GameStateModel {
  const factory _GameStateModel(
      {required final String gameUuid,
      required final String currentFen,
      required final List<String> fenHistory,
      required final Map<String, int> fenCounts,
      required final List<MoveDataModel> moves,
      final int currentHalfmoveIndex,
      final String? result,
      final String termination,
      final String? resignationSide,
      final String? timeoutSide,
      final bool agreementDraw,
      final int halfmoveClock,
      final int materialEvaluation,
      required final DateTime lastUpdated}) = _$GameStateModelImpl;

  factory _GameStateModel.fromJson(Map<String, dynamic> json) =
      _$GameStateModelImpl.fromJson;

  @override
  String get gameUuid;
  @override
  String get currentFen;
  @override
  List<String> get fenHistory;
  @override
  Map<String, int> get fenCounts;
  @override
  List<MoveDataModel> get moves;
  @override
  int get currentHalfmoveIndex;
  @override
  String? get result;
  @override
  String get termination;
  @override
  String? get resignationSide;
  @override
  String? get timeoutSide;
  @override
  bool get agreementDraw;
  @override
  int get halfmoveClock;
  @override
  int get materialEvaluation;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$GameStateModelImplCopyWith<_$GameStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
