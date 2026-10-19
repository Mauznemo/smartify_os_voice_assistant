// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wake_word_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WakeWordLogEntry {

 DateTime get time;/// Whether this was the wake word, rather than only something said.
 bool get wakeWord;/// The way of saying the wake word that was heard, or what was said.
 String get text;
/// Create a copy of WakeWordLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WakeWordLogEntryCopyWith<WakeWordLogEntry> get copyWith => _$WakeWordLogEntryCopyWithImpl<WakeWordLogEntry>(this as WakeWordLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WakeWordLogEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.wakeWord, wakeWord) || other.wakeWord == wakeWord)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,time,wakeWord,text);

@override
String toString() {
  return 'WakeWordLogEntry(time: $time, wakeWord: $wakeWord, text: $text)';
}


}

/// @nodoc
abstract mixin class $WakeWordLogEntryCopyWith<$Res>  {
  factory $WakeWordLogEntryCopyWith(WakeWordLogEntry value, $Res Function(WakeWordLogEntry) _then) = _$WakeWordLogEntryCopyWithImpl;
@useResult
$Res call({
 DateTime time, bool wakeWord, String text
});




}
/// @nodoc
class _$WakeWordLogEntryCopyWithImpl<$Res>
    implements $WakeWordLogEntryCopyWith<$Res> {
  _$WakeWordLogEntryCopyWithImpl(this._self, this._then);

  final WakeWordLogEntry _self;
  final $Res Function(WakeWordLogEntry) _then;

/// Create a copy of WakeWordLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? wakeWord = null,Object? text = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,wakeWord: null == wakeWord ? _self.wakeWord : wakeWord // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WakeWordLogEntry].
extension WakeWordLogEntryPatterns on WakeWordLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WakeWordLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WakeWordLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WakeWordLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _WakeWordLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WakeWordLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WakeWordLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  bool wakeWord,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WakeWordLogEntry() when $default != null:
return $default(_that.time,_that.wakeWord,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  bool wakeWord,  String text)  $default,) {final _that = this;
switch (_that) {
case _WakeWordLogEntry():
return $default(_that.time,_that.wakeWord,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  bool wakeWord,  String text)?  $default,) {final _that = this;
switch (_that) {
case _WakeWordLogEntry() when $default != null:
return $default(_that.time,_that.wakeWord,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _WakeWordLogEntry implements WakeWordLogEntry {
  const _WakeWordLogEntry({required this.time, required this.wakeWord, required this.text});
  

@override final  DateTime time;
/// Whether this was the wake word, rather than only something said.
@override final  bool wakeWord;
/// The way of saying the wake word that was heard, or what was said.
@override final  String text;

/// Create a copy of WakeWordLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WakeWordLogEntryCopyWith<_WakeWordLogEntry> get copyWith => __$WakeWordLogEntryCopyWithImpl<_WakeWordLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WakeWordLogEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.wakeWord, wakeWord) || other.wakeWord == wakeWord)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,time,wakeWord,text);

@override
String toString() {
  return 'WakeWordLogEntry(time: $time, wakeWord: $wakeWord, text: $text)';
}


}

/// @nodoc
abstract mixin class _$WakeWordLogEntryCopyWith<$Res> implements $WakeWordLogEntryCopyWith<$Res> {
  factory _$WakeWordLogEntryCopyWith(_WakeWordLogEntry value, $Res Function(_WakeWordLogEntry) _then) = __$WakeWordLogEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, bool wakeWord, String text
});




}
/// @nodoc
class __$WakeWordLogEntryCopyWithImpl<$Res>
    implements _$WakeWordLogEntryCopyWith<$Res> {
  __$WakeWordLogEntryCopyWithImpl(this._self, this._then);

  final _WakeWordLogEntry _self;
  final $Res Function(_WakeWordLogEntry) _then;

/// Create a copy of WakeWordLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? wakeWord = null,Object? text = null,}) {
  return _then(_WakeWordLogEntry(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,wakeWord: null == wakeWord ? _self.wakeWord : wakeWord // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
