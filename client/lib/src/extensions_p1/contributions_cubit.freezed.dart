// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contributions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContributionsState {

 ContributionsPhase get phase; List<ContributionEntry> get entries; ContributionEntry? get selected; ExtensionDocument? get document;
/// Create a copy of ContributionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributionsStateCopyWith<ContributionsState> get copyWith => _$ContributionsStateCopyWithImpl<ContributionsState>(this as ContributionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ContributionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContributionsState&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&(identical(other.document, _this.document) || other.document == _this.document));
}


@override
int get hashCode {
  final _this = this as ContributionsState;
  return Object.hash(runtimeType,_this.phase,const DeepCollectionEquality().hash(_this.entries),_this.selected,_this.document);
}

@override
String toString() {
  final _this = this as ContributionsState;
  return 'ContributionsState(phase: ${_this.phase}, entries: ${_this.entries}, selected: ${_this.selected}, document: ${_this.document})';
}


}

/// @nodoc
abstract mixin class $ContributionsStateCopyWith<$Res>  {
  factory $ContributionsStateCopyWith(ContributionsState value, $Res Function(ContributionsState) _then) = _$ContributionsStateCopyWithImpl;
@useResult
$Res call({
 ContributionsPhase phase, List<ContributionEntry> entries, ContributionEntry? selected, ExtensionDocument? document
});




}
/// @nodoc
class _$ContributionsStateCopyWithImpl<$Res>
    implements $ContributionsStateCopyWith<$Res> {
  _$ContributionsStateCopyWithImpl(this._self, this._then);

  final ContributionsState _self;
  final $Res Function(ContributionsState) _then;

/// Create a copy of ContributionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? entries = null,Object? selected = freezed,Object? document = freezed,}) {
  return _then(ContributionsState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ContributionsPhase,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<ContributionEntry>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as ContributionEntry?,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as ExtensionDocument?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContributionsState].
extension ContributionsStatePatterns on ContributionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContributionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContributionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContributionsState value)  $default,){
final _that = this;
switch (_that) {
case _ContributionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContributionsState value)?  $default,){
final _that = this;
switch (_that) {
case _ContributionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContributionsPhase phase,  List<ContributionEntry> entries,  ContributionEntry? selected,  ExtensionDocument? document)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContributionsState() when $default != null:
return $default(_that.phase,_that.entries,_that.selected,_that.document);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContributionsPhase phase,  List<ContributionEntry> entries,  ContributionEntry? selected,  ExtensionDocument? document)  $default,) {final _that = this;
switch (_that) {
case _ContributionsState():
return $default(_that.phase,_that.entries,_that.selected,_that.document);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContributionsPhase phase,  List<ContributionEntry> entries,  ContributionEntry? selected,  ExtensionDocument? document)?  $default,) {final _that = this;
switch (_that) {
case _ContributionsState() when $default != null:
return $default(_that.phase,_that.entries,_that.selected,_that.document);case _:
  return null;

}
}

}

/// @nodoc


class _ContributionsState implements ContributionsState {
  const _ContributionsState({this.phase = ContributionsPhase.loading,  List<ContributionEntry> entries = const <ContributionEntry>[], this.selected, this.document}): _entries = entries;
  

@override@JsonKey() final  ContributionsPhase phase;
 final  List<ContributionEntry> _entries;
@override@JsonKey() List<ContributionEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  ContributionEntry? selected;
@override final  ExtensionDocument? document;

/// Create a copy of ContributionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributionsStateCopyWith<_ContributionsState> get copyWith => __$ContributionsStateCopyWithImpl<_ContributionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContributionsState&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.document, document) || other.document == document));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(_entries),selected,document);
}

@override
String toString() {
    return 'ContributionsState(phase: $phase, entries: $entries, selected: $selected, document: $document)';
}


}

/// @nodoc
abstract mixin class _$ContributionsStateCopyWith<$Res> implements $ContributionsStateCopyWith<$Res> {
  factory _$ContributionsStateCopyWith(_ContributionsState value, $Res Function(_ContributionsState) _then) = __$ContributionsStateCopyWithImpl;
@override @useResult
$Res call({
 ContributionsPhase phase, List<ContributionEntry> entries, ContributionEntry? selected, ExtensionDocument? document
});




}
/// @nodoc
class __$ContributionsStateCopyWithImpl<$Res>
    implements _$ContributionsStateCopyWith<$Res> {
  __$ContributionsStateCopyWithImpl(this._self, this._then);

  final _ContributionsState _self;
  final $Res Function(_ContributionsState) _then;

/// Create a copy of ContributionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? entries = null,Object? selected = freezed,Object? document = freezed,}) {
  return _then(_ContributionsState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ContributionsPhase,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<ContributionEntry>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as ContributionEntry?,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as ExtensionDocument?,
  ));
}


}

// dart format on
