// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_assistant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceAssistantState {

 VoiceAssistantPhase get phase;/// What it heard you say so far. Grows while you talk, and is final from
/// [VoiceAssistantPhase.thinking] on.
 String get heard;/// What it answered, once it has.
 String? get reply;/// Whether the answer is coming from the AI server rather than the car.
 bool get askingServer;/// Whether it ended because something went wrong, rather than with an
/// answer.
 bool get failed;/// Whether it is waiting for the wake word right now.
 bool get wakeWordListening;
/// Create a copy of VoiceAssistantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceAssistantStateCopyWith<VoiceAssistantState> get copyWith => _$VoiceAssistantStateCopyWithImpl<VoiceAssistantState>(this as VoiceAssistantState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceAssistantState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.heard, heard) || other.heard == heard)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.askingServer, askingServer) || other.askingServer == askingServer)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.wakeWordListening, wakeWordListening) || other.wakeWordListening == wakeWordListening));
}


@override
int get hashCode => Object.hash(runtimeType,phase,heard,reply,askingServer,failed,wakeWordListening);

@override
String toString() {
  return 'VoiceAssistantState(phase: $phase, heard: $heard, reply: $reply, askingServer: $askingServer, failed: $failed, wakeWordListening: $wakeWordListening)';
}


}

/// @nodoc
abstract mixin class $VoiceAssistantStateCopyWith<$Res>  {
  factory $VoiceAssistantStateCopyWith(VoiceAssistantState value, $Res Function(VoiceAssistantState) _then) = _$VoiceAssistantStateCopyWithImpl;
@useResult
$Res call({
 VoiceAssistantPhase phase, String heard, String? reply, bool askingServer, bool failed, bool wakeWordListening
});




}
/// @nodoc
class _$VoiceAssistantStateCopyWithImpl<$Res>
    implements $VoiceAssistantStateCopyWith<$Res> {
  _$VoiceAssistantStateCopyWithImpl(this._self, this._then);

  final VoiceAssistantState _self;
  final $Res Function(VoiceAssistantState) _then;

/// Create a copy of VoiceAssistantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? heard = null,Object? reply = freezed,Object? askingServer = null,Object? failed = null,Object? wakeWordListening = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as VoiceAssistantPhase,heard: null == heard ? _self.heard : heard // ignore: cast_nullable_to_non_nullable
as String,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String?,askingServer: null == askingServer ? _self.askingServer : askingServer // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,wakeWordListening: null == wakeWordListening ? _self.wakeWordListening : wakeWordListening // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceAssistantState].
extension VoiceAssistantStatePatterns on VoiceAssistantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceAssistantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceAssistantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceAssistantState value)  $default,){
final _that = this;
switch (_that) {
case _VoiceAssistantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceAssistantState value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceAssistantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VoiceAssistantPhase phase,  String heard,  String? reply,  bool askingServer,  bool failed,  bool wakeWordListening)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceAssistantState() when $default != null:
return $default(_that.phase,_that.heard,_that.reply,_that.askingServer,_that.failed,_that.wakeWordListening);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VoiceAssistantPhase phase,  String heard,  String? reply,  bool askingServer,  bool failed,  bool wakeWordListening)  $default,) {final _that = this;
switch (_that) {
case _VoiceAssistantState():
return $default(_that.phase,_that.heard,_that.reply,_that.askingServer,_that.failed,_that.wakeWordListening);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VoiceAssistantPhase phase,  String heard,  String? reply,  bool askingServer,  bool failed,  bool wakeWordListening)?  $default,) {final _that = this;
switch (_that) {
case _VoiceAssistantState() when $default != null:
return $default(_that.phase,_that.heard,_that.reply,_that.askingServer,_that.failed,_that.wakeWordListening);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceAssistantState extends VoiceAssistantState {
  const _VoiceAssistantState({this.phase = VoiceAssistantPhase.idle, this.heard = '', this.reply, this.askingServer = false, this.failed = false, this.wakeWordListening = false}): super._();
  

@override@JsonKey() final  VoiceAssistantPhase phase;
/// What it heard you say so far. Grows while you talk, and is final from
/// [VoiceAssistantPhase.thinking] on.
@override@JsonKey() final  String heard;
/// What it answered, once it has.
@override final  String? reply;
/// Whether the answer is coming from the AI server rather than the car.
@override@JsonKey() final  bool askingServer;
/// Whether it ended because something went wrong, rather than with an
/// answer.
@override@JsonKey() final  bool failed;
/// Whether it is waiting for the wake word right now.
@override@JsonKey() final  bool wakeWordListening;

/// Create a copy of VoiceAssistantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceAssistantStateCopyWith<_VoiceAssistantState> get copyWith => __$VoiceAssistantStateCopyWithImpl<_VoiceAssistantState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceAssistantState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.heard, heard) || other.heard == heard)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.askingServer, askingServer) || other.askingServer == askingServer)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.wakeWordListening, wakeWordListening) || other.wakeWordListening == wakeWordListening));
}


@override
int get hashCode => Object.hash(runtimeType,phase,heard,reply,askingServer,failed,wakeWordListening);

@override
String toString() {
  return 'VoiceAssistantState(phase: $phase, heard: $heard, reply: $reply, askingServer: $askingServer, failed: $failed, wakeWordListening: $wakeWordListening)';
}


}

/// @nodoc
abstract mixin class _$VoiceAssistantStateCopyWith<$Res> implements $VoiceAssistantStateCopyWith<$Res> {
  factory _$VoiceAssistantStateCopyWith(_VoiceAssistantState value, $Res Function(_VoiceAssistantState) _then) = __$VoiceAssistantStateCopyWithImpl;
@override @useResult
$Res call({
 VoiceAssistantPhase phase, String heard, String? reply, bool askingServer, bool failed, bool wakeWordListening
});




}
/// @nodoc
class __$VoiceAssistantStateCopyWithImpl<$Res>
    implements _$VoiceAssistantStateCopyWith<$Res> {
  __$VoiceAssistantStateCopyWithImpl(this._self, this._then);

  final _VoiceAssistantState _self;
  final $Res Function(_VoiceAssistantState) _then;

/// Create a copy of VoiceAssistantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? heard = null,Object? reply = freezed,Object? askingServer = null,Object? failed = null,Object? wakeWordListening = null,}) {
  return _then(_VoiceAssistantState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as VoiceAssistantPhase,heard: null == heard ? _self.heard : heard // ignore: cast_nullable_to_non_nullable
as String,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String?,askingServer: null == askingServer ? _self.askingServer : askingServer // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,wakeWordListening: null == wakeWordListening ? _self.wakeWordListening : wakeWordListening // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
