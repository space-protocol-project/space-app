// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {

 bool get loading; bool get busy; bool get supported; List<Channel> get sections; Channel? get section; List<FeedPost> get posts; FeedPost? get post; List<FeedComment> get comments; int get before; int get after; FeedPermissions? get permissions; Object? get error;
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStateCopyWith<FeedState> get copyWith => _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.supported, _this.supported) || other.supported == _this.supported)&&const DeepCollectionEquality().equals(other.sections, _this.sections)&&(identical(other.section, _this.section) || other.section == _this.section)&&const DeepCollectionEquality().equals(other.posts, _this.posts)&&(identical(other.post, _this.post) || other.post == _this.post)&&const DeepCollectionEquality().equals(other.comments, _this.comments)&&(identical(other.before, _this.before) || other.before == _this.before)&&(identical(other.after, _this.after) || other.after == _this.after)&&(identical(other.permissions, _this.permissions) || other.permissions == _this.permissions)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as FeedState;
  return Object.hash(runtimeType,_this.loading,_this.busy,_this.supported,const DeepCollectionEquality().hash(_this.sections),_this.section,const DeepCollectionEquality().hash(_this.posts),_this.post,const DeepCollectionEquality().hash(_this.comments),_this.before,_this.after,_this.permissions,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as FeedState;
  return 'FeedState(loading: ${_this.loading}, busy: ${_this.busy}, supported: ${_this.supported}, sections: ${_this.sections}, section: ${_this.section}, posts: ${_this.posts}, post: ${_this.post}, comments: ${_this.comments}, before: ${_this.before}, after: ${_this.after}, permissions: ${_this.permissions}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res>  {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) = _$FeedStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool busy, bool supported, List<Channel> sections, Channel? section, List<FeedPost> posts, FeedPost? post, List<FeedComment> comments, int before, int after, FeedPermissions? permissions, Object? error
});




}
/// @nodoc
class _$FeedStateCopyWithImpl<$Res>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? busy = null,Object? supported = null,Object? sections = null,Object? section = freezed,Object? posts = null,Object? post = freezed,Object? comments = null,Object? before = null,Object? after = null,Object? permissions = freezed,Object? error = freezed,}) {
  return _then(FeedState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<Channel>,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as Channel?,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<FeedPost>,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as FeedPost?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<FeedComment>,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as int,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as FeedPermissions?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedState value)  $default,){
final _that = this;
switch (_that) {
case _FeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool busy,  bool supported,  List<Channel> sections,  Channel? section,  List<FeedPost> posts,  FeedPost? post,  List<FeedComment> comments,  int before,  int after,  FeedPermissions? permissions,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.loading,_that.busy,_that.supported,_that.sections,_that.section,_that.posts,_that.post,_that.comments,_that.before,_that.after,_that.permissions,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool busy,  bool supported,  List<Channel> sections,  Channel? section,  List<FeedPost> posts,  FeedPost? post,  List<FeedComment> comments,  int before,  int after,  FeedPermissions? permissions,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _FeedState():
return $default(_that.loading,_that.busy,_that.supported,_that.sections,_that.section,_that.posts,_that.post,_that.comments,_that.before,_that.after,_that.permissions,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool busy,  bool supported,  List<Channel> sections,  Channel? section,  List<FeedPost> posts,  FeedPost? post,  List<FeedComment> comments,  int before,  int after,  FeedPermissions? permissions,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.loading,_that.busy,_that.supported,_that.sections,_that.section,_that.posts,_that.post,_that.comments,_that.before,_that.after,_that.permissions,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FeedState implements FeedState {
  const _FeedState({this.loading = false, this.busy = false, this.supported = false,  List<Channel> sections = const [], this.section,  List<FeedPost> posts = const [], this.post,  List<FeedComment> comments = const [], this.before = 0, this.after = 0, this.permissions, this.error}): _sections = sections,_posts = posts,_comments = comments;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool supported;
 final  List<Channel> _sections;
@override@JsonKey() List<Channel> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  Channel? section;
 final  List<FeedPost> _posts;
@override@JsonKey() List<FeedPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override final  FeedPost? post;
 final  List<FeedComment> _comments;
@override@JsonKey() List<FeedComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey() final  int before;
@override@JsonKey() final  int after;
@override final  FeedPermissions? permissions;
@override final  Object? error;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStateCopyWith<_FeedState> get copyWith => __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.supported, supported) || other.supported == supported)&&const DeepCollectionEquality().equals(other.sections, _sections)&&(identical(other.section, section) || other.section == section)&&const DeepCollectionEquality().equals(other.posts, _posts)&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other.comments, _comments)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,busy,supported,const DeepCollectionEquality().hash(_sections),section,const DeepCollectionEquality().hash(_posts),post,const DeepCollectionEquality().hash(_comments),before,after,permissions,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'FeedState(loading: $loading, busy: $busy, supported: $supported, sections: $sections, section: $section, posts: $posts, post: $post, comments: $comments, before: $before, after: $after, permissions: $permissions, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(_FeedState value, $Res Function(_FeedState) _then) = __$FeedStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool busy, bool supported, List<Channel> sections, Channel? section, List<FeedPost> posts, FeedPost? post, List<FeedComment> comments, int before, int after, FeedPermissions? permissions, Object? error
});




}
/// @nodoc
class __$FeedStateCopyWithImpl<$Res>
    implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? busy = null,Object? supported = null,Object? sections = null,Object? section = freezed,Object? posts = null,Object? post = freezed,Object? comments = null,Object? before = null,Object? after = null,Object? permissions = freezed,Object? error = freezed,}) {
  return _then(_FeedState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<Channel>,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as Channel?,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<FeedPost>,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as FeedPost?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<FeedComment>,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as int,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as FeedPermissions?,error: freezed == error ? _self.error : error ,
  ));
}


}

