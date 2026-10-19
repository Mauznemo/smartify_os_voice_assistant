import 'package:flutter/material.dart';
import 'package:smartify_os_core/language.dart';
import 'package:smartify_os_core/modals.dart';
import 'package:smartify_os_core/settings.dart';
import 'package:smartify_os_core/widgets.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/providers/voice_assistant_provider.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_commands_registry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_sensitivity.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/smartify_os_voice_assistant.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model_status.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings.dart';
import 'package:smartify_os_voice_assistant/src/widgets/voice_assistant_setup_page.dart';
import 'package:smartify_os_voice_assistant/src/widgets/wake_word_debug_view.dart';
import 'package:smartify_os_voice_assistant/src/widgets/wake_word_teach_page.dart';

/// The `id`s of the voice assistant's settings pages.
abstract final class VoiceAssistantSettingsPages {
  static const main = 'voice_assistant';

  /// Downloads everything the driver's picks need, in one go.
  static const setup = 'voice_assistant.setup';

  /// Teaches it how the driver says the wake word.
  static const teach = 'voice_assistant.teach';
  static const models = 'voice_assistant.models';
  static const commands = 'voice_assistant.commands';
  static const developer = 'voice_assistant.developer';
}

/// Internal: the voice assistant's pages in Settings.
List<SettingsPage> voiceAssistantSettingsPages() => [
  SettingsPage.builder(
    id: VoiceAssistantSettingsPages.main,
    title: t.voice_assistant.title,
    icon: const Icon(Icons.mic),
    entries: _mainEntries,
  ),
  SettingsPage.custom(
    id: VoiceAssistantSettingsPages.setup,
    parent: VoiceAssistantSettingsPages.main,
    title: t.settings.setup,
    subtitle: t.settings.setup_subtitle,
    icon: const Icon(Icons.download_for_offline),
    // At the top, where it is found first.
    order: 0,
    body: (_) => const VoiceAssistantSetupPage(),
  ),
  SettingsPage.custom(
    id: VoiceAssistantSettingsPages.teach,
    parent: VoiceAssistantSettingsPages.main,
    title: t.teach.title,
    subtitle: t.teach.subtitle,
    icon: const Icon(Icons.record_voice_over),
    section: t.settings.listening,
    order: 15,
    body: (_) => const WakeWordTeachPage(),
  ),
  SettingsPage.builder(
    id: VoiceAssistantSettingsPages.models,
    parent: VoiceAssistantSettingsPages.main,
    title: t.settings.models,
    subtitle: t.settings.models_subtitle,
    icon: const Icon(Icons.download),
    order: 200,
    entries: _modelEntries,
  ),
  SettingsPage.builder(
    id: VoiceAssistantSettingsPages.commands,
    parent: VoiceAssistantSettingsPages.main,
    title: t.settings.commands,
    subtitle: t.settings.commands_subtitle,
    icon: const Icon(Icons.record_voice_over),
    order: 210,
    entries: _commandEntries,
  ),
  SettingsPage(
    id: VoiceAssistantSettingsPages.developer,
    parent: SettingsPages.developer,
    title: t.voice_assistant.title,
    icon: const Icon(Icons.mic),
    entries: [
      SettingsEntry.custom(
        id: 'try_sentence',
        title: t.settings.try_sentence,
        builder: (settings) => const _TrySentence(),
      ),
      SettingsEntry.custom(
        id: 'what_it_hears',
        title: t.settings.debug_wake_word,
        section: t.settings.debug_wake_word,
        builder: (settings) => const WakeWordDebugView(),
      ),
    ],
  ),
];

VoiceAssistantService get _service => VoiceAssistantService.instance;

