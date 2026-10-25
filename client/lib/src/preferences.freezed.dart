// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreferencesState {

 int get notificationMode; double get uiScale; bool get dark; ThemeMode get themeMode; bool get effects; String get palette; String get language; String get sendShortcut; String get error; List<String> get origins; Map<String, Map<String, dynamic>> get serverIcons; ThemeData? get theme;
/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesStateCopyWith<PreferencesState> get copyWith => _$PreferencesStateCopyWithImpl<PreferencesState>(this as PreferencesState, _$identity);





@override
String toString() {
  final _this = this as PreferencesState;
  return 'PreferencesState(notificationMode: ${_this.notificationMode}, uiScale: ${_this.uiScale}, dark: ${_this.dark}, themeMode: ${_this.themeMode}, effects: ${_this.effects}, palette: ${_this.palette}, language: ${_this.language}, sendShortcut: ${_this.sendShortcut}, error: ${_this.error}, origins: ${_this.origins}, serverIcons: ${_this.serverIcons}, theme: ${_this.theme})';
}


}

/// @nodoc
abstract mixin class $PreferencesStateCopyWith<$Res>  {
  factory $PreferencesStateCopyWith(PreferencesState value, $Res Function(PreferencesState) _then) = _$PreferencesStateCopyWithImpl;
@useResult
$Res call({
 int notificationMode, double uiScale, bool dark, ThemeMode themeMode, bool effects, String palette, String language, String sendShortcut, String error, List<String> origins, Map<String, Map<String, dynamic>> serverIcons, ThemeData? theme
});




}
/// @nodoc
class _$PreferencesStateCopyWithImpl<$Res>
    implements $PreferencesStateCopyWith<$Res> {
  _$PreferencesStateCopyWithImpl(this._self, this._then);

  final PreferencesState _self;
  final $Res Function(PreferencesState) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationMode = null,Object? uiScale = null,Object? dark = null,Object? themeMode = null,Object? effects = null,Object? palette = null,Object? language = null,Object? sendShortcut = null,Object? error = null,Object? origins = null,Object? serverIcons = null,Object? theme = freezed,}) {
  return _then(PreferencesState(
notificationMode: null == notificationMode ? _self.notificationMode : notificationMode // ignore: cast_nullable_to_non_nullable
as int,uiScale: null == uiScale ? _self.uiScale : uiScale // ignore: cast_nullable_to_non_nullable
as double,dark: null == dark ? _self.dark : dark // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,effects: null == effects ? _self.effects : effects // ignore: cast_nullable_to_non_nullable
as bool,palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,sendShortcut: null == sendShortcut ? _self.sendShortcut : sendShortcut // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,origins: null == origins ? _self.origins : origins // ignore: cast_nullable_to_non_nullable
as List<String>,serverIcons: null == serverIcons ? _self.serverIcons : serverIcons // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, dynamic>>,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeData?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesState].
extension PreferencesStatePatterns on PreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int notificationMode,  double uiScale,  bool dark,  ThemeMode themeMode,  bool effects,  String palette,  String language,  String sendShortcut,  String error,  List<String> origins,  Map<String, Map<String, dynamic>> serverIcons,  ThemeData? theme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that.notificationMode,_that.uiScale,_that.dark,_that.themeMode,_that.effects,_that.palette,_that.language,_that.sendShortcut,_that.error,_that.origins,_that.serverIcons,_that.theme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int notificationMode,  double uiScale,  bool dark,  ThemeMode themeMode,  bool effects,  String palette,  String language,  String sendShortcut,  String error,  List<String> origins,  Map<String, Map<String, dynamic>> serverIcons,  ThemeData? theme)  $default,) {final _that = this;
switch (_that) {
case _PreferencesState():
return $default(_that.notificationMode,_that.uiScale,_that.dark,_that.themeMode,_that.effects,_that.palette,_that.language,_that.sendShortcut,_that.error,_that.origins,_that.serverIcons,_that.theme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int notificationMode,  double uiScale,  bool dark,  ThemeMode themeMode,  bool effects,  String palette,  String language,  String sendShortcut,  String error,  List<String> origins,  Map<String, Map<String, dynamic>> serverIcons,  ThemeData? theme)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that.notificationMode,_that.uiScale,_that.dark,_that.themeMode,_that.effects,_that.palette,_that.language,_that.sendShortcut,_that.error,_that.origins,_that.serverIcons,_that.theme);case _:
  return null;

}
}

}

