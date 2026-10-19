import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartify_os_core/app_list.dart';
import 'package:smartify_os_core/core.dart';
import 'package:smartify_os_core/extensions.dart';
import 'package:smartify_os_core/floating_panels.dart';
import 'package:smartify_os_core/settings.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/src/widgets/voice_assistant_panel.dart';
import 'package:smartify_os_voice_assistant/voice_assistant.dart';

void main() {
  late Directory models;
  var windowsClosed = 0;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    models = await Directory.systemTemp.createTemp('voice_assistant_test');
    await VoiceAssistantExtension(
      modelsDirectory: models.path,
      hiddenCommands: {VoiceCommands.time},
      commands: [
        VoiceCommand(
          id: 'windows_up',
          title: 'Close the windows',
          words: [
            ['window', 'windows'],
            ['up', 'close'],
          ],
          onRun: (run) {
            windowsClosed++;
            return 'Closing the windows';
          },
        ),
      ],
    ).init(
      const SmartifyOsExtensionContext(coreVersion: 'test', extensions: []),
    );
  });

  tearDownAll(() => models.delete(recursive: true));

  tearDown(SmartifyOsVoiceAssistant.closeAssistant);

  test('adds its app list entry, settings pages and commands', () {
    expect(SmartifyOsAppList.hasEntry(VoiceAssistantIds.appListEntry), isTrue);
    expect(
      SmartifyOsSettings.hasPage(VoiceAssistantSettingsPages.main),
      isTrue,
    );
    expect(
      SmartifyOsSettings.hasPage(VoiceAssistantSettingsPages.models),
      isTrue,
    );
    expect(SmartifyOsVoiceAssistant.hasCommand(VoiceCommands.volumeUp), isTrue);
    expect(SmartifyOsVoiceAssistant.hasCommand('windows_up'), isTrue);
    // Hidden, but still there to bring back.
    expect(SmartifyOsVoiceAssistant.hasCommand(VoiceCommands.time), isTrue);
    expect(
      SmartifyOsVoiceAssistant.commands.map((c) => c.id),
      isNot(contains(VoiceCommands.time)),
    );
  });

  test('runs a command it understood, and answers', () async {
    await SmartifyOsVoiceAssistant.respondToText('could you close the windows');

    expect(windowsClosed, 1);
    final state = SmartifyOsVoiceAssistant.state;
    expect(state.phase, VoiceAssistantPhase.done);
    expect(state.heard, 'could you close the windows');
    expect(state.reply, 'Closing the windows');
    expect(state.failed, isFalse);
    expect(SmartifyOsFloatingPanels.hasPanel(VoiceAssistantIds.panel), isTrue);
  });

  test('says so when it does not understand', () async {
    await SmartifyOsVoiceAssistant.respondToText('fly me to the moon');

    final state = SmartifyOsVoiceAssistant.state;
    expect(state.failed, isTrue);
    expect(state.reply, "Sorry, I don't know how to help with that yet.");
  });

  test('never mind closes it without an answer', () async {
    await SmartifyOsVoiceAssistant.respondToText('never mind');

    expect(SmartifyOsVoiceAssistant.state.isActive, isFalse);
    await pumpEventQueue();
    expect(SmartifyOsFloatingPanels.hasPanel(VoiceAssistantIds.panel), isFalse);
  });

  test('listening without a downloaded model says how to get one', () async {
    await SmartifyOsVoiceAssistant.startListening();

    final state = SmartifyOsVoiceAssistant.state;
    expect(state.failed, isTrue);
    expect(state.reply, contains('Settings'));
  });

  test('what is needed follows what was picked', () {
    final service = VoiceAssistantService.instance;
    final needed = service.neededModels.map((model) => model.id);
    expect(needed, contains(SpeechModels.parakeet.id));
    expect(needed, contains(SpeechModels.voiceDetection.id));
    expect(needed, contains(SpeechModels.kokoroFable.id));
    // The wake word is off until the driver turns it on.
    expect(needed, isNot(contains(SpeechModels.wakeWord.id)));

    SmartifyOsVoiceAssistant.setWakeWordEnabled(true);
    expect(
      service.neededModels.map((model) => model.id),
      contains(SpeechModels.wakeWord.id),
    );
    SmartifyOsVoiceAssistant.setWakeWordEnabled(false);
  });

  testWidgets('an app that is already open is not opened again', (
    tester,
  ) async {
    SmartifyOsAppList.addEntry(
      AppListEntry(
        id: 'radio',
        title: 'Radio',
        icon: const Icon(Icons.radio),
        onOpen: (context) => SmartifyOsNavigator.push(
          context,
          const Scaffold(body: Text('radio window')),
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: SmartifyOsNavigator.navigatorKey,
        navigatorObservers: [SmartifyOsNavigator.observer],
        home: const Scaffold(body: SizedBox()),
      ),
    );

    await tester.runAsync(
      () => SmartifyOsVoiceAssistant.respondToText('open the radio'),
    );
    await tester.pumpAndSettle();
    expect(SmartifyOsVoiceAssistant.state.reply, "Sure, here's Radio.");

    await tester.runAsync(
      () => SmartifyOsVoiceAssistant.respondToText('open the radio'),
    );
    await tester.pumpAndSettle();
    expect(SmartifyOsVoiceAssistant.state.reply, 'Radio is already open.');
    expect(find.text('radio window'), findsOneWidget);

    await tester.runAsync(
      () async => SmartifyOsVoiceAssistant.closeAssistant(),
    );
    SmartifyOsNavigator.goHome();
    await tester.pumpAndSettle();
    SmartifyOsAppList.removeEntry('radio');
  });

  testWidgets('the panel shows what it heard and what it answered', (
    tester,
  ) async {
    await tester.runAsync(
      () => SmartifyOsVoiceAssistant.respondToText('close the windows'),
    );
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Center(child: VoiceAssistantPanel())),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('close the windows'), findsOneWidget);
    expect(find.text('Closing the windows'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Outside the test's pretend clock, where closing starts the real timer
    // that unloads the models later.
    await tester.runAsync(
      () async => SmartifyOsVoiceAssistant.closeAssistant(),
    );
    await tester.pumpWidget(const SizedBox());
  });
}
