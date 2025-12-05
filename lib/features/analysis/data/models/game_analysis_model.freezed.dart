// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameAnalysisModel _$GameAnalysisModelFromJson(Map<String, dynamic> json) {
  return _GameAnalysisModel.fromJson(json);
}

/// @nodoc
mixin _$GameAnalysisModel {
  int? get id => throw _privateConstructorUsedError;
  String get gameUuid => throw _privateConstructorUsedError;
  String get moveEvaluationsJson => throw _privateConstructorUsedError;
  double? get whiteAccuracy => throw _privateConstructorUsedError;
  double? get blackAccuracy => throw _privateConstructorUsedError;
  int get whiteBlunders => throw _privateConstructorUsedError;
  int get blackBlunders => throw _privateConstructorUsedError;
  int get whiteMistakes => throw _privateConstructorUsedError;
  int get blackMistakes => throw _privateConstructorUsedError;
  int get whiteInaccuracies => throw _privateConstructorUsedError;
  int get blackInaccuracies => throw _privateConstructorUsedError;
  String? get openingName => throw _privateConstructorUsedError;
  String? get eco => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  DateTime get analyzedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameAnalysisModelCopyWith<GameAnalysisModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameAnalysisModelCopyWith<$Res> {
  factory $GameAnalysisModelCopyWith(
          GameAnalysisModel value, $Res Function(GameAnalysisModel) then) =
      _$GameAnalysisModelCopyWithImpl<$Res, GameAnalysisModel>;
  @useResult
  $Res call(
      {int? id,
      String gameUuid,
      String moveEvaluationsJson,
      double? whiteAccuracy,
      double? blackAccuracy,
      int whiteBlunders,
      int blackBlunders,
      int whiteMistakes,
      int blackMistakes,
      int whiteInaccuracies,
      int blackInaccuracies,
      String? openingName,
      String? eco,
      double completionPercentage,
      DateTime analyzedAt});
}

/// @nodoc
class _$GameAnalysisModelCopyWithImpl<$Res, $Val extends GameAnalysisModel>
    implements $GameAnalysisModelCopyWith<$Res> {
  _$GameAnalysisModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? gameUuid = null,
    Object? moveEvaluationsJson = null,
    Object? whiteAccuracy = freezed,
    Object? blackAccuracy = freezed,
    Object? whiteBlunders = null,
    Object? blackBlunders = null,
    Object? whiteMistakes = null,
    Object? blackMistakes = null,
    Object? whiteInaccuracies = null,
    Object? blackInaccuracies = null,
    Object? openingName = freezed,
    Object? eco = freezed,
    Object? completionPercentage = null,
    Object? analyzedAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      gameUuid: null == gameUuid
          ? _value.gameUuid
          : gameUuid // ignore: cast_nullable_to_non_nullable
              as String,
      moveEvaluationsJson: null == moveEvaluationsJson
          ? _value.moveEvaluationsJson
          : moveEvaluationsJson // ignore: cast_nullable_to_non_nullable
              as String,
      whiteAccuracy: freezed == whiteAccuracy
          ? _value.whiteAccuracy
          : whiteAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      blackAccuracy: freezed == blackAccuracy
          ? _value.blackAccuracy
          : blackAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      whiteBlunders: null == whiteBlunders
          ? _value.whiteBlunders
          : whiteBlunders // ignore: cast_nullable_to_non_nullable
              as int,
      blackBlunders: null == blackBlunders
          ? _value.blackBlunders
          : blackBlunders // ignore: cast_nullable_to_non_nullable
              as int,
      whiteMistakes: null == whiteMistakes
          ? _value.whiteMistakes
          : whiteMistakes // ignore: cast_nullable_to_non_nullable
              as int,
      blackMistakes: null == blackMistakes
          ? _value.blackMistakes
          : blackMistakes // ignore: cast_nullable_to_non_nullable
              as int,
      whiteInaccuracies: null == whiteInaccuracies
          ? _value.whiteInaccuracies
          : whiteInaccuracies // ignore: cast_nullable_to_non_nullable
              as int,
      blackInaccuracies: null == blackInaccuracies
          ? _value.blackInaccuracies
          : blackInaccuracies // ignore: cast_nullable_to_non_nullable
              as int,
      openingName: freezed == openingName
          ? _value.openingName
          : openingName // ignore: cast_nullable_to_non_nullable
              as String?,
      eco: freezed == eco
          ? _value.eco
          : eco // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameAnalysisModelImplCopyWith<$Res>
    implements $GameAnalysisModelCopyWith<$Res> {
  factory _$$GameAnalysisModelImplCopyWith(_$GameAnalysisModelImpl value,
          $Res Function(_$GameAnalysisModelImpl) then) =
      __$$GameAnalysisModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String gameUuid,
      String moveEvaluationsJson,
      double? whiteAccuracy,
      double? blackAccuracy,
      int whiteBlunders,
      int blackBlunders,
      int whiteMistakes,
      int blackMistakes,
      int whiteInaccuracies,
      int blackInaccuracies,
      String? openingName,
      String? eco,
      double completionPercentage,
      DateTime analyzedAt});
}

