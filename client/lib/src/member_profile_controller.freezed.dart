// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberProfileState {

 String get nickname; String get draftName; ParticipantProfile? get profile; List<int> get avatar; AvatarEdit get avatarEdit; bool get loading; bool get preparing; bool get saving; bool get loaded; bool get saved; ProfileProblem get problem;
/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileStateCopyWith<MemberProfileState> get copyWith => _$MemberProfileStateCopyWithImpl<MemberProfileState>(this as MemberProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemberProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileState&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.draftName, _this.draftName) || other.draftName == _this.draftName)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&const DeepCollectionEquality().equals(other.avatar, _this.avatar)&&(identical(other.avatarEdit, _this.avatarEdit) || other.avatarEdit == _this.avatarEdit)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.preparing, _this.preparing) || other.preparing == _this.preparing)&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.problem, _this.problem) || other.problem == _this.problem));
}


@override
int get hashCode {
  final _this = this as MemberProfileState;
  return Object.hash(runtimeType,_this.nickname,_this.draftName,_this.profile,const DeepCollectionEquality().hash(_this.avatar),_this.avatarEdit,_this.loading,_this.preparing,_this.saving,_this.loaded,_this.saved,_this.problem);
}

@override
String toString() {
  final _this = this as MemberProfileState;
  return 'MemberProfileState(nickname: ${_this.nickname}, draftName: ${_this.draftName}, profile: ${_this.profile}, avatar: ${_this.avatar}, avatarEdit: ${_this.avatarEdit}, loading: ${_this.loading}, preparing: ${_this.preparing}, saving: ${_this.saving}, loaded: ${_this.loaded}, saved: ${_this.saved}, problem: ${_this.problem})';
}


}

/// @nodoc
abstract mixin class $MemberProfileStateCopyWith<$Res>  {
  factory $MemberProfileStateCopyWith(MemberProfileState value, $Res Function(MemberProfileState) _then) = _$MemberProfileStateCopyWithImpl;
@useResult
$Res call({
 String nickname, String draftName, ParticipantProfile? profile, List<int> avatar, AvatarEdit avatarEdit, bool loading, bool preparing, bool saving, bool loaded, bool saved, ProfileProblem problem
});




}
/// @nodoc
class _$MemberProfileStateCopyWithImpl<$Res>
    implements $MemberProfileStateCopyWith<$Res> {
  _$MemberProfileStateCopyWithImpl(this._self, this._then);

  final MemberProfileState _self;
  final $Res Function(MemberProfileState) _then;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = null,Object? draftName = null,Object? profile = freezed,Object? avatar = null,Object? avatarEdit = null,Object? loading = null,Object? preparing = null,Object? saving = null,Object? loaded = null,Object? saved = null,Object? problem = null,}) {
  return _then(MemberProfileState(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,draftName: null == draftName ? _self.draftName : draftName // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ParticipantProfile?,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as List<int>,avatarEdit: null == avatarEdit ? _self.avatarEdit : avatarEdit // ignore: cast_nullable_to_non_nullable
as AvatarEdit,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,preparing: null == preparing ? _self.preparing : preparing // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,problem: null == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as ProfileProblem,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberProfileState].
extension MemberProfileStatePatterns on MemberProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberProfileState value)  $default,){
final _that = this;
switch (_that) {
case _MemberProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _MemberProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nickname,  String draftName,  ParticipantProfile? profile,  List<int> avatar,  AvatarEdit avatarEdit,  bool loading,  bool preparing,  bool saving,  bool loaded,  bool saved,  ProfileProblem problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberProfileState() when $default != null:
return $default(_that.nickname,_that.draftName,_that.profile,_that.avatar,_that.avatarEdit,_that.loading,_that.preparing,_that.saving,_that.loaded,_that.saved,_that.problem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nickname,  String draftName,  ParticipantProfile? profile,  List<int> avatar,  AvatarEdit avatarEdit,  bool loading,  bool preparing,  bool saving,  bool loaded,  bool saved,  ProfileProblem problem)  $default,) {final _that = this;
switch (_that) {
case _MemberProfileState():
return $default(_that.nickname,_that.draftName,_that.profile,_that.avatar,_that.avatarEdit,_that.loading,_that.preparing,_that.saving,_that.loaded,_that.saved,_that.problem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nickname,  String draftName,  ParticipantProfile? profile,  List<int> avatar,  AvatarEdit avatarEdit,  bool loading,  bool preparing,  bool saving,  bool loaded,  bool saved,  ProfileProblem problem)?  $default,) {final _that = this;
switch (_that) {
case _MemberProfileState() when $default != null:
return $default(_that.nickname,_that.draftName,_that.profile,_that.avatar,_that.avatarEdit,_that.loading,_that.preparing,_that.saving,_that.loaded,_that.saved,_that.problem);case _:
  return null;

}
}

}

/// @nodoc


class _MemberProfileState extends MemberProfileState {
  const _MemberProfileState({this.nickname = '', this.draftName = '', this.profile,  List<int> avatar = const [], this.avatarEdit = AvatarEdit.keep, this.loading = false, this.preparing = false, this.saving = false, this.loaded = false, this.saved = false, this.problem = ProfileProblem.none}): _avatar = avatar,super._();
  

@override@JsonKey() final  String nickname;
@override@JsonKey() final  String draftName;
@override final  ParticipantProfile? profile;
 final  List<int> _avatar;
@override@JsonKey() List<int> get avatar {
  if (_avatar is EqualUnmodifiableListView) return _avatar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avatar);
}

@override@JsonKey() final  AvatarEdit avatarEdit;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool preparing;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool saved;
@override@JsonKey() final  ProfileProblem problem;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberProfileStateCopyWith<_MemberProfileState> get copyWith => __$MemberProfileStateCopyWithImpl<_MemberProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberProfileState&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.draftName, draftName) || other.draftName == draftName)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.avatar, _avatar)&&(identical(other.avatarEdit, avatarEdit) || other.avatarEdit == avatarEdit)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.preparing, preparing) || other.preparing == preparing)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nickname,draftName,profile,const DeepCollectionEquality().hash(_avatar),avatarEdit,loading,preparing,saving,loaded,saved,problem);
}

