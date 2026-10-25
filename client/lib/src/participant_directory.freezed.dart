// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_directory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantDirectoryState {

 Map<String, ParticipantProfile> get profiles;
/// Create a copy of ParticipantDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantDirectoryStateCopyWith<ParticipantDirectoryState> get copyWith => _$ParticipantDirectoryStateCopyWithImpl<ParticipantDirectoryState>(this as ParticipantDirectoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ParticipantDirectoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantDirectoryState&&const DeepCollectionEquality().equals(other.profiles, _this.profiles));
}


@override
int get hashCode {
  final _this = this as ParticipantDirectoryState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.profiles));
}

@override
String toString() {
  final _this = this as ParticipantDirectoryState;
  return 'ParticipantDirectoryState(profiles: ${_this.profiles})';
}


}

/// @nodoc
abstract mixin class $ParticipantDirectoryStateCopyWith<$Res>  {
  factory $ParticipantDirectoryStateCopyWith(ParticipantDirectoryState value, $Res Function(ParticipantDirectoryState) _then) = _$ParticipantDirectoryStateCopyWithImpl;
@useResult
$Res call({
 Map<String, ParticipantProfile> profiles
});




}
/// @nodoc
class _$ParticipantDirectoryStateCopyWithImpl<$Res>
    implements $ParticipantDirectoryStateCopyWith<$Res> {
  _$ParticipantDirectoryStateCopyWithImpl(this._self, this._then);

  final ParticipantDirectoryState _self;
  final $Res Function(ParticipantDirectoryState) _then;

/// Create a copy of ParticipantDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profiles = null,}) {
  return _then(ParticipantDirectoryState(
profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as Map<String, ParticipantProfile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantDirectoryState].
extension ParticipantDirectoryStatePatterns on ParticipantDirectoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantDirectoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantDirectoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantDirectoryState value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantDirectoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantDirectoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantDirectoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, ParticipantProfile> profiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantDirectoryState() when $default != null:
return $default(_that.profiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, ParticipantProfile> profiles)  $default,) {final _that = this;
switch (_that) {
case _ParticipantDirectoryState():
return $default(_that.profiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, ParticipantProfile> profiles)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantDirectoryState() when $default != null:
return $default(_that.profiles);case _:
  return null;

}
}

}

/// @nodoc


class _ParticipantDirectoryState implements ParticipantDirectoryState {
  const _ParticipantDirectoryState({ Map<String, ParticipantProfile> profiles = const {}}): _profiles = profiles;
  

 final  Map<String, ParticipantProfile> _profiles;
@override@JsonKey() Map<String, ParticipantProfile> get profiles {
  if (_profiles is EqualUnmodifiableMapView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_profiles);
}


/// Create a copy of ParticipantDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantDirectoryStateCopyWith<_ParticipantDirectoryState> get copyWith => __$ParticipantDirectoryStateCopyWithImpl<_ParticipantDirectoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantDirectoryState&&const DeepCollectionEquality().equals(other.profiles, _profiles));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles));
}

@override
String toString() {
    return 'ParticipantDirectoryState(profiles: $profiles)';
}


}

/// @nodoc
abstract mixin class _$ParticipantDirectoryStateCopyWith<$Res> implements $ParticipantDirectoryStateCopyWith<$Res> {
  factory _$ParticipantDirectoryStateCopyWith(_ParticipantDirectoryState value, $Res Function(_ParticipantDirectoryState) _then) = __$ParticipantDirectoryStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, ParticipantProfile> profiles
});




}
/// @nodoc
class __$ParticipantDirectoryStateCopyWithImpl<$Res>
    implements _$ParticipantDirectoryStateCopyWith<$Res> {
  __$ParticipantDirectoryStateCopyWithImpl(this._self, this._then);

  final _ParticipantDirectoryState _self;
  final $Res Function(_ParticipantDirectoryState) _then;

/// Create a copy of ParticipantDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,}) {
  return _then(_ParticipantDirectoryState(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as Map<String, ParticipantProfile>,
  ));
}


}

// dart format on
