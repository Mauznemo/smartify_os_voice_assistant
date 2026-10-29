import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings_pages.dart';

/// `smartify_os_downloads.json`, which `smartify_os: downloads:` in pubspec.yaml names: every
/// model in [SpeechModels], in the format the smartify-os CLI reads (`src/core/downloads/` in
/// the CLI), so it can put them on a car with its app. A car often has no internet to
/// download them in Settings.
///
/// The file is written from the catalog here, so the two never drift apart: when they do,
/// this test writes it again and fails, and the new file only has to be committed.
void main() {
  tearDown(() => SpeechModels.lightweightForTesting = null);

  test('the defaults are what the extension runs with on each kind of car', () {
    for (final (arch, lightweight) in [('x64', false), ('arm64', true)]) {
      SpeechModels.lightweightForTesting = lightweight;
      final english = SpeechModels.voicesInOrder.firstWhere(
        (v) => v.supports('en'),
      );
      final picked = {
        for (final MapEntry(:key, :value) in _defaults.entries)
          if (value.contains(arch)) key,
      };
      expect(picked, {SpeechModels.defaultRecognizer, english}, reason: arch);
    }
  });

  test(
    'smartify_os_downloads.json lists every speech model as SpeechModels has it',
    () {
      final file = File('smartify_os_downloads.json');
      final written = file.existsSync() ? file.readAsStringSync() : '';
      final wanted =
          '${const JsonEncoder.withIndent('  ').convert(_downloads())}\n';
      if (written != wanted) {
        file.writeAsStringSync(wanted);
        fail(
          'smartify_os_downloads.json was out of date, and is written again. Commit it.',
        );
      }
    },
  );
}

/// How lib/main.dart writes each model, which is how the CLI tells which one a setting picks.
final _written = {
  SpeechModels.parakeet: 'SpeechModels.parakeet',
  SpeechModels.whisperBase: 'SpeechModels.whisperBase',
  SpeechModels.whisperTiny: 'SpeechModels.whisperTiny',
  SpeechModels.moonshineBase: 'SpeechModels.moonshineBase',
  SpeechModels.moonshineTiny: 'SpeechModels.moonshineTiny',
  SpeechModels.kokoroFable: 'SpeechModels.kokoroFable',
  SpeechModels.piperAlan: 'SpeechModels.piperAlan',
  SpeechModels.piperThorsten: 'SpeechModels.piperThorsten',
  SpeechModels.wakeWord: 'SpeechModels.wakeWord',
  SpeechModels.voiceDetection: 'SpeechModels.voiceDetection',
};

/// What goes on a car unless its owner says otherwise. The recognizer and the voices the app
/// sets win over these, so these are what it runs with when it sets none:
/// [SpeechModels.defaultRecognizer] and the first English voice of
/// [SpeechModels.voicesInOrder], on a PC and on a Raspberry Pi (arm64). The test below keeps
/// the two in step.
final _defaults = {
  SpeechModels.parakeet: ['x64'],
  SpeechModels.whisperBase: ['arm64'],
  SpeechModels.kokoroFable: ['x64'],
  SpeechModels.piperAlan: ['arm64'],
};

Map<String, Object?> _downloads() {
  final missing = SpeechModels.all.where(
    (model) => !_written.containsKey(model),
  );
  expect(
    missing.map((m) => m.id),
    isEmpty,
    reason: 'Say how lib/main.dart writes every model above.',
  );

  return {
    'folder': 'voice_assistant/models',
    'items': [for (final model in SpeechModels.all) _item(model)],
  };
}

Map<String, Object?> _item(SpeechModel model) {
  final setting = switch (model.kind) {
    SpeechModelKind.recognizer => 'recognizer',
    SpeechModelKind.voice => 'voices',
    _ => null,
  };
  final kind = switch (model.kind) {
    SpeechModelKind.recognizer => ' (speech recognition)',
    SpeechModelKind.voice => ' (voice)',
    _ => '',
  };
  return {
    'id': model.id,
    'title': '${speechModelTitle(model)}$kind',
    'about': speechModelAbout(model),
    'folder': model.folder,
    'sizeMb': model.sizeMb,
    // Every car needs these two, and they are 7 MB together.
    if (setting == null) 'required': true,
    'default': ?_defaults[model],
    if (setting != null) ...{'setting': setting, 'value': _written[model]},
    'files': [
      for (final part in model.parts)
        switch (part) {
          SpeechModelFile(:final url, :final path) => {
            'url': url,
            'path': path,
          },
          SpeechModelHuggingFaceFolder(:final repo, :final folder) => {
            'huggingFace': repo,
            'folder': folder,
          },
          SpeechModelArchive(:final url, :final keep) => {
            'archive': url,
            'keep': keep,
          },
        },
    ],
  };
}
