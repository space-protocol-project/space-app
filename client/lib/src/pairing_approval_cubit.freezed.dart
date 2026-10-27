// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_approval_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairingApprovalState {

 bool get busy; bool get prepared; String get code; String get verification; String? get messageKey; Object? get error;
/// Create a copy of PairingApprovalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingApprovalStateCopyWith<PairingApprovalState> get copyWith => _$PairingApprovalStateCopyWithImpl<PairingApprovalState>(this as PairingApprovalState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PairingApprovalState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingApprovalState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.prepared, _this.prepared) || other.prepared == _this.prepared)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.verification, _this.verification) || other.verification == _this.verification)&&(identical(other.messageKey, _this.messageKey) || other.messageKey == _this.messageKey)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as PairingApprovalState;
  return Object.hash(runtimeType,_this.busy,_this.prepared,_this.code,_this.verification,_this.messageKey,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as PairingApprovalState;
  return 'PairingApprovalState(busy: ${_this.busy}, prepared: ${_this.prepared}, code: ${_this.code}, verification: ${_this.verification}, messageKey: ${_this.messageKey}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $PairingApprovalStateCopyWith<$Res>  {
  factory $PairingApprovalStateCopyWith(PairingApprovalState value, $Res Function(PairingApprovalState) _then) = _$PairingApprovalStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool prepared, String code, String verification, String? messageKey, Object? error
});




}
/// @nodoc
class _$PairingApprovalStateCopyWithImpl<$Res>
    implements $PairingApprovalStateCopyWith<$Res> {
  _$PairingApprovalStateCopyWithImpl(this._self, this._then);

  final PairingApprovalState _self;
  final $Res Function(PairingApprovalState) _then;

/// Create a copy of PairingApprovalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? prepared = null,Object? code = null,Object? verification = null,Object? messageKey = freezed,Object? error = freezed,}) {
  return _then(PairingApprovalState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,prepared: null == prepared ? _self.prepared : prepared // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as String,messageKey: freezed == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [PairingApprovalState].
extension PairingApprovalStatePatterns on PairingApprovalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingApprovalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingApprovalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingApprovalState value)  $default,){
final _that = this;
switch (_that) {
case _PairingApprovalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingApprovalState value)?  $default,){
final _that = this;
switch (_that) {
case _PairingApprovalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool prepared,  String code,  String verification,  String? messageKey,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingApprovalState() when $default != null:
return $default(_that.busy,_that.prepared,_that.code,_that.verification,_that.messageKey,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool prepared,  String code,  String verification,  String? messageKey,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _PairingApprovalState():
return $default(_that.busy,_that.prepared,_that.code,_that.verification,_that.messageKey,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool prepared,  String code,  String verification,  String? messageKey,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _PairingApprovalState() when $default != null:
return $default(_that.busy,_that.prepared,_that.code,_that.verification,_that.messageKey,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PairingApprovalState implements PairingApprovalState {
  const _PairingApprovalState({this.busy = false, this.prepared = false, this.code = '', this.verification = '', this.messageKey, this.error});
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool prepared;
@override@JsonKey() final  String code;
@override@JsonKey() final  String verification;
@override final  String? messageKey;
@override final  Object? error;

/// Create a copy of PairingApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingApprovalStateCopyWith<_PairingApprovalState> get copyWith => __$PairingApprovalStateCopyWithImpl<_PairingApprovalState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingApprovalState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.prepared, prepared) || other.prepared == prepared)&&(identical(other.code, code) || other.code == code)&&(identical(other.verification, verification) || other.verification == verification)&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,prepared,code,verification,messageKey,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'PairingApprovalState(busy: $busy, prepared: $prepared, code: $code, verification: $verification, messageKey: $messageKey, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PairingApprovalStateCopyWith<$Res> implements $PairingApprovalStateCopyWith<$Res> {
  factory _$PairingApprovalStateCopyWith(_PairingApprovalState value, $Res Function(_PairingApprovalState) _then) = __$PairingApprovalStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool prepared, String code, String verification, String? messageKey, Object? error
});




}
/// @nodoc
class __$PairingApprovalStateCopyWithImpl<$Res>
    implements _$PairingApprovalStateCopyWith<$Res> {
  __$PairingApprovalStateCopyWithImpl(this._self, this._then);

  final _PairingApprovalState _self;
  final $Res Function(_PairingApprovalState) _then;

/// Create a copy of PairingApprovalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? prepared = null,Object? code = null,Object? verification = null,Object? messageKey = freezed,Object? error = freezed,}) {
  return _then(_PairingApprovalState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,prepared: null == prepared ? _self.prepared : prepared // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as String,messageKey: freezed == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
