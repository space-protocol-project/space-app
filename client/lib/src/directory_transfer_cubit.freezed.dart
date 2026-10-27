// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'directory_transfer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DirectoryTransferState {

 DirectoryTransferStage get stage; bool get receiving; bool get mergeSettings; Map<String, SettingsChoice> get settingsChoices; String get qr; String get sas; List<String> get selected; DirectoryRestorePlan? get plan;
/// Create a copy of DirectoryTransferState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectoryTransferStateCopyWith<DirectoryTransferState> get copyWith => _$DirectoryTransferStateCopyWithImpl<DirectoryTransferState>(this as DirectoryTransferState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DirectoryTransferState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectoryTransferState&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.receiving, _this.receiving) || other.receiving == _this.receiving)&&(identical(other.mergeSettings, _this.mergeSettings) || other.mergeSettings == _this.mergeSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _this.settingsChoices)&&(identical(other.qr, _this.qr) || other.qr == _this.qr)&&(identical(other.sas, _this.sas) || other.sas == _this.sas)&&const DeepCollectionEquality().equals(other.selected, _this.selected)&&(identical(other.plan, _this.plan) || other.plan == _this.plan));
}


@override
int get hashCode {
  final _this = this as DirectoryTransferState;
  return Object.hash(runtimeType,_this.stage,_this.receiving,_this.mergeSettings,const DeepCollectionEquality().hash(_this.settingsChoices),_this.qr,_this.sas,const DeepCollectionEquality().hash(_this.selected),_this.plan);
}

@override
String toString() {
  final _this = this as DirectoryTransferState;
  return 'DirectoryTransferState(stage: ${_this.stage}, receiving: ${_this.receiving}, mergeSettings: ${_this.mergeSettings}, settingsChoices: ${_this.settingsChoices}, qr: ${_this.qr}, sas: ${_this.sas}, selected: ${_this.selected}, plan: ${_this.plan})';
}


}

/// @nodoc
abstract mixin class $DirectoryTransferStateCopyWith<$Res>  {
  factory $DirectoryTransferStateCopyWith(DirectoryTransferState value, $Res Function(DirectoryTransferState) _then) = _$DirectoryTransferStateCopyWithImpl;
@useResult
$Res call({
 DirectoryTransferStage stage, bool receiving, bool mergeSettings, Map<String, SettingsChoice> settingsChoices, String qr, String sas, List<String> selected, DirectoryRestorePlan? plan
});




}
/// @nodoc
class _$DirectoryTransferStateCopyWithImpl<$Res>
    implements $DirectoryTransferStateCopyWith<$Res> {
  _$DirectoryTransferStateCopyWithImpl(this._self, this._then);

  final DirectoryTransferState _self;
  final $Res Function(DirectoryTransferState) _then;

/// Create a copy of DirectoryTransferState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? receiving = null,Object? mergeSettings = null,Object? settingsChoices = null,Object? qr = null,Object? sas = null,Object? selected = null,Object? plan = freezed,}) {
  return _then(DirectoryTransferState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as DirectoryTransferStage,receiving: null == receiving ? _self.receiving : receiving // ignore: cast_nullable_to_non_nullable
as bool,mergeSettings: null == mergeSettings ? _self.mergeSettings : mergeSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self.settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,qr: null == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as String,sas: null == sas ? _self.sas : sas // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as List<String>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as DirectoryRestorePlan?,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectoryTransferState].
extension DirectoryTransferStatePatterns on DirectoryTransferState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectoryTransferState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectoryTransferState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectoryTransferState value)  $default,){
final _that = this;
switch (_that) {
case _DirectoryTransferState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectoryTransferState value)?  $default,){
final _that = this;
switch (_that) {
case _DirectoryTransferState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DirectoryTransferStage stage,  bool receiving,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String qr,  String sas,  List<String> selected,  DirectoryRestorePlan? plan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectoryTransferState() when $default != null:
return $default(_that.stage,_that.receiving,_that.mergeSettings,_that.settingsChoices,_that.qr,_that.sas,_that.selected,_that.plan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DirectoryTransferStage stage,  bool receiving,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String qr,  String sas,  List<String> selected,  DirectoryRestorePlan? plan)  $default,) {final _that = this;
switch (_that) {
case _DirectoryTransferState():
return $default(_that.stage,_that.receiving,_that.mergeSettings,_that.settingsChoices,_that.qr,_that.sas,_that.selected,_that.plan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DirectoryTransferStage stage,  bool receiving,  bool mergeSettings,  Map<String, SettingsChoice> settingsChoices,  String qr,  String sas,  List<String> selected,  DirectoryRestorePlan? plan)?  $default,) {final _that = this;
switch (_that) {
case _DirectoryTransferState() when $default != null:
return $default(_that.stage,_that.receiving,_that.mergeSettings,_that.settingsChoices,_that.qr,_that.sas,_that.selected,_that.plan);case _:
  return null;

}
}

}

/// @nodoc


class _DirectoryTransferState implements DirectoryTransferState {
  const _DirectoryTransferState({this.stage = DirectoryTransferStage.idle, this.receiving = false, this.mergeSettings = false,  Map<String, SettingsChoice> settingsChoices = const {}, this.qr = '', this.sas = '',  List<String> selected = const [], this.plan}): _settingsChoices = settingsChoices,_selected = selected;
  

@override@JsonKey() final  DirectoryTransferStage stage;
@override@JsonKey() final  bool receiving;
@override@JsonKey() final  bool mergeSettings;
 final  Map<String, SettingsChoice> _settingsChoices;
@override@JsonKey() Map<String, SettingsChoice> get settingsChoices {
  if (_settingsChoices is EqualUnmodifiableMapView) return _settingsChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settingsChoices);
}

@override@JsonKey() final  String qr;
@override@JsonKey() final  String sas;
 final  List<String> _selected;
@override@JsonKey() List<String> get selected {
  if (_selected is EqualUnmodifiableListView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selected);
}

@override final  DirectoryRestorePlan? plan;

/// Create a copy of DirectoryTransferState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectoryTransferStateCopyWith<_DirectoryTransferState> get copyWith => __$DirectoryTransferStateCopyWithImpl<_DirectoryTransferState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectoryTransferState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.receiving, receiving) || other.receiving == receiving)&&(identical(other.mergeSettings, mergeSettings) || other.mergeSettings == mergeSettings)&&const DeepCollectionEquality().equals(other.settingsChoices, _settingsChoices)&&(identical(other.qr, qr) || other.qr == qr)&&(identical(other.sas, sas) || other.sas == sas)&&const DeepCollectionEquality().equals(other.selected, _selected)&&(identical(other.plan, plan) || other.plan == plan));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stage,receiving,mergeSettings,const DeepCollectionEquality().hash(_settingsChoices),qr,sas,const DeepCollectionEquality().hash(_selected),plan);
}

