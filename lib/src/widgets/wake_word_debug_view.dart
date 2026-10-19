import 'package:flutter/material.dart';
import 'package:smartify_os_core/theme.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_log_entry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';

/// What the microphone hears while waiting for the wake word, and every time
/// the wake word was heard (in which of its spellings), for finding out why
/// it does or does not start.
///
/// Only while it is on screen is everything said turned into text, since
/// that keeps the speech model busy.
///
/// Internal: on the Developer options page.
class WakeWordDebugView extends StatefulWidget {
  const WakeWordDebugView({super.key});

  @override
  State<WakeWordDebugView> createState() => _WakeWordDebugViewState();
}

class _WakeWordDebugViewState extends State<WakeWordDebugView> {
  final _service = VoiceAssistantService.instance;

  @override
  void initState() {
    super.initState();
    _service.setHearingWhileWaiting(true);
  }

  @override
  void dispose() {
    _service.setHearingWhileWaiting(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;
    final store = SpeechModelStore.instance;
    final ready =
        store.isDownloaded(SpeechModels.voiceDetection) &&
        _service.recognizerModels.any(store.isDownloaded);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            !ready
                ? t.settings.debug_needs_model
                : _service.settings.wakeWord.value
                ? t.settings.debug_on(phrase: _service.setup.wakeWord)
                : t.settings.debug_off,
            style: text.title,
          ),
          const SizedBox(height: 4),
          Text(t.settings.debug_hint, style: text.dim(text.small)),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: _service.level,
            builder: (context, level, _) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: level,
                minHeight: 8,
                color: colors.primary,
                backgroundColor: colors.onSurface.withValues(alpha: 0.12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: _service.wakeWordLog,
            builder: (context, log, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (log.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      t.settings.debug_nothing_yet,
                      style: text.dim(text.body),
                    ),
                  ),
                for (final entry in log.take(12)) _LogLine(entry: entry),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogLine extends StatelessWidget {
  final WakeWordLogEntry entry;

  const _LogLine({required this.entry});

  @override
  Widget build(BuildContext context) {
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;
    final time = entry.time;
    String two(int value) => value.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${two(time.hour)}:${two(time.minute)}:${two(time.second)}',
            style: text.dim(text.small),
          ),
          const SizedBox(width: 12),
          Icon(
            entry.wakeWord ? Icons.notifications_active : Icons.hearing,
            size: 18,
            color: entry.wakeWord ? colors.primary : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.wakeWord
                  ? t.settings.debug_heard_wake_word(spelling: entry.text)
                  : entry.text,
              style: entry.wakeWord
                  ? text.strong(text.body).copyWith(color: colors.primary)
                  : text.body,
            ),
          ),
        ],
      ),
    );
  }
}
