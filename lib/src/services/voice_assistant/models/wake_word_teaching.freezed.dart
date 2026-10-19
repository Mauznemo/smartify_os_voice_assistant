// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wake_word_teaching.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearnedSpelling {

 String get spelling; int get heard;
/// Create a copy of LearnedSpelling
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearnedSpellingCopyWith<LearnedSpelling> get copyWith => _$LearnedSpellingCopyWithImpl<LearnedSpelling>(this as LearnedSpelling, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearnedSpelling&&(identical(other.spelling, spelling) || other.spelling == spelling)&&(identical(other.heard, heard) || other.heard == heard));
}


@override
int get hashCode => Object.hash(runtimeType,spelling,heard);

@override
String toString() {
  return 'LearnedSpelling(spelling: $spelling, heard: $heard)';
}


}

/// @nodoc
abstract mixin class $LearnedSpellingCopyWith<$Res>  {
  factory $LearnedSpellingCopyWith(LearnedSpelling value, $Res Function(LearnedSpelling) _then) = _$LearnedSpellingCopyWithImpl;
@useResult
$Res call({
 String spelling, int heard
});




}
/// @nodoc
class _$LearnedSpellingCopyWithImpl<$Res>
    implements $LearnedSpellingCopyWith<$Res> {
  _$LearnedSpellingCopyWithImpl(this._self, this._then);

  final LearnedSpelling _self;
  final $Res Function(LearnedSpelling) _then;

/// Create a copy of LearnedSpelling
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spelling = null,Object? heard = null,}) {
  return _then(_self.copyWith(
spelling: null == spelling ? _self.spelling : spelling // ignore: cast_nullable_to_non_nullable
as String,heard: null == heard ? _self.heard : heard // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LearnedSpelling].
extension LearnedSpellingPatterns on LearnedSpelling {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearnedSpelling value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearnedSpelling() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearnedSpelling value)  $default,){
final _that = this;
switch (_that) {
case _LearnedSpelling():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearnedSpelling value)?  $default,){
final _that = this;
switch (_that) {
case _LearnedSpelling() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spelling,  int heard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearnedSpelling() when $default != null:
return $default(_that.spelling,_that.heard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spelling,  int heard)  $default,) {final _that = this;
switch (_that) {
case _LearnedSpelling():
return $default(_that.spelling,_that.heard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spelling,  int heard)?  $default,) {final _that = this;
switch (_that) {
case _LearnedSpelling() when $default != null:
return $default(_that.spelling,_that.heard);case _:
  return null;

}
}

}

/// @nodoc


class _LearnedSpelling implements LearnedSpelling {
  const _LearnedSpelling({required this.spelling, required this.heard});
  

@override final  String spelling;
@override final  int heard;

/// Create a copy of LearnedSpelling
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearnedSpellingCopyWith<_LearnedSpelling> get copyWith => __$LearnedSpellingCopyWithImpl<_LearnedSpelling>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearnedSpelling&&(identical(other.spelling, spelling) || other.spelling == spelling)&&(identical(other.heard, heard) || other.heard == heard));
}


@override
int get hashCode => Object.hash(runtimeType,spelling,heard);

@override
String toString() {
  return 'LearnedSpelling(spelling: $spelling, heard: $heard)';
}


}

/// @nodoc
abstract mixin class _$LearnedSpellingCopyWith<$Res> implements $LearnedSpellingCopyWith<$Res> {
  factory _$LearnedSpellingCopyWith(_LearnedSpelling value, $Res Function(_LearnedSpelling) _then) = __$LearnedSpellingCopyWithImpl;
@override @useResult
$Res call({
 String spelling, int heard
});




}
/// @nodoc
class __$LearnedSpellingCopyWithImpl<$Res>
    implements _$LearnedSpellingCopyWith<$Res> {
  __$LearnedSpellingCopyWithImpl(this._self, this._then);

  final _LearnedSpelling _self;
  final $Res Function(_LearnedSpelling) _then;

/// Create a copy of LearnedSpelling
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spelling = null,Object? heard = null,}) {
  return _then(_LearnedSpelling(
spelling: null == spelling ? _self.spelling : spelling // ignore: cast_nullable_to_non_nullable
as String,heard: null == heard ? _self.heard : heard // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WakeWordTeaching {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeaching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WakeWordTeaching()';
}


}

/// @nodoc
class $WakeWordTeachingCopyWith<$Res>  {
$WakeWordTeachingCopyWith(WakeWordTeaching _, $Res Function(WakeWordTeaching) __);
}


/// Adds pattern-matching-related methods to [WakeWordTeaching].
extension WakeWordTeachingPatterns on WakeWordTeaching {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WakeWordTeachingIdle value)?  idle,TResult Function( WakeWordTeachingRecording value)?  recording,TResult Function( WakeWordTeachingWorking value)?  working,TResult Function( WakeWordTeachingDone value)?  done,TResult Function( WakeWordTeachingFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WakeWordTeachingIdle() when idle != null:
return idle(_that);case WakeWordTeachingRecording() when recording != null:
return recording(_that);case WakeWordTeachingWorking() when working != null:
return working(_that);case WakeWordTeachingDone() when done != null:
return done(_that);case WakeWordTeachingFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WakeWordTeachingIdle value)  idle,required TResult Function( WakeWordTeachingRecording value)  recording,required TResult Function( WakeWordTeachingWorking value)  working,required TResult Function( WakeWordTeachingDone value)  done,required TResult Function( WakeWordTeachingFailed value)  failed,}){
final _that = this;
switch (_that) {
case WakeWordTeachingIdle():
return idle(_that);case WakeWordTeachingRecording():
return recording(_that);case WakeWordTeachingWorking():
return working(_that);case WakeWordTeachingDone():
return done(_that);case WakeWordTeachingFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WakeWordTeachingIdle value)?  idle,TResult? Function( WakeWordTeachingRecording value)?  recording,TResult? Function( WakeWordTeachingWorking value)?  working,TResult? Function( WakeWordTeachingDone value)?  done,TResult? Function( WakeWordTeachingFailed value)?  failed,}){
final _that = this;
switch (_that) {
case WakeWordTeachingIdle() when idle != null:
return idle(_that);case WakeWordTeachingRecording() when recording != null:
return recording(_that);case WakeWordTeachingWorking() when working != null:
return working(_that);case WakeWordTeachingDone() when done != null:
return done(_that);case WakeWordTeachingFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( int recorded,  int wanted,  String? lastHeard,  bool lastLeftOut)?  recording,TResult Function( int tried,  int total)?  working,TResult Function( int recordings,  int before,  int after,  List<LearnedSpelling> learned)?  done,TResult Function( String reason)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WakeWordTeachingIdle() when idle != null:
return idle();case WakeWordTeachingRecording() when recording != null:
return recording(_that.recorded,_that.wanted,_that.lastHeard,_that.lastLeftOut);case WakeWordTeachingWorking() when working != null:
return working(_that.tried,_that.total);case WakeWordTeachingDone() when done != null:
return done(_that.recordings,_that.before,_that.after,_that.learned);case WakeWordTeachingFailed() when failed != null:
return failed(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( int recorded,  int wanted,  String? lastHeard,  bool lastLeftOut)  recording,required TResult Function( int tried,  int total)  working,required TResult Function( int recordings,  int before,  int after,  List<LearnedSpelling> learned)  done,required TResult Function( String reason)  failed,}) {final _that = this;
switch (_that) {
case WakeWordTeachingIdle():
return idle();case WakeWordTeachingRecording():
return recording(_that.recorded,_that.wanted,_that.lastHeard,_that.lastLeftOut);case WakeWordTeachingWorking():
return working(_that.tried,_that.total);case WakeWordTeachingDone():
return done(_that.recordings,_that.before,_that.after,_that.learned);case WakeWordTeachingFailed():
return failed(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( int recorded,  int wanted,  String? lastHeard,  bool lastLeftOut)?  recording,TResult? Function( int tried,  int total)?  working,TResult? Function( int recordings,  int before,  int after,  List<LearnedSpelling> learned)?  done,TResult? Function( String reason)?  failed,}) {final _that = this;
switch (_that) {
case WakeWordTeachingIdle() when idle != null:
return idle();case WakeWordTeachingRecording() when recording != null:
return recording(_that.recorded,_that.wanted,_that.lastHeard,_that.lastLeftOut);case WakeWordTeachingWorking() when working != null:
return working(_that.tried,_that.total);case WakeWordTeachingDone() when done != null:
return done(_that.recordings,_that.before,_that.after,_that.learned);case WakeWordTeachingFailed() when failed != null:
return failed(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class WakeWordTeachingIdle implements WakeWordTeaching {
  const WakeWordTeachingIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeachingIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WakeWordTeaching.idle()';
}


}




/// @nodoc


class WakeWordTeachingRecording implements WakeWordTeaching {
  const WakeWordTeachingRecording({required this.recorded, required this.wanted, this.lastHeard, this.lastLeftOut = false});
  

 final  int recorded;
 final  int wanted;
/// What it heard last, so the driver sees it is listening.
 final  String? lastHeard;
/// Whether the last thing heard did not sound like the wake word and
/// was left out.
@JsonKey() final  bool lastLeftOut;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WakeWordTeachingRecordingCopyWith<WakeWordTeachingRecording> get copyWith => _$WakeWordTeachingRecordingCopyWithImpl<WakeWordTeachingRecording>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeachingRecording&&(identical(other.recorded, recorded) || other.recorded == recorded)&&(identical(other.wanted, wanted) || other.wanted == wanted)&&(identical(other.lastHeard, lastHeard) || other.lastHeard == lastHeard)&&(identical(other.lastLeftOut, lastLeftOut) || other.lastLeftOut == lastLeftOut));
}


@override
int get hashCode => Object.hash(runtimeType,recorded,wanted,lastHeard,lastLeftOut);

@override
String toString() {
  return 'WakeWordTeaching.recording(recorded: $recorded, wanted: $wanted, lastHeard: $lastHeard, lastLeftOut: $lastLeftOut)';
}


}

/// @nodoc
abstract mixin class $WakeWordTeachingRecordingCopyWith<$Res> implements $WakeWordTeachingCopyWith<$Res> {
  factory $WakeWordTeachingRecordingCopyWith(WakeWordTeachingRecording value, $Res Function(WakeWordTeachingRecording) _then) = _$WakeWordTeachingRecordingCopyWithImpl;
@useResult
$Res call({
 int recorded, int wanted, String? lastHeard, bool lastLeftOut
});




}
/// @nodoc
class _$WakeWordTeachingRecordingCopyWithImpl<$Res>
    implements $WakeWordTeachingRecordingCopyWith<$Res> {
  _$WakeWordTeachingRecordingCopyWithImpl(this._self, this._then);

  final WakeWordTeachingRecording _self;
  final $Res Function(WakeWordTeachingRecording) _then;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recorded = null,Object? wanted = null,Object? lastHeard = freezed,Object? lastLeftOut = null,}) {
  return _then(WakeWordTeachingRecording(
recorded: null == recorded ? _self.recorded : recorded // ignore: cast_nullable_to_non_nullable
as int,wanted: null == wanted ? _self.wanted : wanted // ignore: cast_nullable_to_non_nullable
as int,lastHeard: freezed == lastHeard ? _self.lastHeard : lastHeard // ignore: cast_nullable_to_non_nullable
as String?,lastLeftOut: null == lastLeftOut ? _self.lastLeftOut : lastLeftOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class WakeWordTeachingWorking implements WakeWordTeaching {
  const WakeWordTeachingWorking({required this.tried, required this.total});
  

 final  int tried;
 final  int total;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WakeWordTeachingWorkingCopyWith<WakeWordTeachingWorking> get copyWith => _$WakeWordTeachingWorkingCopyWithImpl<WakeWordTeachingWorking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeachingWorking&&(identical(other.tried, tried) || other.tried == tried)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,tried,total);

@override
String toString() {
  return 'WakeWordTeaching.working(tried: $tried, total: $total)';
}


}

/// @nodoc
abstract mixin class $WakeWordTeachingWorkingCopyWith<$Res> implements $WakeWordTeachingCopyWith<$Res> {
  factory $WakeWordTeachingWorkingCopyWith(WakeWordTeachingWorking value, $Res Function(WakeWordTeachingWorking) _then) = _$WakeWordTeachingWorkingCopyWithImpl;
@useResult
$Res call({
 int tried, int total
});




}
/// @nodoc
class _$WakeWordTeachingWorkingCopyWithImpl<$Res>
    implements $WakeWordTeachingWorkingCopyWith<$Res> {
  _$WakeWordTeachingWorkingCopyWithImpl(this._self, this._then);

  final WakeWordTeachingWorking _self;
  final $Res Function(WakeWordTeachingWorking) _then;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tried = null,Object? total = null,}) {
  return _then(WakeWordTeachingWorking(
tried: null == tried ? _self.tried : tried // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class WakeWordTeachingDone implements WakeWordTeaching {
  const WakeWordTeachingDone({required this.recordings, required this.before, required this.after, required final  List<LearnedSpelling> learned}): _learned = learned;
  

 final  int recordings;
 final  int before;
 final  int after;
 final  List<LearnedSpelling> _learned;
 List<LearnedSpelling> get learned {
  if (_learned is EqualUnmodifiableListView) return _learned;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_learned);
}


/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WakeWordTeachingDoneCopyWith<WakeWordTeachingDone> get copyWith => _$WakeWordTeachingDoneCopyWithImpl<WakeWordTeachingDone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeachingDone&&(identical(other.recordings, recordings) || other.recordings == recordings)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&const DeepCollectionEquality().equals(other._learned, _learned));
}


@override
int get hashCode => Object.hash(runtimeType,recordings,before,after,const DeepCollectionEquality().hash(_learned));

@override
String toString() {
  return 'WakeWordTeaching.done(recordings: $recordings, before: $before, after: $after, learned: $learned)';
}


}

/// @nodoc
abstract mixin class $WakeWordTeachingDoneCopyWith<$Res> implements $WakeWordTeachingCopyWith<$Res> {
  factory $WakeWordTeachingDoneCopyWith(WakeWordTeachingDone value, $Res Function(WakeWordTeachingDone) _then) = _$WakeWordTeachingDoneCopyWithImpl;
@useResult
$Res call({
 int recordings, int before, int after, List<LearnedSpelling> learned
});




}
/// @nodoc
class _$WakeWordTeachingDoneCopyWithImpl<$Res>
    implements $WakeWordTeachingDoneCopyWith<$Res> {
  _$WakeWordTeachingDoneCopyWithImpl(this._self, this._then);

  final WakeWordTeachingDone _self;
  final $Res Function(WakeWordTeachingDone) _then;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recordings = null,Object? before = null,Object? after = null,Object? learned = null,}) {
  return _then(WakeWordTeachingDone(
recordings: null == recordings ? _self.recordings : recordings // ignore: cast_nullable_to_non_nullable
as int,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as int,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as int,learned: null == learned ? _self._learned : learned // ignore: cast_nullable_to_non_nullable
as List<LearnedSpelling>,
  ));
}


}

/// @nodoc


class WakeWordTeachingFailed implements WakeWordTeaching {
  const WakeWordTeachingFailed(this.reason);
  

 final  String reason;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WakeWordTeachingFailedCopyWith<WakeWordTeachingFailed> get copyWith => _$WakeWordTeachingFailedCopyWithImpl<WakeWordTeachingFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordTeachingFailed&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'WakeWordTeaching.failed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $WakeWordTeachingFailedCopyWith<$Res> implements $WakeWordTeachingCopyWith<$Res> {
  factory $WakeWordTeachingFailedCopyWith(WakeWordTeachingFailed value, $Res Function(WakeWordTeachingFailed) _then) = _$WakeWordTeachingFailedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$WakeWordTeachingFailedCopyWithImpl<$Res>
    implements $WakeWordTeachingFailedCopyWith<$Res> {
  _$WakeWordTeachingFailedCopyWithImpl(this._self, this._then);

  final WakeWordTeachingFailed _self;
  final $Res Function(WakeWordTeachingFailed) _then;

/// Create a copy of WakeWordTeaching
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(WakeWordTeachingFailed(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