@override
String toString() {
    return 'DirectoryTransferState(stage: $stage, receiving: $receiving, mergeSettings: $mergeSettings, settingsChoices: $settingsChoices, qr: $qr, sas: $sas, selected: $selected, plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$DirectoryTransferStateCopyWith<$Res> implements $DirectoryTransferStateCopyWith<$Res> {
  factory _$DirectoryTransferStateCopyWith(_DirectoryTransferState value, $Res Function(_DirectoryTransferState) _then) = __$DirectoryTransferStateCopyWithImpl;
@override @useResult
$Res call({
 DirectoryTransferStage stage, bool receiving, bool mergeSettings, Map<String, SettingsChoice> settingsChoices, String qr, String sas, List<String> selected, DirectoryRestorePlan? plan
});




}
/// @nodoc
class __$DirectoryTransferStateCopyWithImpl<$Res>
    implements _$DirectoryTransferStateCopyWith<$Res> {
  __$DirectoryTransferStateCopyWithImpl(this._self, this._then);

  final _DirectoryTransferState _self;
  final $Res Function(_DirectoryTransferState) _then;

/// Create a copy of DirectoryTransferState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? receiving = null,Object? mergeSettings = null,Object? settingsChoices = null,Object? qr = null,Object? sas = null,Object? selected = null,Object? plan = freezed,}) {
  return _then(_DirectoryTransferState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as DirectoryTransferStage,receiving: null == receiving ? _self.receiving : receiving // ignore: cast_nullable_to_non_nullable
as bool,mergeSettings: null == mergeSettings ? _self.mergeSettings : mergeSettings // ignore: cast_nullable_to_non_nullable
as bool,settingsChoices: null == settingsChoices ? _self._settingsChoices : settingsChoices // ignore: cast_nullable_to_non_nullable
as Map<String, SettingsChoice>,qr: null == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as String,sas: null == sas ? _self.sas : sas // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as List<String>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as DirectoryRestorePlan?,
  ));
}


}

// dart format on
