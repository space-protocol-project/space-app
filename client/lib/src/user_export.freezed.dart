// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserExportState {

 bool get busy; bool get revoked; bool get saved; String get document; int get count; Object? get error;
/// Create a copy of UserExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserExportStateCopyWith<UserExportState> get copyWith => _$UserExportStateCopyWithImpl<UserExportState>(this as UserExportState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserExportState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserExportState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.revoked, _this.revoked) || other.revoked == _this.revoked)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.document, _this.document) || other.document == _this.document)&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as UserExportState;
  return Object.hash(runtimeType,_this.busy,_this.revoked,_this.saved,_this.document,_this.count,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as UserExportState;
  return 'UserExportState(busy: ${_this.busy}, revoked: ${_this.revoked}, saved: ${_this.saved}, document: ${_this.document}, count: ${_this.count}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $UserExportStateCopyWith<$Res>  {
  factory $UserExportStateCopyWith(UserExportState value, $Res Function(UserExportState) _then) = _$UserExportStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool revoked, bool saved, String document, int count, Object? error
});




}
/// @nodoc
class _$UserExportStateCopyWithImpl<$Res>
    implements $UserExportStateCopyWith<$Res> {
  _$UserExportStateCopyWithImpl(this._self, this._then);

  final UserExportState _self;
  final $Res Function(UserExportState) _then;

/// Create a copy of UserExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? revoked = null,Object? saved = null,Object? document = null,Object? count = null,Object? error = freezed,}) {
  return _then(UserExportState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [UserExportState].
extension UserExportStatePatterns on UserExportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserExportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserExportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserExportState value)  $default,){
final _that = this;
switch (_that) {
case _UserExportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserExportState value)?  $default,){
final _that = this;
switch (_that) {
case _UserExportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool revoked,  bool saved,  String document,  int count,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserExportState() when $default != null:
return $default(_that.busy,_that.revoked,_that.saved,_that.document,_that.count,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool revoked,  bool saved,  String document,  int count,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _UserExportState():
return $default(_that.busy,_that.revoked,_that.saved,_that.document,_that.count,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool revoked,  bool saved,  String document,  int count,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _UserExportState() when $default != null:
return $default(_that.busy,_that.revoked,_that.saved,_that.document,_that.count,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _UserExportState implements UserExportState {
  const _UserExportState({this.busy = false, this.revoked = false, this.saved = false, this.document = '', this.count = 0, this.error});
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool revoked;
@override@JsonKey() final  bool saved;
@override@JsonKey() final  String document;
@override@JsonKey() final  int count;
@override final  Object? error;

/// Create a copy of UserExportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserExportStateCopyWith<_UserExportState> get copyWith => __$UserExportStateCopyWithImpl<_UserExportState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserExportState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.revoked, revoked) || other.revoked == revoked)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.document, document) || other.document == document)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,revoked,saved,document,count,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'UserExportState(busy: $busy, revoked: $revoked, saved: $saved, document: $document, count: $count, error: $error)';
}


}

/// @nodoc
abstract mixin class _$UserExportStateCopyWith<$Res> implements $UserExportStateCopyWith<$Res> {
  factory _$UserExportStateCopyWith(_UserExportState value, $Res Function(_UserExportState) _then) = __$UserExportStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool revoked, bool saved, String document, int count, Object? error
});




}
/// @nodoc
class __$UserExportStateCopyWithImpl<$Res>
    implements _$UserExportStateCopyWith<$Res> {
  __$UserExportStateCopyWithImpl(this._self, this._then);

  final _UserExportState _self;
  final $Res Function(_UserExportState) _then;

/// Create a copy of UserExportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? revoked = null,Object? saved = null,Object? document = null,Object? count = null,Object? error = freezed,}) {
  return _then(_UserExportState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
