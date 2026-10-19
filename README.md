# Voice assistant

A voice assistant for [SmartifyOS](https://github.com/Mauznemo/smartify_os_flutter_test)
that runs on the car itself. Say the wake word or press a button, say what you want, and
the car does it and answers. It works without the internet: listening, understanding
your commands and the spoken answer all happen on the car.

It understands what you ask through your own list of commands, so most cars need nothing
else. An AI server (Ollama at home, or any service that speaks the OpenAI API) is
optional, for asking anything at all.

## Install

In your car's app folder:

```bash
smartify-os extension add https://github.com/Mauznemo/smartify_os_voice_assistant
```

That switches it on in your app's `lib/main.dart`:

```dart
await SmartifyOs().init(
  extensions: [
    VoiceAssistantExtension(wakeWord: 'Hey Miata'),
  ],
);
```

Then open Settings, Voice assistant, **Get ready to listen**, which downloads everything
what you picked needs in one go (or let the CLI put the models on the car). Asking
something before that opens the page by itself.

## What it adds

- **Ask** in the app list, which starts listening. Put it in the dock
  (`BarConfig(dockApps: [VoiceAssistantIds.appListEntry])`) for a button that is always
  there.
- A panel over everything while it listens and answers, with what it heard, what it is
  doing and waves that move with your voice, and a chime when it starts and stops
  listening (`listeningSound`, `heardSound`, `nothingHeardSound`, see
  `VoiceAssistantSounds`; `null` for silence).
- **Voice assistant** in Settings: the wake word (off until the driver turns it on), which
  speech model and voice to use, downloading them, and everything it understands.
- Commands it knows by itself (see `VoiceCommands`): the volume, muting, the phone's
  music, opening anything in the app list by its name, the home screen, the time, and
  "never mind". Hide any of them with `hiddenCommands`, or replace one by adding your
  own with the same `id`.

## Your own commands

Say what it does, how it is said, and what to run. The easiest way is `words`: the
command runs when what you said has a word out of every list, in any order and in any
language:

```dart
VoiceAssistantExtension(
  commands: [
    VoiceCommand(
      id: 'windows_up',
      title: 'Close the windows',
      words: [
        ['window', 'windows', 'fenster'],
        ['up', 'raise', 'close', 'hoch', 'zu'],
      ],
      onRun: (run) {
        myCar.windows(up: true);
        return "I'm closing the windows."; // or null to only show that it is done
      },
    ),
    VoiceCommand(
      id: 'temperature',
      title: 'Set the temperature',
      phrases: ['set the temperature to {degrees}', 'make it {degrees} degrees'],
      onRun: (run) {
        final degrees = run.number('degrees');
        if (degrees == null) return 'To how many degrees?';
        myCar.setTemperature(degrees);
        return "I've set it to ${degrees.round()} degrees.";
      },
    ),
  ],
)
```

Your commands always win over the built-in ones. Add more later from anywhere with
`SmartifyOsVoiceAssistant.addCommand`. Settings, Developer options, Voice assistant has a
field to type a sentence in and run it as if you had said it.

## A button of your own

```dart
// Press: listens until you stop talking. Press again while it answers: stops.
SmartifyOsVoiceAssistant.toggleListening();

// Or hold to talk:
SmartifyOsVoiceAssistant.startListening(); // when it goes down
SmartifyOsVoiceAssistant.stopListening();  // when it comes up
```

With the wake word off, nothing runs between questions: the microphone is closed and the
speech models are unloaded a few minutes after the last one (`keepModelsLoadedFor`).

## Speech models

Pick the one that understands what you say by what matters more to you. The driver can
change it in Settings.

| | Speed | Accuracy | Languages | Size |
|---|---|---|---|---|
| `SpeechModels.parakeet` (default) | good on a mini PC, slow on a Pi | best | 25 European | 670 MB |
| `SpeechModels.whisperBase` | good | good | nearly all | 160 MB |
| `SpeechModels.whisperTiny` | fast | rough | nearly all | 105 MB |
| `SpeechModels.moonshineBase` | fast | very good | English | 290 MB |
| `SpeechModels.moonshineTiny` | fastest | good | English | 125 MB |

Voices: `kokoroFable` (British English, natural, needs a mini PC), `piperAlan` (British
English, light enough for a Raspberry Pi), `piperThorsten` (German).

The wake word can be any phrase and needs no training, but it is heard the way an English
speaker says it. A word the wake word model does not know well (a name like "Miata") needs
a few spellings of how it sounds:

```dart
VoiceAssistantExtension(
  wakeWord: 'Hey Miata',
  wakeWordSpellings: ['Hey Miyata', 'Hey Me ah ta', 'Hey Mia ta', 'Hey Me ata'],
)
```

In testing that took "Hey Miata" from being heard 57 times out of 100 to 81, without
starting by mistake more often. Two or three words start it less often by mistake than
one.

Easier still, the driver can **teach it their voice** in Settings, Voice assistant: they
say the wake word eight times, the car writes down how it heard each one, tries those
spellings against the recordings, and keeps the few that hear them best (it shows how many
of the eight it heard before and after). Settings, Developer options, Voice assistant
shows what the microphone hears and which spelling it heard each time.

## Servers, optional

```dart
VoiceAssistantExtension(
  // Understands anything you say; your commands are handed to it as tools.
  aiServer: const VoiceAiServer(url: 'http://192.168.1.20:11434/v1', model: 'qwen3:8b'),
  // Speaks with a voice too heavy for the car (OpenAI's /v1/audio/speech).
  speechServer: const VoiceSpeechServer(
    url: 'http://192.168.1.20:8880/v1',
    model: 'qwen3-tts',
    voice: 'aiden',
  ),
)
```

Without a connection it falls back to your commands and the car's own voice.

## Platforms

Linux (the car), Android, macOS and Windows. On macOS the app needs the
`com.apple.security.device.audio-input` entitlement and an `NSMicrophoneUsageDescription`,
on Android the `RECORD_AUDIO` permission. On Linux it listens through `parecord`, which
the CLI installs from `pubspec.yaml`. The music is turned down while it talks on Linux and
Android.

## Working on it

```bash
smartify-os extension run       # try it in SmartifyOS on this computer
flutter test                    # run the tests
dart run slang                  # after changing lib/src/i18n/en.i18n.json
dart run build_runner build     # after changing a freezed class
```
