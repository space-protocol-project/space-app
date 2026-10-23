// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 bool get busy; bool get running; bool get pendingUpdate; bool get recoveryBlocked; bool get updateAvailable; String get ip; HomeNetwork? get network; HomeDiagnosis? get diagnosis; HomeDiagnosisError? get diagnosisError; bool get diagnosing; String get error; String get installedVersion; String get availableVersion; String get availableReleaseNotes; String get recoverySummary; HomePhase get phase; double get progress; double get operationProgress; Duration get elapsed; int? get downloadSecondsRemaining; HomeServerState? get server; LocalFailureCode? get failureCode; HomeSpaceReport? get spaceReport;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);





@override
String toString() {
  final _this = this as HomeState;
  return 'HomeState(busy: ${_this.busy}, running: ${_this.running}, pendingUpdate: ${_this.pendingUpdate}, recoveryBlocked: ${_this.recoveryBlocked}, updateAvailable: ${_this.updateAvailable}, ip: ${_this.ip}, network: ${_this.network}, diagnosis: ${_this.diagnosis}, diagnosisError: ${_this.diagnosisError}, diagnosing: ${_this.diagnosing}, error: ${_this.error}, installedVersion: ${_this.installedVersion}, availableVersion: ${_this.availableVersion}, availableReleaseNotes: ${_this.availableReleaseNotes}, recoverySummary: ${_this.recoverySummary}, phase: ${_this.phase}, progress: ${_this.progress}, operationProgress: ${_this.operationProgress}, elapsed: ${_this.elapsed}, downloadSecondsRemaining: ${_this.downloadSecondsRemaining}, server: ${_this.server}, failureCode: ${_this.failureCode}, spaceReport: ${_this.spaceReport})';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 bool busy, bool running, bool pendingUpdate, bool recoveryBlocked, bool updateAvailable, String ip, HomeNetwork? network, HomeDiagnosis? diagnosis, HomeDiagnosisError? diagnosisError, bool diagnosing, String error, String installedVersion, String availableVersion, String availableReleaseNotes, String recoverySummary, HomePhase phase, double progress, double operationProgress, Duration elapsed, int? downloadSecondsRemaining, HomeServerState? server, LocalFailureCode? failureCode, HomeSpaceReport? spaceReport
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? running = null,Object? pendingUpdate = null,Object? recoveryBlocked = null,Object? updateAvailable = null,Object? ip = null,Object? network = freezed,Object? diagnosis = freezed,Object? diagnosisError = freezed,Object? diagnosing = null,Object? error = null,Object? installedVersion = null,Object? availableVersion = null,Object? availableReleaseNotes = null,Object? recoverySummary = null,Object? phase = null,Object? progress = null,Object? operationProgress = null,Object? elapsed = null,Object? downloadSecondsRemaining = freezed,Object? server = freezed,Object? failureCode = freezed,Object? spaceReport = freezed,}) {
  return _then(HomeState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,pendingUpdate: null == pendingUpdate ? _self.pendingUpdate : pendingUpdate // ignore: cast_nullable_to_non_nullable
as bool,recoveryBlocked: null == recoveryBlocked ? _self.recoveryBlocked : recoveryBlocked // ignore: cast_nullable_to_non_nullable
as bool,updateAvailable: null == updateAvailable ? _self.updateAvailable : updateAvailable // ignore: cast_nullable_to_non_nullable
as bool,ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as HomeNetwork?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as HomeDiagnosis?,diagnosisError: freezed == diagnosisError ? _self.diagnosisError : diagnosisError // ignore: cast_nullable_to_non_nullable
as HomeDiagnosisError?,diagnosing: null == diagnosing ? _self.diagnosing : diagnosing // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,installedVersion: null == installedVersion ? _self.installedVersion : installedVersion // ignore: cast_nullable_to_non_nullable
as String,availableVersion: null == availableVersion ? _self.availableVersion : availableVersion // ignore: cast_nullable_to_non_nullable
as String,availableReleaseNotes: null == availableReleaseNotes ? _self.availableReleaseNotes : availableReleaseNotes // ignore: cast_nullable_to_non_nullable
as String,recoverySummary: null == recoverySummary ? _self.recoverySummary : recoverySummary // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as HomePhase,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,operationProgress: null == operationProgress ? _self.operationProgress : operationProgress // ignore: cast_nullable_to_non_nullable
as double,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,downloadSecondsRemaining: freezed == downloadSecondsRemaining ? _self.downloadSecondsRemaining : downloadSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as HomeServerState?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as LocalFailureCode?,spaceReport: freezed == spaceReport ? _self.spaceReport : spaceReport // ignore: cast_nullable_to_non_nullable
as HomeSpaceReport?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool busy,  bool running,  bool pendingUpdate,  bool recoveryBlocked,  bool updateAvailable,  String ip,  HomeNetwork? network,  HomeDiagnosis? diagnosis,  HomeDiagnosisError? diagnosisError,  bool diagnosing,  String error,  String installedVersion,  String availableVersion,  String availableReleaseNotes,  String recoverySummary,  HomePhase phase,  double progress,  double operationProgress,  Duration elapsed,  int? downloadSecondsRemaining,  HomeServerState? server,  LocalFailureCode? failureCode,  HomeSpaceReport? spaceReport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.busy,_that.running,_that.pendingUpdate,_that.recoveryBlocked,_that.updateAvailable,_that.ip,_that.network,_that.diagnosis,_that.diagnosisError,_that.diagnosing,_that.error,_that.installedVersion,_that.availableVersion,_that.availableReleaseNotes,_that.recoverySummary,_that.phase,_that.progress,_that.operationProgress,_that.elapsed,_that.downloadSecondsRemaining,_that.server,_that.failureCode,_that.spaceReport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool busy,  bool running,  bool pendingUpdate,  bool recoveryBlocked,  bool updateAvailable,  String ip,  HomeNetwork? network,  HomeDiagnosis? diagnosis,  HomeDiagnosisError? diagnosisError,  bool diagnosing,  String error,  String installedVersion,  String availableVersion,  String availableReleaseNotes,  String recoverySummary,  HomePhase phase,  double progress,  double operationProgress,  Duration elapsed,  int? downloadSecondsRemaining,  HomeServerState? server,  LocalFailureCode? failureCode,  HomeSpaceReport? spaceReport)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.busy,_that.running,_that.pendingUpdate,_that.recoveryBlocked,_that.updateAvailable,_that.ip,_that.network,_that.diagnosis,_that.diagnosisError,_that.diagnosing,_that.error,_that.installedVersion,_that.availableVersion,_that.availableReleaseNotes,_that.recoverySummary,_that.phase,_that.progress,_that.operationProgress,_that.elapsed,_that.downloadSecondsRemaining,_that.server,_that.failureCode,_that.spaceReport);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool busy,  bool running,  bool pendingUpdate,  bool recoveryBlocked,  bool updateAvailable,  String ip,  HomeNetwork? network,  HomeDiagnosis? diagnosis,  HomeDiagnosisError? diagnosisError,  bool diagnosing,  String error,  String installedVersion,  String availableVersion,  String availableReleaseNotes,  String recoverySummary,  HomePhase phase,  double progress,  double operationProgress,  Duration elapsed,  int? downloadSecondsRemaining,  HomeServerState? server,  LocalFailureCode? failureCode,  HomeSpaceReport? spaceReport)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.busy,_that.running,_that.pendingUpdate,_that.recoveryBlocked,_that.updateAvailable,_that.ip,_that.network,_that.diagnosis,_that.diagnosisError,_that.diagnosing,_that.error,_that.installedVersion,_that.availableVersion,_that.availableReleaseNotes,_that.recoverySummary,_that.phase,_that.progress,_that.operationProgress,_that.elapsed,_that.downloadSecondsRemaining,_that.server,_that.failureCode,_that.spaceReport);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.busy = false, this.running = false, this.pendingUpdate = false, this.recoveryBlocked = false, this.updateAvailable = false, this.ip = '', this.network, this.diagnosis, this.diagnosisError, this.diagnosing = false, this.error = '', this.installedVersion = '', this.availableVersion = '', this.availableReleaseNotes = '', this.recoverySummary = '', this.phase = HomePhase.idle, this.progress = 0, this.operationProgress = .01, this.elapsed = Duration.zero, this.downloadSecondsRemaining, this.server, this.failureCode, this.spaceReport}): super._();
  

