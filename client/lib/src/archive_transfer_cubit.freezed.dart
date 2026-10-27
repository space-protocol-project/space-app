// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_transfer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchiveTransferState {

 bool get busy; bool get cancellable; bool get cancelling; bool get finished; bool get saved; int get bytes; String get status; ArchiveWorkspace? get pending; Object? get error;
/// Create a copy of ArchiveTransferState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveTransferStateCopyWith<ArchiveTransferState> get copyWith => _$ArchiveTransferStateCopyWithImpl<ArchiveTransferState>(this as ArchiveTransferState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ArchiveTransferState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveTransferState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.cancellable, _this.cancellable) || other.cancellable == _this.cancellable)&&(identical(other.cancelling, _this.cancelling) || other.cancelling == _this.cancelling)&&(identical(other.finished, _this.finished) || other.finished == _this.finished)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as ArchiveTransferState;
  return Object.hash(runtimeType,_this.busy,_this.cancellable,_this.cancelling,_this.finished,_this.saved,_this.bytes,_this.status,_this.pending,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as ArchiveTransferState;
  return 'ArchiveTransferState(busy: ${_this.busy}, cancellable: ${_this.cancellable}, cancelling: ${_this.cancelling}, finished: ${_this.finished}, saved: ${_this.saved}, bytes: ${_this.bytes}, status: ${_this.status}, pending: ${_this.pending}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ArchiveTransferStateCopyWith<$Res>  {
  factory $ArchiveTransferStateCopyWith(ArchiveTransferState value, $Res Function(ArchiveTransferState) _then) = _$ArchiveTransferStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool cancellable, bool cancelling, bool finished, bool saved, int bytes, String status, ArchiveWorkspace? pending, Object? error
});




}
/// @nodoc
class _$ArchiveTransferStateCopyWithImpl<$Res>
    implements $ArchiveTransferStateCopyWith<$Res> {
  _$ArchiveTransferStateCopyWithImpl(this._self, this._then);

  final ArchiveTransferState _self;
  final $Res Function(ArchiveTransferState) _then;

/// Create a copy of ArchiveTransferState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? cancellable = null,Object? cancelling = null,Object? finished = null,Object? saved = null,Object? bytes = null,Object? status = null,Object? pending = freezed,Object? error = freezed,}) {
  return _then(ArchiveTransferState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,cancellable: null == cancellable ? _self.cancellable : cancellable // ignore: cast_nullable_to_non_nullable
as bool,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pending: freezed == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as ArchiveWorkspace?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveTransferState].
extension ArchiveTransferStatePatterns on ArchiveTransferState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveTransferState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveTransferState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveTransferState value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveTransferState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveTransferState value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveTransferState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool cancellable,  bool cancelling,  bool finished,  bool saved,  int bytes,  String status,  ArchiveWorkspace? pending,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveTransferState() when $default != null:
return $default(_that.busy,_that.cancellable,_that.cancelling,_that.finished,_that.saved,_that.bytes,_that.status,_that.pending,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool cancellable,  bool cancelling,  bool finished,  bool saved,  int bytes,  String status,  ArchiveWorkspace? pending,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _ArchiveTransferState():
return $default(_that.busy,_that.cancellable,_that.cancelling,_that.finished,_that.saved,_that.bytes,_that.status,_that.pending,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool cancellable,  bool cancelling,  bool finished,  bool saved,  int bytes,  String status,  ArchiveWorkspace? pending,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveTransferState() when $default != null:
return $default(_that.busy,_that.cancellable,_that.cancelling,_that.finished,_that.saved,_that.bytes,_that.status,_that.pending,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ArchiveTransferState implements ArchiveTransferState {
  const _ArchiveTransferState({this.busy = false, this.cancellable = false, this.cancelling = false, this.finished = false, this.saved = false, this.bytes = 0, this.status = '', this.pending, this.error});
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool cancellable;
@override@JsonKey() final  bool cancelling;
@override@JsonKey() final  bool finished;
@override@JsonKey() final  bool saved;
@override@JsonKey() final  int bytes;
@override@JsonKey() final  String status;
@override final  ArchiveWorkspace? pending;
@override final  Object? error;

/// Create a copy of ArchiveTransferState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveTransferStateCopyWith<_ArchiveTransferState> get copyWith => __$ArchiveTransferStateCopyWithImpl<_ArchiveTransferState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveTransferState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.cancellable, cancellable) || other.cancellable == cancellable)&&(identical(other.cancelling, cancelling) || other.cancelling == cancelling)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.status, status) || other.status == status)&&(identical(other.pending, pending) || other.pending == pending)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,cancellable,cancelling,finished,saved,bytes,status,pending,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'ArchiveTransferState(busy: $busy, cancellable: $cancellable, cancelling: $cancelling, finished: $finished, saved: $saved, bytes: $bytes, status: $status, pending: $pending, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ArchiveTransferStateCopyWith<$Res> implements $ArchiveTransferStateCopyWith<$Res> {
  factory _$ArchiveTransferStateCopyWith(_ArchiveTransferState value, $Res Function(_ArchiveTransferState) _then) = __$ArchiveTransferStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool cancellable, bool cancelling, bool finished, bool saved, int bytes, String status, ArchiveWorkspace? pending, Object? error
});




}
/// @nodoc
class __$ArchiveTransferStateCopyWithImpl<$Res>
    implements _$ArchiveTransferStateCopyWith<$Res> {
  __$ArchiveTransferStateCopyWithImpl(this._self, this._then);

  final _ArchiveTransferState _self;
  final $Res Function(_ArchiveTransferState) _then;

/// Create a copy of ArchiveTransferState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? cancellable = null,Object? cancelling = null,Object? finished = null,Object? saved = null,Object? bytes = null,Object? status = null,Object? pending = freezed,Object? error = freezed,}) {
  return _then(_ArchiveTransferState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,cancellable: null == cancellable ? _self.cancellable : cancellable // ignore: cast_nullable_to_non_nullable
as bool,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pending: freezed == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as ArchiveWorkspace?,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