/// @nodoc
mixin _$FeedDraftState {

 String get text; String get key; String get payload; bool get busy; bool get failed;
/// Create a copy of FeedDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedDraftStateCopyWith<FeedDraftState> get copyWith => _$FeedDraftStateCopyWithImpl<FeedDraftState>(this as FeedDraftState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedDraftState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedDraftState&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.payload, _this.payload) || other.payload == _this.payload)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.failed, _this.failed) || other.failed == _this.failed));
}


@override
int get hashCode {
  final _this = this as FeedDraftState;
  return Object.hash(runtimeType,_this.text,_this.key,_this.payload,_this.busy,_this.failed);
}

@override
String toString() {
  final _this = this as FeedDraftState;
  return 'FeedDraftState(text: ${_this.text}, key: ${_this.key}, payload: ${_this.payload}, busy: ${_this.busy}, failed: ${_this.failed})';
}


}

/// @nodoc
abstract mixin class $FeedDraftStateCopyWith<$Res>  {
  factory $FeedDraftStateCopyWith(FeedDraftState value, $Res Function(FeedDraftState) _then) = _$FeedDraftStateCopyWithImpl;
@useResult
$Res call({
 String text, String key, String payload, bool busy, bool failed
});




}
/// @nodoc
class _$FeedDraftStateCopyWithImpl<$Res>
    implements $FeedDraftStateCopyWith<$Res> {
  _$FeedDraftStateCopyWithImpl(this._self, this._then);

  final FeedDraftState _self;
  final $Res Function(FeedDraftState) _then;

/// Create a copy of FeedDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? key = null,Object? payload = null,Object? busy = null,Object? failed = null,}) {
  return _then(FeedDraftState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedDraftState].
extension FeedDraftStatePatterns on FeedDraftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedDraftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedDraftState value)  $default,){
final _that = this;
switch (_that) {
case _FeedDraftState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedDraftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String key,  String payload,  bool busy,  bool failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedDraftState() when $default != null:
return $default(_that.text,_that.key,_that.payload,_that.busy,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String key,  String payload,  bool busy,  bool failed)  $default,) {final _that = this;
switch (_that) {
case _FeedDraftState():
return $default(_that.text,_that.key,_that.payload,_that.busy,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String key,  String payload,  bool busy,  bool failed)?  $default,) {final _that = this;
switch (_that) {
case _FeedDraftState() when $default != null:
return $default(_that.text,_that.key,_that.payload,_that.busy,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _FeedDraftState implements FeedDraftState {
  const _FeedDraftState({this.text = '', this.key = '', this.payload = '', this.busy = false, this.failed = false});
  

@override@JsonKey() final  String text;
@override@JsonKey() final  String key;
@override@JsonKey() final  String payload;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool failed;

/// Create a copy of FeedDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedDraftStateCopyWith<_FeedDraftState> get copyWith => __$FeedDraftStateCopyWithImpl<_FeedDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedDraftState&&(identical(other.text, text) || other.text == text)&&(identical(other.key, key) || other.key == key)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,key,payload,busy,failed);
}

@override
String toString() {
    return 'FeedDraftState(text: $text, key: $key, payload: $payload, busy: $busy, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$FeedDraftStateCopyWith<$Res> implements $FeedDraftStateCopyWith<$Res> {
  factory _$FeedDraftStateCopyWith(_FeedDraftState value, $Res Function(_FeedDraftState) _then) = __$FeedDraftStateCopyWithImpl;
@override @useResult
$Res call({
 String text, String key, String payload, bool busy, bool failed
});




}
/// @nodoc
class __$FeedDraftStateCopyWithImpl<$Res>
    implements _$FeedDraftStateCopyWith<$Res> {
  __$FeedDraftStateCopyWithImpl(this._self, this._then);

  final _FeedDraftState _self;
  final $Res Function(_FeedDraftState) _then;

/// Create a copy of FeedDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? key = null,Object? payload = null,Object? busy = null,Object? failed = null,}) {
  return _then(_FeedDraftState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
