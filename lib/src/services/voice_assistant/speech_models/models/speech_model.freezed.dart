// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeechModelPart {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelPart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SpeechModelPart()';
}


}

/// @nodoc
class $SpeechModelPartCopyWith<$Res>  {
$SpeechModelPartCopyWith(SpeechModelPart _, $Res Function(SpeechModelPart) __);
}


/// Adds pattern-matching-related methods to [SpeechModelPart].
extension SpeechModelPartPatterns on SpeechModelPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SpeechModelFile value)?  file,TResult Function( SpeechModelHuggingFaceFolder value)?  huggingFaceFolder,TResult Function( SpeechModelArchive value)?  archive,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SpeechModelFile() when file != null:
return file(_that);case SpeechModelHuggingFaceFolder() when huggingFaceFolder != null:
return huggingFaceFolder(_that);case SpeechModelArchive() when archive != null:
return archive(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SpeechModelFile value)  file,required TResult Function( SpeechModelHuggingFaceFolder value)  huggingFaceFolder,required TResult Function( SpeechModelArchive value)  archive,}){
final _that = this;
switch (_that) {
case SpeechModelFile():
return file(_that);case SpeechModelHuggingFaceFolder():
return huggingFaceFolder(_that);case SpeechModelArchive():
return archive(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SpeechModelFile value)?  file,TResult? Function( SpeechModelHuggingFaceFolder value)?  huggingFaceFolder,TResult? Function( SpeechModelArchive value)?  archive,}){
final _that = this;
switch (_that) {
case SpeechModelFile() when file != null:
return file(_that);case SpeechModelHuggingFaceFolder() when huggingFaceFolder != null:
return huggingFaceFolder(_that);case SpeechModelArchive() when archive != null:
return archive(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String url,  String path)?  file,TResult Function( String repo,  String folder)?  huggingFaceFolder,TResult Function( String url,  Map<String, String> keep)?  archive,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SpeechModelFile() when file != null:
return file(_that.url,_that.path);case SpeechModelHuggingFaceFolder() when huggingFaceFolder != null:
return huggingFaceFolder(_that.repo,_that.folder);case SpeechModelArchive() when archive != null:
return archive(_that.url,_that.keep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String url,  String path)  file,required TResult Function( String repo,  String folder)  huggingFaceFolder,required TResult Function( String url,  Map<String, String> keep)  archive,}) {final _that = this;
switch (_that) {
case SpeechModelFile():
return file(_that.url,_that.path);case SpeechModelHuggingFaceFolder():
return huggingFaceFolder(_that.repo,_that.folder);case SpeechModelArchive():
return archive(_that.url,_that.keep);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String url,  String path)?  file,TResult? Function( String repo,  String folder)?  huggingFaceFolder,TResult? Function( String url,  Map<String, String> keep)?  archive,}) {final _that = this;
switch (_that) {
case SpeechModelFile() when file != null:
return file(_that.url,_that.path);case SpeechModelHuggingFaceFolder() when huggingFaceFolder != null:
return huggingFaceFolder(_that.repo,_that.folder);case SpeechModelArchive() when archive != null:
return archive(_that.url,_that.keep);case _:
  return null;

}
}

}

/// @nodoc


class SpeechModelFile implements SpeechModelPart {
  const SpeechModelFile({required this.url, required this.path});
  

 final  String url;
 final  String path;

/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelFileCopyWith<SpeechModelFile> get copyWith => _$SpeechModelFileCopyWithImpl<SpeechModelFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelFile&&(identical(other.url, url) || other.url == url)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,url,path);

@override
String toString() {
  return 'SpeechModelPart.file(url: $url, path: $path)';
}


}