List<SettingsEntry> _mainEntries(SettingsContext settings) {
  // Rebuilds as models arrive, so their rows say so.
  settings.ref.watch(speechModelStatusesProvider);
  final store = SpeechModelStore.instance;
  final saved = _service.settings;
  final setup = _service.setup;
  final language = SmartifyOsLanguage.languageCode;
  final wakeWordReady = store.isDownloaded(SpeechModels.wakeWord);

  return [
    SettingsEntry.toggle(
      id: 'wake_word',
      title: t.settings.wake_word,
      subtitle: wakeWordReady
          ? t.settings.wake_word_subtitle(phrase: setup.wakeWord)
          : t.settings.wake_word_needs_model,
      section: t.settings.listening,
      saved: saved.wakeWord,
      order: 10,
    ),
    SettingsEntry.choice<String>(
      id: 'sensitivity',
      title: t.settings.sensitivity,
      section: t.settings.listening,
      saved: saved.sensitivity,
      order: 20,
      visible: (_) => saved.wakeWord.value,
      options: [
        SettingsChoice(
          WakeWordSensitivity.low.name,
          t.settings.sensitivity_low,
          subtitle: t.settings.sensitivity_low_subtitle,
        ),
        SettingsChoice(
          WakeWordSensitivity.normal.name,
          t.settings.sensitivity_normal,
        ),
        SettingsChoice(
          WakeWordSensitivity.high.name,
          t.settings.sensitivity_high,
          subtitle: t.settings.sensitivity_high_subtitle,
        ),
      ],
    ),
    SettingsEntry.choice<String>(
      id: 'recognizer',
      title: t.settings.recognizer,
      section: t.settings.recognition,
      saved: saved.recognizer,
      order: 30,
      options: [
        for (final model in _service.recognizerModels)
          SettingsChoice(
            model.id,
            speechModelTitle(model),
            subtitle: _modelSubtitle(model, store.statusOf(model)),
          ),
      ],
    ),
    SettingsEntry.toggle(
      id: 'speak_answers',
      title: t.settings.speak_answers,
      section: t.settings.answers,
      saved: saved.speakAnswers,
      order: 40,
    ),
    SettingsEntry.choice<String>(
      id: 'voice',
      title: t.settings.voice,
      section: t.settings.answers,
      saved: _service.voiceSettingFor(language),
      order: 50,
      visible: (_) => saved.speakAnswers.value,
      options: [
        for (final model in _service.voiceModelsFor(language))
          SettingsChoice(
            model.id,
            speechModelTitle(model),
            subtitle: _modelSubtitle(model, store.statusOf(model)),
          ),
        if (setup.speechServer != null)
          SettingsChoice(
            VoiceAssistantSettings.server,
            t.settings.voice_server,
            subtitle: t.settings.voice_server_subtitle,
          ),
      ],
    ),
    if (setup.aiServer != null)
      SettingsEntry.toggle(
        id: 'use_ai',
        title: t.settings.use_ai,
        subtitle: t.settings.use_ai_subtitle,
        section: t.settings.ai,
        saved: saved.useAiServer,
        order: 60,
      ),
  ];
}

List<SettingsEntry> _modelEntries(SettingsContext settings) {
  settings.ref.watch(speechModelStatusesProvider);
  final store = SpeechModelStore.instance;
  final models = {
    ..._service.recognizerModels,
    for (final language in SmartifyOsLanguage.supportedLanguages)
      ..._service.voiceModelsFor(language),
    ...SpeechModels.voices,
    SpeechModels.wakeWord,
    SpeechModels.voiceDetection,
  };

  return [
    for (final model in models)
      SettingsEntry.action(
        id: model.id,
        title: speechModelTitle(model),
        subtitle: _modelSubtitle(model, store.statusOf(model)),
        section: switch (model.kind) {
          SpeechModelKind.recognizer => t.settings.kind_recognizer,
          SpeechModelKind.voice => t.settings.kind_voice,
          SpeechModelKind.wakeWord => t.settings.kind_wake_word,
          SpeechModelKind.voiceDetection => t.settings.kind_voice_detection,
        },
        icon: Icon(switch (store.statusOf(model)) {
          SpeechModelStatus(downloaded: true) => Icons.check_circle,
          SpeechModelStatus(downloading: true) => Icons.downloading,
          SpeechModelStatus(failed: true) => Icons.error_outline,
          _ => Icons.download,
        }),
        onTap: () => _onModelTapped(settings.context, model),
      ),
  ];
}

