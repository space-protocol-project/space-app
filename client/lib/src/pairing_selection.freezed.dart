// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairingSelectionState {

 Set<String> get origins; bool get fullManagement; bool get busy; bool get prepared; String get error; int get revision;
/// Create a copy of PairingSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingSelectionStateCopyWith<PairingSelectionState> get copyWith => _$PairingSelectionStateCopyWithImpl<PairingSelectionState>(this as PairingSelectionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PairingSelectionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingSelectionState&&const DeepCollectionEquality().equals(other.origins, _this.origins)&&(identical(other.fullManagement, _this.fullManagement) || other.fullManagement == _this.fullManagement)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.prepared, _this.prepared) || other.prepared == _this.prepared)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.revision, _this.revision) || other.revision == _this.revision));
}


@override
int get hashCode {
  final _this = this as PairingSelectionState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.origins),_this.fullManagement,_this.busy,_this.prepared,_this.error,_this.revision);
}

@override
String toString() {
  final _this = this as PairingSelectionState;
  return 'PairingSelectionState(origins: ${_this.origins}, fullManagement: ${_this.fullManagement}, busy: ${_this.busy}, prepared: ${_this.prepared}, error: ${_this.error}, revision: ${_this.revision})';
}


}

/// @nodoc
abstract mixin class $PairingSelectionStateCopyWith<$Res>  {
  factory $PairingSelectionStateCopyWith(PairingSelectionState value, $Res Function(PairingSelectionState) _then) = _$PairingSelectionStateCopyWithImpl;
@useResult
$Res call({
 Set<String> origins, bool fullManagement, bool busy, bool prepared, String error, int revision
});




}
/// @nodoc
class _$PairingSelectionStateCopyWithImpl<$Res>
    implements $PairingSelectionStateCopyWith<$Res> {
  _$PairingSelectionStateCopyWithImpl(this._self, this._then);

  final PairingSelectionState _self;
  final $Res Function(PairingSelectionState) _then;

/// Create a copy of PairingSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? origins = null,Object? fullManagement = null,Object? busy = null,Object? prepared = null,Object? error = null,Object? revision = null,}) {
  return _then(PairingSelectionState(
origins: null == origins ? _self.origins : origins // ignore: cast_nullable_to_non_nullable
as Set<String>,fullManagement: null == fullManagement ? _self.fullManagement : fullManagement // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,prepared: null == prepared ? _self.prepared : prepared // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PairingSelectionState].
extension PairingSelectionStatePatterns on PairingSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _PairingSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _PairingSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> origins,  bool fullManagement,  bool busy,  bool prepared,  String error,  int revision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingSelectionState() when $default != null:
return $default(_that.origins,_that.fullManagement,_that.busy,_that.prepared,_that.error,_that.revision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> origins,  bool fullManagement,  bool busy,  bool prepared,  String error,  int revision)  $default,) {final _that = this;
switch (_that) {
case _PairingSelectionState():
return $default(_that.origins,_that.fullManagement,_that.busy,_that.prepared,_that.error,_that.revision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> origins,  bool fullManagement,  bool busy,  bool prepared,  String error,  int revision)?  $default,) {final _that = this;
switch (_that) {
case _PairingSelectionState() when $default != null:
return $default(_that.origins,_that.fullManagement,_that.busy,_that.prepared,_that.error,_that.revision);case _:
  return null;

}
}

}

/// @nodoc


class _PairingSelectionState implements PairingSelectionState {
  const _PairingSelectionState({ Set<String> origins = const <String>{}, this.fullManagement = false, this.busy = false, this.prepared = false, this.error = '', this.revision = 0}): _origins = origins;
  

 final  Set<String> _origins;
@override@JsonKey() Set<String> get origins {
  if (_origins is EqualUnmodifiableSetView) return _origins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_origins);
}

@override@JsonKey() final  bool fullManagement;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool prepared;
@override@JsonKey() final  String error;
@override@JsonKey() final  int revision;

/// Create a copy of PairingSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingSelectionStateCopyWith<_PairingSelectionState> get copyWith => __$PairingSelectionStateCopyWithImpl<_PairingSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingSelectionState&&const DeepCollectionEquality().equals(other.origins, _origins)&&(identical(other.fullManagement, fullManagement) || other.fullManagement == fullManagement)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.prepared, prepared) || other.prepared == prepared)&&(identical(other.error, error) || other.error == error)&&(identical(other.revision, revision) || other.revision == revision));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_origins),fullManagement,busy,prepared,error,revision);
}

@override
String toString() {
    return 'PairingSelectionState(origins: $origins, fullManagement: $fullManagement, busy: $busy, prepared: $prepared, error: $error, revision: $revision)';
}


}

/// @nodoc
abstract mixin class _$PairingSelectionStateCopyWith<$Res> implements $PairingSelectionStateCopyWith<$Res> {
  factory _$PairingSelectionStateCopyWith(_PairingSelectionState value, $Res Function(_PairingSelectionState) _then) = __$PairingSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> origins, bool fullManagement, bool busy, bool prepared, String error, int revision
});




}
/// @nodoc
class __$PairingSelectionStateCopyWithImpl<$Res>
    implements _$PairingSelectionStateCopyWith<$Res> {
  __$PairingSelectionStateCopyWithImpl(this._self, this._then);

  final _PairingSelectionState _self;
  final $Res Function(_PairingSelectionState) _then;

/// Create a copy of PairingSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? origins = null,Object? fullManagement = null,Object? busy = null,Object? prepared = null,Object? error = null,Object? revision = null,}) {
  return _then(_PairingSelectionState(
origins: null == origins ? _self._origins : origins // ignore: cast_nullable_to_non_nullable
as Set<String>,fullManagement: null == fullManagement ? _self.fullManagement : fullManagement // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,prepared: null == prepared ? _self.prepared : prepared // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