/// @nodoc
abstract mixin class $SpeechModelFileCopyWith<$Res> implements $SpeechModelPartCopyWith<$Res> {
  factory $SpeechModelFileCopyWith(SpeechModelFile value, $Res Function(SpeechModelFile) _then) = _$SpeechModelFileCopyWithImpl;
@useResult
$Res call({
 String url, String path
});




}
/// @nodoc
class _$SpeechModelFileCopyWithImpl<$Res>
    implements $SpeechModelFileCopyWith<$Res> {
  _$SpeechModelFileCopyWithImpl(this._self, this._then);

  final SpeechModelFile _self;
  final $Res Function(SpeechModelFile) _then;

/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,Object? path = null,}) {
  return _then(SpeechModelFile(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SpeechModelHuggingFaceFolder implements SpeechModelPart {
  const SpeechModelHuggingFaceFolder({required this.repo, required this.folder});
  

 final  String repo;
 final  String folder;

/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelHuggingFaceFolderCopyWith<SpeechModelHuggingFaceFolder> get copyWith => _$SpeechModelHuggingFaceFolderCopyWithImpl<SpeechModelHuggingFaceFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelHuggingFaceFolder&&(identical(other.repo, repo) || other.repo == repo)&&(identical(other.folder, folder) || other.folder == folder));
}


@override
int get hashCode => Object.hash(runtimeType,repo,folder);

@override
String toString() {
  return 'SpeechModelPart.huggingFaceFolder(repo: $repo, folder: $folder)';
}


}

/// @nodoc
abstract mixin class $SpeechModelHuggingFaceFolderCopyWith<$Res> implements $SpeechModelPartCopyWith<$Res> {
  factory $SpeechModelHuggingFaceFolderCopyWith(SpeechModelHuggingFaceFolder value, $Res Function(SpeechModelHuggingFaceFolder) _then) = _$SpeechModelHuggingFaceFolderCopyWithImpl;
@useResult
$Res call({
 String repo, String folder
});




}
/// @nodoc
class _$SpeechModelHuggingFaceFolderCopyWithImpl<$Res>
    implements $SpeechModelHuggingFaceFolderCopyWith<$Res> {
  _$SpeechModelHuggingFaceFolderCopyWithImpl(this._self, this._then);

  final SpeechModelHuggingFaceFolder _self;
  final $Res Function(SpeechModelHuggingFaceFolder) _then;

/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? repo = null,Object? folder = null,}) {
  return _then(SpeechModelHuggingFaceFolder(
repo: null == repo ? _self.repo : repo // ignore: cast_nullable_to_non_nullable
as String,folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SpeechModelArchive implements SpeechModelPart {
  const SpeechModelArchive({required this.url, required final  Map<String, String> keep}): _keep = keep;
  

 final  String url;
 final  Map<String, String> _keep;
 Map<String, String> get keep {
  if (_keep is EqualUnmodifiableMapView) return _keep;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_keep);
}


/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelArchiveCopyWith<SpeechModelArchive> get copyWith => _$SpeechModelArchiveCopyWithImpl<SpeechModelArchive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelArchive&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._keep, _keep));
}


@override
int get hashCode => Object.hash(runtimeType,url,const DeepCollectionEquality().hash(_keep));

@override
String toString() {
  return 'SpeechModelPart.archive(url: $url, keep: $keep)';
}


}

