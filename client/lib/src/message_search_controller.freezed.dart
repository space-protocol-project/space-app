// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_search_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageSearchState {

 String get query; String get next; List<Content> get messages; bool get loading; bool get failed; bool get allChannels;
/// Create a copy of MessageSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageSearchStateCopyWith<MessageSearchState> get copyWith => _$MessageSearchStateCopyWithImpl<MessageSearchState>(this as MessageSearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MessageSearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageSearchState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.next, _this.next) || other.next == _this.next)&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.allChannels, _this.allChannels) || other.allChannels == _this.allChannels));
}


@override
int get hashCode {
  final _this = this as MessageSearchState;
  return Object.hash(runtimeType,_this.query,_this.next,const DeepCollectionEquality().hash(_this.messages),_this.loading,_this.failed,_this.allChannels);
}

@override
String toString() {
  final _this = this as MessageSearchState;
  return 'MessageSearchState(query: ${_this.query}, next: ${_this.next}, messages: ${_this.messages}, loading: ${_this.loading}, failed: ${_this.failed}, allChannels: ${_this.allChannels})';
}


}

/// @nodoc
abstract mixin class $MessageSearchStateCopyWith<$Res>  {
  factory $MessageSearchStateCopyWith(MessageSearchState value, $Res Function(MessageSearchState) _then) = _$MessageSearchStateCopyWithImpl;
@useResult
$Res call({
 String query, String next, List<Content> messages, bool loading, bool failed, bool allChannels
});




}
/// @nodoc
class _$MessageSearchStateCopyWithImpl<$Res>
    implements $MessageSearchStateCopyWith<$Res> {
  _$MessageSearchStateCopyWithImpl(this._self, this._then);

  final MessageSearchState _self;
  final $Res Function(MessageSearchState) _then;

/// Create a copy of MessageSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? next = null,Object? messages = null,Object? loading = null,Object? failed = null,Object? allChannels = null,}) {
  return _then(MessageSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Content>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,allChannels: null == allChannels ? _self.allChannels : allChannels // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageSearchState].
extension MessageSearchStatePatterns on MessageSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageSearchState value)  $default,){
final _that = this;
switch (_that) {
case _MessageSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _MessageSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  String next,  List<Content> messages,  bool loading,  bool failed,  bool allChannels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageSearchState() when $default != null:
return $default(_that.query,_that.next,_that.messages,_that.loading,_that.failed,_that.allChannels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  String next,  List<Content> messages,  bool loading,  bool failed,  bool allChannels)  $default,) {final _that = this;
switch (_that) {
case _MessageSearchState():
return $default(_that.query,_that.next,_that.messages,_that.loading,_that.failed,_that.allChannels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  String next,  List<Content> messages,  bool loading,  bool failed,  bool allChannels)?  $default,) {final _that = this;
switch (_that) {
case _MessageSearchState() when $default != null:
return $default(_that.query,_that.next,_that.messages,_that.loading,_that.failed,_that.allChannels);case _:
  return null;

}
}

}

/// @nodoc


class _MessageSearchState implements MessageSearchState {
  const _MessageSearchState({this.query = '', this.next = '',  List<Content> messages = const [], this.loading = false, this.failed = false, this.allChannels = false}): _messages = messages;
  

@override@JsonKey() final  String query;
@override@JsonKey() final  String next;
 final  List<Content> _messages;
@override@JsonKey() List<Content> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  bool allChannels;

/// Create a copy of MessageSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageSearchStateCopyWith<_MessageSearchState> get copyWith => __$MessageSearchStateCopyWithImpl<_MessageSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageSearchState&&(identical(other.query, query) || other.query == query)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.allChannels, allChannels) || other.allChannels == allChannels));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,next,const DeepCollectionEquality().hash(_messages),loading,failed,allChannels);
}

@override
String toString() {
    return 'MessageSearchState(query: $query, next: $next, messages: $messages, loading: $loading, failed: $failed, allChannels: $allChannels)';
}


}

/// @nodoc
abstract mixin class _$MessageSearchStateCopyWith<$Res> implements $MessageSearchStateCopyWith<$Res> {
  factory _$MessageSearchStateCopyWith(_MessageSearchState value, $Res Function(_MessageSearchState) _then) = __$MessageSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, String next, List<Content> messages, bool loading, bool failed, bool allChannels
});




}
/// @nodoc
class __$MessageSearchStateCopyWithImpl<$Res>
    implements _$MessageSearchStateCopyWith<$Res> {
  __$MessageSearchStateCopyWithImpl(this._self, this._then);

  final _MessageSearchState _self;
  final $Res Function(_MessageSearchState) _then;

/// Create a copy of MessageSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? next = null,Object? messages = null,Object? loading = null,Object? failed = null,Object? allChannels = null,}) {
  return _then(_MessageSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Content>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,allChannels: null == allChannels ? _self.allChannels : allChannels // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
