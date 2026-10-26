// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_favorite_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityFavoriteListState {

 List<CommunityFavorite> get entries; String get next; bool get loading; bool get revoked; Object? get error;
/// Create a copy of CommunityFavoriteListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityFavoriteListStateCopyWith<CommunityFavoriteListState> get copyWith => _$CommunityFavoriteListStateCopyWithImpl<CommunityFavoriteListState>(this as CommunityFavoriteListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CommunityFavoriteListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityFavoriteListState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.revoked, _this.revoked) || other.revoked == _this.revoked)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as CommunityFavoriteListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.next,_this.loading,_this.revoked,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as CommunityFavoriteListState;
  return 'CommunityFavoriteListState(entries: ${_this.entries}, next: ${_this.next}, loading: ${_this.loading}, revoked: ${_this.revoked}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $CommunityFavoriteListStateCopyWith<$Res>  {
  factory $CommunityFavoriteListStateCopyWith(CommunityFavoriteListState value, $Res Function(CommunityFavoriteListState) _then) = _$CommunityFavoriteListStateCopyWithImpl;
@useResult
$Res call({
 List<CommunityFavorite> entries, String next, bool loading, bool revoked, Object? error
});




}
/// @nodoc
class _$CommunityFavoriteListStateCopyWithImpl<$Res>
    implements $CommunityFavoriteListStateCopyWith<$Res> {
  _$CommunityFavoriteListStateCopyWithImpl(this._self, this._then);

  final CommunityFavoriteListState _self;
  final $Res Function(CommunityFavoriteListState) _then;

/// Create a copy of CommunityFavoriteListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? next = null,Object? loading = null,Object? revoked = null,Object? error = freezed,}) {
  return _then(CommunityFavoriteListState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<CommunityFavorite>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityFavoriteListState].
extension CommunityFavoriteListStatePatterns on CommunityFavoriteListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityFavoriteListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityFavoriteListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityFavoriteListState value)  $default,){
final _that = this;
switch (_that) {
case _CommunityFavoriteListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityFavoriteListState value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityFavoriteListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CommunityFavorite> entries,  String next,  bool loading,  bool revoked,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityFavoriteListState() when $default != null:
return $default(_that.entries,_that.next,_that.loading,_that.revoked,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CommunityFavorite> entries,  String next,  bool loading,  bool revoked,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _CommunityFavoriteListState():
return $default(_that.entries,_that.next,_that.loading,_that.revoked,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CommunityFavorite> entries,  String next,  bool loading,  bool revoked,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _CommunityFavoriteListState() when $default != null:
return $default(_that.entries,_that.next,_that.loading,_that.revoked,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _CommunityFavoriteListState implements CommunityFavoriteListState {
  const _CommunityFavoriteListState({ List<CommunityFavorite> entries = const [], this.next = '', this.loading = false, this.revoked = false, this.error}): _entries = entries;
  

 final  List<CommunityFavorite> _entries;
@override@JsonKey() List<CommunityFavorite> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  String next;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool revoked;
@override final  Object? error;

/// Create a copy of CommunityFavoriteListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityFavoriteListStateCopyWith<_CommunityFavoriteListState> get copyWith => __$CommunityFavoriteListStateCopyWithImpl<_CommunityFavoriteListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityFavoriteListState&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.next, next) || other.next == next)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.revoked, revoked) || other.revoked == revoked)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),next,loading,revoked,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'CommunityFavoriteListState(entries: $entries, next: $next, loading: $loading, revoked: $revoked, error: $error)';
}


}

/// @nodoc
abstract mixin class _$CommunityFavoriteListStateCopyWith<$Res> implements $CommunityFavoriteListStateCopyWith<$Res> {
  factory _$CommunityFavoriteListStateCopyWith(_CommunityFavoriteListState value, $Res Function(_CommunityFavoriteListState) _then) = __$CommunityFavoriteListStateCopyWithImpl;
@override @useResult
$Res call({
 List<CommunityFavorite> entries, String next, bool loading, bool revoked, Object? error
});




}
/// @nodoc
class __$CommunityFavoriteListStateCopyWithImpl<$Res>
    implements _$CommunityFavoriteListStateCopyWith<$Res> {
  __$CommunityFavoriteListStateCopyWithImpl(this._self, this._then);

  final _CommunityFavoriteListState _self;
  final $Res Function(_CommunityFavoriteListState) _then;

/// Create a copy of CommunityFavoriteListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? next = null,Object? loading = null,Object? revoked = null,Object? error = freezed,}) {
  return _then(_CommunityFavoriteListState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<CommunityFavorite>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