/// @nodoc
abstract mixin class $SpeechModelArchiveCopyWith<$Res> implements $SpeechModelPartCopyWith<$Res> {
  factory $SpeechModelArchiveCopyWith(SpeechModelArchive value, $Res Function(SpeechModelArchive) _then) = _$SpeechModelArchiveCopyWithImpl;
@useResult
$Res call({
 String url, Map<String, String> keep
});




}
/// @nodoc
class _$SpeechModelArchiveCopyWithImpl<$Res>
    implements $SpeechModelArchiveCopyWith<$Res> {
  _$SpeechModelArchiveCopyWithImpl(this._self, this._then);

  final SpeechModelArchive _self;
  final $Res Function(SpeechModelArchive) _then;

/// Create a copy of SpeechModelPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,Object? keep = null,}) {
  return _then(SpeechModelArchive(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,keep: null == keep ? _self._keep : keep // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc
mixin _$SpeechModel {

/// A short name for it, unique among all models.
 String get id; SpeechModelKind get kind;/// Internal: how it is loaded.
 SpeechEngine get engine;/// The folder it is kept in. Voices that share their files (several
/// voices of one model) share a folder too, and are downloaded once.
 String get folder;/// What to download into [folder].
 List<SpeechModelPart> get parts;/// Internal: which file in [folder] is which part of the network, by the
/// name sherpa-onnx gives it (`encoder`, `tokens`, ...).
 Map<String, String> get files;/// The languages it understands or speaks, as two letter codes. Empty for
/// almost all of them.
 Set<String> get languages;/// Roughly how much space it takes, in megabytes.
 int get sizeMb;/// Which of the voices in the files this is, for a voice model with
/// several.
 int get speaker;/// The name shown in Settings, for a model SmartifyOS does not know.
 String? get title;/// What it is good at, for a model SmartifyOS does not know.
 String? get about;
/// Create a copy of SpeechModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelCopyWith<SpeechModel> get copyWith => _$SpeechModelCopyWithImpl<SpeechModel>(this as SpeechModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.sizeMb, sizeMb) || other.sizeMb == sizeMb)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.title, title) || other.title == title)&&(identical(other.about, about) || other.about == about));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,engine,folder,const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(languages),sizeMb,speaker,title,about);

@override
String toString() {
  return 'SpeechModel(id: $id, kind: $kind, engine: $engine, folder: $folder, parts: $parts, files: $files, languages: $languages, sizeMb: $sizeMb, speaker: $speaker, title: $title, about: $about)';
}


}

/// @nodoc
abstract mixin class $SpeechModelCopyWith<$Res>  {
  factory $SpeechModelCopyWith(SpeechModel value, $Res Function(SpeechModel) _then) = _$SpeechModelCopyWithImpl;
@useResult
$Res call({
 String id, SpeechModelKind kind, SpeechEngine engine, String folder, List<SpeechModelPart> parts, Map<String, String> files, Set<String> languages, int sizeMb, int speaker, String? title, String? about
});




}
/// @nodoc
class _$SpeechModelCopyWithImpl<$Res>
    implements $SpeechModelCopyWith<$Res> {
  _$SpeechModelCopyWithImpl(this._self, this._then);

  final SpeechModel _self;
  final $Res Function(SpeechModel) _then;

/// Create a copy of SpeechModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? engine = null,Object? folder = null,Object? parts = null,Object? files = null,Object? languages = null,Object? sizeMb = null,Object? speaker = null,Object? title = freezed,Object? about = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpeechModelKind,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as SpeechEngine,folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<SpeechModelPart>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as Map<String, String>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as Set<String>,sizeMb: null == sizeMb ? _self.sizeMb : sizeMb // ignore: cast_nullable_to_non_nullable
as int,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechModel].
extension SpeechModelPatterns on SpeechModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechModel value)  $default,){
final _that = this;
switch (_that) {
case _SpeechModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SpeechModelKind kind,  SpeechEngine engine,  String folder,  List<SpeechModelPart> parts,  Map<String, String> files,  Set<String> languages,  int sizeMb,  int speaker,  String? title,  String? about)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechModel() when $default != null:
return $default(_that.id,_that.kind,_that.engine,_that.folder,_that.parts,_that.files,_that.languages,_that.sizeMb,_that.speaker,_that.title,_that.about);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SpeechModelKind kind,  SpeechEngine engine,  String folder,  List<SpeechModelPart> parts,  Map<String, String> files,  Set<String> languages,  int sizeMb,  int speaker,  String? title,  String? about)  $default,) {final _that = this;
switch (_that) {
case _SpeechModel():
return $default(_that.id,_that.kind,_that.engine,_that.folder,_that.parts,_that.files,_that.languages,_that.sizeMb,_that.speaker,_that.title,_that.about);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SpeechModelKind kind,  SpeechEngine engine,  String folder,  List<SpeechModelPart> parts,  Map<String, String> files,  Set<String> languages,  int sizeMb,  int speaker,  String? title,  String? about)?  $default,) {final _that = this;
switch (_that) {
case _SpeechModel() when $default != null:
return $default(_that.id,_that.kind,_that.engine,_that.folder,_that.parts,_that.files,_that.languages,_that.sizeMb,_that.speaker,_that.title,_that.about);case _:
  return null;

}
}

}

