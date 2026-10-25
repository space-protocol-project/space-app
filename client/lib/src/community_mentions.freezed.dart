// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_mentions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentionDraftState {

 String get text; List<CommunityMention> get mentions;
/// Create a copy of MentionDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentionDraftStateCopyWith<MentionDraftState> get copyWith => _$MentionDraftStateCopyWithImpl<MentionDraftState>(this as MentionDraftState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MentionDraftState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentionDraftState&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.mentions, _this.mentions));
}


@override
int get hashCode {
  final _this = this as MentionDraftState;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.mentions));
}

@override
String toString() {
  final _this = this as MentionDraftState;
  return 'MentionDraftState(text: ${_this.text}, mentions: ${_this.mentions})';
}


}

/// @nodoc
abstract mixin class $MentionDraftStateCopyWith<$Res>  {
  factory $MentionDraftStateCopyWith(MentionDraftState value, $Res Function(MentionDraftState) _then) = _$MentionDraftStateCopyWithImpl;
@useResult
$Res call({
 String text, List<CommunityMention> mentions
});




}
/// @nodoc
class _$MentionDraftStateCopyWithImpl<$Res>
    implements $MentionDraftStateCopyWith<$Res> {
  _$MentionDraftStateCopyWithImpl(this._self, this._then);

  final MentionDraftState _self;
  final $Res Function(MentionDraftState) _then;

/// Create a copy of MentionDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? mentions = null,}) {
  return _then(MentionDraftState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<CommunityMention>,
  ));
}

}


/// Adds pattern-matching-related methods to [MentionDraftState].
extension MentionDraftStatePatterns on MentionDraftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentionDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentionDraftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentionDraftState value)  $default,){
final _that = this;
switch (_that) {
case _MentionDraftState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentionDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _MentionDraftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<CommunityMention> mentions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentionDraftState() when $default != null:
return $default(_that.text,_that.mentions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<CommunityMention> mentions)  $default,) {final _that = this;
switch (_that) {
case _MentionDraftState():
return $default(_that.text,_that.mentions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<CommunityMention> mentions)?  $default,) {final _that = this;
switch (_that) {
case _MentionDraftState() when $default != null:
return $default(_that.text,_that.mentions);case _:
  return null;

}
}

}

/// @nodoc


class _MentionDraftState implements MentionDraftState {
  const _MentionDraftState({this.text = '',  List<CommunityMention> mentions = const []}): _mentions = mentions;
  

@override@JsonKey() final  String text;
 final  List<CommunityMention> _mentions;
@override@JsonKey() List<CommunityMention> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}


/// Create a copy of MentionDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentionDraftStateCopyWith<_MentionDraftState> get copyWith => __$MentionDraftStateCopyWithImpl<_MentionDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentionDraftState&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.mentions, _mentions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_mentions));
}

@override
String toString() {
    return 'MentionDraftState(text: $text, mentions: $mentions)';
}


}

/// @nodoc
abstract mixin class _$MentionDraftStateCopyWith<$Res> implements $MentionDraftStateCopyWith<$Res> {
  factory _$MentionDraftStateCopyWith(_MentionDraftState value, $Res Function(_MentionDraftState) _then) = __$MentionDraftStateCopyWithImpl;
@override @useResult
$Res call({
 String text, List<CommunityMention> mentions
});




}
/// @nodoc
class __$MentionDraftStateCopyWithImpl<$Res>
    implements _$MentionDraftStateCopyWith<$Res> {
  __$MentionDraftStateCopyWithImpl(this._self, this._then);

  final _MentionDraftState _self;
  final $Res Function(_MentionDraftState) _then;

/// Create a copy of MentionDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? mentions = null,}) {
  return _then(_MentionDraftState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<CommunityMention>,
  ));
}


}

