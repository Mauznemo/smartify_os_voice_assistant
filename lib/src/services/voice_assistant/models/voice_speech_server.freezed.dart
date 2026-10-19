// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_speech_server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceSpeechServer {

/// Where the server is, up to and including `/v1`.
 String get url;/// Which model to use, as the server names it.
 String get model;/// Which voice, as the server names it.
 String get voice;/// The key the server wants, if it wants one.
 String? get apiKey;/// How long to wait for a sentence before using the car's own voice.
 Duration get timeout;
/// Create a copy of VoiceSpeechServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceSpeechServerCopyWith<VoiceSpeechServer> get copyWith => _$VoiceSpeechServerCopyWithImpl<VoiceSpeechServer>(this as VoiceSpeechServer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceSpeechServer&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,url,model,voice,apiKey,timeout);

@override
String toString() {
  return 'VoiceSpeechServer(url: $url, model: $model, voice: $voice, apiKey: $apiKey, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class $VoiceSpeechServerCopyWith<$Res>  {
  factory $VoiceSpeechServerCopyWith(VoiceSpeechServer value, $Res Function(VoiceSpeechServer) _then) = _$VoiceSpeechServerCopyWithImpl;
@useResult
$Res call({
 String url, String model, String voice, String? apiKey, Duration timeout
});




}
/// @nodoc
class _$VoiceSpeechServerCopyWithImpl<$Res>
    implements $VoiceSpeechServerCopyWith<$Res> {
  _$VoiceSpeechServerCopyWithImpl(this._self, this._then);

  final VoiceSpeechServer _self;
  final $Res Function(VoiceSpeechServer) _then;

/// Create a copy of VoiceSpeechServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? model = null,Object? voice = null,Object? apiKey = freezed,Object? timeout = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,voice: null == voice ? _self.voice : voice // ignore: cast_nullable_to_non_nullable
as String,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceSpeechServer].
extension VoiceSpeechServerPatterns on VoiceSpeechServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceSpeechServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceSpeechServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceSpeechServer value)  $default,){
final _that = this;
switch (_that) {
case _VoiceSpeechServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceSpeechServer value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceSpeechServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String model,  String voice,  String? apiKey,  Duration timeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceSpeechServer() when $default != null:
return $default(_that.url,_that.model,_that.voice,_that.apiKey,_that.timeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String model,  String voice,  String? apiKey,  Duration timeout)  $default,) {final _that = this;
switch (_that) {
case _VoiceSpeechServer():
return $default(_that.url,_that.model,_that.voice,_that.apiKey,_that.timeout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String model,  String voice,  String? apiKey,  Duration timeout)?  $default,) {final _that = this;
switch (_that) {
case _VoiceSpeechServer() when $default != null:
return $default(_that.url,_that.model,_that.voice,_that.apiKey,_that.timeout);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceSpeechServer implements VoiceSpeechServer {
  const _VoiceSpeechServer({required this.url, required this.model, required this.voice, this.apiKey, this.timeout = const Duration(seconds: 8)});
  

/// Where the server is, up to and including `/v1`.
@override final  String url;
/// Which model to use, as the server names it.
@override final  String model;
/// Which voice, as the server names it.
@override final  String voice;
/// The key the server wants, if it wants one.
@override final  String? apiKey;
/// How long to wait for a sentence before using the car's own voice.
@override@JsonKey() final  Duration timeout;

/// Create a copy of VoiceSpeechServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceSpeechServerCopyWith<_VoiceSpeechServer> get copyWith => __$VoiceSpeechServerCopyWithImpl<_VoiceSpeechServer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceSpeechServer&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,url,model,voice,apiKey,timeout);

@override
String toString() {
  return 'VoiceSpeechServer(url: $url, model: $model, voice: $voice, apiKey: $apiKey, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class _$VoiceSpeechServerCopyWith<$Res> implements $VoiceSpeechServerCopyWith<$Res> {
  factory _$VoiceSpeechServerCopyWith(_VoiceSpeechServer value, $Res Function(_VoiceSpeechServer) _then) = __$VoiceSpeechServerCopyWithImpl;
@override @useResult
$Res call({
 String url, String model, String voice, String? apiKey, Duration timeout
});




}
/// @nodoc
class __$VoiceSpeechServerCopyWithImpl<$Res>
    implements _$VoiceSpeechServerCopyWith<$Res> {
  __$VoiceSpeechServerCopyWithImpl(this._self, this._then);

  final _VoiceSpeechServer _self;
  final $Res Function(_VoiceSpeechServer) _then;

/// Create a copy of VoiceSpeechServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? model = null,Object? voice = null,Object? apiKey = freezed,Object? timeout = null,}) {
  return _then(_VoiceSpeechServer(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,voice: null == voice ? _self.voice : voice // ignore: cast_nullable_to_non_nullable
as String,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