Future<void> _onModelTapped(BuildContext context, SpeechModel model) async {
  final store = SpeechModelStore.instance;
  final status = store.statusOf(model);
  if (status.downloading) {
    store.cancelDownload(model);
  } else if (status.downloaded) {
    final delete = await ThemedDialog.confirm(
      context,
      title: speechModelTitle(model),
      confirmLabel: t.settings.delete,
      destructive: true,
    );
    if (delete) await store.delete(model);
  } else {
    await store.download(model);
  }
}

List<SettingsEntry> _commandEntries(SettingsContext settings) {
  final snapshot =
      settings.ref.watch(voiceCommandsProvider).value ??
      VoiceCommandsRegistry.instance.snapshot;
  return [
    for (final command in snapshot.active)
      SettingsEntry.info(
        id: command.id,
        title: command.title,
        subtitle: _examples(command),
        value: '',
      ),
  ];
}

/// A few ways of saying [command], with its gaps shown as "...".
String _examples(VoiceCommand command) {
  final phrases = [
    for (final phrase in command.phrases.take(3))
      '"${phrase.replaceAll(RegExp(r'\{\w+\}'), '...')}"',
  ];
  if (phrases.isEmpty && command.words.isNotEmpty) {
    phrases.add(
      command.words.map((group) => group.take(2).join(' / ')).join(' + '),
    );
  }
  return phrases.join(', ');
}

String _modelSubtitle(SpeechModel model, SpeechModelStatus status) {
  final state = switch (status) {
    SpeechModelStatus(:final double progress) => t.settings.downloading(
      percent: (progress * 100).round(),
    ),
    SpeechModelStatus(downloaded: true) => t.settings.downloaded,
    SpeechModelStatus(failed: true) => t.settings.download_failed,
    _ => t.settings.not_downloaded,
  };
  return [
    speechModelAbout(model),
    t.settings.size(size: model.sizeMb),
    state,
  ].where((part) => part.isNotEmpty).join(' · ');
}

/// The name the driver reads for [model].
String speechModelTitle(SpeechModel model) => switch (model.id) {
  'parakeet_v3' => t.models.parakeet_v3,
  'whisper_base' => t.models.whisper_base,
  'whisper_tiny' => t.models.whisper_tiny,
  'moonshine_base_en' => t.models.moonshine_base_en,
  'moonshine_tiny_en' => t.models.moonshine_tiny_en,
  'kokoro_fable' => t.models.kokoro_fable,
  'piper_alan' => t.models.piper_alan,
  'piper_thorsten' => t.models.piper_thorsten,
  'wake_word' => t.models.wake_word,
  'voice_detection' => t.models.voice_detection,
  _ => model.title ?? model.id,
};

/// What [model] is good at, in a few words.
String speechModelAbout(SpeechModel model) => switch (model.id) {
  'parakeet_v3' => t.models.parakeet_v3_about,
  'whisper_base' => t.models.whisper_base_about,
  'whisper_tiny' => t.models.whisper_tiny_about,
  'moonshine_base_en' => t.models.moonshine_base_en_about,
  'moonshine_tiny_en' => t.models.moonshine_tiny_en_about,
  'kokoro_fable' => t.models.kokoro_fable_about,
  'piper_alan' => t.models.piper_alan_about,
  'piper_thorsten' => t.models.piper_thorsten_about,
  'wake_word' => t.models.wake_word_about,
  'voice_detection' => t.models.voice_detection_about,
  _ => model.about ?? '',
};

/// A sentence typed in and run as if it had been said, for trying commands
/// on a computer without talking to it.
class _TrySentence extends StatefulWidget {
  const _TrySentence();

  @override
  State<_TrySentence> createState() => _TrySentenceState();
}

class _TrySentenceState extends State<_TrySentence> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    SmartifyOsVoiceAssistant.respondToText(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ThemedTextField(
              controller: _controller,
              hintText: t.settings.try_sentence_subtitle,
            ),
          ),
          const SizedBox(width: 12),
          ThemedButton(onTap: _run, child: Text(t.settings.try_sentence)),
        ],
      ),
    );
  }
}
