// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_ai_server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceAiServer {

/// Where the server is, up to and including `/v1`, for example
/// `'https://api.openai.com/v1'`.
 String get url;/// Which model to ask, as the server names it.
 String get model;/// The key the server wants, if it wants one.
 String? get apiKey;/// Anything the assistant should know about your car or how to answer,
/// added to what SmartifyOS tells it anyway (to answer short, in the
/// car's language).
 String? get instructions;/// How long to wait for an answer before falling back to the car.
 Duration get timeout;
/// Create a copy of VoiceAiServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceAiServerCopyWith<VoiceAiServer> get copyWith => _$VoiceAiServerCopyWithImpl<VoiceAiServer>(this as VoiceAiServer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceAiServer&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,url,model,apiKey,instructions,timeout);

@override
String toString() {
  return 'VoiceAiServer(url: $url, model: $model, apiKey: $apiKey, instructions: $instructions, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class $VoiceAiServerCopyWith<$Res>  {
  factory $VoiceAiServerCopyWith(VoiceAiServer value, $Res Function(VoiceAiServer) _then) = _$VoiceAiServerCopyWithImpl;
@useResult
$Res call({
 String url, String model, String? apiKey, String? instructions, Duration timeout
});




}
/// @nodoc
class _$VoiceAiServerCopyWithImpl<$Res>
    implements $VoiceAiServerCopyWith<$Res> {
  _$VoiceAiServerCopyWithImpl(this._self, this._then);

  final VoiceAiServer _self;
  final $Res Function(VoiceAiServer) _then;

/// Create a copy of VoiceAiServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? model = null,Object? apiKey = freezed,Object? instructions = freezed,Object? timeout = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceAiServer].
extension VoiceAiServerPatterns on VoiceAiServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceAiServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceAiServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceAiServer value)  $default,){
final _that = this;
switch (_that) {
case _VoiceAiServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceAiServer value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceAiServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String model,  String? apiKey,  String? instructions,  Duration timeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceAiServer() when $default != null:
return $default(_that.url,_that.model,_that.apiKey,_that.instructions,_that.timeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String model,  String? apiKey,  String? instructions,  Duration timeout)  $default,) {final _that = this;
switch (_that) {
case _VoiceAiServer():
return $default(_that.url,_that.model,_that.apiKey,_that.instructions,_that.timeout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String model,  String? apiKey,  String? instructions,  Duration timeout)?  $default,) {final _that = this;
switch (_that) {
case _VoiceAiServer() when $default != null:
return $default(_that.url,_that.model,_that.apiKey,_that.instructions,_that.timeout);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceAiServer implements VoiceAiServer {
  const _VoiceAiServer({required this.url, required this.model, this.apiKey, this.instructions, this.timeout = const Duration(seconds: 15)});
  

/// Where the server is, up to and including `/v1`, for example
/// `'https://api.openai.com/v1'`.
@override final  String url;
/// Which model to ask, as the server names it.
@override final  String model;
/// The key the server wants, if it wants one.
@override final  String? apiKey;
/// Anything the assistant should know about your car or how to answer,
/// added to what SmartifyOS tells it anyway (to answer short, in the
/// car's language).
@override final  String? instructions;
/// How long to wait for an answer before falling back to the car.
@override@JsonKey() final  Duration timeout;

/// Create a copy of VoiceAiServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceAiServerCopyWith<_VoiceAiServer> get copyWith => __$VoiceAiServerCopyWithImpl<_VoiceAiServer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceAiServer&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,url,model,apiKey,instructions,timeout);

@override
String toString() {
  return 'VoiceAiServer(url: $url, model: $model, apiKey: $apiKey, instructions: $instructions, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class _$VoiceAiServerCopyWith<$Res> implements $VoiceAiServerCopyWith<$Res> {
  factory _$VoiceAiServerCopyWith(_VoiceAiServer value, $Res Function(_VoiceAiServer) _then) = __$VoiceAiServerCopyWithImpl;
@override @useResult
$Res call({
 String url, String model, String? apiKey, String? instructions, Duration timeout
});




}
/// @nodoc
class __$VoiceAiServerCopyWithImpl<$Res>
    implements _$VoiceAiServerCopyWith<$Res> {
  __$VoiceAiServerCopyWithImpl(this._self, this._then);

  final _VoiceAiServer _self;
  final $Res Function(_VoiceAiServer) _then;

/// Create a copy of VoiceAiServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? model = null,Object? apiKey = freezed,Object? instructions = freezed,Object? timeout = null,}) {
  return _then(_VoiceAiServer(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