@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool running;
@override@JsonKey() final  bool pendingUpdate;
@override@JsonKey() final  bool recoveryBlocked;
@override@JsonKey() final  bool updateAvailable;
@override@JsonKey() final  String ip;
@override final  HomeNetwork? network;
@override final  HomeDiagnosis? diagnosis;
@override final  HomeDiagnosisError? diagnosisError;
@override@JsonKey() final  bool diagnosing;
@override@JsonKey() final  String error;
@override@JsonKey() final  String installedVersion;
@override@JsonKey() final  String availableVersion;
@override@JsonKey() final  String availableReleaseNotes;
@override@JsonKey() final  String recoverySummary;
@override@JsonKey() final  HomePhase phase;
@override@JsonKey() final  double progress;
@override@JsonKey() final  double operationProgress;
@override@JsonKey() final  Duration elapsed;
@override final  int? downloadSecondsRemaining;
@override final  HomeServerState? server;
@override final  LocalFailureCode? failureCode;
@override final  HomeSpaceReport? spaceReport;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);





@override
String toString() {
    return 'HomeState(busy: $busy, running: $running, pendingUpdate: $pendingUpdate, recoveryBlocked: $recoveryBlocked, updateAvailable: $updateAvailable, ip: $ip, network: $network, diagnosis: $diagnosis, diagnosisError: $diagnosisError, diagnosing: $diagnosing, error: $error, installedVersion: $installedVersion, availableVersion: $availableVersion, availableReleaseNotes: $availableReleaseNotes, recoverySummary: $recoverySummary, phase: $phase, progress: $progress, operationProgress: $operationProgress, elapsed: $elapsed, downloadSecondsRemaining: $downloadSecondsRemaining, server: $server, failureCode: $failureCode, spaceReport: $spaceReport)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool busy, bool running, bool pendingUpdate, bool recoveryBlocked, bool updateAvailable, String ip, HomeNetwork? network, HomeDiagnosis? diagnosis, HomeDiagnosisError? diagnosisError, bool diagnosing, String error, String installedVersion, String availableVersion, String availableReleaseNotes, String recoverySummary, HomePhase phase, double progress, double operationProgress, Duration elapsed, int? downloadSecondsRemaining, HomeServerState? server, LocalFailureCode? failureCode, HomeSpaceReport? spaceReport
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? running = null,Object? pendingUpdate = null,Object? recoveryBlocked = null,Object? updateAvailable = null,Object? ip = null,Object? network = freezed,Object? diagnosis = freezed,Object? diagnosisError = freezed,Object? diagnosing = null,Object? error = null,Object? installedVersion = null,Object? availableVersion = null,Object? availableReleaseNotes = null,Object? recoverySummary = null,Object? phase = null,Object? progress = null,Object? operationProgress = null,Object? elapsed = null,Object? downloadSecondsRemaining = freezed,Object? server = freezed,Object? failureCode = freezed,Object? spaceReport = freezed,}) {
  return _then(_HomeState(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,pendingUpdate: null == pendingUpdate ? _self.pendingUpdate : pendingUpdate // ignore: cast_nullable_to_non_nullable
as bool,recoveryBlocked: null == recoveryBlocked ? _self.recoveryBlocked : recoveryBlocked // ignore: cast_nullable_to_non_nullable
as bool,updateAvailable: null == updateAvailable ? _self.updateAvailable : updateAvailable // ignore: cast_nullable_to_non_nullable
as bool,ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as HomeNetwork?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as HomeDiagnosis?,diagnosisError: freezed == diagnosisError ? _self.diagnosisError : diagnosisError // ignore: cast_nullable_to_non_nullable
as HomeDiagnosisError?,diagnosing: null == diagnosing ? _self.diagnosing : diagnosing // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,installedVersion: null == installedVersion ? _self.installedVersion : installedVersion // ignore: cast_nullable_to_non_nullable
as String,availableVersion: null == availableVersion ? _self.availableVersion : availableVersion // ignore: cast_nullable_to_non_nullable
as String,availableReleaseNotes: null == availableReleaseNotes ? _self.availableReleaseNotes : availableReleaseNotes // ignore: cast_nullable_to_non_nullable
as String,recoverySummary: null == recoverySummary ? _self.recoverySummary : recoverySummary // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as HomePhase,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,operationProgress: null == operationProgress ? _self.operationProgress : operationProgress // ignore: cast_nullable_to_non_nullable
as double,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,downloadSecondsRemaining: freezed == downloadSecondsRemaining ? _self.downloadSecondsRemaining : downloadSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as HomeServerState?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as LocalFailureCode?,spaceReport: freezed == spaceReport ? _self.spaceReport : spaceReport // ignore: cast_nullable_to_non_nullable
as HomeSpaceReport?,
  ));
}


}

// dart format on
