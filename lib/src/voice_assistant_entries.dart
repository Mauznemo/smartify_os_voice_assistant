import 'package:flutter/material.dart';
import 'package:smartify_os_core/app_list.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/smartify_os_voice_assistant.dart';

/// The `id`s of what the voice assistant adds to the car, for hiding one or
/// putting it in the dock.
abstract final class VoiceAssistantIds {
  /// "Ask" in the app list, which starts listening. Put it in the dock with
  /// `BarConfig(dockApps: [VoiceAssistantIds.appListEntry])` for a button
  /// that is always there.
  static const appListEntry = 'voice_assistant';

  /// The panel that shows while it listens and answers.
  static const panel = 'voice_assistant.panel';
}

/// Internal: "Ask" in the app list.
AppListEntry voiceAssistantAppListEntry() => AppListEntry(
  id: VoiceAssistantIds.appListEntry,
  title: t.voice_assistant.app_title,
  icon: const Icon(Icons.mic),
  onOpen: (_) => SmartifyOsVoiceAssistant.toggleListening(),
);