@override
String toString() {
    return 'MemberProfileState(nickname: $nickname, draftName: $draftName, profile: $profile, avatar: $avatar, avatarEdit: $avatarEdit, loading: $loading, preparing: $preparing, saving: $saving, loaded: $loaded, saved: $saved, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$MemberProfileStateCopyWith<$Res> implements $MemberProfileStateCopyWith<$Res> {
  factory _$MemberProfileStateCopyWith(_MemberProfileState value, $Res Function(_MemberProfileState) _then) = __$MemberProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String nickname, String draftName, ParticipantProfile? profile, List<int> avatar, AvatarEdit avatarEdit, bool loading, bool preparing, bool saving, bool loaded, bool saved, ProfileProblem problem
});




}
/// @nodoc
class __$MemberProfileStateCopyWithImpl<$Res>
    implements _$MemberProfileStateCopyWith<$Res> {
  __$MemberProfileStateCopyWithImpl(this._self, this._then);

  final _MemberProfileState _self;
  final $Res Function(_MemberProfileState) _then;

/// Create a copy of MemberProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = null,Object? draftName = null,Object? profile = freezed,Object? avatar = null,Object? avatarEdit = null,Object? loading = null,Object? preparing = null,Object? saving = null,Object? loaded = null,Object? saved = null,Object? problem = null,}) {
  return _then(_MemberProfileState(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,draftName: null == draftName ? _self.draftName : draftName // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ParticipantProfile?,avatar: null == avatar ? _self._avatar : avatar // ignore: cast_nullable_to_non_nullable
as List<int>,avatarEdit: null == avatarEdit ? _self.avatarEdit : avatarEdit // ignore: cast_nullable_to_non_nullable
as AvatarEdit,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,preparing: null == preparing ? _self.preparing : preparing // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,problem: null == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as ProfileProblem,
  ));
}


}

// dart format on
