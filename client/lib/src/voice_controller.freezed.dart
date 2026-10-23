// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceState {

 VoicePhase get phase; String get title; String get room; bool get muted; bool get deafened; bool get busy; String get error; VoiceRoomState? get roster; Set<String> get speaking; bool get canPublish; VoiceConnectionInfo get connection;
/// Create a copy of VoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceStateCopyWith<VoiceState> get copyWith => _$VoiceStateCopyWithImpl<VoiceState>(this as VoiceState, _$identity);





@override
String toString() {
  final _this = this as VoiceState;
  return 'VoiceState(phase: ${_this.phase}, title: ${_this.title}, room: ${_this.room}, muted: ${_this.muted}, deafened: ${_this.deafened}, busy: ${_this.busy}, error: ${_this.error}, roster: ${_this.roster}, speaking: ${_this.speaking}, canPublish: ${_this.canPublish}, connection: ${_this.connection})';
}


}

/// @nodoc
abstract mixin class $VoiceStateCopyWith<$Res>  {
  factory $VoiceStateCopyWith(VoiceState value, $Res Function(VoiceState) _then) = _$VoiceStateCopyWithImpl;
@useResult
$Res call({
 VoicePhase phase, String title, String room, bool muted, bool deafened, bool busy, String error, VoiceRoomState? roster, Set<String> speaking, bool canPublish, VoiceConnectionInfo connection
});




}
/// @nodoc
class _$VoiceStateCopyWithImpl<$Res>
    implements $VoiceStateCopyWith<$Res> {
  _$VoiceStateCopyWithImpl(this._self, this._then);

  final VoiceState _self;
  final $Res Function(VoiceState) _then;

/// Create a copy of VoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? title = null,Object? room = null,Object? muted = null,Object? deafened = null,Object? busy = null,Object? error = null,Object? roster = freezed,Object? speaking = null,Object? canPublish = null,Object? connection = null,}) {
  return _then(VoiceState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as VoicePhase,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as bool,deafened: null == deafened ? _self.deafened : deafened // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,roster: freezed == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as VoiceRoomState?,speaking: null == speaking ? _self.speaking : speaking // ignore: cast_nullable_to_non_nullable
as Set<String>,canPublish: null == canPublish ? _self.canPublish : canPublish // ignore: cast_nullable_to_non_nullable
as bool,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as VoiceConnectionInfo,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceState].
extension VoiceStatePatterns on VoiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VoicePhase phase,  String title,  String room,  bool muted,  bool deafened,  bool busy,  String error,  VoiceRoomState? roster,  Set<String> speaking,  bool canPublish,  VoiceConnectionInfo connection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceState() when $default != null:
return $default(_that.phase,_that.title,_that.room,_that.muted,_that.deafened,_that.busy,_that.error,_that.roster,_that.speaking,_that.canPublish,_that.connection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VoicePhase phase,  String title,  String room,  bool muted,  bool deafened,  bool busy,  String error,  VoiceRoomState? roster,  Set<String> speaking,  bool canPublish,  VoiceConnectionInfo connection)  $default,) {final _that = this;
switch (_that) {
case _VoiceState():
return $default(_that.phase,_that.title,_that.room,_that.muted,_that.deafened,_that.busy,_that.error,_that.roster,_that.speaking,_that.canPublish,_that.connection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VoicePhase phase,  String title,  String room,  bool muted,  bool deafened,  bool busy,  String error,  VoiceRoomState? roster,  Set<String> speaking,  bool canPublish,  VoiceConnectionInfo connection)?  $default,) {final _that = this;
switch (_that) {
case _VoiceState() when $default != null:
return $default(_that.phase,_that.title,_that.room,_that.muted,_that.deafened,_that.busy,_that.error,_that.roster,_that.speaking,_that.canPublish,_that.connection);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceState extends VoiceState {
  const _VoiceState({this.phase = VoicePhase.idle, this.title = '', this.room = '', this.muted = true, this.deafened = false, this.busy = false, this.error = '', this.roster,  Set<String> speaking = const {}, this.canPublish = false, this.connection = const VoiceConnectionInfo()}): _speaking = speaking,super._();
  

@override@JsonKey() final  VoicePhase phase;
@override@JsonKey() final  String title;
@override@JsonKey() final  String room;
@override@JsonKey() final  bool muted;
@override@JsonKey() final  bool deafened;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  String error;
@override final  VoiceRoomState? roster;
 final  Set<String> _speaking;
@override@JsonKey() Set<String> get speaking {
  if (_speaking is EqualUnmodifiableSetView) return _speaking;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_speaking);
}

@override@JsonKey() final  bool canPublish;
@override@JsonKey() final  VoiceConnectionInfo connection;

/// Create a copy of VoiceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceStateCopyWith<_VoiceState> get copyWith => __$VoiceStateCopyWithImpl<_VoiceState>(this, _$identity);





@override
String toString() {
    return 'VoiceState(phase: $phase, title: $title, room: $room, muted: $muted, deafened: $deafened, busy: $busy, error: $error, roster: $roster, speaking: $speaking, canPublish: $canPublish, connection: $connection)';
}


}

/// @nodoc
abstract mixin class _$VoiceStateCopyWith<$Res> implements $VoiceStateCopyWith<$Res> {
  factory _$VoiceStateCopyWith(_VoiceState value, $Res Function(_VoiceState) _then) = __$VoiceStateCopyWithImpl;
@override @useResult
$Res call({
 VoicePhase phase, String title, String room, bool muted, bool deafened, bool busy, String error, VoiceRoomState? roster, Set<String> speaking, bool canPublish, VoiceConnectionInfo connection
});




}
/// @nodoc
class __$VoiceStateCopyWithImpl<$Res>
    implements _$VoiceStateCopyWith<$Res> {
  __$VoiceStateCopyWithImpl(this._self, this._then);

  final _VoiceState _self;
  final $Res Function(_VoiceState) _then;

/// Create a copy of VoiceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? title = null,Object? room = null,Object? muted = null,Object? deafened = null,Object? busy = null,Object? error = null,Object? roster = freezed,Object? speaking = null,Object? canPublish = null,Object? connection = null,}) {
  return _then(_VoiceState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as VoicePhase,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as bool,deafened: null == deafened ? _self.deafened : deafened // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,roster: freezed == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as VoiceRoomState?,speaking: null == speaking ? _self._speaking : speaking // ignore: cast_nullable_to_non_nullable
as Set<String>,canPublish: null == canPublish ? _self.canPublish : canPublish // ignore: cast_nullable_to_non_nullable
as bool,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as VoiceConnectionInfo,
  ));
}


}

// dart format on
