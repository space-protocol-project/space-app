// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairingState implements DiagnosticableTreeMixin {

 bool get busy; bool get verified; String get code; String get verification; Uint8List? get qr; PairingIssue? get issue;
/// Create a copy of PairingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingStateCopyWith<PairingState> get copyWith => _$PairingStateCopyWithImpl<PairingState>(this as PairingState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as PairingState;
  properties
    ..add(DiagnosticsProperty('type', 'PairingState'))
    ..add(DiagnosticsProperty('busy', _this.busy))..add(DiagnosticsProperty('verified', _this.verified))..add(DiagnosticsProperty('code', _this.code))..add(DiagnosticsProperty('verification', _this.verification))..add(DiagnosticsProperty('qr', _this.qr))..add(DiagnosticsProperty('issue', _this.issue));
}

@override
bool operator ==(Object other) {
  final _this = this as PairingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.verified, _this.verified) || other.verified == _this.verified)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.verification, _this.verification) || other.verification == _this.verification)&&const DeepCollectionEquality().equals(other.qr, _this.qr)&&(identical(other.issue, _this.issue) || other.issue == _this.issue));
}


@override
int get hashCode {
  final _this = this as PairingState;
  return Object.hash(runtimeType,_this.busy,_this.verified,_this.code,_this.verification,const DeepCollectionEquality().hash(_this.qr),_this.issue);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as PairingState;
  return 'PairingState(busy: ${_this.busy}, verified: ${_this.verified}, code: ${_this.code}, verification: ${_this.verification}, qr: ${_this.qr}, issue: ${_this.issue})';
}


}

/// @nodoc
abstract mixin class $PairingStateCopyWith<$Res>  {
  factory $PairingStateCopyWith(PairingState value, $Res Function(PairingState) _then) = _$PairingStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool verified, String code, String verification, Uint8List? qr, PairingIssue? issue
});




}
/// @nodoc
class _$PairingStateCopyWithImpl<$Res>
    implements $PairingStateCopyWith<$Res> {
  _$PairingStateCopyWithImpl(this._self, this._then);

  final PairingState _self;
  final $Res Function(PairingState) _then;

/// Create a copy of PairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? verified = null,Object? code = null,Object? verification = null,Object? qr = freezed,Object? issue = freezed,}) {
  return _then(PairingState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as String,qr: freezed == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as Uint8List?,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as PairingIssue?,
  ));
}

}


/// Adds pattern-matching-related methods to [PairingState].
extension PairingStatePatterns on PairingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingState value)  $default,){
final _that = this;
switch (_that) {
case _PairingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingState value)?  $default,){
final _that = this;
switch (_that) {
case _PairingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool verified,  String code,  String verification,  Uint8List? qr,  PairingIssue? issue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingState() when $default != null:
return $default(_that.busy,_that.verified,_that.code,_that.verification,_that.qr,_that.issue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool verified,  String code,  String verification,  Uint8List? qr,  PairingIssue? issue)  $default,) {final _that = this;
switch (_that) {
case _PairingState():
return $default(_that.busy,_that.verified,_that.code,_that.verification,_that.qr,_that.issue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool verified,  String code,  String verification,  Uint8List? qr,  PairingIssue? issue)?  $default,) {final _that = this;
switch (_that) {
case _PairingState() when $default != null:
return $default(_that.busy,_that.verified,_that.code,_that.verification,_that.qr,_that.issue);case _:
  return null;

}
}

}

/// @nodoc


class _PairingState with DiagnosticableTreeMixin implements PairingState {
  const _PairingState({this.busy = false, this.verified = false, this.code = '', this.verification = '', this.qr, this.issue});
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool verified;
@override@JsonKey() final  String code;
@override@JsonKey() final  String verification;
@override final  Uint8List? qr;
@override final  PairingIssue? issue;

/// Create a copy of PairingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingStateCopyWith<_PairingState> get copyWith => __$PairingStateCopyWithImpl<_PairingState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'PairingState'))
    ..add(DiagnosticsProperty('busy', busy))..add(DiagnosticsProperty('verified', verified))..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('verification', verification))..add(DiagnosticsProperty('qr', qr))..add(DiagnosticsProperty('issue', issue));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.code, code) || other.code == code)&&(identical(other.verification, verification) || other.verification == verification)&&const DeepCollectionEquality().equals(other.qr, qr)&&(identical(other.issue, issue) || other.issue == issue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,verified,code,verification,const DeepCollectionEquality().hash(qr),issue);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'PairingState(busy: $busy, verified: $verified, code: $code, verification: $verification, qr: $qr, issue: $issue)';
}


}

/// @nodoc
abstract mixin class _$PairingStateCopyWith<$Res> implements $PairingStateCopyWith<$Res> {
  factory _$PairingStateCopyWith(_PairingState value, $Res Function(_PairingState) _then) = __$PairingStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool verified, String code, String verification, Uint8List? qr, PairingIssue? issue
});




}
/// @nodoc
class __$PairingStateCopyWithImpl<$Res>
    implements _$PairingStateCopyWith<$Res> {
  __$PairingStateCopyWithImpl(this._self, this._then);

  final _PairingState _self;
  final $Res Function(_PairingState) _then;

/// Create a copy of PairingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? verified = null,Object? code = null,Object? verification = null,Object? qr = freezed,Object? issue = freezed,}) {
  return _then(_PairingState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as String,qr: freezed == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as Uint8List?,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as PairingIssue?,
  ));
}


}

// dart format on
