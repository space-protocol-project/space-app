// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttachmentState {

 List<PendingAttachment> get files; bool get busy; double get progress; String get error; Object? get problem;
/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentStateCopyWith<AttachmentState> get copyWith => _$AttachmentStateCopyWithImpl<AttachmentState>(this as AttachmentState, _$identity);





@override
String toString() {
  final _this = this as AttachmentState;
  return 'AttachmentState(files: ${_this.files}, busy: ${_this.busy}, progress: ${_this.progress}, error: ${_this.error}, problem: ${_this.problem})';
}


}

/// @nodoc
abstract mixin class $AttachmentStateCopyWith<$Res>  {
  factory $AttachmentStateCopyWith(AttachmentState value, $Res Function(AttachmentState) _then) = _$AttachmentStateCopyWithImpl;
@useResult
$Res call({
 List<PendingAttachment> files, bool busy, double progress, String error, Object? problem
});




}
/// @nodoc
class _$AttachmentStateCopyWithImpl<$Res>
    implements $AttachmentStateCopyWith<$Res> {
  _$AttachmentStateCopyWithImpl(this._self, this._then);

  final AttachmentState _self;
  final $Res Function(AttachmentState) _then;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? busy = null,Object? progress = null,Object? error = null,Object? problem = freezed,}) {
  return _then(AttachmentState(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<PendingAttachment>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,problem: freezed == problem ? _self.problem : problem ,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentState].
extension AttachmentStatePatterns on AttachmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentState value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentState value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PendingAttachment> files,  bool busy,  double progress,  String error,  Object? problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
return $default(_that.files,_that.busy,_that.progress,_that.error,_that.problem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PendingAttachment> files,  bool busy,  double progress,  String error,  Object? problem)  $default,) {final _that = this;
switch (_that) {
case _AttachmentState():
return $default(_that.files,_that.busy,_that.progress,_that.error,_that.problem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PendingAttachment> files,  bool busy,  double progress,  String error,  Object? problem)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentState() when $default != null:
return $default(_that.files,_that.busy,_that.progress,_that.error,_that.problem);case _:
  return null;

}
}

}

/// @nodoc


class _AttachmentState extends AttachmentState {
  const _AttachmentState({ List<PendingAttachment> files = const [], this.busy = false, this.progress = 0, this.error = '', this.problem}): _files = files,super._();
  

 final  List<PendingAttachment> _files;
@override@JsonKey() List<PendingAttachment> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override@JsonKey() final  bool busy;
@override@JsonKey() final  double progress;
@override@JsonKey() final  String error;
@override final  Object? problem;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentStateCopyWith<_AttachmentState> get copyWith => __$AttachmentStateCopyWithImpl<_AttachmentState>(this, _$identity);





@override
String toString() {
    return 'AttachmentState(files: $files, busy: $busy, progress: $progress, error: $error, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$AttachmentStateCopyWith<$Res> implements $AttachmentStateCopyWith<$Res> {
  factory _$AttachmentStateCopyWith(_AttachmentState value, $Res Function(_AttachmentState) _then) = __$AttachmentStateCopyWithImpl;
@override @useResult
$Res call({
 List<PendingAttachment> files, bool busy, double progress, String error, Object? problem
});




}
/// @nodoc
class __$AttachmentStateCopyWithImpl<$Res>
    implements _$AttachmentStateCopyWith<$Res> {
  __$AttachmentStateCopyWithImpl(this._self, this._then);

  final _AttachmentState _self;
  final $Res Function(_AttachmentState) _then;

/// Create a copy of AttachmentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? busy = null,Object? progress = null,Object? error = null,Object? problem = freezed,}) {
  return _then(_AttachmentState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<PendingAttachment>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,problem: freezed == problem ? _self.problem : problem ,
  ));
}


}

// dart format on
