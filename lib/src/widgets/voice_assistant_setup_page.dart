import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartify_os_core/theme.dart';
import 'package:smartify_os_core/widgets.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/providers/voice_assistant_provider.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model_status.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings_pages.dart';

/// Everything the voice assistant needs for what the driver picked, with one
/// button that downloads all of it and one bar for how far it got.
///
/// Internal: the "Get ready to listen" page in Settings, also opened by
/// itself when the driver asks something before the models are there.
class VoiceAssistantSetupPage extends ConsumerStatefulWidget {
  const VoiceAssistantSetupPage({super.key});

  @override
  ConsumerState<VoiceAssistantSetupPage> createState() =>
      _VoiceAssistantSetupPageState();
}

class _VoiceAssistantSetupPageState
    extends ConsumerState<VoiceAssistantSetupPage> {
  static const _maxWidth = 720.0;

  bool _failed = false;

  SpeechModelStore get _store => SpeechModelStore.instance;

  Future<void> _downloadAll() async {
    setState(() => _failed = false);
    final ok = await _store.downloadAll(
      VoiceAssistantService.instance.neededModels,
    );
    if (!mounted) return;
    // Stopped on purpose is not a failure, only a model that failed is.
    final anyFailed = VoiceAssistantService.instance.neededModels.any(
      (model) => _store.statusOf(model).failed,
    );
    setState(() => _failed = !ok && anyFailed);
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds as every model moves along.
    ref.watch(speechModelStatusesProvider);
    final text = context.smartifyOsText;
    final colors = Theme.of(context).colorScheme;

    final needed = VoiceAssistantService.instance.neededModels;
    final missing = [
      for (final model in needed)
        if (!_store.isDownloaded(model)) model,
    ];
    final downloading = needed.any((m) => _store.statusOf(m).downloading);
    final progress = _store.progressOf(needed);
    final total = needed.fold(0, (sum, model) => sum + model.sizeMb);
    final left = missing.fold(0, (sum, model) => sum + model.sizeMb);
    final ready = missing.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                ready ? Icons.check_circle : Icons.mic,
                size: 56,
                color: colors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                ready
                    ? t.settings.setup_ready
                    : t.settings.setup_missing(size: megabytes(left)),
                textAlign: TextAlign.center,
                style: text.title,
              ),
              const SizedBox(height: 20),
              _ProgressBar(value: progress),
              const SizedBox(height: 8),
              Text(
                t.settings.setup_progress(
                  done: megabytes((progress * total).round()),
                  total: megabytes(total),
                ),
                textAlign: TextAlign.center,
                style: text.dim(text.small),
              ),
              if (_failed) ...[
                const SizedBox(height: 8),
                Text(
                  t.settings.setup_failed,
                  textAlign: TextAlign.center,
                  style: text.small.copyWith(color: colors.error),
                ),
              ],
              if (!ready) ...[
                const SizedBox(height: 20),
                Center(
                  child: ThemedButton(
                    onTap: downloading ? _store.cancelDownloads : _downloadAll,
                    child: Text(
                      downloading
                          ? t.settings.setup_cancel
                          : t.settings.setup_download(size: megabytes(left)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ThemedSectionHeader(title: t.settings.setup_needed),
              for (final model in needed)
                ThemedListTile(
                  leading: Icon(_iconFor(_store.statusOf(model))),
                  title: speechModelTitle(model),
                  subtitle: speechModelAbout(model),
                  trailing: Text(switch (_store.statusOf(model)) {
                    SpeechModelStatus(:final double progress) =>
                      '${(progress * 100).round()}%',
                    _ => t.settings.size(size: model.sizeMb),
                  }, style: text.dim(text.body)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(SpeechModelStatus status) => switch (status) {
    SpeechModelStatus(downloaded: true) => Icons.check_circle,
    SpeechModelStatus(downloading: true) => Icons.downloading,
    SpeechModelStatus(failed: true) => Icons.error_outline,
    _ => Icons.download,
  };
}

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = context.smartifyOsTheme;
    final radius = BorderRadius.circular(theme.cornerRadius / 2);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: 14,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: colors.onSurface.withValues(alpha: 0.12)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary,
                  gradient: theme.accentGradient,
                  borderRadius: radius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [megabytes] the way people say them, 1.1 GB rather than 1100 MB.
String megabytes(int megabytes) => megabytes >= 1000
    ? '${(megabytes / 1000).toStringAsFixed(1)} GB'
    : '$megabytes MB';
