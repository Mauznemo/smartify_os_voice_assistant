import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model_status.dart';

/// Internal: the speech models on the car, downloading new ones and deleting
/// old ones.
///
/// Each model lives in a folder of its own under [directory], which only
/// exists once it is complete: a download goes into `<folder>.part` and is
/// renamed when everything is in. So a car that lost power halfway never
/// mistakes half a model for a whole one, and the smartify-os CLI can put
/// models in place the same way.
///
/// On Linux the folder is `~/.local/share/smartify-os/voice_assistant/models`
/// whatever the app is called, so the CLI knows where to put them. Elsewhere
/// it is in the app's own support folder.
class SpeechModelStore {
  static const _tag = 'VoiceAssistant.Models';

  static final SpeechModelStore instance = SpeechModelStore._();
  SpeechModelStore._();

  final ValueStream<Map<String, SpeechModelStatus>> _statuses = ValueStream(
    const {},
  );

  /// Downloads running right now, by folder, so one can be cancelled.
  final Map<String, _Download> _downloads = {};

  Directory? _directory;

  /// Set by [cancelDownloads], so [downloadAll] stops before the next model.
  bool _cancelAll = false;

  /// Where the models are, once [start] has found it.
  Directory? get directory => _directory;

  /// Every model's status, by its folder.
  Map<String, SpeechModelStatus> get statuses => _statuses.value;

  /// Emits every time a model's status changes.
  Stream<Map<String, SpeechModelStatus>> get changes => _statuses.stream;

  /// Finds the folder and looks at what is in it. Never throws.
  Future<void> start({String? directory}) async {
    try {
      final dir = Directory(directory ?? await _defaultDirectory());
      await dir.create(recursive: true);
      _directory = dir;

      final statuses = <String, SpeechModelStatus>{};
      await for (final entity in dir.list()) {
        if (entity is! Directory) continue;
        final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
        if (name.endsWith('.part')) {
          // A download that never finished, from before the car restarted.
          unawaited(_deleteQuietly(entity));
          continue;
        }
        statuses[name] = const SpeechModelStatus(downloaded: true);
      }
      _statuses.value = Map.unmodifiable(statuses);
      SmartifyOsLog.info(
        _tag,
        'Models are in ${dir.path}: ${statuses.keys.join(', ')}',
      );
    } on Object catch (error) {
      SmartifyOsLog.error(_tag, 'Could not find the models folder', error);
    }
  }

  /// The status of [model].
  SpeechModelStatus statusOf(SpeechModel model) =>
      statuses[model.folder] ?? const SpeechModelStatus();

  /// Whether [model] is on the car and complete.
  bool isDownloaded(SpeechModel model) => statusOf(model).downloaded;

  /// Where one of [model]'s files is, by its role (`encoder`, `tokens`).
  String filePath(SpeechModel model, String role) =>
      '${_directory?.path}/${model.folder}/${model.files[role]}';

  /// Every one of [model]'s files by its role, as full paths.
  Map<String, String> filePaths(SpeechModel model) => {
    for (final role in model.files.keys) role: filePath(model, role),
  };

  /// How much space the downloaded models take, in megabytes, going by what
  /// the catalog says about each.
  int sizeOnCar(Iterable<SpeechModel> models) {
    final folders = <String, int>{};
    for (final model in models) {
      if (isDownloaded(model)) folders[model.folder] = model.sizeMb;
    }
    return folders.values.fold(0, (sum, size) => sum + size);
  }

  /// Downloads [model], unless it is already there or on its way. Finishes
  /// once it is in place, or failed. Never throws.
  Future<bool> download(SpeechModel model) async {
    final dir = _directory;
    if (dir == null) return false;
    if (isDownloaded(model)) return true;
    final running = _downloads[model.folder];
    if (running != null) return running.done.future;

    final download = _Download();
    _downloads[model.folder] = download;
    _setStatus(model.folder, const SpeechModelStatus(progress: 0));

    final partial = Directory('${dir.path}/${model.folder}.part');
    var ok = false;
    try {
      if (await partial.exists()) await partial.delete(recursive: true);
      await partial.create(recursive: true);

      final total = (model.sizeMb * 1024 * 1024).toDouble();
      var received = 0;
      void onBytes(int count) {
        received += count;
        final progress = (received / total).clamp(0.0, 0.99);
        // A step at a time, so a fast download does not rebuild the screen
        // for every packet.
        final shown = statusOf(model).progress ?? 0;
        if (progress - shown >= 0.01) {
          _setStatus(model.folder, SpeechModelStatus(progress: progress));
        }
      }

      for (final part in model.parts) {
        if (download.cancelled) break;
        await _downloadPart(part, partial, download, onBytes);
      }
      if (download.cancelled) throw const _Cancelled();

      final target = Directory('${dir.path}/${model.folder}');
      if (await target.exists()) await target.delete(recursive: true);
      await partial.rename(target.path);
      ok = true;
      _setStatus(model.folder, const SpeechModelStatus(downloaded: true));
      SmartifyOsLog.info(_tag, 'Downloaded ${model.id}');
    } on _Cancelled {
      _setStatus(model.folder, const SpeechModelStatus());
      SmartifyOsLog.info(_tag, 'Download of ${model.id} cancelled');
    } on Object catch (error) {
      _setStatus(model.folder, const SpeechModelStatus(failed: true));
      SmartifyOsLog.warning(_tag, 'Could not download ${model.id}', error);
    } finally {
      _downloads.remove(model.folder);
      if (!ok) unawaited(_deleteQuietly(partial));
      download.done.complete(ok);
    }
    return ok;
  }

