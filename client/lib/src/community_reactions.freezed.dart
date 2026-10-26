// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_reactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityReactionsState {

 Map<String, CommunityReactionState> get entries; Set<String> get busy; Map<String, Object> get errors; Set<String> get retryable; Object? get loadError;
/// Create a copy of CommunityReactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityReactionsStateCopyWith<CommunityReactionsState> get copyWith => _$CommunityReactionsStateCopyWithImpl<CommunityReactionsState>(this as CommunityReactionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CommunityReactionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityReactionsState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&const DeepCollectionEquality().equals(other.busy, _this.busy)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&const DeepCollectionEquality().equals(other.retryable, _this.retryable)&&const DeepCollectionEquality().equals(other.loadError, _this.loadError));
}


@override
int get hashCode {
  final _this = this as CommunityReactionsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),const DeepCollectionEquality().hash(_this.busy),const DeepCollectionEquality().hash(_this.errors),const DeepCollectionEquality().hash(_this.retryable),const DeepCollectionEquality().hash(_this.loadError));
}

@override
String toString() {
  final _this = this as CommunityReactionsState;
  return 'CommunityReactionsState(entries: ${_this.entries}, busy: ${_this.busy}, errors: ${_this.errors}, retryable: ${_this.retryable}, loadError: ${_this.loadError})';
}


}

/// @nodoc
abstract mixin class $CommunityReactionsStateCopyWith<$Res>  {
  factory $CommunityReactionsStateCopyWith(CommunityReactionsState value, $Res Function(CommunityReactionsState) _then) = _$CommunityReactionsStateCopyWithImpl;
@useResult
$Res call({
 Map<String, CommunityReactionState> entries, Set<String> busy, Map<String, Object> errors, Set<String> retryable, Object? loadError
});




}
/// @nodoc
class _$CommunityReactionsStateCopyWithImpl<$Res>
    implements $CommunityReactionsStateCopyWith<$Res> {
  _$CommunityReactionsStateCopyWithImpl(this._self, this._then);

  final CommunityReactionsState _self;
  final $Res Function(CommunityReactionsState) _then;

/// Create a copy of CommunityReactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? busy = null,Object? errors = null,Object? retryable = null,Object? loadError = freezed,}) {
  return _then(CommunityReactionsState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, CommunityReactionState>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as Set<String>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as Set<String>,loadError: freezed == loadError ? _self.loadError : loadError ,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityReactionsState].
extension CommunityReactionsStatePatterns on CommunityReactionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityReactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityReactionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityReactionsState value)  $default,){
final _that = this;
switch (_that) {
case _CommunityReactionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityReactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityReactionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, CommunityReactionState> entries,  Set<String> busy,  Map<String, Object> errors,  Set<String> retryable,  Object? loadError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityReactionsState() when $default != null:
return $default(_that.entries,_that.busy,_that.errors,_that.retryable,_that.loadError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, CommunityReactionState> entries,  Set<String> busy,  Map<String, Object> errors,  Set<String> retryable,  Object? loadError)  $default,) {final _that = this;
switch (_that) {
case _CommunityReactionsState():
return $default(_that.entries,_that.busy,_that.errors,_that.retryable,_that.loadError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, CommunityReactionState> entries,  Set<String> busy,  Map<String, Object> errors,  Set<String> retryable,  Object? loadError)?  $default,) {final _that = this;
switch (_that) {
case _CommunityReactionsState() when $default != null:
return $default(_that.entries,_that.busy,_that.errors,_that.retryable,_that.loadError);case _:
  return null;

}
}

}

/// @nodoc


class _CommunityReactionsState implements CommunityReactionsState {
  const _CommunityReactionsState({ Map<String, CommunityReactionState> entries = const {},  Set<String> busy = const {},  Map<String, Object> errors = const {},  Set<String> retryable = const {}, this.loadError}): _entries = entries,_busy = busy,_errors = errors,_retryable = retryable;
  

 final  Map<String, CommunityReactionState> _entries;
@override@JsonKey() Map<String, CommunityReactionState> get entries {
  if (_entries is EqualUnmodifiableMapView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_entries);
}

 final  Set<String> _busy;
@override@JsonKey() Set<String> get busy {
  if (_busy is EqualUnmodifiableSetView) return _busy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busy);
}

 final  Map<String, Object> _errors;
@override@JsonKey() Map<String, Object> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

 final  Set<String> _retryable;
@override@JsonKey() Set<String> get retryable {
  if (_retryable is EqualUnmodifiableSetView) return _retryable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_retryable);
}

@override final  Object? loadError;

/// Create a copy of CommunityReactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityReactionsStateCopyWith<_CommunityReactionsState> get copyWith => __$CommunityReactionsStateCopyWithImpl<_CommunityReactionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityReactionsState&&const DeepCollectionEquality().equals(other.entries, _entries)&&const DeepCollectionEquality().equals(other.busy, _busy)&&const DeepCollectionEquality().equals(other.errors, _errors)&&const DeepCollectionEquality().equals(other.retryable, _retryable)&&const DeepCollectionEquality().equals(other.loadError, loadError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_busy),const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_retryable),const DeepCollectionEquality().hash(loadError));
}

@override
String toString() {
    return 'CommunityReactionsState(entries: $entries, busy: $busy, errors: $errors, retryable: $retryable, loadError: $loadError)';
}


}

/// @nodoc
abstract mixin class _$CommunityReactionsStateCopyWith<$Res> implements $CommunityReactionsStateCopyWith<$Res> {
  factory _$CommunityReactionsStateCopyWith(_CommunityReactionsState value, $Res Function(_CommunityReactionsState) _then) = __$CommunityReactionsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, CommunityReactionState> entries, Set<String> busy, Map<String, Object> errors, Set<String> retryable, Object? loadError
});




}
/// @nodoc
class __$CommunityReactionsStateCopyWithImpl<$Res>
    implements _$CommunityReactionsStateCopyWith<$Res> {
  __$CommunityReactionsStateCopyWithImpl(this._self, this._then);

  final _CommunityReactionsState _self;
  final $Res Function(_CommunityReactionsState) _then;

/// Create a copy of CommunityReactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? busy = null,Object? errors = null,Object? retryable = null,Object? loadError = freezed,}) {
  return _then(_CommunityReactionsState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, CommunityReactionState>,busy: null == busy ? _self._busy : busy // ignore: cast_nullable_to_non_nullable
as Set<String>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,retryable: null == retryable ? _self._retryable : retryable // ignore: cast_nullable_to_non_nullable
as Set<String>,loadError: freezed == loadError ? _self.loadError : loadError ,
  ));
}


}

// dart format on
