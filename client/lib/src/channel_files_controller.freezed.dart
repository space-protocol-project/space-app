// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_files_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelFilesState {

 List<Asset> get files; Map<String, String> get authors; String get author; String get cursor; bool get busy; String get error; bool get more;
/// Create a copy of ChannelFilesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelFilesStateCopyWith<ChannelFilesState> get copyWith => _$ChannelFilesStateCopyWithImpl<ChannelFilesState>(this as ChannelFilesState, _$identity);





@override
String toString() {
  final _this = this as ChannelFilesState;
  return 'ChannelFilesState(files: ${_this.files}, authors: ${_this.authors}, author: ${_this.author}, cursor: ${_this.cursor}, busy: ${_this.busy}, error: ${_this.error}, more: ${_this.more})';
}


}

/// @nodoc
abstract mixin class $ChannelFilesStateCopyWith<$Res>  {
  factory $ChannelFilesStateCopyWith(ChannelFilesState value, $Res Function(ChannelFilesState) _then) = _$ChannelFilesStateCopyWithImpl;
@useResult
$Res call({
 List<Asset> files, Map<String, String> authors, String author, String cursor, bool busy, String error, bool more
});




}
/// @nodoc
class _$ChannelFilesStateCopyWithImpl<$Res>
    implements $ChannelFilesStateCopyWith<$Res> {
  _$ChannelFilesStateCopyWithImpl(this._self, this._then);

  final ChannelFilesState _self;
  final $Res Function(ChannelFilesState) _then;

/// Create a copy of ChannelFilesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? authors = null,Object? author = null,Object? cursor = null,Object? busy = null,Object? error = null,Object? more = null,}) {
  return _then(ChannelFilesState(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<Asset>,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,more: null == more ? _self.more : more // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelFilesState].
extension ChannelFilesStatePatterns on ChannelFilesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelFilesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelFilesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelFilesState value)  $default,){
final _that = this;
switch (_that) {
case _ChannelFilesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelFilesState value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelFilesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Asset> files,  Map<String, String> authors,  String author,  String cursor,  bool busy,  String error,  bool more)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelFilesState() when $default != null:
return $default(_that.files,_that.authors,_that.author,_that.cursor,_that.busy,_that.error,_that.more);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Asset> files,  Map<String, String> authors,  String author,  String cursor,  bool busy,  String error,  bool more)  $default,) {final _that = this;
switch (_that) {
case _ChannelFilesState():
return $default(_that.files,_that.authors,_that.author,_that.cursor,_that.busy,_that.error,_that.more);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Asset> files,  Map<String, String> authors,  String author,  String cursor,  bool busy,  String error,  bool more)?  $default,) {final _that = this;
switch (_that) {
case _ChannelFilesState() when $default != null:
return $default(_that.files,_that.authors,_that.author,_that.cursor,_that.busy,_that.error,_that.more);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelFilesState extends ChannelFilesState {
  const _ChannelFilesState({ List<Asset> files = const [],  Map<String, String> authors = const {}, this.author = '', this.cursor = '', this.busy = false, this.error = '', this.more = true}): _files = files,_authors = authors,super._();
  

 final  List<Asset> _files;
@override@JsonKey() List<Asset> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  Map<String, String> _authors;
@override@JsonKey() Map<String, String> get authors {
  if (_authors is EqualUnmodifiableMapView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_authors);
}

@override@JsonKey() final  String author;
@override@JsonKey() final  String cursor;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  String error;
@override@JsonKey() final  bool more;

/// Create a copy of ChannelFilesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelFilesStateCopyWith<_ChannelFilesState> get copyWith => __$ChannelFilesStateCopyWithImpl<_ChannelFilesState>(this, _$identity);





@override
String toString() {
    return 'ChannelFilesState(files: $files, authors: $authors, author: $author, cursor: $cursor, busy: $busy, error: $error, more: $more)';
}


}

/// @nodoc
abstract mixin class _$ChannelFilesStateCopyWith<$Res> implements $ChannelFilesStateCopyWith<$Res> {
  factory _$ChannelFilesStateCopyWith(_ChannelFilesState value, $Res Function(_ChannelFilesState) _then) = __$ChannelFilesStateCopyWithImpl;
@override @useResult
$Res call({
 List<Asset> files, Map<String, String> authors, String author, String cursor, bool busy, String error, bool more
});




}
/// @nodoc
class __$ChannelFilesStateCopyWithImpl<$Res>
    implements _$ChannelFilesStateCopyWith<$Res> {
  __$ChannelFilesStateCopyWithImpl(this._self, this._then);

  final _ChannelFilesState _self;
  final $Res Function(_ChannelFilesState) _then;

/// Create a copy of ChannelFilesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? authors = null,Object? author = null,Object? cursor = null,Object? busy = null,Object? error = null,Object? more = null,}) {
  return _then(_ChannelFilesState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<Asset>,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,more: null == more ? _self.more : more // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