  /// Downloads every one of [models] that is not on the car yet, one after
  /// the other. Finishes with whether all of them are there.
  Future<bool> downloadAll(Iterable<SpeechModel> models) async {
    _cancelAll = false;
    var ok = true;
    for (final model in models) {
      if (_cancelAll) return false;
      ok &= await download(model);
    }
    return ok;
  }

  /// Stops [downloadAll], and the download it is in the middle of.
  void cancelDownloads() {
    _cancelAll = true;
    for (final download in _downloads.values) {
      download.cancelled = true;
      download.client?.close(force: true);
    }
  }

  /// How far [models] are on the car together, from 0 to 1, by size: a
  /// model downloaded counts whole, one on its way by how far it got.
  double progressOf(Iterable<SpeechModel> models) {
    final byFolder = {for (final model in models) model.folder: model};
    final total = byFolder.values.fold(0, (sum, m) => sum + m.sizeMb);
    if (total == 0) return 1;
    var done = 0.0;
    for (final model in byFolder.values) {
      final status = statusOf(model);
      done += status.downloaded
          ? model.sizeMb
          : (status.progress ?? 0) * model.sizeMb;
    }
    return done / total;
  }

  /// Stops downloading [model], throwing away what came so far.
  void cancelDownload(SpeechModel model) {
    final download = _downloads[model.folder];
    if (download == null) return;
    download.cancelled = true;
    download.client?.close(force: true);
  }

  /// Deletes [model] from the car. Every other model in the same folder goes
  /// with it.
  Future<void> delete(SpeechModel model) async {
    final dir = _directory;
    if (dir == null) return;
    cancelDownload(model);
    await _deleteQuietly(Directory('${dir.path}/${model.folder}'));
    _setStatus(model.folder, const SpeechModelStatus());
  }

  /// Forgets everything. Only useful in tests.
  void reset() {
    for (final download in _downloads.values) {
      download.cancelled = true;
    }
    _downloads.clear();
    _directory = null;
    _statuses.forceSet(const {});
  }

  Future<void> _downloadPart(
    SpeechModelPart part,
    Directory into,
    _Download download,
    void Function(int count) onBytes,
  ) async {
    switch (part) {
      case SpeechModelFile(:final url, :final path):
        await _fetch(url, File('${into.path}/$path'), download, onBytes);
      case SpeechModelHuggingFaceFolder(:final repo, :final folder):
        for (final path in await _listHuggingFaceFolder(repo, folder)) {
          if (download.cancelled) return;
          await _fetch(
            'https://huggingface.co/$repo/resolve/main/$path',
            File('${into.path}/$path'),
            download,
            onBytes,
          );
        }
      case SpeechModelArchive(:final url, :final keep):
        final archive = File('${into.path}/.archive.tar.bz2');
        await _fetch(url, archive, download, onBytes);
        if (download.cancelled) return;
        // Unpacking takes a few seconds of solid work, which must not freeze
        // the screen.
        await Isolate.run(() => _unpack(archive.path, into.path, keep));
        await archive.delete();
    }
  }

  Future<List<String>> _listHuggingFaceFolder(
    String repo,
    String folder,
  ) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(
        Uri.parse(
          'https://huggingface.co/api/models/$repo/tree/main/$folder'
          '?recursive=true',
        ),
      );
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Listing $repo/$folder: ${response.statusCode}');
      }
      final body = await response.transform(utf8.decoder).join();
      return [
        for (final item in jsonDecode(body) as List<Object?>)
          if (item case {'type': 'file', 'path': final String path}) path,
      ];
    } finally {
      client.close();
    }
  }

  Future<void> _fetch(
    String url,
    File file,
    _Download download,
    void Function(int count) onBytes,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);
    download.client = client;
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('$url: ${response.statusCode}');
      }
      await file.parent.create(recursive: true);
      final sink = file.openWrite();
      try {
        await for (final chunk in response) {
          if (download.cancelled) throw const _Cancelled();
          sink.add(chunk);
          onBytes(chunk.length);
        }
      } finally {
        await sink.close();
      }
    } on Object {
      if (download.cancelled) throw const _Cancelled();
      rethrow;
    } finally {
      download.client = null;
      client.close();
    }
  }

  void _setStatus(String folder, SpeechModelStatus status) {
    _statuses.value = Map.unmodifiable({...statuses, folder: status});
  }

  static Future<void> _deleteQuietly(Directory dir) async {
    try {
      if (await dir.exists()) await dir.delete(recursive: true);
    } on Object catch (error) {
      SmartifyOsLog.debug(_tag, 'Could not delete ${dir.path}: $error');
    }
  }

  static Future<String> _defaultDirectory() async {
    if (Platform.isLinux) {
      final env = Platform.environment;
      final data = env['XDG_DATA_HOME'] ?? '${env['HOME']}/.local/share';
      return '$data/smartify-os/voice_assistant/models';
    }
    final support = await getApplicationSupportDirectory();
    return '${support.path}/voice_assistant/models';
  }
}

/// Unpacks the files in [keep] out of the `.tar.bz2` at [archivePath].
void _unpack(String archivePath, String into, Map<String, String> keep) {
  final bytes = File(archivePath).readAsBytesSync();
  final tar = TarDecoder().decodeBytes(BZip2Decoder().decodeBytes(bytes));
  for (final file in tar.files) {
    final target = keep[file.name];
    if (target == null || !file.isFile) continue;
    File('$into/$target')
      ..createSync(recursive: true)
      ..writeAsBytesSync(file.content);
  }
  final missing = keep.values.where(
    (path) => !File('$into/$path').existsSync(),
  );
  if (missing.isNotEmpty) {
    throw StateError('Missing from the archive: ${missing.join(', ')}');
  }
}

class _Download {
  final done = Completer<bool>();
  HttpClient? client;
  bool cancelled = false;
}

class _Cancelled implements Exception {
  const _Cancelled();
}
