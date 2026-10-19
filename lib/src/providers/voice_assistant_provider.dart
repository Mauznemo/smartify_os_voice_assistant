import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_commands_snapshot.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_commands_registry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_state.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model_status.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';

/// What the voice assistant is doing, what it heard and what it answered.
final voiceAssistantStateProvider = StreamProvider<VoiceAssistantState>(
  (ref) => VoiceAssistantService.instance.changes,
);

/// Every voice command, and which are turned off.
final voiceCommandsProvider = StreamProvider<VoiceCommandsSnapshot>(
  (ref) => VoiceCommandsRegistry.instance.changes,
);

/// Whether each speech model is downloaded, by its folder.
final speechModelStatusesProvider =
    StreamProvider<Map<String, SpeechModelStatus>>(
      (ref) => SpeechModelStore.instance.changes,
    );
