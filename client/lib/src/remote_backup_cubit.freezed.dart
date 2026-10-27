// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_backup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteBackupState {

 bool get busy; bool get replaceSettings; Map<String, SettingsChoice> get settingsChoices; String get message; RemoteBackupKit? get kit; RemoteRestore? get restore; Object? get error;
/// Create a copy of RemoteBackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteBackupStateCopyWith<RemoteBackupState> get copyWith => _$RemoteBackupStateCopyWithImpl<RemoteBackupState>(this as RemoteBackupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemoteBackupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteBackupState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.replaceSettings, _this.replaceSettings) || other.replaceSettings == _this.replaceSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _this.settingsChoices)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.kit, _this.kit) || other.kit == _this.kit)&&(identical(other.restore, _this.restore) || other.restore == _this.restore)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as RemoteBackupState;
  return Object.hash(runtimeType,_this.busy,_this.replaceSettings,const DeepCollectionEquality().hash(_this.settingsChoices),_this.message,_this.kit,_this.restore,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as RemoteBackupState;
  return 'RemoteBackupState(busy: ${_this.busy}, replaceSettings: ${_this.replaceSettings}, settingsChoices: ${_this.settingsChoices}, message: ${_this.message}, kit: ${_this.kit}, restore: ${_this.restore}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $RemoteBackupStateCopyWith<$Res>  {
  factory $RemoteBackupStateCopyWith(RemoteBackupState value, $Res Function(RemoteBackupState) _then) = _$RemoteBackupStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool replaceSettings, Map<String, SettingsChoice> settingsChoices, String message, RemoteBackupKit? kit, RemoteRestore? restore, Object? error
});




}
/// @nodoc
class _$RemoteBackupStateCopyWithImpl<$Res>
    implements $RemoteBackupStateCopyWith<$Res> {
  _$RemoteBackupStateCopyWithImpl(this._self, this._then);

  final RemoteBackupState _self;
  final $Res Function(RemoteBackupState) _then;

/// Create a copy of RemoteBackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? replaceSettings = null,Object? settingsChoices = null,Object? message = null,Object? kit = freezed,Object? restore = freezed,Object? error = freezed,}) {
  return _then(RemoteBackupState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,replaceSettings: null == replaceSettings ? _self.replaceSettings : replaceSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self.settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,kit: freezed == kit ? _self.kit : kit // ignore: cast_nullable_to_non_nullable
as RemoteBackupKit?,restore: freezed == restore ? _self.restore : restore // ignore: cast_nullable_to_non_nullable
as RemoteRestore?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteBackupState].
extension RemoteBackupStatePatterns on RemoteBackupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteBackupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteBackupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteBackupState value)  $default,){
final _that = this;
switch (_that) {
case _RemoteBackupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteBackupState value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteBackupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool replaceSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  RemoteBackupKit? kit,  RemoteRestore? restore,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteBackupState() when $default != null:
return $default(_that.busy,_that.replaceSettings,_that.settingsChoices,_that.message,_that.kit,_that.restore,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool replaceSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  RemoteBackupKit? kit,  RemoteRestore? restore,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _RemoteBackupState():
return $default(_that.busy,_that.replaceSettings,_that.settingsChoices,_that.message,_that.kit,_that.restore,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool replaceSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  RemoteBackupKit? kit,  RemoteRestore? restore,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _RemoteBackupState() when $default != null:
return $default(_that.busy,_that.replaceSettings,_that.settingsChoices,_that.message,_that.kit,_that.restore,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteBackupState implements RemoteBackupState {
  const _RemoteBackupState({this.busy = false, this.replaceSettings = false,  Map<String, SettingsChoice> settingsChoices = const {}, this.message = '', this.kit, this.restore, this.error}): _settingsChoices = settingsChoices;
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool replaceSettings;
 final  Map<String, SettingsChoice> _settingsChoices;
@override@JsonKey() Map<String, SettingsChoice> get settingsChoices {
  if (_settingsChoices is EqualUnmodifiableMapView) return _settingsChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settingsChoices);
}

@override@JsonKey() final  String message;
@override final  RemoteBackupKit? kit;
@override final  RemoteRestore? restore;
@override final  Object? error;

/// Create a copy of RemoteBackupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteBackupStateCopyWith<_RemoteBackupState> get copyWith => __$RemoteBackupStateCopyWithImpl<_RemoteBackupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteBackupState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.replaceSettings, replaceSettings) || other.replaceSettings == replaceSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _settingsChoices)&&(identical(other.message, message) || other.message == message)&&(identical(other.kit, kit) || other.kit == kit)&&(identical(other.restore, restore) || other.restore == restore)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,replaceSettings,const DeepCollectionEquality().hash(_settingsChoices),message,kit,restore,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'RemoteBackupState(busy: $busy, replaceSettings: $replaceSettings, settingsChoices: $settingsChoices, message: $message, kit: $kit, restore: $restore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoteBackupStateCopyWith<$Res> implements $RemoteBackupStateCopyWith<$Res> {
  factory _$RemoteBackupStateCopyWith(_RemoteBackupState value, $Res Function(_RemoteBackupState) _then) = __$RemoteBackupStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool replaceSettings, Map<String, SettingsChoice> settingsChoices, String message, RemoteBackupKit? kit, RemoteRestore? restore, Object? error
});




}
/// @nodoc
class __$RemoteBackupStateCopyWithImpl<$Res>
    implements _$RemoteBackupStateCopyWith<$Res> {
  __$RemoteBackupStateCopyWithImpl(this._self, this._then);

  final _RemoteBackupState _self;
  final $Res Function(_RemoteBackupState) _then;

/// Create a copy of RemoteBackupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? replaceSettings = null,Object? settingsChoices = null,Object? message = null,Object? kit = freezed,Object? restore = freezed,Object? error = freezed,}) {
  return _then(_RemoteBackupState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,replaceSettings: null == replaceSettings ? _self.replaceSettings : replaceSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self._settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,kit: freezed == kit ? _self.kit : kit // ignore: cast_nullable_to_non_nullable
as RemoteBackupKit?,restore: freezed == restore ? _self.restore : restore // ignore: cast_nullable_to_non_nullable
as RemoteRestore?,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
