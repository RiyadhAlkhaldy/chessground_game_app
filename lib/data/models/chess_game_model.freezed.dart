// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chess_game_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChessGameModel _$ChessGameModelFromJson(Map<String, dynamic> json) {
  return _ChessGameModel.fromJson(json);
}

/// @nodoc
mixin _$ChessGameModel {
  int? get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String? get event => throw _privateConstructorUsedError;
  String? get site => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get round => throw _privateConstructorUsedError;
  PlayerModel get whitePlayer => throw _privateConstructorUsedError;
  PlayerModel get blackPlayer => throw _privateConstructorUsedError;
  String get result =>
      throw _privateConstructorUsedError; // "1-0", "0-1", "1/2-1/2", "*"
  GameTermination get termination =>
      throw _privateConstructorUsedError; // إضافات تحليلية ووصفية
  String? get eco => throw _privateConstructorUsedError;
  int? get whiteElo => throw _privateConstructorUsedError;
  int? get blackElo => throw _privateConstructorUsedError;
  String? get timeControl => throw _privateConstructorUsedError;
  String? get startingFen =>
      throw _privateConstructorUsedError; // للـ non-standard start
  String? get fullPgn =>
      throw _privateConstructorUsedError; // النص الكامل للمباراة (مصدر)
  int get movesCount => throw _privateConstructorUsedError;
  List<MoveDataModel> get moves => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChessGameModelCopyWith<ChessGameModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChessGameModelCopyWith<$Res> {
  factory $ChessGameModelCopyWith(
          ChessGameModel value, $Res Function(ChessGameModel) then) =
      _$ChessGameModelCopyWithImpl<$Res, ChessGameModel>;
  @useResult
  $Res call(
      {int? id,
      String uuid,
      String? event,
      String? site,
      DateTime? date,
      String? round,
      PlayerModel whitePlayer,
      PlayerModel blackPlayer,
      String result,
      GameTermination termination,
      String? eco,
      int? whiteElo,
      int? blackElo,
      String? timeControl,
      String? startingFen,
      String? fullPgn,
      int movesCount,
      List<MoveDataModel> moves});

  $PlayerModelCopyWith<$Res> get whitePlayer;
  $PlayerModelCopyWith<$Res> get blackPlayer;
}

/// @nodoc
class _$ChessGameModelCopyWithImpl<$Res, $Val extends ChessGameModel>
    implements $ChessGameModelCopyWith<$Res> {
  _$ChessGameModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = null,
    Object? event = freezed,
    Object? site = freezed,
    Object? date = freezed,
    Object? round = freezed,
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? result = null,
    Object? termination = null,
    Object? eco = freezed,
    Object? whiteElo = freezed,
    Object? blackElo = freezed,
    Object? timeControl = freezed,
    Object? startingFen = freezed,
    Object? fullPgn = freezed,
    Object? movesCount = null,
    Object? moves = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as String?,
      whitePlayer: null == whitePlayer
          ? _value.whitePlayer
          : whitePlayer // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      blackPlayer: null == blackPlayer
          ? _value.blackPlayer
          : blackPlayer // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      termination: null == termination
          ? _value.termination
          : termination // ignore: cast_nullable_to_non_nullable
              as GameTermination,
      eco: freezed == eco
          ? _value.eco
          : eco // ignore: cast_nullable_to_non_nullable
              as String?,
      whiteElo: freezed == whiteElo
          ? _value.whiteElo
          : whiteElo // ignore: cast_nullable_to_non_nullable
              as int?,
      blackElo: freezed == blackElo
          ? _value.blackElo
          : blackElo // ignore: cast_nullable_to_non_nullable
              as int?,
      timeControl: freezed == timeControl
          ? _value.timeControl
          : timeControl // ignore: cast_nullable_to_non_nullable
              as String?,
      startingFen: freezed == startingFen
          ? _value.startingFen
          : startingFen // ignore: cast_nullable_to_non_nullable
              as String?,
      fullPgn: freezed == fullPgn
          ? _value.fullPgn
          : fullPgn // ignore: cast_nullable_to_non_nullable
              as String?,
      movesCount: null == movesCount
          ? _value.movesCount
          : movesCount // ignore: cast_nullable_to_non_nullable
              as int,
      moves: null == moves
          ? _value.moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveDataModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerModelCopyWith<$Res> get whitePlayer {
    return $PlayerModelCopyWith<$Res>(_value.whitePlayer, (value) {
      return _then(_value.copyWith(whitePlayer: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerModelCopyWith<$Res> get blackPlayer {
    return $PlayerModelCopyWith<$Res>(_value.blackPlayer, (value) {
      return _then(_value.copyWith(blackPlayer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChessGameModelImplCopyWith<$Res>
    implements $ChessGameModelCopyWith<$Res> {
  factory _$$ChessGameModelImplCopyWith(_$ChessGameModelImpl value,
          $Res Function(_$ChessGameModelImpl) then) =
      __$$ChessGameModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String uuid,
      String? event,
      String? site,
      DateTime? date,
      String? round,
      PlayerModel whitePlayer,
      PlayerModel blackPlayer,
      String result,
      GameTermination termination,
      String? eco,
      int? whiteElo,
      int? blackElo,
      String? timeControl,
      String? startingFen,
      String? fullPgn,
      int movesCount,
      List<MoveDataModel> moves});

  @override
  $PlayerModelCopyWith<$Res> get whitePlayer;
  @override
  $PlayerModelCopyWith<$Res> get blackPlayer;
}

/// @nodoc
class __$$ChessGameModelImplCopyWithImpl<$Res>
    extends _$ChessGameModelCopyWithImpl<$Res, _$ChessGameModelImpl>
    implements _$$ChessGameModelImplCopyWith<$Res> {
  __$$ChessGameModelImplCopyWithImpl(
      _$ChessGameModelImpl _value, $Res Function(_$ChessGameModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = null,
    Object? event = freezed,
    Object? site = freezed,
    Object? date = freezed,
    Object? round = freezed,
    Object? whitePlayer = null,
    Object? blackPlayer = null,
    Object? result = null,
    Object? termination = null,
    Object? eco = freezed,
    Object? whiteElo = freezed,
    Object? blackElo = freezed,
    Object? timeControl = freezed,
    Object? startingFen = freezed,
    Object? fullPgn = freezed,
    Object? movesCount = null,
    Object? moves = null,
  }) {
    return _then(_$ChessGameModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String?,
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as String?,
      whitePlayer: null == whitePlayer
          ? _value.whitePlayer
          : whitePlayer // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      blackPlayer: null == blackPlayer
          ? _value.blackPlayer
          : blackPlayer // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      termination: null == termination
          ? _value.termination
          : termination // ignore: cast_nullable_to_non_nullable
              as GameTermination,
      eco: freezed == eco
          ? _value.eco
          : eco // ignore: cast_nullable_to_non_nullable
              as String?,
      whiteElo: freezed == whiteElo
          ? _value.whiteElo
          : whiteElo // ignore: cast_nullable_to_non_nullable
              as int?,
      blackElo: freezed == blackElo
          ? _value.blackElo
          : blackElo // ignore: cast_nullable_to_non_nullable
              as int?,
      timeControl: freezed == timeControl
          ? _value.timeControl
          : timeControl // ignore: cast_nullable_to_non_nullable
              as String?,
      startingFen: freezed == startingFen
          ? _value.startingFen
          : startingFen // ignore: cast_nullable_to_non_nullable
              as String?,
      fullPgn: freezed == fullPgn
          ? _value.fullPgn
          : fullPgn // ignore: cast_nullable_to_non_nullable
              as String?,
      movesCount: null == movesCount
          ? _value.movesCount
          : movesCount // ignore: cast_nullable_to_non_nullable
              as int,
      moves: null == moves
          ? _value._moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveDataModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChessGameModelImpl implements _ChessGameModel {
  const _$ChessGameModelImpl(
      {required this.id,
      required this.uuid,
      this.event,
      this.site,
      this.date,
      this.round,
      required this.whitePlayer,
      required this.blackPlayer,
      this.result = '*',
      this.termination = GameTermination.ongoing,
      this.eco,
      this.whiteElo,
      this.blackElo,
      this.timeControl,
      this.startingFen,
      this.fullPgn,
      this.movesCount = 0,
      final List<MoveDataModel> moves = const []})
      : _moves = moves;

  factory _$ChessGameModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChessGameModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String uuid;
  @override
  final String? event;
  @override
  final String? site;
  @override
  final DateTime? date;
  @override
  final String? round;
  @override
  final PlayerModel whitePlayer;
  @override
  final PlayerModel blackPlayer;
  @override
  @JsonKey()
  final String result;
// "1-0", "0-1", "1/2-1/2", "*"
  @override
  @JsonKey()
  final GameTermination termination;
// إضافات تحليلية ووصفية
  @override
  final String? eco;
  @override
  final int? whiteElo;
  @override
  final int? blackElo;
  @override
  final String? timeControl;
  @override
  final String? startingFen;
// للـ non-standard start
  @override
  final String? fullPgn;
// النص الكامل للمباراة (مصدر)
  @override
  @JsonKey()
  final int movesCount;
  final List<MoveDataModel> _moves;
  @override
  @JsonKey()
  List<MoveDataModel> get moves {
    if (_moves is EqualUnmodifiableListView) return _moves;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moves);
  }

  @override
  String toString() {
    return 'ChessGameModel(id: $id, uuid: $uuid, event: $event, site: $site, date: $date, round: $round, whitePlayer: $whitePlayer, blackPlayer: $blackPlayer, result: $result, termination: $termination, eco: $eco, whiteElo: $whiteElo, blackElo: $blackElo, timeControl: $timeControl, startingFen: $startingFen, fullPgn: $fullPgn, movesCount: $movesCount, moves: $moves)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChessGameModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.whitePlayer, whitePlayer) ||
                other.whitePlayer == whitePlayer) &&
            (identical(other.blackPlayer, blackPlayer) ||
                other.blackPlayer == blackPlayer) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.termination, termination) ||
                other.termination == termination) &&
            (identical(other.eco, eco) || other.eco == eco) &&
            (identical(other.whiteElo, whiteElo) ||
                other.whiteElo == whiteElo) &&
            (identical(other.blackElo, blackElo) ||
                other.blackElo == blackElo) &&
            (identical(other.timeControl, timeControl) ||
                other.timeControl == timeControl) &&
            (identical(other.startingFen, startingFen) ||
                other.startingFen == startingFen) &&
            (identical(other.fullPgn, fullPgn) || other.fullPgn == fullPgn) &&
            (identical(other.movesCount, movesCount) ||
                other.movesCount == movesCount) &&
            const DeepCollectionEquality().equals(other._moves, _moves));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uuid,
      event,
      site,
      date,
      round,
      whitePlayer,
      blackPlayer,
      result,
      termination,
      eco,
      whiteElo,
      blackElo,
      timeControl,
      startingFen,
      fullPgn,
      movesCount,
      const DeepCollectionEquality().hash(_moves));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChessGameModelImplCopyWith<_$ChessGameModelImpl> get copyWith =>
      __$$ChessGameModelImplCopyWithImpl<_$ChessGameModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChessGameModelImplToJson(
      this,
    );
  }
}

abstract class _ChessGameModel implements ChessGameModel {
  const factory _ChessGameModel(
      {required final int? id,
      required final String uuid,
      final String? event,
      final String? site,
      final DateTime? date,
      final String? round,
      required final PlayerModel whitePlayer,
      required final PlayerModel blackPlayer,
      final String result,
      final GameTermination termination,
      final String? eco,
      final int? whiteElo,
      final int? blackElo,
      final String? timeControl,
      final String? startingFen,
      final String? fullPgn,
      final int movesCount,
      final List<MoveDataModel> moves}) = _$ChessGameModelImpl;

  factory _ChessGameModel.fromJson(Map<String, dynamic> json) =
      _$ChessGameModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get uuid;
  @override
  String? get event;
  @override
  String? get site;
  @override
  DateTime? get date;
  @override
  String? get round;
  @override
  PlayerModel get whitePlayer;
  @override
  PlayerModel get blackPlayer;
  @override
  String get result;
  @override // "1-0", "0-1", "1/2-1/2", "*"
  GameTermination get termination;
  @override // إضافات تحليلية ووصفية
  String? get eco;
  @override
  int? get whiteElo;
  @override
  int? get blackElo;
  @override
  String? get timeControl;
  @override
  String? get startingFen;
  @override // للـ non-standard start
  String? get fullPgn;
  @override // النص الكامل للمباراة (مصدر)
  int get movesCount;
  @override
  List<MoveDataModel> get moves;
  @override
  @JsonKey(ignore: true)
  _$$ChessGameModelImplCopyWith<_$ChessGameModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
