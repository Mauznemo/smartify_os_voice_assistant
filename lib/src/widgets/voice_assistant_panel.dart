import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartify_os_core/theme.dart';
import 'package:smartify_os_core/widgets.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/providers/voice_assistant_provider.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_phase.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_state.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/widgets/voice_wave.dart';

/// What the voice assistant shows while it listens and answers: what it is
/// doing, what it heard, its answer, and waves that move with the voice.
///
/// Internal: shown as a floating panel by the extension whenever a
/// conversation is going on.
class VoiceAssistantPanel extends ConsumerWidget {
  const VoiceAssistantPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = VoiceAssistantService.instance;
    final state = ref.watch(voiceAssistantStateProvider).value ?? service.state;
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;

    final mood = switch (state.phase) {
      VoiceAssistantPhase.listening ||
      VoiceAssistantPhase.speaking => VoiceWaveMood.following,
      VoiceAssistantPhase.preparing ||
      VoiceAssistantPhase.understanding ||
      VoiceAssistantPhase.thinking => VoiceWaveMood.working,
      VoiceAssistantPhase.idle ||
      VoiceAssistantPhase.done => VoiceWaveMood.resting,
    };

    return ThemedPanel(
      padding: const EdgeInsets.fromLTRB(20, 14, 10, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _Status(state: state)),
              ThemedIconButton(
                icon: Icons.close,
                size: 36,
                tooltip: t.voice_assistant.stop,
                // The way out comes after what the panel is for.
                focusOrder: 1000,
                onTap: service.closeAssistant,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.heard.isNotEmpty || _waitingForWords(state))
                    Text(
                      state.heard.isNotEmpty
                          ? state.heard
                          : t.status.listening_hint,
                      style: state.heard.isEmpty
                          ? text.dim(text.heading)
                          : state.reply == null
                          ? text.heading
                          : text.dim(text.title),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (state.reply case final String reply) ...[
                    const SizedBox(height: 6),
                    Text(
                      reply,
                      style: text.heading.copyWith(
                        color: state.failed ? colors.error : null,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: VoiceWave(level: service.level, mood: mood),
          ),
        ],
      ),
    );
  }

  static bool _waitingForWords(VoiceAssistantState state) =>
      state.phase == VoiceAssistantPhase.preparing ||
      state.phase == VoiceAssistantPhase.listening;
}

/// What it is doing, in a word, with dots that keep moving while it works,
/// so it never looks stuck.
class _Status extends StatelessWidget {
  final VoiceAssistantState state;

  const _Status({required this.state});

  @override
  Widget build(BuildContext context) {
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;

    final (label, busy) = switch (state.phase) {
      VoiceAssistantPhase.preparing => (t.status.getting_ready, true),
      VoiceAssistantPhase.listening => (t.status.listening, false),
      VoiceAssistantPhase.understanding => (t.status.understanding, true),
      VoiceAssistantPhase.thinking => (
        state.askingServer ? t.status.asking_server : t.status.thinking,
        true,
      ),
      VoiceAssistantPhase.speaking => (t.status.speaking, false),
      VoiceAssistantPhase.done ||
      VoiceAssistantPhase.idle => (t.status.done, false),
    };

    final style = text
        .strong(text.small)
        .copyWith(
          color: state.failed ? colors.error : colors.primary,
          letterSpacing: 0.4,
        );

    return Row(
      children: [
        Icon(
          state.phase == VoiceAssistantPhase.done && !state.failed
              ? Icons.check_circle
              : Icons.mic,
          size: 18,
          color: style.color,
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(label, key: ValueKey(label), style: style),
        ),
        if (busy) _Dots(style: style),
      ],
    );
  }
}

class _Dots extends StatefulWidget {
  final TextStyle style;

  const _Dots({required this.style});

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shown = (_controller.value * 4).floor();
        return Text(
          '...'.substring(0, shown.clamp(0, 3)).padRight(3),
          style: widget.style,
        );
      },
    );
  }
}
