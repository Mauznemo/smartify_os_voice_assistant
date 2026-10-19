import 'package:flutter/material.dart';
import 'package:smartify_os_core/core.dart';
import 'package:smartify_os_voice_assistant/voice_assistant.dart';

/// SmartifyOS with nothing but Voice assistant added, to try it on this computer
/// the way a car would run it. Every layout is there to try in Settings,
/// Appearance.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SmartifyOs().init(
    display: const DisplayConfig(windowSize: Size(1024, 600)),
    extensions: [VoiceAssistantExtension()],
  );
  runApp(const SmartifyOsApp());
}
