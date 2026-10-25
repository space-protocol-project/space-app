// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_inbox_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalInboxState {

 PersonalNotificationScope? get scope; List<PersonalNotification> get items; List<int> get history; bool get loading; bool get failed; bool get marking; bool get hasMore; int get after; int get through; int get next;
/// Create a copy of PersonalInboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalInboxStateCopyWith<PersonalInboxState> get copyWith => _$PersonalInboxStateCopyWithImpl<PersonalInboxState>(this as PersonalInboxState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PersonalInboxState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalInboxState&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.history, _this.history)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.marking, _this.marking) || other.marking == _this.marking)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.after, _this.after) || other.after == _this.after)&&(identical(other.through, _this.through) || other.through == _this.through)&&(identical(other.next, _this.next) || other.next == _this.next));
}


@override
int get hashCode {
  final _this = this as PersonalInboxState;
  return Object.hash(runtimeType,_this.scope,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.history),_this.loading,_this.failed,_this.marking,_this.hasMore,_this.after,_this.through,_this.next);
}

@override
String toString() {
  final _this = this as PersonalInboxState;
  return 'PersonalInboxState(scope: ${_this.scope}, items: ${_this.items}, history: ${_this.history}, loading: ${_this.loading}, failed: ${_this.failed}, marking: ${_this.marking}, hasMore: ${_this.hasMore}, after: ${_this.after}, through: ${_this.through}, next: ${_this.next})';
}


}

/// @nodoc
abstract mixin class $PersonalInboxStateCopyWith<$Res>  {
  factory $PersonalInboxStateCopyWith(PersonalInboxState value, $Res Function(PersonalInboxState) _then) = _$PersonalInboxStateCopyWithImpl;
@useResult
$Res call({
 PersonalNotificationScope? scope, List<PersonalNotification> items, List<int> history, bool loading, bool failed, bool marking, bool hasMore, int after, int through, int next
});




}
/// @nodoc
class _$PersonalInboxStateCopyWithImpl<$Res>
    implements $PersonalInboxStateCopyWith<$Res> {
  _$PersonalInboxStateCopyWithImpl(this._self, this._then);

  final PersonalInboxState _self;
  final $Res Function(PersonalInboxState) _then;

/// Create a copy of PersonalInboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = freezed,Object? items = null,Object? history = null,Object? loading = null,Object? failed = null,Object? marking = null,Object? hasMore = null,Object? after = null,Object? through = null,Object? next = null,}) {
  return _then(PersonalInboxState(
scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PersonalNotificationScope?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PersonalNotification>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<int>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,marking: null == marking ? _self.marking : marking // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,through: null == through ? _self.through : through // ignore: cast_nullable_to_non_nullable
as int,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalInboxState].
extension PersonalInboxStatePatterns on PersonalInboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalInboxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalInboxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalInboxState value)  $default,){
final _that = this;
switch (_that) {
case _PersonalInboxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalInboxState value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalInboxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonalNotificationScope? scope,  List<PersonalNotification> items,  List<int> history,  bool loading,  bool failed,  bool marking,  bool hasMore,  int after,  int through,  int next)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalInboxState() when $default != null:
return $default(_that.scope,_that.items,_that.history,_that.loading,_that.failed,_that.marking,_that.hasMore,_that.after,_that.through,_that.next);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonalNotificationScope? scope,  List<PersonalNotification> items,  List<int> history,  bool loading,  bool failed,  bool marking,  bool hasMore,  int after,  int through,  int next)  $default,) {final _that = this;
switch (_that) {
case _PersonalInboxState():
return $default(_that.scope,_that.items,_that.history,_that.loading,_that.failed,_that.marking,_that.hasMore,_that.after,_that.through,_that.next);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonalNotificationScope? scope,  List<PersonalNotification> items,  List<int> history,  bool loading,  bool failed,  bool marking,  bool hasMore,  int after,  int through,  int next)?  $default,) {final _that = this;
switch (_that) {
case _PersonalInboxState() when $default != null:
return $default(_that.scope,_that.items,_that.history,_that.loading,_that.failed,_that.marking,_that.hasMore,_that.after,_that.through,_that.next);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalInboxState implements PersonalInboxState {
  const _PersonalInboxState({this.scope,  List<PersonalNotification> items = const [],  List<int> history = const [], this.loading = false, this.failed = false, this.marking = false, this.hasMore = false, this.after = 0, this.through = 0, this.next = 0}): _items = items,_history = history;
  

@override final  PersonalNotificationScope? scope;
 final  List<PersonalNotification> _items;
@override@JsonKey() List<PersonalNotification> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<int> _history;
@override@JsonKey() List<int> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  bool marking;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int after;
@override@JsonKey() final  int through;
@override@JsonKey() final  int next;

/// Create a copy of PersonalInboxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalInboxStateCopyWith<_PersonalInboxState> get copyWith => __$PersonalInboxStateCopyWithImpl<_PersonalInboxState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalInboxState&&(identical(other.scope, scope) || other.scope == scope)&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.history, _history)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.marking, marking) || other.marking == marking)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.after, after) || other.after == after)&&(identical(other.through, through) || other.through == through)&&(identical(other.next, next) || other.next == next));
}


@override
int get hashCode {
    return Object.hash(runtimeType,scope,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_history),loading,failed,marking,hasMore,after,through,next);
}

@override
String toString() {
    return 'PersonalInboxState(scope: $scope, items: $items, history: $history, loading: $loading, failed: $failed, marking: $marking, hasMore: $hasMore, after: $after, through: $through, next: $next)';
}


}

/// @nodoc
abstract mixin class _$PersonalInboxStateCopyWith<$Res> implements $PersonalInboxStateCopyWith<$Res> {
  factory _$PersonalInboxStateCopyWith(_PersonalInboxState value, $Res Function(_PersonalInboxState) _then) = __$PersonalInboxStateCopyWithImpl;
@override @useResult
$Res call({
 PersonalNotificationScope? scope, List<PersonalNotification> items, List<int> history, bool loading, bool failed, bool marking, bool hasMore, int after, int through, int next
});




}
/// @nodoc
class __$PersonalInboxStateCopyWithImpl<$Res>
    implements _$PersonalInboxStateCopyWith<$Res> {
  __$PersonalInboxStateCopyWithImpl(this._self, this._then);

  final _PersonalInboxState _self;
  final $Res Function(_PersonalInboxState) _then;

/// Create a copy of PersonalInboxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = freezed,Object? items = null,Object? history = null,Object? loading = null,Object? failed = null,Object? marking = null,Object? hasMore = null,Object? after = null,Object? through = null,Object? next = null,}) {
  return _then(_PersonalInboxState(
scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PersonalNotificationScope?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PersonalNotification>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<int>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,marking: null == marking ? _self.marking : marking // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,through: null == through ? _self.through : through // ignore: cast_nullable_to_non_nullable
as int,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
