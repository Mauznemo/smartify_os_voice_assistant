import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartify_os_core/theme.dart';
import 'package:smartify_os_core/widgets.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_teaching.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/wake_word_teacher.dart';

/// Teaching the car how the driver says the wake word: they say it a few
/// times, and it keeps the spellings that hear them best.
///
/// Internal: the "Teach it your voice" page in Settings. Leaving the page
/// while it records stops it, without learning anything.
class WakeWordTeachPage extends StatefulWidget {
  const WakeWordTeachPage({super.key});

  @override
  State<WakeWordTeachPage> createState() => _WakeWordTeachPageState();
}

class _WakeWordTeachPageState extends State<WakeWordTeachPage> {
  static const _maxWidth = 720.0;

  final _teacher = WakeWordTeacher.instance;
  final _service = VoiceAssistantService.instance;

  @override
  void dispose() {
    if (_teacher.state.value is WakeWordTeachingRecording) {
      _teacher.cancelTeaching();
    }
    super.dispose();
  }

  void _forget() {
    _service.learnedSpellings = const [];
    _teacher.state.value = WakeWordTeaching.failed(t.teach.forgotten);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: ValueListenableBuilder(
            valueListenable: _teacher.state,
            builder: (context, teaching, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: switch (teaching) {
                WakeWordTeachingIdle() => _idle(context, null),
                WakeWordTeachingFailed(:final reason) => _idle(context, reason),
                WakeWordTeachingRecording() => _recording(context, teaching),
                WakeWordTeachingWorking() => _working(context, teaching),
                WakeWordTeachingDone() => _done(context, teaching),
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _idle(BuildContext context, String? message) {
    final text = context.smartifyOsText;
    final learned = _service.learnedSpellings;
    return [
      _Microphone(level: _service.level, listening: false),
      const SizedBox(height: 16),
      Text(
        t.teach.intro(
          phrase: _service.setup.wakeWord,
          count: WakeWordTeacher.wanted,
        ),
        textAlign: TextAlign.center,
        style: text.body,
      ),
      if (message != null) ...[
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center, style: text.dim(text.body)),
      ],
      const SizedBox(height: 20),
      Center(
        child: ThemedButton(
          onTap: _teacher.startTeaching,
          child: Text(learned.isEmpty ? t.teach.start : t.teach.again),
        ),
      ),
      if (learned.isNotEmpty) ...[
        const SizedBox(height: 16),
        ThemedSectionHeader(title: t.teach.learned),
        for (final spelling in learned)
          ThemedListTile(
            leading: const Icon(Icons.record_voice_over),
            title: spelling,
          ),
        const SizedBox(height: 8),
        ThemedListTile(
          leading: const Icon(Icons.delete_outline),
          title: t.teach.forget,
          destructive: true,
          onTap: _forget,
        ),
      ],
    ];
  }

  List<Widget> _recording(
    BuildContext context,
    WakeWordTeachingRecording recording,
  ) {
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;
    final lastHeard = recording.lastHeard;
    return [
      _Microphone(level: _service.level, listening: true),
      const SizedBox(height: 16),
      Text(
        t.teach.say_it(phrase: _service.setup.wakeWord),
        textAlign: TextAlign.center,
        style: text.heading,
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < recording.wanted; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < recording.recorded
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.15),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        t.teach.recorded(done: recording.recorded, total: recording.wanted),
        textAlign: TextAlign.center,
        style: text.dim(text.small),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 48,
        child: lastHeard == null
            ? null
            : Text(
                recording.lastLeftOut
                    ? t.teach.left_out(text: lastHeard)
                    : t.teach.heard(text: lastHeard),
                textAlign: TextAlign.center,
                style: recording.lastLeftOut
                    ? text.body.copyWith(color: colors.error)
                    : text.dim(text.body),
              ),
      ),
      Center(
        child: ThemedButton(
          onTap: _teacher.cancelTeaching,
          child: Text(t.teach.cancel),
        ),
      ),
    ];
  }

  List<Widget> _working(BuildContext context, WakeWordTeachingWorking working) {
    final text = context.smartifyOsText;
    return [
      const SizedBox(height: 24),
      const Center(child: CircularProgressIndicator()),
      const SizedBox(height: 20),
      Text(t.teach.working, textAlign: TextAlign.center, style: text.heading),
      const SizedBox(height: 8),
      Text(
        t.teach.tried(done: working.tried, total: working.total),
        textAlign: TextAlign.center,
        style: text.dim(text.small),
      ),
    ];
  }

  List<Widget> _done(BuildContext context, WakeWordTeachingDone done) {
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;
    return [
      Icon(Icons.check_circle, size: 64, color: colors.primary),
      const SizedBox(height: 16),
      Text(
        t.teach.result(
          before: done.before,
          after: done.after,
          total: done.recordings,
        ),
        textAlign: TextAlign.center,
        style: text.heading,
      ),
      const SizedBox(height: 16),
      if (done.learned.isEmpty)
        Text(
          t.teach.nothing_learned,
          textAlign: TextAlign.center,
          style: text.dim(text.body),
        )
      else ...[
        ThemedSectionHeader(title: t.teach.learned),
        for (final spelling in done.learned)
          ThemedListTile(
            leading: const Icon(Icons.record_voice_over),
            title: spelling.spelling,
            trailing: Text(
              t.teach.learned_heard(
                count: spelling.heard,
                total: done.recordings,
              ),
              style: text.dim(text.body),
            ),
          ),
      ],
      const SizedBox(height: 20),
      Center(
        child: ThemedButton(
          onTap: _teacher.startTeaching,
          child: Text(t.teach.again),
        ),
      ),
    ];
  }
}

/// A microphone that grows a ring with how loud it is while it listens.
class _Microphone extends StatelessWidget {
  final ValueListenable<double> level;
  final bool listening;

  const _Microphone({required this.level, required this.listening});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 120,
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: level,
          builder: (context, value, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            width: 84 + (listening ? value * 36 : 0),
            height: 84 + (listening ? value * 36 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: listening ? 0.18 : 0.1),
            ),
            child: child,
          ),
          child: Icon(
            listening ? Icons.mic : Icons.mic_none,
            size: 44,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}
