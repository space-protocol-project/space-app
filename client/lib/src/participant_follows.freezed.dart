// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_follows.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FollowAuthorsState {

 Map<String, bool> get entries; int get revision; bool get busy; Object? get error;
/// Create a copy of FollowAuthorsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowAuthorsStateCopyWith<FollowAuthorsState> get copyWith => _$FollowAuthorsStateCopyWithImpl<FollowAuthorsState>(this as FollowAuthorsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FollowAuthorsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowAuthorsState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as FollowAuthorsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.revision,_this.busy,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as FollowAuthorsState;
  return 'FollowAuthorsState(entries: ${_this.entries}, revision: ${_this.revision}, busy: ${_this.busy}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $FollowAuthorsStateCopyWith<$Res>  {
  factory $FollowAuthorsStateCopyWith(FollowAuthorsState value, $Res Function(FollowAuthorsState) _then) = _$FollowAuthorsStateCopyWithImpl;
@useResult
$Res call({
 Map<String, bool> entries, int revision, bool busy, Object? error
});




}
/// @nodoc
class _$FollowAuthorsStateCopyWithImpl<$Res>
    implements $FollowAuthorsStateCopyWith<$Res> {
  _$FollowAuthorsStateCopyWithImpl(this._self, this._then);

  final FollowAuthorsState _self;
  final $Res Function(FollowAuthorsState) _then;

/// Create a copy of FollowAuthorsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? revision = null,Object? busy = null,Object? error = freezed,}) {
  return _then(FollowAuthorsState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowAuthorsState].
extension FollowAuthorsStatePatterns on FollowAuthorsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowAuthorsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowAuthorsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowAuthorsState value)  $default,){
final _that = this;
switch (_that) {
case _FollowAuthorsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowAuthorsState value)?  $default,){
final _that = this;
switch (_that) {
case _FollowAuthorsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, bool> entries,  int revision,  bool busy,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowAuthorsState() when $default != null:
return $default(_that.entries,_that.revision,_that.busy,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, bool> entries,  int revision,  bool busy,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _FollowAuthorsState():
return $default(_that.entries,_that.revision,_that.busy,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, bool> entries,  int revision,  bool busy,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _FollowAuthorsState() when $default != null:
return $default(_that.entries,_that.revision,_that.busy,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FollowAuthorsState implements FollowAuthorsState {
  const _FollowAuthorsState({ Map<String, bool> entries = const {}, this.revision = 0, this.busy = false, this.error}): _entries = entries;
  

 final  Map<String, bool> _entries;
@override@JsonKey() Map<String, bool> get entries {
  if (_entries is EqualUnmodifiableMapView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_entries);
}

@override@JsonKey() final  int revision;
@override@JsonKey() final  bool busy;
@override final  Object? error;

/// Create a copy of FollowAuthorsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowAuthorsStateCopyWith<_FollowAuthorsState> get copyWith => __$FollowAuthorsStateCopyWithImpl<_FollowAuthorsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowAuthorsState&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.busy, busy) || other.busy == busy)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),revision,busy,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'FollowAuthorsState(entries: $entries, revision: $revision, busy: $busy, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FollowAuthorsStateCopyWith<$Res> implements $FollowAuthorsStateCopyWith<$Res> {
  factory _$FollowAuthorsStateCopyWith(_FollowAuthorsState value, $Res Function(_FollowAuthorsState) _then) = __$FollowAuthorsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, bool> entries, int revision, bool busy, Object? error
});




}
/// @nodoc
class __$FollowAuthorsStateCopyWithImpl<$Res>
    implements _$FollowAuthorsStateCopyWith<$Res> {
  __$FollowAuthorsStateCopyWithImpl(this._self, this._then);

  final _FollowAuthorsState _self;
  final $Res Function(_FollowAuthorsState) _then;

/// Create a copy of FollowAuthorsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? revision = null,Object? busy = null,Object? error = freezed,}) {
  return _then(_FollowAuthorsState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

/// @nodoc
mixin _$FollowTimelineState {

 List<PersonalFeedEntry> get entries; List<FollowingParticipant> get participants; String get next; int get revision; bool get loading; bool get revoked; bool get capped; Object? get error;
/// Create a copy of FollowTimelineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowTimelineStateCopyWith<FollowTimelineState> get copyWith => _$FollowTimelineStateCopyWithImpl<FollowTimelineState>(this as FollowTimelineState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FollowTimelineState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowTimelineState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.revoked, _this.revoked) || other.revoked == _this.revoked)&&(identical(other.capped, _this.capped) || other.capped == _this.capped)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as FollowTimelineState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),const DeepCollectionEquality().hash(_this.participants),_this.next,_this.revision,_this.loading,_this.revoked,_this.capped,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as FollowTimelineState;
  return 'FollowTimelineState(entries: ${_this.entries}, participants: ${_this.participants}, next: ${_this.next}, revision: ${_this.revision}, loading: ${_this.loading}, revoked: ${_this.revoked}, capped: ${_this.capped}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $FollowTimelineStateCopyWith<$Res>  {
  factory $FollowTimelineStateCopyWith(FollowTimelineState value, $Res Function(FollowTimelineState) _then) = _$FollowTimelineStateCopyWithImpl;
@useResult
$Res call({
 List<PersonalFeedEntry> entries, List<FollowingParticipant> participants, String next, int revision, bool loading, bool revoked, bool capped, Object? error
});




}
/// @nodoc
class _$FollowTimelineStateCopyWithImpl<$Res>
    implements $FollowTimelineStateCopyWith<$Res> {
  _$FollowTimelineStateCopyWithImpl(this._self, this._then);

  final FollowTimelineState _self;
  final $Res Function(FollowTimelineState) _then;

/// Create a copy of FollowTimelineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? participants = null,Object? next = null,Object? revision = null,Object? loading = null,Object? revoked = null,Object? capped = null,Object? error = freezed,}) {
  return _then(FollowTimelineState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<PersonalFeedEntry>,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<FollowingParticipant>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,capped: null == capped ? _self.capped : capped // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowTimelineState].
extension FollowTimelineStatePatterns on FollowTimelineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowTimelineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowTimelineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowTimelineState value)  $default,){
final _that = this;
switch (_that) {
case _FollowTimelineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowTimelineState value)?  $default,){
final _that = this;
switch (_that) {
case _FollowTimelineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PersonalFeedEntry> entries,  List<FollowingParticipant> participants,  String next,  int revision,  bool loading,  bool revoked,  bool capped,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowTimelineState() when $default != null:
return $default(_that.entries,_that.participants,_that.next,_that.revision,_that.loading,_that.revoked,_that.capped,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PersonalFeedEntry> entries,  List<FollowingParticipant> participants,  String next,  int revision,  bool loading,  bool revoked,  bool capped,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _FollowTimelineState():
return $default(_that.entries,_that.participants,_that.next,_that.revision,_that.loading,_that.revoked,_that.capped,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PersonalFeedEntry> entries,  List<FollowingParticipant> participants,  String next,  int revision,  bool loading,  bool revoked,  bool capped,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _FollowTimelineState() when $default != null:
return $default(_that.entries,_that.participants,_that.next,_that.revision,_that.loading,_that.revoked,_that.capped,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FollowTimelineState implements FollowTimelineState {
  const _FollowTimelineState({ List<PersonalFeedEntry> entries = const [],  List<FollowingParticipant> participants = const [], this.next = '', this.revision = 0, this.loading = false, this.revoked = false, this.capped = false, this.error}): _entries = entries,_participants = participants;
  

 final  List<PersonalFeedEntry> _entries;
@override@JsonKey() List<PersonalFeedEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  List<FollowingParticipant> _participants;
@override@JsonKey() List<FollowingParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  String next;
@override@JsonKey() final  int revision;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool revoked;
@override@JsonKey() final  bool capped;
@override final  Object? error;

/// Create a copy of FollowTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowTimelineStateCopyWith<_FollowTimelineState> get copyWith => __$FollowTimelineStateCopyWithImpl<_FollowTimelineState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowTimelineState&&const DeepCollectionEquality().equals(other.entries, _entries)&&const DeepCollectionEquality().equals(other.participants, _participants)&&(identical(other.next, next) || other.next == next)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.revoked, revoked) || other.revoked == revoked)&&(identical(other.capped, capped) || other.capped == capped)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_participants),next,revision,loading,revoked,capped,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'FollowTimelineState(entries: $entries, participants: $participants, next: $next, revision: $revision, loading: $loading, revoked: $revoked, capped: $capped, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FollowTimelineStateCopyWith<$Res> implements $FollowTimelineStateCopyWith<$Res> {
  factory _$FollowTimelineStateCopyWith(_FollowTimelineState value, $Res Function(_FollowTimelineState) _then) = __$FollowTimelineStateCopyWithImpl;
@override @useResult
$Res call({
 List<PersonalFeedEntry> entries, List<FollowingParticipant> participants, String next, int revision, bool loading, bool revoked, bool capped, Object? error
});




}
/// @nodoc
class __$FollowTimelineStateCopyWithImpl<$Res>
    implements _$FollowTimelineStateCopyWith<$Res> {
  __$FollowTimelineStateCopyWithImpl(this._self, this._then);

  final _FollowTimelineState _self;
  final $Res Function(_FollowTimelineState) _then;

/// Create a copy of FollowTimelineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? participants = null,Object? next = null,Object? revision = null,Object? loading = null,Object? revoked = null,Object? capped = null,Object? error = freezed,}) {
  return _then(_FollowTimelineState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<PersonalFeedEntry>,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<FollowingParticipant>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,revoked: null == revoked ? _self.revoked : revoked // ignore: cast_nullable_to_non_nullable
as bool,capped: null == capped ? _self.capped : capped // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
