// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunitySearchState {

 String get query; List<CommunitySearchResult> get results; String get next; bool get loading; bool get invalid; bool get revoked; Object? get error;
/// Create a copy of CommunitySearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunitySearchStateCopyWith<CommunitySearchState> get copyWith => _$CommunitySearchStateCopyWithImpl<CommunitySearchState>(this as CommunitySearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CommunitySearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunitySearchState&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.invalid, _this.invalid) || other.invalid == _this.invalid)&&(identical(other.revoked, _this.revoked) || other.revoked == _this.revoked)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as CommunitySearchState;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.results),_this.next,_this.loading,_this.invalid,_this.revoked,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as CommunitySearchState;
  return 'CommunitySearchState(query: ${_this.query}, results: ${_this.results}, next: ${_this.next}, loading: ${_this.loading}, invalid: ${_this.invalid}, revoked: ${_this.revoked}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $CommunitySearchStateCopyWith<$Res>  {
  factory $CommunitySearchStateCopyWith(CommunitySearchState value, $Res Function(CommunitySearchState) _then) = _$CommunitySearchStateCopyWithImpl;
@useResult
$Res call({
 String query, List<CommunitySearchResult> results, String next, bool loading, bool invalid, bool revoked, Object? error
});




}
/// @nodoc
class _$CommunitySearchStateCopyWithImpl<$Res>
    implements $CommunitySearchStateCopyWith<$Res> {
  _$CommunitySearchStateCopyWithImpl(this._self, this._then);

  final CommunitySearchState _self;
  final $Res Function(CommunitySearchState) _then;

/// Create a copy of CommunitySearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? results = null,Object? next = null,Object? loading = null,Object? invalid = null,Object? revoked = null,Object? error = freezed,}) {
  return _then(CommunitySearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<CommunitySearchResult>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,invalid: null == invalid ? _self.invalid : invalid // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunitySearchState].
extension CommunitySearchStatePatterns on CommunitySearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunitySearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunitySearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunitySearchState value)  $default,){
final _that = this;
switch (_that) {
case _CommunitySearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunitySearchState value)?  $default,){
final _that = this;
switch (_that) {
case _CommunitySearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<CommunitySearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunitySearchState() when $default != null:
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<CommunitySearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _CommunitySearchState():
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<CommunitySearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _CommunitySearchState() when $default != null:
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _CommunitySearchState implements CommunitySearchState {
  const _CommunitySearchState({this.query = '',  List<CommunitySearchResult> results = const [], this.next = '', this.loading = false, this.invalid = false, this.revoked = false, this.error}): _results = results;
  

@override@JsonKey() final  String query;
 final  List<CommunitySearchResult> _results;
@override@JsonKey() List<CommunitySearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  String next;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool invalid;
@override@JsonKey() final  bool revoked;
@override final  Object? error;

/// Create a copy of CommunitySearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunitySearchStateCopyWith<_CommunitySearchState> get copyWith => __$CommunitySearchStateCopyWithImpl<_CommunitySearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunitySearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.next, next) || other.next == next)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.invalid, invalid) || other.invalid == invalid)&&(identical(other.revoked, revoked) || other.revoked == revoked)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_results),next,loading,invalid,revoked,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'CommunitySearchState(query: $query, results: $results, next: $next, loading: $loading, invalid: $invalid, revoked: $revoked, error: $error)';
}


}

/// @nodoc
abstract mixin class _$CommunitySearchStateCopyWith<$Res> implements $CommunitySearchStateCopyWith<$Res> {
  factory _$CommunitySearchStateCopyWith(_CommunitySearchState value, $Res Function(_CommunitySearchState) _then) = __$CommunitySearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<CommunitySearchResult> results, String next, bool loading, bool invalid, bool revoked, Object? error
});




}
/// @nodoc
class __$CommunitySearchStateCopyWithImpl<$Res>
    implements _$CommunitySearchStateCopyWith<$Res> {
  __$CommunitySearchStateCopyWithImpl(this._self, this._then);

  final _CommunitySearchState _self;
  final $Res Function(_CommunitySearchState) _then;

/// Create a copy of CommunitySearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? results = null,Object? next = null,Object? loading = null,Object? invalid = null,Object? revoked = null,Object? error = freezed,}) {
  return _then(_CommunitySearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<CommunitySearchResult>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,invalid: null == invalid ? _self.invalid : invalid // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