/// @nodoc
mixin _$MentionPickerState {

 bool get loading; bool get failed; List<MentionCandidate> get candidates;
/// Create a copy of MentionPickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentionPickerStateCopyWith<MentionPickerState> get copyWith => _$MentionPickerStateCopyWithImpl<MentionPickerState>(this as MentionPickerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MentionPickerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentionPickerState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&const DeepCollectionEquality().equals(other.candidates, _this.candidates));
}


@override
int get hashCode {
  final _this = this as MentionPickerState;
  return Object.hash(runtimeType,_this.loading,_this.failed,const DeepCollectionEquality().hash(_this.candidates));
}

@override
String toString() {
  final _this = this as MentionPickerState;
  return 'MentionPickerState(loading: ${_this.loading}, failed: ${_this.failed}, candidates: ${_this.candidates})';
}


}

/// @nodoc
abstract mixin class $MentionPickerStateCopyWith<$Res>  {
  factory $MentionPickerStateCopyWith(MentionPickerState value, $Res Function(MentionPickerState) _then) = _$MentionPickerStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool failed, List<MentionCandidate> candidates
});




}
/// @nodoc
class _$MentionPickerStateCopyWithImpl<$Res>
    implements $MentionPickerStateCopyWith<$Res> {
  _$MentionPickerStateCopyWithImpl(this._self, this._then);

  final MentionPickerState _self;
  final $Res Function(MentionPickerState) _then;

/// Create a copy of MentionPickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? failed = null,Object? candidates = null,}) {
  return _then(MentionPickerState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<MentionCandidate>,
  ));
}

}


/// Adds pattern-matching-related methods to [MentionPickerState].
extension MentionPickerStatePatterns on MentionPickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentionPickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentionPickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentionPickerState value)  $default,){
final _that = this;
switch (_that) {
case _MentionPickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentionPickerState value)?  $default,){
final _that = this;
switch (_that) {
case _MentionPickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool failed,  List<MentionCandidate> candidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentionPickerState() when $default != null:
return $default(_that.loading,_that.failed,_that.candidates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool failed,  List<MentionCandidate> candidates)  $default,) {final _that = this;
switch (_that) {
case _MentionPickerState():
return $default(_that.loading,_that.failed,_that.candidates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool failed,  List<MentionCandidate> candidates)?  $default,) {final _that = this;
switch (_that) {
case _MentionPickerState() when $default != null:
return $default(_that.loading,_that.failed,_that.candidates);case _:
  return null;

}
}

}

/// @nodoc


class _MentionPickerState implements MentionPickerState {
  const _MentionPickerState({this.loading = false, this.failed = false,  List<MentionCandidate> candidates = const []}): _candidates = candidates;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool failed;
 final  List<MentionCandidate> _candidates;
@override@JsonKey() List<MentionCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}


/// Create a copy of MentionPickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentionPickerStateCopyWith<_MentionPickerState> get copyWith => __$MentionPickerStateCopyWithImpl<_MentionPickerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentionPickerState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other.candidates, _candidates));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,failed,const DeepCollectionEquality().hash(_candidates));
}

@override
String toString() {
    return 'MentionPickerState(loading: $loading, failed: $failed, candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$MentionPickerStateCopyWith<$Res> implements $MentionPickerStateCopyWith<$Res> {
  factory _$MentionPickerStateCopyWith(_MentionPickerState value, $Res Function(_MentionPickerState) _then) = __$MentionPickerStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool failed, List<MentionCandidate> candidates
});




}
/// @nodoc
class __$MentionPickerStateCopyWithImpl<$Res>
    implements _$MentionPickerStateCopyWith<$Res> {
  __$MentionPickerStateCopyWithImpl(this._self, this._then);

  final _MentionPickerState _self;
  final $Res Function(_MentionPickerState) _then;

/// Create a copy of MentionPickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? failed = null,Object? candidates = null,}) {
  return _then(_MentionPickerState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<MentionCandidate>,
  ));
}


}

// dart format on
