// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_management.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedManagementState {

 bool get busy; bool get resolved; int get revision; int get after; List<FeedAccessRule> get rules; List<FeedReport> get reports; List<FeedModerationEvent> get log; Object? get error;
/// Create a copy of FeedManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedManagementStateCopyWith<FeedManagementState> get copyWith => _$FeedManagementStateCopyWithImpl<FeedManagementState>(this as FeedManagementState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedManagementState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedManagementState&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.resolved, _this.resolved) || other.resolved == _this.resolved)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.after, _this.after) || other.after == _this.after)&&const DeepCollectionEquality().equals(other.rules, _this.rules)&&const DeepCollectionEquality().equals(other.reports, _this.reports)&&const DeepCollectionEquality().equals(other.log, _this.log)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as FeedManagementState;
  return Object.hash(runtimeType,_this.busy,_this.resolved,_this.revision,_this.after,const DeepCollectionEquality().hash(_this.rules),const DeepCollectionEquality().hash(_this.reports),const DeepCollectionEquality().hash(_this.log),const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as FeedManagementState;
  return 'FeedManagementState(busy: ${_this.busy}, resolved: ${_this.resolved}, revision: ${_this.revision}, after: ${_this.after}, rules: ${_this.rules}, reports: ${_this.reports}, log: ${_this.log}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $FeedManagementStateCopyWith<$Res>  {
  factory $FeedManagementStateCopyWith(FeedManagementState value, $Res Function(FeedManagementState) _then) = _$FeedManagementStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool resolved, int revision, int after, List<FeedAccessRule> rules, List<FeedReport> reports, List<FeedModerationEvent> log, Object? error
});




}
/// @nodoc
class _$FeedManagementStateCopyWithImpl<$Res>
    implements $FeedManagementStateCopyWith<$Res> {
  _$FeedManagementStateCopyWithImpl(this._self, this._then);

  final FeedManagementState _self;
  final $Res Function(FeedManagementState) _then;

/// Create a copy of FeedManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? resolved = null,Object? revision = null,Object? after = null,Object? rules = null,Object? reports = null,Object? log = null,Object? error = freezed,}) {
  return _then(FeedManagementState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<FeedAccessRule>,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<FeedReport>,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as List<FeedModerationEvent>,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedManagementState].
extension FeedManagementStatePatterns on FeedManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedManagementState value)  $default,){
final _that = this;
switch (_that) {
case _FeedManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool resolved,  int revision,  int after,  List<FeedAccessRule> rules,  List<FeedReport> reports,  List<FeedModerationEvent> log,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedManagementState() when $default != null:
return $default(_that.busy,_that.resolved,_that.revision,_that.after,_that.rules,_that.reports,_that.log,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool resolved,  int revision,  int after,  List<FeedAccessRule> rules,  List<FeedReport> reports,  List<FeedModerationEvent> log,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _FeedManagementState():
return $default(_that.busy,_that.resolved,_that.revision,_that.after,_that.rules,_that.reports,_that.log,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool resolved,  int revision,  int after,  List<FeedAccessRule> rules,  List<FeedReport> reports,  List<FeedModerationEvent> log,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _FeedManagementState() when $default != null:
return $default(_that.busy,_that.resolved,_that.revision,_that.after,_that.rules,_that.reports,_that.log,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FeedManagementState implements FeedManagementState {
  const _FeedManagementState({this.busy = false, this.resolved = false, this.revision = 0, this.after = 0,  List<FeedAccessRule> rules = const [],  List<FeedReport> reports = const [],  List<FeedModerationEvent> log = const [], this.error}): _rules = rules,_reports = reports,_log = log;
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool resolved;
@override@JsonKey() final  int revision;
@override@JsonKey() final  int after;
 final  List<FeedAccessRule> _rules;
@override@JsonKey() List<FeedAccessRule> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

 final  List<FeedReport> _reports;
@override@JsonKey() List<FeedReport> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}

 final  List<FeedModerationEvent> _log;
@override@JsonKey() List<FeedModerationEvent> get log {
  if (_log is EqualUnmodifiableListView) return _log;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_log);
}

@override final  Object? error;

/// Create a copy of FeedManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedManagementStateCopyWith<_FeedManagementState> get copyWith => __$FeedManagementStateCopyWithImpl<_FeedManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedManagementState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.after, after) || other.after == after)&&const DeepCollectionEquality().equals(other.rules, _rules)&&const DeepCollectionEquality().equals(other.reports, _reports)&&const DeepCollectionEquality().equals(other.log, _log)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,busy,resolved,revision,after,const DeepCollectionEquality().hash(_rules),const DeepCollectionEquality().hash(_reports),const DeepCollectionEquality().hash(_log),const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'FeedManagementState(busy: $busy, resolved: $resolved, revision: $revision, after: $after, rules: $rules, reports: $reports, log: $log, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FeedManagementStateCopyWith<$Res> implements $FeedManagementStateCopyWith<$Res> {
  factory _$FeedManagementStateCopyWith(_FeedManagementState value, $Res Function(_FeedManagementState) _then) = __$FeedManagementStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool resolved, int revision, int after, List<FeedAccessRule> rules, List<FeedReport> reports, List<FeedModerationEvent> log, Object? error
});




}
/// @nodoc
class __$FeedManagementStateCopyWithImpl<$Res>
    implements _$FeedManagementStateCopyWith<$Res> {
  __$FeedManagementStateCopyWithImpl(this._self, this._then);

  final _FeedManagementState _self;
  final $Res Function(_FeedManagementState) _then;

/// Create a copy of FeedManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? resolved = null,Object? revision = null,Object? after = null,Object? rules = null,Object? reports = null,Object? log = null,Object? error = freezed,}) {
  return _then(_FeedManagementState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<FeedAccessRule>,reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<FeedReport>,log: null == log ? _self._log : log // ignore: cast_nullable_to_non_nullable
as List<FeedModerationEvent>,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
