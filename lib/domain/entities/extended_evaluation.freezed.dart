// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extended_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtendedEvaluation {

 int get depth; int? get cp;// centipawns (من منظور white عادةً)
 int? get mate;// mate in N (±)
 String get pv; int? get wdlWin;// permille: 500 => 50.0%
 int? get wdlDraw; int? get wdlLoss;
/// Create a copy of ExtendedEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtendedEvaluationCopyWith<ExtendedEvaluation> get copyWith => _$ExtendedEvaluationCopyWithImpl<ExtendedEvaluation>(this as ExtendedEvaluation, _$identity);

  /// Serializes this ExtendedEvaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtendedEvaluation&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.cp, cp) || other.cp == cp)&&(identical(other.mate, mate) || other.mate == mate)&&(identical(other.pv, pv) || other.pv == pv)&&(identical(other.wdlWin, wdlWin) || other.wdlWin == wdlWin)&&(identical(other.wdlDraw, wdlDraw) || other.wdlDraw == wdlDraw)&&(identical(other.wdlLoss, wdlLoss) || other.wdlLoss == wdlLoss));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,depth,cp,mate,pv,wdlWin,wdlDraw,wdlLoss);

@override
String toString() {
  return 'ExtendedEvaluation(depth: $depth, cp: $cp, mate: $mate, pv: $pv, wdlWin: $wdlWin, wdlDraw: $wdlDraw, wdlLoss: $wdlLoss)';
}


}

