import 'package:smartify_os_core/app_list.dart';
import 'package:smartify_os_core/bluetooth.dart';
import 'package:smartify_os_core/core.dart';
import 'package:smartify_os_core/date_time.dart';
import 'package:smartify_os_core/volume.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command_run.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_command_matcher.dart';

/// The `id`s of the commands the voice assistant comes with, for hiding or
/// replacing one:
///
/// ```dart
/// VoiceAssistantExtension(hiddenCommands: {VoiceCommands.time})
/// ```
///
/// Adding a command of your own with one of these ids replaces the built-in
/// one.
abstract final class VoiceCommands {
  static const volumeUp = 'volume_up';
  static const volumeDown = 'volume_down';
  static const mute = 'mute';
  static const unmute = 'unmute';
  static const goHome = 'go_home';

  /// Opens anything in the app list by its name: "open settings".
  static const openApp = 'open_app';
  static const playMusic = 'play_music';
  static const pauseMusic = 'pause_music';
  static const nextTrack = 'next_track';
  static const previousTrack = 'previous_track';
  static const time = 'time';

  /// "Never mind": closes the assistant without doing anything.
  static const cancel = 'cancel';
}

/// How far one "louder" turns the volume.
const _volumeStep = 0.1;

/// Internal: the commands the voice assistant comes with, in the car's
/// language, with the English phrases too, since many people say some things
/// in English whatever language their car is in.
List<VoiceCommand> builtInVoiceCommands() {
  final local = t.commands;
  final english = AppLocale.en.translations.commands;

  List<String> both(List<String> local, List<String> english) =>
      {...local, ...english}.toList();

  return [
    VoiceCommand(
      id: VoiceCommands.volumeUp,
      title: local.volume_up.title,
      phrases: both(local.volume_up.phrases, english.volume_up.phrases),
      onRun: (_) {
        SmartifyOsVolume.changeVolume(_volumeStep);
        return t.replies.volume_up;
      },
    ),
    VoiceCommand(
      id: VoiceCommands.volumeDown,
      title: local.volume_down.title,
      phrases: both(local.volume_down.phrases, english.volume_down.phrases),
      onRun: (_) {
        SmartifyOsVolume.changeVolume(-_volumeStep);
        return t.replies.volume_down;
      },
    ),
    VoiceCommand(
      id: VoiceCommands.mute,
      title: local.mute.title,
      phrases: both(local.mute.phrases, english.mute.phrases),
      onRun: (_) {
        SmartifyOsVolume.setMuted(true);
        return null;
      },
    ),
    VoiceCommand(
      id: VoiceCommands.unmute,
      title: local.unmute.title,
      phrases: both(local.unmute.phrases, english.unmute.phrases),
      onRun: (_) {
        SmartifyOsVolume.setMuted(false);
        return t.replies.unmuted;
      },
    ),
    VoiceCommand(
      id: VoiceCommands.goHome,
      title: local.go_home.title,
      phrases: both(local.go_home.phrases, english.go_home.phrases),
      onRun: (_) {
        SmartifyOsNavigator.goHome();
        return null;
      },
    ),
    VoiceCommand(
      id: VoiceCommands.openApp,
      title: local.open_app.title,
      phrases: both(local.open_app.phrases, english.open_app.phrases),
      values: {'app': local.open_app.app},
      onRun: _openApp,
    ),
    VoiceCommand(
      id: VoiceCommands.playMusic,
      title: local.play_music.title,
      phrases: both(local.play_music.phrases, english.play_music.phrases),
      onRun: (_) => _withPhone(Bluetooth.play),
    ),
    VoiceCommand(
      id: VoiceCommands.pauseMusic,
      title: local.pause_music.title,
      phrases: both(local.pause_music.phrases, english.pause_music.phrases),
      onRun: (_) => _withPhone(Bluetooth.pause),
    ),
    VoiceCommand(
      id: VoiceCommands.nextTrack,
      title: local.next_track.title,
      phrases: both(local.next_track.phrases, english.next_track.phrases),
      onRun: (_) => _withPhone(Bluetooth.next),
    ),
    VoiceCommand(
      id: VoiceCommands.previousTrack,
      title: local.previous_track.title,
      phrases: both(
        local.previous_track.phrases,
        english.previous_track.phrases,
      ),
      onRun: (_) => _withPhone(Bluetooth.previous),
    ),
    VoiceCommand(
      id: VoiceCommands.time,
      title: local.time.title,
      phrases: both(local.time.phrases, english.time.phrases),
      onRun: (run) {
        final context = run.context;
        final now = SmartifyOsTime.now;
        final time = context != null
            ? formatClockTime(context, now)
            : '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
        return t.replies.time(time: time);
      },
    ),
    VoiceCommand(
      id: VoiceCommands.cancel,
      title: local.cancel.title,
      phrases: both(local.cancel.phrases, english.cancel.phrases),
      // The assistant closes on its own for this one, see
      // VoiceAssistantService.
      onRun: (_) => null,
    ),
  ];
}

Future<String?> _withPhone(Future<void> Function() action) async {
  if (Bluetooth.connectedDevice == null) return t.replies.no_phone;
  await action();
  return null;
}

String? _openApp(VoiceCommandRun run) {
  final name = run.value('app');
  if (name == null) return t.replies.not_understood;

  final entry = findAppListEntry(name, SmartifyOsAppList.entries);
  if (entry == null) return t.replies.app_not_found(name: name);

  // Already what the driver is looking at: opening it again would only stack
  // a second one on top.
  if (SmartifyOsAppList.isEntryInFront(entry.id)) {
    return t.replies.already_open(name: entry.title);
  }
  final context = run.context;
  if (context == null) return t.replies.something_went_wrong;
  // One open under another window comes back to the front.
  SmartifyOsAppList.openEntry(context, entry.id);
  return t.replies.opening(name: entry.title);
}

/// Internal: the app list entry whose title fits [name] best: the same title,
/// then one the name has in it ("the settings app"), then one that has the
/// name in it ("android" for "Android Auto").
AppListEntry? findAppListEntry(String name, Iterable<AppListEntry> entries) {
  final said = VoiceCommandMatcher.tokenize(name).join(' ');
  if (said.isEmpty) return null;

  AppListEntry? partial;
  for (final entry in entries) {
    final title = VoiceCommandMatcher.tokenize(entry.title).join(' ');
    if (title.isEmpty) continue;
    if (title == said) return entry;
    if (partial == null &&
        (' $said '.contains(' $title ') || ' $title '.contains(' $said '))) {
      partial = entry;
    }
  }
  return partial;
}
