// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BuiltinNavigationState {

 bool get busy; bool get failed; List<BuiltinSection> get sections; BuiltinSection? get opened;
/// Create a copy of BuiltinNavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuiltinNavigationStateCopyWith<BuiltinNavigationState> get copyWith => _$BuiltinNavigationStateCopyWithImpl<BuiltinNavigationState>(this as BuiltinNavigationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BuiltinNavigationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuiltinNavigationState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&const DeepCollectionEquality().equals(other.sections, _this.sections)&&(identical(other.opened, _this.opened) || other.opened == _this.opened));
}


@override
int get hashCode {
  final _this = this as BuiltinNavigationState;
  return Object.hash(runtimeType,_this.busy,_this.failed,const DeepCollectionEquality().hash(_this.sections),_this.opened);
}

@override
String toString() {
  final _this = this as BuiltinNavigationState;
  return 'BuiltinNavigationState(busy: ${_this.busy}, failed: ${_this.failed}, sections: ${_this.sections}, opened: ${_this.opened})';
}


}

/// @nodoc
abstract mixin class $BuiltinNavigationStateCopyWith<$Res>  {
  factory $BuiltinNavigationStateCopyWith(BuiltinNavigationState value, $Res Function(BuiltinNavigationState) _then) = _$BuiltinNavigationStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool failed, List<BuiltinSection> sections, BuiltinSection? opened
});




}
/// @nodoc
class _$BuiltinNavigationStateCopyWithImpl<$Res>
    implements $BuiltinNavigationStateCopyWith<$Res> {
  _$BuiltinNavigationStateCopyWithImpl(this._self, this._then);

  final BuiltinNavigationState _self;
  final $Res Function(BuiltinNavigationState) _then;

/// Create a copy of BuiltinNavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? failed = null,Object? sections = null,Object? opened = freezed,}) {
  return _then(BuiltinNavigationState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<BuiltinSection>,opened: freezed == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as BuiltinSection?,
  ));
}

}


/// Adds pattern-matching-related methods to [BuiltinNavigationState].
extension BuiltinNavigationStatePatterns on BuiltinNavigationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuiltinNavigationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuiltinNavigationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuiltinNavigationState value)  $default,){
final _that = this;
switch (_that) {
case _BuiltinNavigationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuiltinNavigationState value)?  $default,){
final _that = this;
switch (_that) {
case _BuiltinNavigationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool failed,  List<BuiltinSection> sections,  BuiltinSection? opened)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuiltinNavigationState() when $default != null:
return $default(_that.busy,_that.failed,_that.sections,_that.opened);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool failed,  List<BuiltinSection> sections,  BuiltinSection? opened)  $default,) {final _that = this;
switch (_that) {
case _BuiltinNavigationState():
return $default(_that.busy,_that.failed,_that.sections,_that.opened);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool failed,  List<BuiltinSection> sections,  BuiltinSection? opened)?  $default,) {final _that = this;
switch (_that) {
case _BuiltinNavigationState() when $default != null:
return $default(_that.busy,_that.failed,_that.sections,_that.opened);case _:
  return null;

}
}

}

/// @nodoc


class _BuiltinNavigationState implements BuiltinNavigationState {
  const _BuiltinNavigationState({this.busy = true, this.failed = false,  List<BuiltinSection> sections = const <BuiltinSection>[], this.opened}): _sections = sections;
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool failed;
 final  List<BuiltinSection> _sections;
@override@JsonKey() List<BuiltinSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  BuiltinSection? opened;

/// Create a copy of BuiltinNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuiltinNavigationStateCopyWith<_BuiltinNavigationState> get copyWith => __$BuiltinNavigationStateCopyWithImpl<_BuiltinNavigationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuiltinNavigationState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other.sections, _sections)&&(identical(other.opened, opened) || other.opened == opened));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,failed,const DeepCollectionEquality().hash(_sections),opened);
}

@override
String toString() {
    return 'BuiltinNavigationState(busy: $busy, failed: $failed, sections: $sections, opened: $opened)';
}


}

/// @nodoc
abstract mixin class _$BuiltinNavigationStateCopyWith<$Res> implements $BuiltinNavigationStateCopyWith<$Res> {
  factory _$BuiltinNavigationStateCopyWith(_BuiltinNavigationState value, $Res Function(_BuiltinNavigationState) _then) = __$BuiltinNavigationStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool failed, List<BuiltinSection> sections, BuiltinSection? opened
});




}
/// @nodoc
class __$BuiltinNavigationStateCopyWithImpl<$Res>
    implements _$BuiltinNavigationStateCopyWith<$Res> {
  __$BuiltinNavigationStateCopyWithImpl(this._self, this._then);

  final _BuiltinNavigationState _self;
  final $Res Function(_BuiltinNavigationState) _then;

/// Create a copy of BuiltinNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? failed = null,Object? sections = null,Object? opened = freezed,}) {
  return _then(_BuiltinNavigationState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<BuiltinSection>,opened: freezed == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as BuiltinSection?,
  ));
}


}

// dart format on
