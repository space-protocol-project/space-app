// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_devices.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceDevicesState {

 List<VoiceDevice> get devices; bool get busy; String get error; String? get input; String? get output; bool get ready; VoiceAudioSettings get audio;
/// Create a copy of VoiceDevicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceDevicesStateCopyWith<VoiceDevicesState> get copyWith => _$VoiceDevicesStateCopyWithImpl<VoiceDevicesState>(this as VoiceDevicesState, _$identity);





@override
String toString() {
  final _this = this as VoiceDevicesState;
  return 'VoiceDevicesState(devices: ${_this.devices}, busy: ${_this.busy}, error: ${_this.error}, input: ${_this.input}, output: ${_this.output}, ready: ${_this.ready}, audio: ${_this.audio})';
}


}

/// @nodoc
abstract mixin class $VoiceDevicesStateCopyWith<$Res>  {
  factory $VoiceDevicesStateCopyWith(VoiceDevicesState value, $Res Function(VoiceDevicesState) _then) = _$VoiceDevicesStateCopyWithImpl;
@useResult
$Res call({
 List<VoiceDevice> devices, bool busy, String error, String? input, String? output, bool ready, VoiceAudioSettings audio
});




}
/// @nodoc
class _$VoiceDevicesStateCopyWithImpl<$Res>
    implements $VoiceDevicesStateCopyWith<$Res> {
  _$VoiceDevicesStateCopyWithImpl(this._self, this._then);

  final VoiceDevicesState _self;
  final $Res Function(VoiceDevicesState) _then;

/// Create a copy of VoiceDevicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,Object? busy = null,Object? error = null,Object? input = freezed,Object? output = freezed,Object? ready = null,Object? audio = null,}) {
  return _then(VoiceDevicesState(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<VoiceDevice>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String?,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as VoiceAudioSettings,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceDevicesState].
extension VoiceDevicesStatePatterns on VoiceDevicesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceDevicesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceDevicesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceDevicesState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceDevicesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceDevicesState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceDevicesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VoiceDevice> devices,  bool busy,  String error,  String? input,  String? output,  bool ready,  VoiceAudioSettings audio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceDevicesState() when $default != null:
return $default(_that.devices,_that.busy,_that.error,_that.input,_that.output,_that.ready,_that.audio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VoiceDevice> devices,  bool busy,  String error,  String? input,  String? output,  bool ready,  VoiceAudioSettings audio)  $default,) {final _that = this;
switch (_that) {
case _VoiceDevicesState():
return $default(_that.devices,_that.busy,_that.error,_that.input,_that.output,_that.ready,_that.audio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VoiceDevice> devices,  bool busy,  String error,  String? input,  String? output,  bool ready,  VoiceAudioSettings audio)?  $default,) {final _that = this;
switch (_that) {
case _VoiceDevicesState() when $default != null:
return $default(_that.devices,_that.busy,_that.error,_that.input,_that.output,_that.ready,_that.audio);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceDevicesState extends VoiceDevicesState {
  const _VoiceDevicesState({ List<VoiceDevice> devices = const [], this.busy = false, this.error = '', this.input, this.output, this.ready = false, this.audio = const VoiceAudioSettings()}): _devices = devices,super._();
  

 final  List<VoiceDevice> _devices;
@override@JsonKey() List<VoiceDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override@JsonKey() final  bool busy;
@override@JsonKey() final  String error;
@override final  String? input;
@override final  String? output;
@override@JsonKey() final  bool ready;
@override@JsonKey() final  VoiceAudioSettings audio;

/// Create a copy of VoiceDevicesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceDevicesStateCopyWith<_VoiceDevicesState> get copyWith => __$VoiceDevicesStateCopyWithImpl<_VoiceDevicesState>(this, _$identity);





@override
String toString() {
    return 'VoiceDevicesState(devices: $devices, busy: $busy, error: $error, input: $input, output: $output, ready: $ready, audio: $audio)';
}


}

/// @nodoc
abstract mixin class _$VoiceDevicesStateCopyWith<$Res> implements $VoiceDevicesStateCopyWith<$Res> {
  factory _$VoiceDevicesStateCopyWith(_VoiceDevicesState value, $Res Function(_VoiceDevicesState) _then) = __$VoiceDevicesStateCopyWithImpl;
@override @useResult
$Res call({
 List<VoiceDevice> devices, bool busy, String error, String? input, String? output, bool ready, VoiceAudioSettings audio
});




}
/// @nodoc
class __$VoiceDevicesStateCopyWithImpl<$Res>
    implements _$VoiceDevicesStateCopyWith<$Res> {
  __$VoiceDevicesStateCopyWithImpl(this._self, this._then);

  final _VoiceDevicesState _self;
  final $Res Function(_VoiceDevicesState) _then;

/// Create a copy of VoiceDevicesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? busy = null,Object? error = null,Object? input = freezed,Object? output = freezed,Object? ready = null,Object? audio = null,}) {
  return _then(_VoiceDevicesState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<VoiceDevice>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,input: freezed == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String?,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as VoiceAudioSettings,
  ));
}


}

// dart format on
