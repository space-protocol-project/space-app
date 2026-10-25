// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_notifications_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalNotificationsState {

 List<PersonalNotificationScope> get scopes; bool get enabled;
/// Create a copy of PersonalNotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalNotificationsStateCopyWith<PersonalNotificationsState> get copyWith => _$PersonalNotificationsStateCopyWithImpl<PersonalNotificationsState>(this as PersonalNotificationsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PersonalNotificationsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalNotificationsState&&const DeepCollectionEquality().equals(other.scopes, _this.scopes)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}


@override
int get hashCode {
  final _this = this as PersonalNotificationsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.scopes),_this.enabled);
}

@override
String toString() {
  final _this = this as PersonalNotificationsState;
  return 'PersonalNotificationsState(scopes: ${_this.scopes}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $PersonalNotificationsStateCopyWith<$Res>  {
  factory $PersonalNotificationsStateCopyWith(PersonalNotificationsState value, $Res Function(PersonalNotificationsState) _then) = _$PersonalNotificationsStateCopyWithImpl;
@useResult
$Res call({
 List<PersonalNotificationScope> scopes, bool enabled
});




}
/// @nodoc
class _$PersonalNotificationsStateCopyWithImpl<$Res>
    implements $PersonalNotificationsStateCopyWith<$Res> {
  _$PersonalNotificationsStateCopyWithImpl(this._self, this._then);

  final PersonalNotificationsState _self;
  final $Res Function(PersonalNotificationsState) _then;

/// Create a copy of PersonalNotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scopes = null,Object? enabled = null,}) {
  return _then(PersonalNotificationsState(
scopes: null == scopes ? _self.scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<PersonalNotificationScope>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalNotificationsState].
extension PersonalNotificationsStatePatterns on PersonalNotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalNotificationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalNotificationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalNotificationsState value)  $default,){
final _that = this;
switch (_that) {
case _PersonalNotificationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalNotificationsState value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalNotificationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PersonalNotificationScope> scopes,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalNotificationsState() when $default != null:
return $default(_that.scopes,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PersonalNotificationScope> scopes,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _PersonalNotificationsState():
return $default(_that.scopes,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PersonalNotificationScope> scopes,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _PersonalNotificationsState() when $default != null:
return $default(_that.scopes,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalNotificationsState implements PersonalNotificationsState {
  const _PersonalNotificationsState({ List<PersonalNotificationScope> scopes = const [], this.enabled = false}): _scopes = scopes;
  

 final  List<PersonalNotificationScope> _scopes;
@override@JsonKey() List<PersonalNotificationScope> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}

@override@JsonKey() final  bool enabled;

/// Create a copy of PersonalNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalNotificationsStateCopyWith<_PersonalNotificationsState> get copyWith => __$PersonalNotificationsStateCopyWithImpl<_PersonalNotificationsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalNotificationsState&&const DeepCollectionEquality().equals(other.scopes, _scopes)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_scopes),enabled);
}

@override
String toString() {
    return 'PersonalNotificationsState(scopes: $scopes, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$PersonalNotificationsStateCopyWith<$Res> implements $PersonalNotificationsStateCopyWith<$Res> {
  factory _$PersonalNotificationsStateCopyWith(_PersonalNotificationsState value, $Res Function(_PersonalNotificationsState) _then) = __$PersonalNotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 List<PersonalNotificationScope> scopes, bool enabled
});




}
/// @nodoc
class __$PersonalNotificationsStateCopyWithImpl<$Res>
    implements _$PersonalNotificationsStateCopyWith<$Res> {
  __$PersonalNotificationsStateCopyWithImpl(this._self, this._then);

  final _PersonalNotificationsState _self;
  final $Res Function(_PersonalNotificationsState) _then;

/// Create a copy of PersonalNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scopes = null,Object? enabled = null,}) {
  return _then(_PersonalNotificationsState(
scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<PersonalNotificationScope>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
