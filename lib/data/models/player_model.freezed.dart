// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
// المفتاح المحلي في Isar. يجب أن يكون اختياريًا (nullable) عند الإنشاء.
  int? get id =>
      throw _privateConstructorUsedError; // UUID ثابت للتعرّف على اللاعب، وهو جزء أساسي من هوية اللاعب.
  String get uuid => throw _privateConstructorUsedError; // اسم اللاعب
  String get name =>
      throw _privateConstructorUsedError; // نوع اللاعب (guest/human/computer/registered)
  String get type => throw _privateConstructorUsedError; // تصنيف اللاعب
  int get playerRating => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get image =>
      throw _privateConstructorUsedError; // تاريخ الإنشاء. يجب أن يكون اختياريًا/تلقائيًا.
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
          PlayerModel value, $Res Function(PlayerModel) then) =
      _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call(
      {int? id,
      String uuid,
      String name,
      String type,
      int playerRating,
      String? email,
      String? image,
      DateTime createdAt});
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = null,
    Object? name = null,
    Object? type = null,
    Object? playerRating = null,
    Object? email = freezed,
    Object? image = freezed,
    Object? createdAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      playerRating: null == playerRating
          ? _value.playerRating
          : playerRating // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
          _$PlayerModelImpl value, $Res Function(_$PlayerModelImpl) then) =
      __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String uuid,
      String name,
      String type,
      int playerRating,
      String? email,
      String? image,
      DateTime createdAt});
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
      _$PlayerModelImpl _value, $Res Function(_$PlayerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = null,
    Object? name = null,
    Object? type = null,
    Object? playerRating = null,
    Object? email = freezed,
    Object? image = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PlayerModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      playerRating: null == playerRating
          ? _value.playerRating
          : playerRating // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl implements _PlayerModel {
  const _$PlayerModelImpl(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.type,
      this.playerRating = 1200,
      this.email,
      this.image,
      required this.createdAt});

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

// المفتاح المحلي في Isar. يجب أن يكون اختياريًا (nullable) عند الإنشاء.
  @override
  final int? id;
// UUID ثابت للتعرّف على اللاعب، وهو جزء أساسي من هوية اللاعب.
  @override
  final String uuid;
// اسم اللاعب
  @override
  final String name;
// نوع اللاعب (guest/human/computer/registered)
  @override
  final String type;
// تصنيف اللاعب
  @override
  @JsonKey()
  final int playerRating;
  @override
  final String? email;
  @override
  final String? image;
// تاريخ الإنشاء. يجب أن يكون اختياريًا/تلقائيًا.
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PlayerModel(id: $id, uuid: $uuid, name: $name, type: $type, playerRating: $playerRating, email: $email, image: $image, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.playerRating, playerRating) ||
                other.playerRating == playerRating) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, uuid, name, type, playerRating, email, image, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(
      this,
    );
  }
}

abstract class _PlayerModel implements PlayerModel {
  const factory _PlayerModel(
      {required final int? id,
      required final String uuid,
      required final String name,
      required final String type,
      final int playerRating,
      final String? email,
      final String? image,
      required final DateTime createdAt}) = _$PlayerModelImpl;

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

  @override // المفتاح المحلي في Isar. يجب أن يكون اختياريًا (nullable) عند الإنشاء.
  int? get id;
  @override // UUID ثابت للتعرّف على اللاعب، وهو جزء أساسي من هوية اللاعب.
  String get uuid;
  @override // اسم اللاعب
  String get name;
  @override // نوع اللاعب (guest/human/computer/registered)
  String get type;
  @override // تصنيف اللاعب
  int get playerRating;
  @override
  String? get email;
  @override
  String? get image;
  @override // تاريخ الإنشاء. يجب أن يكون اختياريًا/تلقائيًا.
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
