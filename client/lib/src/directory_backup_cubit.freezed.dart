// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'directory_backup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DirectoryBackupState {

 bool get busy; bool get mergeSettings; Map<String, SettingsChoice> get settingsChoices; String get message; List<String> get results; DirectoryRestorePlan? get plan; Object? get error;
/// Create a copy of DirectoryBackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectoryBackupStateCopyWith<DirectoryBackupState> get copyWith => _$DirectoryBackupStateCopyWithImpl<DirectoryBackupState>(this as DirectoryBackupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DirectoryBackupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectoryBackupState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.mergeSettings, _this.mergeSettings) || other.mergeSettings == _this.mergeSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _this.settingsChoices)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as DirectoryBackupState;
  return Object.hash(runtimeType,_this.busy,_this.mergeSettings,const DeepCollectionEquality().hash(_this.settingsChoices),_this.message,const DeepCollectionEquality().hash(_this.results),_this.plan,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as DirectoryBackupState;
  return 'DirectoryBackupState(busy: ${_this.busy}, mergeSettings: ${_this.mergeSettings}, settingsChoices: ${_this.settingsChoices}, message: ${_this.message}, results: ${_this.results}, plan: ${_this.plan}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $DirectoryBackupStateCopyWith<$Res>  {
  factory $DirectoryBackupStateCopyWith(DirectoryBackupState value, $Res Function(DirectoryBackupState) _then) = _$DirectoryBackupStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool mergeSettings, Map<String, SettingsChoice> settingsChoices, String message, List<String> results, DirectoryRestorePlan? plan, Object? error
});




}
/// @nodoc
class _$DirectoryBackupStateCopyWithImpl<$Res>
    implements $DirectoryBackupStateCopyWith<$Res> {
  _$DirectoryBackupStateCopyWithImpl(this._self, this._then);

  final DirectoryBackupState _self;
  final $Res Function(DirectoryBackupState) _then;

/// Create a copy of DirectoryBackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? mergeSettings = null,Object? settingsChoices = null,Object? message = null,Object? results = null,Object? plan = freezed,Object? error = freezed,}) {
  return _then(DirectoryBackupState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,mergeSettings: null == mergeSettings ? _self.mergeSettings : mergeSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self.settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<String>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as DirectoryRestorePlan?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectoryBackupState].
extension DirectoryBackupStatePatterns on DirectoryBackupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectoryBackupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectoryBackupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectoryBackupState value)  $default,){
final _that = this;
switch (_that) {
case _DirectoryBackupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectoryBackupState value)?  $default,){
final _that = this;
switch (_that) {
case _DirectoryBackupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  List<String> results,  DirectoryRestorePlan? plan,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectoryBackupState() when $default != null:
return $default(_that.busy,_that.mergeSettings,_that.settingsChoices,_that.message,_that.results,_that.plan,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  List<String> results,  DirectoryRestorePlan? plan,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _DirectoryBackupState():
return $default(_that.busy,_that.mergeSettings,_that.settingsChoices,_that.message,_that.results,_that.plan,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String message,  List<String> results,  DirectoryRestorePlan? plan,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _DirectoryBackupState() when $default != null:
return $default(_that.busy,_that.mergeSettings,_that.settingsChoices,_that.message,_that.results,_that.plan,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DirectoryBackupState implements DirectoryBackupState {
  const _DirectoryBackupState({this.busy = false, this.mergeSettings = false,  Map<String, SettingsChoice> settingsChoices = const {}, this.message = '',  List<String> results = const [], this.plan, this.error}): _settingsChoices = settingsChoices,_results = results;
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool mergeSettings;
 final  Map<String, SettingsChoice> _settingsChoices;
@override@JsonKey() Map<String, SettingsChoice> get settingsChoices {
  if (_settingsChoices is EqualUnmodifiableMapView) return _settingsChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settingsChoices);
}

@override@JsonKey() final  String message;
 final  List<String> _results;
@override@JsonKey() List<String> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  DirectoryRestorePlan? plan;
@override final  Object? error;

/// Create a copy of DirectoryBackupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectoryBackupStateCopyWith<_DirectoryBackupState> get copyWith => __$DirectoryBackupStateCopyWithImpl<_DirectoryBackupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectoryBackupState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.mergeSettings, mergeSettings) || other.mergeSettings == mergeSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _settingsChoices)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.plan, plan) || other.plan == plan)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,mergeSettings,const DeepCollectionEquality().hash(_settingsChoices),message,const DeepCollectionEquality().hash(_results),plan,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'DirectoryBackupState(busy: $busy, mergeSettings: $mergeSettings, settingsChoices: $settingsChoices, message: $message, results: $results, plan: $plan, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DirectoryBackupStateCopyWith<$Res> implements $DirectoryBackupStateCopyWith<$Res> {
  factory _$DirectoryBackupStateCopyWith(_DirectoryBackupState value, $Res Function(_DirectoryBackupState) _then) = __$DirectoryBackupStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool mergeSettings, Map<String, SettingsChoice> settingsChoices, String message, List<String> results, DirectoryRestorePlan? plan, Object? error
});




}
/// @nodoc
class __$DirectoryBackupStateCopyWithImpl<$Res>
    implements _$DirectoryBackupStateCopyWith<$Res> {
  __$DirectoryBackupStateCopyWithImpl(this._self, this._then);

  final _DirectoryBackupState _self;
  final $Res Function(_DirectoryBackupState) _then;

/// Create a copy of DirectoryBackupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? mergeSettings = null,Object? settingsChoices = null,Object? message = null,Object? results = null,Object? plan = freezed,Object? error = freezed,}) {
  return _then(_DirectoryBackupState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,mergeSettings: null == mergeSettings ? _self.mergeSettings : mergeSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self._settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<String>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as DirectoryRestorePlan?,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