/// @nodoc
abstract mixin class $ExtendedEvaluationCopyWith<$Res>  {
  factory $ExtendedEvaluationCopyWith(ExtendedEvaluation value, $Res Function(ExtendedEvaluation) _then) = _$ExtendedEvaluationCopyWithImpl;
@useResult
$Res call({
 int depth, int? cp, int? mate, String pv, int? wdlWin, int? wdlDraw, int? wdlLoss
});




}
/// @nodoc
class _$ExtendedEvaluationCopyWithImpl<$Res>
    implements $ExtendedEvaluationCopyWith<$Res> {
  _$ExtendedEvaluationCopyWithImpl(this._self, this._then);

  final ExtendedEvaluation _self;
  final $Res Function(ExtendedEvaluation) _then;

/// Create a copy of ExtendedEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? depth = null,Object? cp = freezed,Object? mate = freezed,Object? pv = null,Object? wdlWin = freezed,Object? wdlDraw = freezed,Object? wdlLoss = freezed,}) {
  return _then(_self.copyWith(
depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,cp: freezed == cp ? _self.cp : cp // ignore: cast_nullable_to_non_nullable
as int?,mate: freezed == mate ? _self.mate : mate // ignore: cast_nullable_to_non_nullable
as int?,pv: null == pv ? _self.pv : pv // ignore: cast_nullable_to_non_nullable
as String,wdlWin: freezed == wdlWin ? _self.wdlWin : wdlWin // ignore: cast_nullable_to_non_nullable
as int?,wdlDraw: freezed == wdlDraw ? _self.wdlDraw : wdlDraw // ignore: cast_nullable_to_non_nullable
as int?,wdlLoss: freezed == wdlLoss ? _self.wdlLoss : wdlLoss // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtendedEvaluation].
extension ExtendedEvaluationPatterns on ExtendedEvaluation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtendedEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtendedEvaluation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtendedEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _ExtendedEvaluation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtendedEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _ExtendedEvaluation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int depth,  int? cp,  int? mate,  String pv,  int? wdlWin,  int? wdlDraw,  int? wdlLoss)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtendedEvaluation() when $default != null:
return $default(_that.depth,_that.cp,_that.mate,_that.pv,_that.wdlWin,_that.wdlDraw,_that.wdlLoss);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int depth,  int? cp,  int? mate,  String pv,  int? wdlWin,  int? wdlDraw,  int? wdlLoss)  $default,) {final _that = this;
switch (_that) {
case _ExtendedEvaluation():
return $default(_that.depth,_that.cp,_that.mate,_that.pv,_that.wdlWin,_that.wdlDraw,_that.wdlLoss);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int depth,  int? cp,  int? mate,  String pv,  int? wdlWin,  int? wdlDraw,  int? wdlLoss)?  $default,) {final _that = this;
switch (_that) {
case _ExtendedEvaluation() when $default != null:
return $default(_that.depth,_that.cp,_that.mate,_that.pv,_that.wdlWin,_that.wdlDraw,_that.wdlLoss);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtendedEvaluation implements ExtendedEvaluation {
  const _ExtendedEvaluation({required this.depth, this.cp, this.mate, this.pv = '', this.wdlWin, this.wdlDraw, this.wdlLoss});
  factory _ExtendedEvaluation.fromJson(Map<String, dynamic> json) => _$ExtendedEvaluationFromJson(json);

@override final  int depth;
@override final  int? cp;
// centipawns (من منظور white عادةً)
@override final  int? mate;
// mate in N (±)
@override@JsonKey() final  String pv;
@override final  int? wdlWin;
// permille: 500 => 50.0%
@override final  int? wdlDraw;
@override final  int? wdlLoss;

/// Create a copy of ExtendedEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtendedEvaluationCopyWith<_ExtendedEvaluation> get copyWith => __$ExtendedEvaluationCopyWithImpl<_ExtendedEvaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtendedEvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtendedEvaluation&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.cp, cp) || other.cp == cp)&&(identical(other.mate, mate) || other.mate == mate)&&(identical(other.pv, pv) || other.pv == pv)&&(identical(other.wdlWin, wdlWin) || other.wdlWin == wdlWin)&&(identical(other.wdlDraw, wdlDraw) || other.wdlDraw == wdlDraw)&&(identical(other.wdlLoss, wdlLoss) || other.wdlLoss == wdlLoss));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,depth,cp,mate,pv,wdlWin,wdlDraw,wdlLoss);

@override
String toString() {
  return 'ExtendedEvaluation(depth: $depth, cp: $cp, mate: $mate, pv: $pv, wdlWin: $wdlWin, wdlDraw: $wdlDraw, wdlLoss: $wdlLoss)';
}


}

/// @nodoc
abstract mixin class _$ExtendedEvaluationCopyWith<$Res> implements $ExtendedEvaluationCopyWith<$Res> {
  factory _$ExtendedEvaluationCopyWith(_ExtendedEvaluation value, $Res Function(_ExtendedEvaluation) _then) = __$ExtendedEvaluationCopyWithImpl;
@override @useResult
$Res call({
 int depth, int? cp, int? mate, String pv, int? wdlWin, int? wdlDraw, int? wdlLoss
});




}
/// @nodoc
class __$ExtendedEvaluationCopyWithImpl<$Res>
    implements _$ExtendedEvaluationCopyWith<$Res> {
  __$ExtendedEvaluationCopyWithImpl(this._self, this._then);

  final _ExtendedEvaluation _self;
  final $Res Function(_ExtendedEvaluation) _then;

/// Create a copy of ExtendedEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? depth = null,Object? cp = freezed,Object? mate = freezed,Object? pv = null,Object? wdlWin = freezed,Object? wdlDraw = freezed,Object? wdlLoss = freezed,}) {
  return _then(_ExtendedEvaluation(
depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,cp: freezed == cp ? _self.cp : cp // ignore: cast_nullable_to_non_nullable
as int?,mate: freezed == mate ? _self.mate : mate // ignore: cast_nullable_to_non_nullable
as int?,pv: null == pv ? _self.pv : pv // ignore: cast_nullable_to_non_nullable
as String,wdlWin: freezed == wdlWin ? _self.wdlWin : wdlWin // ignore: cast_nullable_to_non_nullable
as int?,wdlDraw: freezed == wdlDraw ? _self.wdlDraw : wdlDraw // ignore: cast_nullable_to_non_nullable
as int?,wdlLoss: freezed == wdlLoss ? _self.wdlLoss : wdlLoss // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