/// @nodoc


class _SpeechModel extends SpeechModel {
  const _SpeechModel({required this.id, required this.kind, required this.engine, required this.folder, required final  List<SpeechModelPart> parts, required final  Map<String, String> files, final  Set<String> languages = const <String>{}, this.sizeMb = 0, this.speaker = 0, this.title, this.about}): _parts = parts,_files = files,_languages = languages,super._();
  

/// A short name for it, unique among all models.
@override final  String id;
@override final  SpeechModelKind kind;
/// Internal: how it is loaded.
@override final  SpeechEngine engine;
/// The folder it is kept in. Voices that share their files (several
/// voices of one model) share a folder too, and are downloaded once.
@override final  String folder;
/// What to download into [folder].
 final  List<SpeechModelPart> _parts;
/// What to download into [folder].
@override List<SpeechModelPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

/// Internal: which file in [folder] is which part of the network, by the
/// name sherpa-onnx gives it (`encoder`, `tokens`, ...).
 final  Map<String, String> _files;
/// Internal: which file in [folder] is which part of the network, by the
/// name sherpa-onnx gives it (`encoder`, `tokens`, ...).
@override Map<String, String> get files {
  if (_files is EqualUnmodifiableMapView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_files);
}

/// The languages it understands or speaks, as two letter codes. Empty for
/// almost all of them.
 final  Set<String> _languages;
/// The languages it understands or speaks, as two letter codes. Empty for
/// almost all of them.
@override@JsonKey() Set<String> get languages {
  if (_languages is EqualUnmodifiableSetView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_languages);
}

/// Roughly how much space it takes, in megabytes.
@override@JsonKey() final  int sizeMb;
/// Which of the voices in the files this is, for a voice model with
/// several.
@override@JsonKey() final  int speaker;
/// The name shown in Settings, for a model SmartifyOS does not know.
@override final  String? title;
/// What it is good at, for a model SmartifyOS does not know.
@override final  String? about;

/// Create a copy of SpeechModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechModelCopyWith<_SpeechModel> get copyWith => __$SpeechModelCopyWithImpl<_SpeechModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other._parts, _parts)&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.sizeMb, sizeMb) || other.sizeMb == sizeMb)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.title, title) || other.title == title)&&(identical(other.about, about) || other.about == about));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,engine,folder,const DeepCollectionEquality().hash(_parts),const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_languages),sizeMb,speaker,title,about);

@override
String toString() {
  return 'SpeechModel(id: $id, kind: $kind, engine: $engine, folder: $folder, parts: $parts, files: $files, languages: $languages, sizeMb: $sizeMb, speaker: $speaker, title: $title, about: $about)';
}


}

/// @nodoc
abstract mixin class _$SpeechModelCopyWith<$Res> implements $SpeechModelCopyWith<$Res> {
  factory _$SpeechModelCopyWith(_SpeechModel value, $Res Function(_SpeechModel) _then) = __$SpeechModelCopyWithImpl;
@override @useResult
$Res call({
 String id, SpeechModelKind kind, SpeechEngine engine, String folder, List<SpeechModelPart> parts, Map<String, String> files, Set<String> languages, int sizeMb, int speaker, String? title, String? about
});




}
/// @nodoc
class __$SpeechModelCopyWithImpl<$Res>
    implements _$SpeechModelCopyWith<$Res> {
  __$SpeechModelCopyWithImpl(this._self, this._then);

  final _SpeechModel _self;
  final $Res Function(_SpeechModel) _then;

/// Create a copy of SpeechModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? engine = null,Object? folder = null,Object? parts = null,Object? files = null,Object? languages = null,Object? sizeMb = null,Object? speaker = null,Object? title = freezed,Object? about = freezed,}) {
  return _then(_SpeechModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SpeechModelKind,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as SpeechEngine,folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<SpeechModelPart>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as Map<String, String>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as Set<String>,sizeMb: null == sizeMb ? _self.sizeMb : sizeMb // ignore: cast_nullable_to_non_nullable
as int,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
