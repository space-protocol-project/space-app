// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_microphone_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceMicrophoneTestState {

 bool get active; bool get busy; double get level; String get error;
/// Create a copy of VoiceMicrophoneTestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceMicrophoneTestStateCopyWith<VoiceMicrophoneTestState> get copyWith => _$VoiceMicrophoneTestStateCopyWithImpl<VoiceMicrophoneTestState>(this as VoiceMicrophoneTestState, _$identity);





@override
String toString() {
  final _this = this as VoiceMicrophoneTestState;
  return 'VoiceMicrophoneTestState(active: ${_this.active}, busy: ${_this.busy}, level: ${_this.level}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $VoiceMicrophoneTestStateCopyWith<$Res>  {
  factory $VoiceMicrophoneTestStateCopyWith(VoiceMicrophoneTestState value, $Res Function(VoiceMicrophoneTestState) _then) = _$VoiceMicrophoneTestStateCopyWithImpl;
@useResult
$Res call({
 bool active, bool busy, double level, String error
});




}
/// @nodoc
class _$VoiceMicrophoneTestStateCopyWithImpl<$Res>
    implements $VoiceMicrophoneTestStateCopyWith<$Res> {
  _$VoiceMicrophoneTestStateCopyWithImpl(this._self, this._then);

  final VoiceMicrophoneTestState _self;
  final $Res Function(VoiceMicrophoneTestState) _then;

/// Create a copy of VoiceMicrophoneTestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? busy = null,Object? level = null,Object? error = null,}) {
  return _then(VoiceMicrophoneTestState(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceMicrophoneTestState].
extension VoiceMicrophoneTestStatePatterns on VoiceMicrophoneTestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceMicrophoneTestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceMicrophoneTestState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceMicrophoneTestState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool active,  bool busy,  double level,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState() when $default != null:
return $default(_that.active,_that.busy,_that.level,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool active,  bool busy,  double level,  String error)  $default,) {final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState():
return $default(_that.active,_that.busy,_that.level,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool active,  bool busy,  double level,  String error)?  $default,) {final _that = this;
switch (_that) {
case _VoiceMicrophoneTestState() when $default != null:
return $default(_that.active,_that.busy,_that.level,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceMicrophoneTestState extends VoiceMicrophoneTestState {
  const _VoiceMicrophoneTestState({this.active = false, this.busy = false, this.level = 0, this.error = ''}): super._();
  

@override@JsonKey() final  bool active;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  double level;
@override@JsonKey() final  String error;

/// Create a copy of VoiceMicrophoneTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceMicrophoneTestStateCopyWith<_VoiceMicrophoneTestState> get copyWith => __$VoiceMicrophoneTestStateCopyWithImpl<_VoiceMicrophoneTestState>(this, _$identity);





@override
String toString() {
    return 'VoiceMicrophoneTestState(active: $active, busy: $busy, level: $level, error: $error)';
}


}

/// @nodoc
abstract mixin class _$VoiceMicrophoneTestStateCopyWith<$Res> implements $VoiceMicrophoneTestStateCopyWith<$Res> {
  factory _$VoiceMicrophoneTestStateCopyWith(_VoiceMicrophoneTestState value, $Res Function(_VoiceMicrophoneTestState) _then) = __$VoiceMicrophoneTestStateCopyWithImpl;
@override @useResult
$Res call({
 bool active, bool busy, double level, String error
});




}
/// @nodoc
class __$VoiceMicrophoneTestStateCopyWithImpl<$Res>
    implements _$VoiceMicrophoneTestStateCopyWith<$Res> {
  __$VoiceMicrophoneTestStateCopyWithImpl(this._self, this._then);

  final _VoiceMicrophoneTestState _self;
  final $Res Function(_VoiceMicrophoneTestState) _then;

/// Create a copy of VoiceMicrophoneTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? active = null,Object? busy = null,Object? level = null,Object? error = null,}) {
  return _then(_VoiceMicrophoneTestState(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
