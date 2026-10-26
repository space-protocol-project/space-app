// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpaceSearchState {

 String get query; List<SpaceSearchResult> get results; String get next; bool get loading; bool get invalid; bool get revoked; bool get capped; Object? get error;
/// Create a copy of SpaceSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceSearchStateCopyWith<SpaceSearchState> get copyWith => _$SpaceSearchStateCopyWithImpl<SpaceSearchState>(this as SpaceSearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpaceSearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceSearchState&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.invalid, _this.invalid) || other.invalid == _this.invalid)&&(identical(other.revoked, _this.revoked) || other.revoked == _this.revoked)&&(identical(other.capped, _this.capped) || other.capped == _this.capped)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as SpaceSearchState;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.results),_this.next,_this.loading,_this.invalid,_this.revoked,_this.capped,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as SpaceSearchState;
  return 'SpaceSearchState(query: ${_this.query}, results: ${_this.results}, next: ${_this.next}, loading: ${_this.loading}, invalid: ${_this.invalid}, revoked: ${_this.revoked}, capped: ${_this.capped}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SpaceSearchStateCopyWith<$Res>  {
  factory $SpaceSearchStateCopyWith(SpaceSearchState value, $Res Function(SpaceSearchState) _then) = _$SpaceSearchStateCopyWithImpl;
@useResult
$Res call({
 String query, List<SpaceSearchResult> results, String next, bool loading, bool invalid, bool revoked, bool capped, Object? error
});




}
/// @nodoc
class _$SpaceSearchStateCopyWithImpl<$Res>
    implements $SpaceSearchStateCopyWith<$Res> {
  _$SpaceSearchStateCopyWithImpl(this._self, this._then);

  final SpaceSearchState _self;
  final $Res Function(SpaceSearchState) _then;

/// Create a copy of SpaceSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? results = null,Object? next = null,Object? loading = null,Object? invalid = null,Object? revoked = null,Object? capped = null,Object? error = freezed,}) {
  return _then(SpaceSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SpaceSearchResult>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,invalid: null == invalid ? _self.invalid : invalid // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,capped: null == capped ? _self.capped : capped // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceSearchState].
extension SpaceSearchStatePatterns on SpaceSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceSearchState value)  $default,){
final _that = this;
switch (_that) {
case _SpaceSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<SpaceSearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  bool capped,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceSearchState() when $default != null:
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.capped,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<SpaceSearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  bool capped,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _SpaceSearchState():
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.capped,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<SpaceSearchResult> results,  String next,  bool loading,  bool invalid,  bool revoked,  bool capped,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _SpaceSearchState() when $default != null:
return $default(_that.query,_that.results,_that.next,_that.loading,_that.invalid,_that.revoked,_that.capped,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceSearchState implements SpaceSearchState {
  const _SpaceSearchState({this.query = '',  List<SpaceSearchResult> results = const [], this.next = '', this.loading = false, this.invalid = false, this.revoked = false, this.capped = false, this.error}): _results = results;
  

@override@JsonKey() final  String query;
 final  List<SpaceSearchResult> _results;
@override@JsonKey() List<SpaceSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  String next;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool invalid;
@override@JsonKey() final  bool revoked;
@override@JsonKey() final  bool capped;
@override final  Object? error;

/// Create a copy of SpaceSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceSearchStateCopyWith<_SpaceSearchState> get copyWith => __$SpaceSearchStateCopyWithImpl<_SpaceSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceSearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.next, next) || other.next == next)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.invalid, invalid) || other.invalid == invalid)&&(identical(other.revoked, revoked) || other.revoked == revoked)&&(identical(other.capped, capped) || other.capped == capped)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_results),next,loading,invalid,revoked,capped,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'SpaceSearchState(query: $query, results: $results, next: $next, loading: $loading, invalid: $invalid, revoked: $revoked, capped: $capped, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SpaceSearchStateCopyWith<$Res> implements $SpaceSearchStateCopyWith<$Res> {
  factory _$SpaceSearchStateCopyWith(_SpaceSearchState value, $Res Function(_SpaceSearchState) _then) = __$SpaceSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<SpaceSearchResult> results, String next, bool loading, bool invalid, bool revoked, bool capped, Object? error
});




}
/// @nodoc
class __$SpaceSearchStateCopyWithImpl<$Res>
    implements _$SpaceSearchStateCopyWith<$Res> {
  __$SpaceSearchStateCopyWithImpl(this._self, this._then);

  final _SpaceSearchState _self;
  final $Res Function(_SpaceSearchState) _then;

/// Create a copy of SpaceSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? results = null,Object? next = null,Object? loading = null,Object? invalid = null,Object? revoked = null,Object? capped = null,Object? error = freezed,}) {
  return _then(_SpaceSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SpaceSearchResult>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,invalid: null == invalid ? _self.invalid : invalid // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,capped: null == capped ? _self.capped : capped // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
