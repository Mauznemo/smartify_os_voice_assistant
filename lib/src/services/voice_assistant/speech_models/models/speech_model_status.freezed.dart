// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_model_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeechModelStatus {

/// Whether it is on the car, complete, ready to be used.
 bool get downloaded;/// How far along its download is, from 0 to 1, while it downloads.
 double? get progress;/// Whether the last try to download it failed.
 bool get failed;
/// Create a copy of SpeechModelStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelStatusCopyWith<SpeechModelStatus> get copyWith => _$SpeechModelStatusCopyWithImpl<SpeechModelStatus>(this as SpeechModelStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelStatus&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,downloaded,progress,failed);

@override
String toString() {
  return 'SpeechModelStatus(downloaded: $downloaded, progress: $progress, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $SpeechModelStatusCopyWith<$Res>  {
  factory $SpeechModelStatusCopyWith(SpeechModelStatus value, $Res Function(SpeechModelStatus) _then) = _$SpeechModelStatusCopyWithImpl;
@useResult
$Res call({
 bool downloaded, double? progress, bool failed
});




}
/// @nodoc
class _$SpeechModelStatusCopyWithImpl<$Res>
    implements $SpeechModelStatusCopyWith<$Res> {
  _$SpeechModelStatusCopyWithImpl(this._self, this._then);

  final SpeechModelStatus _self;
  final $Res Function(SpeechModelStatus) _then;

/// Create a copy of SpeechModelStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloaded = null,Object? progress = freezed,Object? failed = null,}) {
  return _then(_self.copyWith(
downloaded: null == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechModelStatus].
extension SpeechModelStatusPatterns on SpeechModelStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechModelStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechModelStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechModelStatus value)  $default,){
final _that = this;
switch (_that) {
case _SpeechModelStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechModelStatus value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechModelStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool downloaded,  double? progress,  bool failed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechModelStatus() when $default != null:
return $default(_that.downloaded,_that.progress,_that.failed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool downloaded,  double? progress,  bool failed)  $default,) {final _that = this;
switch (_that) {
case _SpeechModelStatus():
return $default(_that.downloaded,_that.progress,_that.failed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool downloaded,  double? progress,  bool failed)?  $default,) {final _that = this;
switch (_that) {
case _SpeechModelStatus() when $default != null:
return $default(_that.downloaded,_that.progress,_that.failed);case _:
  return null;

}
}

}

/// @nodoc


class _SpeechModelStatus extends SpeechModelStatus {
  const _SpeechModelStatus({this.downloaded = false, this.progress, this.failed = false}): super._();
  

/// Whether it is on the car, complete, ready to be used.
@override@JsonKey() final  bool downloaded;
/// How far along its download is, from 0 to 1, while it downloads.
@override final  double? progress;
/// Whether the last try to download it failed.
@override@JsonKey() final  bool failed;

/// Create a copy of SpeechModelStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechModelStatusCopyWith<_SpeechModelStatus> get copyWith => __$SpeechModelStatusCopyWithImpl<_SpeechModelStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechModelStatus&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,downloaded,progress,failed);

@override
String toString() {
  return 'SpeechModelStatus(downloaded: $downloaded, progress: $progress, failed: $failed)';
}


}

/// @nodoc
abstract mixin class _$SpeechModelStatusCopyWith<$Res> implements $SpeechModelStatusCopyWith<$Res> {
  factory _$SpeechModelStatusCopyWith(_SpeechModelStatus value, $Res Function(_SpeechModelStatus) _then) = __$SpeechModelStatusCopyWithImpl;
@override @useResult
$Res call({
 bool downloaded, double? progress, bool failed
});




}
/// @nodoc
class __$SpeechModelStatusCopyWithImpl<$Res>
    implements _$SpeechModelStatusCopyWith<$Res> {
  __$SpeechModelStatusCopyWithImpl(this._self, this._then);

  final _SpeechModelStatus _self;
  final $Res Function(_SpeechModelStatus) _then;

/// Create a copy of SpeechModelStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloaded = null,Object? progress = freezed,Object? failed = null,}) {
  return _then(_SpeechModelStatus(
downloaded: null == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
