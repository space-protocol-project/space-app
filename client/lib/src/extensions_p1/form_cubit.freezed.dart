// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtensionFormState {

 Map<String, Object> get values; Set<String> get errors; ExtensionFormStatus get status;
/// Create a copy of ExtensionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtensionFormStateCopyWith<ExtensionFormState> get copyWith => _$ExtensionFormStateCopyWithImpl<ExtensionFormState>(this as ExtensionFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExtensionFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtensionFormState&&const DeepCollectionEquality().equals(other.values, _this.values)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as ExtensionFormState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.values),const DeepCollectionEquality().hash(_this.errors),_this.status);
}

@override
String toString() {
  final _this = this as ExtensionFormState;
  return 'ExtensionFormState(values: ${_this.values}, errors: ${_this.errors}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $ExtensionFormStateCopyWith<$Res>  {
  factory $ExtensionFormStateCopyWith(ExtensionFormState value, $Res Function(ExtensionFormState) _then) = _$ExtensionFormStateCopyWithImpl;
@useResult
$Res call({
 Map<String, Object> values, Set<String> errors, ExtensionFormStatus status
});




}
/// @nodoc
class _$ExtensionFormStateCopyWithImpl<$Res>
    implements $ExtensionFormStateCopyWith<$Res> {
  _$ExtensionFormStateCopyWithImpl(this._self, this._then);

  final ExtensionFormState _self;
  final $Res Function(ExtensionFormState) _then;

/// Create a copy of ExtensionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,Object? errors = null,Object? status = null,}) {
  return _then(ExtensionFormState(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Set<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtensionFormStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtensionFormState].
extension ExtensionFormStatePatterns on ExtensionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtensionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtensionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtensionFormState value)  $default,){
final _that = this;
switch (_that) {
case _ExtensionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtensionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ExtensionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Object> values,  Set<String> errors,  ExtensionFormStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtensionFormState() when $default != null:
return $default(_that.values,_that.errors,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Object> values,  Set<String> errors,  ExtensionFormStatus status)  $default,) {final _that = this;
switch (_that) {
case _ExtensionFormState():
return $default(_that.values,_that.errors,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Object> values,  Set<String> errors,  ExtensionFormStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ExtensionFormState() when $default != null:
return $default(_that.values,_that.errors,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ExtensionFormState implements ExtensionFormState {
  const _ExtensionFormState({required  Map<String, Object> values,  Set<String> errors = const <String>{}, this.status = ExtensionFormStatus.ready}): _values = values,_errors = errors;
  

 final  Map<String, Object> _values;
@override Map<String, Object> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}

 final  Set<String> _errors;
@override@JsonKey() Set<String> get errors {
  if (_errors is EqualUnmodifiableSetView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_errors);
}

@override@JsonKey() final  ExtensionFormStatus status;

/// Create a copy of ExtensionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtensionFormStateCopyWith<_ExtensionFormState> get copyWith => __$ExtensionFormStateCopyWithImpl<_ExtensionFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtensionFormState&&const DeepCollectionEquality().equals(other.values, _values)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_values),const DeepCollectionEquality().hash(_errors),status);
}

@override
String toString() {
    return 'ExtensionFormState(values: $values, errors: $errors, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ExtensionFormStateCopyWith<$Res> implements $ExtensionFormStateCopyWith<$Res> {
  factory _$ExtensionFormStateCopyWith(_ExtensionFormState value, $Res Function(_ExtensionFormState) _then) = __$ExtensionFormStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Object> values, Set<String> errors, ExtensionFormStatus status
});




}
/// @nodoc
class __$ExtensionFormStateCopyWithImpl<$Res>
    implements _$ExtensionFormStateCopyWith<$Res> {
  __$ExtensionFormStateCopyWithImpl(this._self, this._then);

  final _ExtensionFormState _self;
  final $Res Function(_ExtensionFormState) _then;

/// Create a copy of ExtensionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,Object? errors = null,Object? status = null,}) {
  return _then(_ExtensionFormState(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Set<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtensionFormStatus,
  ));
}


}

// dart format on
