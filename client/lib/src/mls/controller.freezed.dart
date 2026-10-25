// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MlsState {

 bool get busy; String get error; MlsChannelData? get data; int get sent; bool get recoveryRequired;
/// Create a copy of MlsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MlsStateCopyWith<MlsState> get copyWith => _$MlsStateCopyWithImpl<MlsState>(this as MlsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MlsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MlsState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.sent, _this.sent) || other.sent == _this.sent)&&(identical(other.recoveryRequired, _this.recoveryRequired) || other.recoveryRequired == _this.recoveryRequired));
}


@override
int get hashCode {
  final _this = this as MlsState;
  return Object.hash(runtimeType,_this.busy,_this.error,_this.data,_this.sent,_this.recoveryRequired);
}

@override
String toString() {
  final _this = this as MlsState;
  return 'MlsState(busy: ${_this.busy}, error: ${_this.error}, data: ${_this.data}, sent: ${_this.sent}, recoveryRequired: ${_this.recoveryRequired})';
}


}

/// @nodoc
abstract mixin class $MlsStateCopyWith<$Res>  {
  factory $MlsStateCopyWith(MlsState value, $Res Function(MlsState) _then) = _$MlsStateCopyWithImpl;
@useResult
$Res call({
 bool busy, String error, MlsChannelData? data, int sent, bool recoveryRequired
});




}
/// @nodoc
class _$MlsStateCopyWithImpl<$Res>
    implements $MlsStateCopyWith<$Res> {
  _$MlsStateCopyWithImpl(this._self, this._then);

  final MlsState _self;
  final $Res Function(MlsState) _then;

/// Create a copy of MlsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? error = null,Object? data = freezed,Object? sent = null,Object? recoveryRequired = null,}) {
  return _then(MlsState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MlsChannelData?,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,recoveryRequired: null == recoveryRequired ? _self.recoveryRequired : recoveryRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MlsState].
extension MlsStatePatterns on MlsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MlsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MlsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MlsState value)  $default,){
final _that = this;
switch (_that) {
case _MlsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MlsState value)?  $default,){
final _that = this;
switch (_that) {
case _MlsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  String error,  MlsChannelData? data,  int sent,  bool recoveryRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MlsState() when $default != null:
return $default(_that.busy,_that.error,_that.data,_that.sent,_that.recoveryRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  String error,  MlsChannelData? data,  int sent,  bool recoveryRequired)  $default,) {final _that = this;
switch (_that) {
case _MlsState():
return $default(_that.busy,_that.error,_that.data,_that.sent,_that.recoveryRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  String error,  MlsChannelData? data,  int sent,  bool recoveryRequired)?  $default,) {final _that = this;
switch (_that) {
case _MlsState() when $default != null:
return $default(_that.busy,_that.error,_that.data,_that.sent,_that.recoveryRequired);case _:
  return null;

}
}

}

/// @nodoc


class _MlsState implements MlsState {
  const _MlsState({this.busy = false, this.error = '', this.data, this.sent = 0, this.recoveryRequired = false});
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  String error;
@override final  MlsChannelData? data;
@override@JsonKey() final  int sent;
@override@JsonKey() final  bool recoveryRequired;

/// Create a copy of MlsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MlsStateCopyWith<_MlsState> get copyWith => __$MlsStateCopyWithImpl<_MlsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MlsState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.error, error) || other.error == error)&&(identical(other.data, data) || other.data == data)&&(identical(other.sent, sent) || other.sent == sent)&&(identical(other.recoveryRequired, recoveryRequired) || other.recoveryRequired == recoveryRequired));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,error,data,sent,recoveryRequired);
}

@override
String toString() {
    return 'MlsState(busy: $busy, error: $error, data: $data, sent: $sent, recoveryRequired: $recoveryRequired)';
}


}

/// @nodoc
abstract mixin class _$MlsStateCopyWith<$Res> implements $MlsStateCopyWith<$Res> {
  factory _$MlsStateCopyWith(_MlsState value, $Res Function(_MlsState) _then) = __$MlsStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, String error, MlsChannelData? data, int sent, bool recoveryRequired
});




}
/// @nodoc
class __$MlsStateCopyWithImpl<$Res>
    implements _$MlsStateCopyWith<$Res> {
  __$MlsStateCopyWithImpl(this._self, this._then);

  final _MlsState _self;
  final $Res Function(_MlsState) _then;

/// Create a copy of MlsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? error = null,Object? data = freezed,Object? sent = null,Object? recoveryRequired = null,}) {
  return _then(_MlsState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MlsChannelData?,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,recoveryRequired: null == recoveryRequired ? _self.recoveryRequired : recoveryRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
