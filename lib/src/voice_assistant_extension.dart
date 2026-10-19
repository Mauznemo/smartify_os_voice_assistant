import 'package:smartify_os_core/app_list.dart';
import 'package:smartify_os_core/extensions.dart';
import 'package:smartify_os_core/floating_panels.dart';
import 'package:smartify_os_core/settings.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_ai_server.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_speech_server.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings_pages.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_sounds.dart';
import 'package:smartify_os_voice_assistant/src/voice_assistant_entries.dart';
import 'package:smartify_os_voice_assistant/src/widgets/voice_assistant_panel.dart';

/// A voice assistant that runs on the car itself: say the wake word or press
/// a button, say what you want, and the car does it and answers.
///
/// ```dart
/// await SmartifyOs().init(
///   extensions: [
///     VoiceAssistantExtension(
///       wakeWord: 'Hey Miata',
///       commands: [
///         VoiceCommand(
///           id: 'windows_up',
///           title: 'Close the windows',
///           words: [
///             ['window', 'windows'],
///             ['up', 'raise', 'close'],
///           ],
///           onRun: (run) {
///             myCar.windows(up: true);
///             return "I'm closing the windows.";
///           },
///         ),
///       ],
///     ),
///   ],
/// );
/// ```
///
/// That adds:
///
/// * **Ask** in the app list, which starts listening. Put it in the dock for
///   a button that is always there.
/// * A page in Settings: the wake word, which speech model and voice to use,
///   one page that downloads everything those need, and everything the
///   driver can say.
/// * A chime when it starts listening, and when it stops.
/// * A panel over everything while it listens and answers.
///
/// Everything it hears and says stays on the car, so it works without a
/// connection. The speech models are downloaded once, in Settings or by the
/// smartify-os CLI. It comes with commands for the volume, the music, opening
/// apps and the time (see `VoiceCommands`), and runs yours.
///
/// For a physical button, call `SmartifyOsVoiceAssistant.toggleListening()`
/// when it is pressed, or `startListening()` and `stopListening()` while it
/// is held. With the wake word off and nothing said in a while, nothing of it
/// runs at all: no microphone, no models.
///
/// Optionally an [aiServer] understands anything you say, and a
/// [speechServer] speaks with a voice too heavy for the car.
class VoiceAssistantExtension extends SmartifyOsExtension {
  /// What starts it without touching anything, once the driver turns the wake
  /// word on in Settings. Any phrase works, but it is heard the way an
  /// English speaker says it, and two or three words start less often by
  /// mistake than one.
  final String wakeWord;

  /// Other ways of writing how [wakeWord] sounds, which it also listens for,
  /// so it is heard however it is said. A name the wake word model does not
  /// know needs a few: for "Hey Miata", `['Hey Miyata', 'Hey Me ah ta']`.
  /// Developer options, Voice assistant shows which one it heard, and what
  /// the microphone hears, to find good ones.
  final List<String> wakeWordSpellings;

  /// Whether the wake word is on until the driver changes it in Settings.
  /// Off, only a button starts it, and nothing listens in between.
  final bool wakeWordOnByDefault;

  /// The speech model that understands what is said, until the driver picks
  /// another in Settings. See `SpeechModels` for how they compare.
  final SpeechModel recognizer;

  /// The voice to answer with in each language, by two letter code, in
  /// place of the default one for it. The driver can still pick another in
  /// Settings.
  final Map<String, SpeechModel> voices;

  /// Your car's own commands. More can be added later from anywhere with
  /// `SmartifyOsVoiceAssistant.addCommand`.
  final List<VoiceCommand> commands;

  /// Built-in commands to leave out, by their `id` from `VoiceCommands`.
  final Set<String> hiddenCommands;

  /// A server that understands anything you say, for when listing phrases is
  /// not enough. Without one, the car only matches its commands' phrases.
  final VoiceAiServer? aiServer;

  /// A server that speaks the answers in a voice of its own.
  final VoiceSpeechServer? speechServer;

  /// Where the speech models are kept. Leave it `null` for the place the
  /// smartify-os CLI puts them.
  final String? modelsDirectory;

  /// How long the models stay loaded after the last question, so the next
  /// one is answered straight away. Once it is over they are unloaded and
  /// take no memory.
  final Duration keepModelsLoadedFor;

  /// How loud the music stays while the assistant listens and talks.
  final double duckLevel;

  /// Played when it starts listening, `null` for silence. A path as in
  /// `pubspec.yaml`, see [VoiceAssistantSounds].
  final String? listeningSound;

  /// Played when it stops listening because you stopped talking.
  final String? heardSound;

  /// Played when it stops listening without having heard anything.
  final String? nothingHeardSound;

  VoiceAssistantExtension({
    this.wakeWord = 'Hey Smartify',
    this.wakeWordSpellings = const [],
    this.wakeWordOnByDefault = false,
    SpeechModel? recognizer,
    this.voices = const {},
    this.commands = const [],
    this.hiddenCommands = const {},
    this.aiServer,
    this.speechServer,
    this.modelsDirectory,
    this.keepModelsLoadedFor = const Duration(minutes: 3),
    this.duckLevel = 0.2,
    this.listeningSound = VoiceAssistantSounds.listening,
    this.heardSound = VoiceAssistantSounds.heard,
    this.nothingHeardSound = VoiceAssistantSounds.nothingHeard,
  }) : recognizer = recognizer ?? SpeechModels.parakeet;

  @override
  String get id => 'voice_assistant';

  @override
  String get name => t.voice_assistant.title;

  @override
  Future<void> init(SmartifyOsExtensionContext context) async {
    final service = VoiceAssistantService.instance;
    await service.start(this);

    SmartifyOsAppList.addEntry(voiceAssistantAppListEntry());
    SmartifyOsSettings.addPages(voiceAssistantSettingsPages());

    // The panel is on screen for as long as a conversation goes on.
    service.changes.map((state) => state.isActive).distinct().listen((active) {
      if (active) {
        SmartifyOsFloatingPanels.showPanel(
          FloatingPanel(
            id: VoiceAssistantIds.panel,
            width: 640,
            builder: (panel) => const VoiceAssistantPanel(),
          ),
        );
      } else {
        SmartifyOsFloatingPanels.dismissPanel(VoiceAssistantIds.panel);
      }
    });
  }
}