/// @nodoc
class __$$GameAnalysisModelImplCopyWithImpl<$Res>
    extends _$GameAnalysisModelCopyWithImpl<$Res, _$GameAnalysisModelImpl>
    implements _$$GameAnalysisModelImplCopyWith<$Res> {
  __$$GameAnalysisModelImplCopyWithImpl(_$GameAnalysisModelImpl _value,
      $Res Function(_$GameAnalysisModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? gameUuid = null,
    Object? moveEvaluationsJson = null,
    Object? whiteAccuracy = freezed,
    Object? blackAccuracy = freezed,
    Object? whiteBlunders = null,
    Object? blackBlunders = null,
    Object? whiteMistakes = null,
    Object? blackMistakes = null,
    Object? whiteInaccuracies = null,
    Object? blackInaccuracies = null,
    Object? openingName = freezed,
    Object? eco = freezed,
    Object? completionPercentage = null,
    Object? analyzedAt = null,
  }) {
    return _then(_$GameAnalysisModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      gameUuid: null == gameUuid
          ? _value.gameUuid
          : gameUuid // ignore: cast_nullable_to_non_nullable
              as String,
      moveEvaluationsJson: null == moveEvaluationsJson
          ? _value.moveEvaluationsJson
          : moveEvaluationsJson // ignore: cast_nullable_to_non_nullable
              as String,
      whiteAccuracy: freezed == whiteAccuracy
          ? _value.whiteAccuracy
          : whiteAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      blackAccuracy: freezed == blackAccuracy
          ? _value.blackAccuracy
          : blackAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      whiteBlunders: null == whiteBlunders
          ? _value.whiteBlunders
          : whiteBlunders // ignore: cast_nullable_to_non_nullable
              as int,
      blackBlunders: null == blackBlunders
          ? _value.blackBlunders
          : blackBlunders // ignore: cast_nullable_to_non_nullable
              as int,
      whiteMistakes: null == whiteMistakes
          ? _value.whiteMistakes
          : whiteMistakes // ignore: cast_nullable_to_non_nullable
              as int,
      blackMistakes: null == blackMistakes
          ? _value.blackMistakes
          : blackMistakes // ignore: cast_nullable_to_non_nullable
              as int,
      whiteInaccuracies: null == whiteInaccuracies
          ? _value.whiteInaccuracies
          : whiteInaccuracies // ignore: cast_nullable_to_non_nullable
              as int,
      blackInaccuracies: null == blackInaccuracies
          ? _value.blackInaccuracies
          : blackInaccuracies // ignore: cast_nullable_to_non_nullable
              as int,
      openingName: freezed == openingName
          ? _value.openingName
          : openingName // ignore: cast_nullable_to_non_nullable
              as String?,
      eco: freezed == eco
          ? _value.eco
          : eco // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameAnalysisModelImpl implements _GameAnalysisModel {
  const _$GameAnalysisModelImpl(
      {this.id,
      required this.gameUuid,
      required this.moveEvaluationsJson,
      this.whiteAccuracy,
      this.blackAccuracy,
      this.whiteBlunders = 0,
      this.blackBlunders = 0,
      this.whiteMistakes = 0,
      this.blackMistakes = 0,
      this.whiteInaccuracies = 0,
      this.blackInaccuracies = 0,
      this.openingName,
      this.eco,
      this.completionPercentage = 0.0,
      required this.analyzedAt});

  factory _$GameAnalysisModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameAnalysisModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String gameUuid;
  @override
  final String moveEvaluationsJson;
  @override
  final double? whiteAccuracy;
  @override
  final double? blackAccuracy;
  @override
  @JsonKey()
  final int whiteBlunders;
  @override
  @JsonKey()
  final int blackBlunders;
  @override
  @JsonKey()
  final int whiteMistakes;
  @override
  @JsonKey()
  final int blackMistakes;
  @override
  @JsonKey()
  final int whiteInaccuracies;
  @override
  @JsonKey()
  final int blackInaccuracies;
  @override
  final String? openingName;
  @override
  final String? eco;
  @override
  @JsonKey()
  final double completionPercentage;
  @override
  final DateTime analyzedAt;

  @override
  String toString() {
    return 'GameAnalysisModel(id: $id, gameUuid: $gameUuid, moveEvaluationsJson: $moveEvaluationsJson, whiteAccuracy: $whiteAccuracy, blackAccuracy: $blackAccuracy, whiteBlunders: $whiteBlunders, blackBlunders: $blackBlunders, whiteMistakes: $whiteMistakes, blackMistakes: $blackMistakes, whiteInaccuracies: $whiteInaccuracies, blackInaccuracies: $blackInaccuracies, openingName: $openingName, eco: $eco, completionPercentage: $completionPercentage, analyzedAt: $analyzedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameAnalysisModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameUuid, gameUuid) ||
                other.gameUuid == gameUuid) &&
            (identical(other.moveEvaluationsJson, moveEvaluationsJson) ||
                other.moveEvaluationsJson == moveEvaluationsJson) &&
            (identical(other.whiteAccuracy, whiteAccuracy) ||
                other.whiteAccuracy == whiteAccuracy) &&
            (identical(other.blackAccuracy, blackAccuracy) ||
                other.blackAccuracy == blackAccuracy) &&
            (identical(other.whiteBlunders, whiteBlunders) ||
                other.whiteBlunders == whiteBlunders) &&
            (identical(other.blackBlunders, blackBlunders) ||
                other.blackBlunders == blackBlunders) &&
            (identical(other.whiteMistakes, whiteMistakes) ||
                other.whiteMistakes == whiteMistakes) &&
            (identical(other.blackMistakes, blackMistakes) ||
                other.blackMistakes == blackMistakes) &&
            (identical(other.whiteInaccuracies, whiteInaccuracies) ||
                other.whiteInaccuracies == whiteInaccuracies) &&
            (identical(other.blackInaccuracies, blackInaccuracies) ||
                other.blackInaccuracies == blackInaccuracies) &&
            (identical(other.openingName, openingName) ||
                other.openingName == openingName) &&
            (identical(other.eco, eco) || other.eco == eco) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      gameUuid,
      moveEvaluationsJson,
      whiteAccuracy,
      blackAccuracy,
      whiteBlunders,
      blackBlunders,
      whiteMistakes,
      blackMistakes,
      whiteInaccuracies,
      blackInaccuracies,
      openingName,
      eco,
      completionPercentage,
      analyzedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameAnalysisModelImplCopyWith<_$GameAnalysisModelImpl> get copyWith =>
      __$$GameAnalysisModelImplCopyWithImpl<_$GameAnalysisModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameAnalysisModelImplToJson(
      this,
    );
  }
}

abstract class _GameAnalysisModel implements GameAnalysisModel {
  const factory _GameAnalysisModel(
      {final int? id,
      required final String gameUuid,
      required final String moveEvaluationsJson,
      final double? whiteAccuracy,
      final double? blackAccuracy,
      final int whiteBlunders,
      final int blackBlunders,
      final int whiteMistakes,
      final int blackMistakes,
      final int whiteInaccuracies,
      final int blackInaccuracies,
      final String? openingName,
      final String? eco,
      final double completionPercentage,
      required final DateTime analyzedAt}) = _$GameAnalysisModelImpl;

  factory _GameAnalysisModel.fromJson(Map<String, dynamic> json) =
      _$GameAnalysisModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get gameUuid;
  @override
  String get moveEvaluationsJson;
  @override
  double? get whiteAccuracy;
  @override
  double? get blackAccuracy;
  @override
  int get whiteBlunders;
  @override
  int get blackBlunders;
  @override
  int get whiteMistakes;
  @override
  int get blackMistakes;
  @override
  int get whiteInaccuracies;
  @override
  int get blackInaccuracies;
  @override
  String? get openingName;
  @override
  String? get eco;
  @override
  double get completionPercentage;
  @override
  DateTime get analyzedAt;
  @override
  @JsonKey(ignore: true)
  _$$GameAnalysisModelImplCopyWith<_$GameAnalysisModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