/// @nodoc


class _PreferencesState extends PreferencesState {
  const _PreferencesState({this.notificationMode = 0, this.uiScale = 1, this.dark = true, this.themeMode = ThemeMode.dark, this.effects = true, this.palette = 'gruvbox', this.language = 'ru', this.sendShortcut = 'enter', this.error = '',  List<String> origins = const [],  Map<String, Map<String, dynamic>> serverIcons = const {}, this.theme}): _origins = origins,_serverIcons = serverIcons,super._();
  

@override@JsonKey() final  int notificationMode;
@override@JsonKey() final  double uiScale;
@override@JsonKey() final  bool dark;
@override@JsonKey() final  ThemeMode themeMode;
@override@JsonKey() final  bool effects;
@override@JsonKey() final  String palette;
@override@JsonKey() final  String language;
@override@JsonKey() final  String sendShortcut;
@override@JsonKey() final  String error;
 final  List<String> _origins;
@override@JsonKey() List<String> get origins {
  if (_origins is EqualUnmodifiableListView) return _origins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_origins);
}

 final  Map<String, Map<String, dynamic>> _serverIcons;
@override@JsonKey() Map<String, Map<String, dynamic>> get serverIcons {
  if (_serverIcons is EqualUnmodifiableMapView) return _serverIcons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_serverIcons);
}

@override final  ThemeData? theme;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesStateCopyWith<_PreferencesState> get copyWith => __$PreferencesStateCopyWithImpl<_PreferencesState>(this, _$identity);





@override
String toString() {
    return 'PreferencesState(notificationMode: $notificationMode, uiScale: $uiScale, dark: $dark, themeMode: $themeMode, effects: $effects, palette: $palette, language: $language, sendShortcut: $sendShortcut, error: $error, origins: $origins, serverIcons: $serverIcons, theme: $theme)';
}


}

/// @nodoc
abstract mixin class _$PreferencesStateCopyWith<$Res> implements $PreferencesStateCopyWith<$Res> {
  factory _$PreferencesStateCopyWith(_PreferencesState value, $Res Function(_PreferencesState) _then) = __$PreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 int notificationMode, double uiScale, bool dark, ThemeMode themeMode, bool effects, String palette, String language, String sendShortcut, String error, List<String> origins, Map<String, Map<String, dynamic>> serverIcons, ThemeData? theme
});




}
/// @nodoc
class __$PreferencesStateCopyWithImpl<$Res>
    implements _$PreferencesStateCopyWith<$Res> {
  __$PreferencesStateCopyWithImpl(this._self, this._then);

  final _PreferencesState _self;
  final $Res Function(_PreferencesState) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationMode = null,Object? uiScale = null,Object? dark = null,Object? themeMode = null,Object? effects = null,Object? palette = null,Object? language = null,Object? sendShortcut = null,Object? error = null,Object? origins = null,Object? serverIcons = null,Object? theme = freezed,}) {
  return _then(_PreferencesState(
notificationMode: null == notificationMode ? _self.notificationMode : notificationMode // ignore: cast_nullable_to_non_nullable
as int,uiScale: null == uiScale ? _self.uiScale : uiScale // ignore: cast_nullable_to_non_nullable
as double,dark: null == dark ? _self.dark : dark // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,effects: null == effects ? _self.effects : effects // ignore: cast_nullable_to_non_nullable
as bool,palette: null == palette ? _self.palette : palette // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,sendShortcut: null == sendShortcut ? _self.sendShortcut : sendShortcut // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,origins: null == origins ? _self._origins : origins // ignore: cast_nullable_to_non_nullable
as List<String>,serverIcons: null == serverIcons ? _self._serverIcons : serverIcons // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, dynamic>>,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeData?,
  ));
}


}

// dart format on
