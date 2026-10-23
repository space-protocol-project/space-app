// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_presence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresenceState implements DiagnosticableTreeMixin {

 Map<String, bool> get online; ServerPresenceChange? get change;
/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresenceStateCopyWith<PresenceState> get copyWith => _$PresenceStateCopyWithImpl<PresenceState>(this as PresenceState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as PresenceState;
  properties
    ..add(DiagnosticsProperty('type', 'PresenceState'))
    ..add(DiagnosticsProperty('online', _this.online))..add(DiagnosticsProperty('change', _this.change));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as PresenceState;
  return 'PresenceState(online: ${_this.online}, change: ${_this.change})';
}


}

/// @nodoc
abstract mixin class $PresenceStateCopyWith<$Res>  {
  factory $PresenceStateCopyWith(PresenceState value, $Res Function(PresenceState) _then) = _$PresenceStateCopyWithImpl;
@useResult
$Res call({
 Map<String, bool> online, ServerPresenceChange? change
});




}
/// @nodoc
class _$PresenceStateCopyWithImpl<$Res>
    implements $PresenceStateCopyWith<$Res> {
  _$PresenceStateCopyWithImpl(this._self, this._then);

  final PresenceState _self;
  final $Res Function(PresenceState) _then;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? online = null,Object? change = freezed,}) {
  return _then(PresenceState(
online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as ServerPresenceChange?,
  ));
}

}


/// Adds pattern-matching-related methods to [PresenceState].
extension PresenceStatePatterns on PresenceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresenceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresenceState value)  $default,){
final _that = this;
switch (_that) {
case _PresenceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresenceState value)?  $default,){
final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, bool> online,  ServerPresenceChange? change)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that.online,_that.change);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, bool> online,  ServerPresenceChange? change)  $default,) {final _that = this;
switch (_that) {
case _PresenceState():
return $default(_that.online,_that.change);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, bool> online,  ServerPresenceChange? change)?  $default,) {final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that.online,_that.change);case _:
  return null;

}
}

}

/// @nodoc


class _PresenceState extends PresenceState with DiagnosticableTreeMixin {
  const _PresenceState({ Map<String, bool> online = const {}, this.change}): _online = online,super._();
  

 final  Map<String, bool> _online;
@override@JsonKey() Map<String, bool> get online {
  if (_online is EqualUnmodifiableMapView) return _online;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_online);
}

@override final  ServerPresenceChange? change;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresenceStateCopyWith<_PresenceState> get copyWith => __$PresenceStateCopyWithImpl<_PresenceState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'PresenceState'))
    ..add(DiagnosticsProperty('online', online))..add(DiagnosticsProperty('change', change));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'PresenceState(online: $online, change: $change)';
}


}

/// @nodoc
abstract mixin class _$PresenceStateCopyWith<$Res> implements $PresenceStateCopyWith<$Res> {
  factory _$PresenceStateCopyWith(_PresenceState value, $Res Function(_PresenceState) _then) = __$PresenceStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, bool> online, ServerPresenceChange? change
});




}
/// @nodoc
class __$PresenceStateCopyWithImpl<$Res>
    implements _$PresenceStateCopyWith<$Res> {
  __$PresenceStateCopyWithImpl(this._self, this._then);

  final _PresenceState _self;
  final $Res Function(_PresenceState) _then;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? online = null,Object? change = freezed,}) {
  return _then(_PresenceState(
online: null == online ? _self._online : online // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as ServerPresenceChange?,
  ));
}


}

// dart format on
