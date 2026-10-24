// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 List<DashboardCommunitySection> get communities; bool get loading; bool get failed; bool get unsupported;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.communities, _this.communities)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.unsupported, _this.unsupported) || other.unsupported == _this.unsupported));
}


@override
int get hashCode {
  final _this = this as DashboardState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.communities),_this.loading,_this.failed,_this.unsupported);
}

@override
String toString() {
  final _this = this as DashboardState;
  return 'DashboardState(communities: ${_this.communities}, loading: ${_this.loading}, failed: ${_this.failed}, unsupported: ${_this.unsupported})';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 List<DashboardCommunitySection> communities, bool loading, bool failed, bool unsupported
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? communities = null,Object? loading = null,Object? failed = null,Object? unsupported = null,}) {
  return _then(DashboardState(
communities: null == communities ? _self.communities : communities // ignore: cast_nullable_to_non_nullable
as List<DashboardCommunitySection>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,unsupported: null == unsupported ? _self.unsupported : unsupported // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DashboardCommunitySection> communities,  bool loading,  bool failed,  bool unsupported)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.communities,_that.loading,_that.failed,_that.unsupported);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DashboardCommunitySection> communities,  bool loading,  bool failed,  bool unsupported)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.communities,_that.loading,_that.failed,_that.unsupported);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DashboardCommunitySection> communities,  bool loading,  bool failed,  bool unsupported)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.communities,_that.loading,_that.failed,_that.unsupported);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({ List<DashboardCommunitySection> communities = const [], this.loading = false, this.failed = false, this.unsupported = false}): _communities = communities;
  

 final  List<DashboardCommunitySection> _communities;
@override@JsonKey() List<DashboardCommunitySection> get communities {
  if (_communities is EqualUnmodifiableListView) return _communities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_communities);
}

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  bool unsupported;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other.communities, _communities)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.unsupported, unsupported) || other.unsupported == unsupported));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_communities),loading,failed,unsupported);
}

@override
String toString() {
    return 'DashboardState(communities: $communities, loading: $loading, failed: $failed, unsupported: $unsupported)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<DashboardCommunitySection> communities, bool loading, bool failed, bool unsupported
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? communities = null,Object? loading = null,Object? failed = null,Object? unsupported = null,}) {
  return _then(_DashboardState(
communities: null == communities ? _self._communities : communities // ignore: cast_nullable_to_non_nullable
as List<DashboardCommunitySection>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,unsupported: null == unsupported ? _self.unsupported : unsupported // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
