This is **Voice assistant**, an extension for SmartifyOS, the open source car infotainment
system built in Flutter. An extension is a Flutter package that adds a feature to a car
without being part of SmartifyOS itself (`smartify_os_core`). A car's app switches it on
with `SmartifyOs().init(extensions: [VoiceAssistantExtension()])`.

The full guide for extensions is `EXTENSIONS.md` in the SmartifyOS repository:
https://github.com/Mauznemo/smartify_os_flutter_test/blob/main/EXTENSIONS.md. Everything
important from it is below, so this file is enough to work on this package.

## Layout

| Path | What |
|---|---|
| `lib/src/voice_assistant_extension.dart` | The `SmartifyOsExtension` subclass: every setup option, and the `init` that adds the app list entry, the Settings pages and the panel. |
| `lib/src/services/voice_assistant/voice_assistant_service.dart` | The conversation, from the wake word to the end of the answer, and what is loaded when. |
| `lib/src/services/voice_assistant/smartify_os_voice_assistant.dart` | The facade a car's app uses. |
| `lib/src/services/voice_assistant/commands/` | The command registry, the phrase and word matcher, the built-in commands. |
| `lib/src/services/voice_assistant/speech/` | The microphone, the speech worker isolate that runs the models, the wake word tokenizer. |
| `lib/src/services/voice_assistant/speech_models/` | The catalog of models (`SpeechModels`) and downloading them (`SpeechModelStore`). |
| `lib/src/services/voice_assistant/servers/` | The optional AI and speech servers (OpenAI API). |
| `lib/src/widgets/` | The panel and its waves. |
| `lib/src/i18n/en.i18n.json` | Every text the driver reads (slang), and the built-in commands' phrases. |
| `lib/voice_assistant.dart` | The public API: only what is exported here is usable by a car's app. |
| `test/` | Tests, run with `flutter test`. |
| `example/` | A minimal SmartifyOS app with this extension in it, for trying it on a computer. |

## How this extension works

Things that are easy to break and do not show until someone talks to a car:

- **Every model runs in the speech worker's isolate** (`speech_worker.dart` and
  `speech_worker_isolate.dart`), never on the main isolate: each sherpa-onnx call blocks
  for up to seconds, and the screen (with a 3D car) has to keep drawing. The isolate only
  runs while something is loaded and is killed once nothing is. With the wake word off,
  nothing of this extension runs between questions, no microphone either: keep it that
  way.
- **Audio arriving while the recognizer loads is kept** and gone through once it is
  there (`_vadFed` in the worker), so the driver can start talking the moment they press
  the button. Loading a recognizer must never reset the utterance being collected.
- **The wake word is any phrase, without a Python tool**: `SentencePiece` reads the wake
  word model's `bpe.model` and splits the phrase exactly the way sentencepiece does,
  which the model was trained on. A different split is made of valid pieces too, and is
  then heard far less reliably, so check a change against the model's own
  `keywords_raw.txt`/`keywords.txt`.
- **The wake word model only knows common English words well.** A name like "Miata"
  was heard 16 times out of 100 with sherpa's defaults. What fixed it, measured on a
  bench of Kokoro voices with car noise (and look-alike sentences that must not start
  it): `maxActivePaths: 16` instead of 4, every spelling in its 10 best splits
  (`encodeVariants`, `wakeWordKeywords`), looser thresholds (`WakeWordSensitivity`), and
  `wakeWordSpellings`, which together got it to 81. Transcribing the start of every
  sentence with the recognizer instead was no more reliable and costs ~0.4 s of
  processor per sentence. Re-measure before changing any of it; TTS says "Miata" as
  "Maya", "Me-ah-ta" is what sounds right. The debug view (Developer options) shows
  which spelling fired and what the microphone hears.
- **Teaching the wake word** (`WakeWordTeacher`) records the driver eight times, takes
  what the recognizer wrote down and every two-way split of its long words as
  candidates, tries each against the recordings with the wake word model itself (one
  spotter loaded with a keyword that never fires, a stream per candidate), and keeps
  the fewest that hear the most, each hearing at least two. Measured on takes it never
  heard, it went from 35 to 37 of 42; it helps most for voices the plain phrase misses.
  Learned spellings are saved and listened for next to `wakeWordSpellings`.
- **SmartifyOS's own sounds are never ducked**, which is what lets the chimes and the
  answer play at full volume while the music is down.
- **The car's own commands always beat the built-in ones** (`fallbacks` in
  `VoiceCommandMatcher`), whatever the scores: a built-in "close the window" once
  swallowed "close the windows". Built-in phrases are in `en.i18n.json`, and the
  English ones are always added next to the car's language.
- **Models live in one folder per model**, which only exists once complete (downloads
  go into `<folder>.part`). On Linux that is `~/.local/share/smartify-os/voice_assistant/models`
  whatever the app is called, because the smartify-os CLI puts models there too, from
  `smartify_os_downloads.json`. `test/downloads_test.dart` writes that file from
  `SpeechModels` (and fails until the new one is committed), so add every new model to
  its `_written` map, and to `_defaults` when it should go on a car unasked.
- **Kokoro is the full precision model on purpose**: the int8 one took more than twice as
  long to speak on ARM. Every new model gets tried for real before it goes in the
  catalog: download it, load it in the worker, and run a sentence through it.
- Sherpa-onnx in Kokoro only speaks English (and Chinese). Every other language gets a
  Piper voice, the wake word model only knows English sounds.

## Commands

```bash
flutter test                           # after every change; keep it passing
flutter analyze                        # must report no issues
dart format lib test example/lib       # never format by hand
dart run slang                         # after changing lib/src/i18n/en.i18n.json
cd example && flutter run -d macos     # or windows, or linux: run it in SmartifyOS
```

Generated files (`*.g.dart`, `*.freezed.dart`, `strings*.g.dart`) are committed, since a
car never runs a generator. `pubspec_overrides.yaml` says where this machine's copy of
SmartifyOS is; it is ignored by git and must stay that way.

## Rules

These are what keeps every car working with every extension. Do not break them, even
when asked for something that seems to need it; say so instead.

- **`init` is quick.** The car waits for it before showing anything. Register what the
  extension adds, read saved settings, and start anything slow without awaiting it.
  After 10 seconds the car starts without it.
- **Never stop the car from starting.** When something the feature needs is missing (a
  USB device, a program on Linux, the right platform), add nothing and log why.
  Anything that talks to hardware, files or the network catches its own errors.
- **Build on every platform.** SmartifyOS runs on Linux, Android, macOS and Windows. The
  package must compile on all four even where it does nothing: check `Platform.isLinux`
  and friends at runtime before using anything that only exists on one, and prefer a
  stand in over nothing on macOS and Windows, where people develop.
- **Only `package:smartify_os_core/<library>.dart`.** Never import a path containing
  `/src/` from SmartifyOS; it is not API and changes without warning. When something
  needed is not public, it belongs in SmartifyOS itself: say so rather than copying it.
- **Everything goes through SmartifyOS's public API**, exactly as a car's app would use
  it: `SmartifyOsAppList`, `SmartifyOsSettings`, `SmartifyOsHomeWidgets`,
  `SmartifyOsQuickSettings`, `SmartifyOsStatusBar`, `SmartifyOsNotifications`,
  `SmartifyOsLayouts` for a whole screen layout (built from the blocks in
  `layouts.dart`), `MediaPlayerCard` for anything that plays music, and
  `SmartifyOsInfoDisplay` for anything the car reports as a number (RPM, a
  temperature): add an `InfoDisplayValue` and feed it with `reportReading`, never a
  display of your own. Something that floats over every window until taken away is a
  `FloatingPanel` (`SmartifyOsFloatingPanels.showPanel`), never an overlay of its own,
  and any sound goes through `SmartifyOsSound`, never a second audio package.
- **Home widgets fit whatever box the layout gives them.** A card (`HomeWidget`) shows
  up by itself where the layout takes cards; a pinned one (`HomeWidget.pinned`, with a
  `title` and `icon`) only where the driver or a layout puts it. Build either to fit
  `home.size` (`home.shape` for a quick choice between arrangements) and set `minSize`,
  never a fixed size. Give every one, cards included, a `title` and an `icon`: the
  driver sees them when holding an area, where they can move a card or take it out.
- **Every name starts with the extension's id, `voice_assistant`.** App list entries,
  settings pages, home widgets, notifications, status icons, quick settings tiles,
  info display values and layouts;
  saved settings use keys `smartify_os.voice_assistant.<name>`.
- **Use what SmartifyOS already has:** `SmartifyOsLog` for logging, never `print` or
  `debugPrint` (`SmartifyOsLog.info('VoiceAssistant', '...')`, from `utils.dart`);
  `SmartifyOsTime.now` for any time the driver reads, never `DateTime.now()`, which is
  only for measuring durations (`date_time.dart`); `SmartifyOsShell` to run a program,
  never `Process`, with arguments as a list (`shell.dart`); `SmartifyOsGps` for where
  the car is and how fast it goes (`gps.dart`); `SmartifyOsVolume` for how loud it is
  (`volume.dart`); `SmartifyOsNightMode` for whether it is dark outside
  (`night_mode.dart`); `SmartifyOsCan` for the car's CAN bus, with the devices and
  messages defined as `CanDevice`s and `CanMessage`s (`can.dart`); `SmartifyOsSerial`
  to open a serial port, never a plugin or `/dev` read of its own (`serial.dart`).
- **Developer-only settings go on one page**, never on the extension's own: a page
  with `parent: SettingsPages.developer`, which is only shown while developer options
  are on (`developer_options.dart`). Anything the extension lets a developer fake is
  dropped when `SmartifyOsDeveloperOptions.enabledChanges` says they were turned off.
- **Windows and controls use the `Themed...` widgets** (`widgets.dart`) and the theme's
  text styles (`context.smartifyOsText`), so they match the car and can be driven with
  its knob and buttons. Anything else that can be pressed is wrapped in a
  `SmartifyOsFocusable` (`focus.dart`). Raw Material controls cannot be reached without
  the touchscreen.
- **Texts go in `lib/src/i18n/en.i18n.json`**, read through `t.`, with `$name` for values.
  Only English is written here; other languages are added by translators later. The
  car's language is `SmartifyOsLanguage.languageCode` (`language.dart`): set the
  extension's locale from it in `init` and follow `languageChanges`. Answers are read out
  loud, so they are written the way a person talks ("I've turned it up a bit").

## Dependencies

- **`smartify_os_core` is a lower bound only**: `">=X.Y.Z"`, the oldest SmartifyOS this
  works with. Raise it when using something only a newer SmartifyOS has. Never add an
  upper bound, a git url or a path: the car's app decides which SmartifyOS it runs.
- **Packages SmartifyOS uses itself are `any`** (see `dependencies` in
  `smartify_os_core/pubspec.yaml`), so SmartifyOS decides their version and this
  extension never blocks an update. Anything else: `flutter pub add <package>`.
- **No code generator whose output only compiles against one exact version.**
  `riverpod_generator` is one: write riverpod providers out by hand
  (`final xProvider = StreamProvider<X>((ref) => ...)`). `freezed` is fine.
- **No `dependency_overrides` in `pubspec.yaml`**: every car's app would have to repeat
  them.
- A GPL dependency makes this package GPL too; say so in `pubspec.yaml` and the README.

## Linux packages

Whatever the car needs installed on Linux is listed under `smartify_os: linux:` in
`pubspec.yaml`, and the `smartify-os` CLI installs it (on the official, apt based
distribution only). Never tell the owner to install something by hand instead.

- **`build.apt`**: what compiling needs, usually `-dev` packages and tools like
  `protobuf-compiler`. Flutter's own toolchain (clang, cmake, ninja, GTK) is not listed.
- **`run.apt`**: only what is loaded or started while running, which a build cannot see:
  a program run through `SmartifyOsShell`, a GStreamer plugin, a driver, a service talked
  to over D-Bus. Never a library the code links against (`libusb-1.0-0`, `libssl3t64`):
  the CLI reads those off the finished build, and their names change with every
  distribution release.
- **List everything this extension uses**, even what SmartifyOS already lists; it may
  stop needing it.
- **Only package names, never versions.** An entry can be `{package: name, arch: [x64]}`
  (or `arm64`) for a package only one of the two has.
- **Never a package that swaps out part of the system** (a sound server, a network
  manager, a display manager). If one is needed, it belongs in SmartifyOS itself.
- **`run.udev`**: rule files in this package, under `system/udev/`, named
  `NN-voice_assistant.rules`. Only permissions (`MODE`, `GROUP`, `TAG+="uaccess"`, `SYMLINK`),
  never `RUN`, `PROGRAM` or `IMPORT{program}`, which the CLI refuses. Keep the number
  below 73 when using `uaccess`.
- **`run.groups`**: groups the car's user is added to, from the CLI's short list of
  harmless ones (`plugdev`, `dialout`, `input`, `video`, ...).
- Passwordless `sudo` is already set up on every car; `SmartifyOsShell` with
  `elevated: true` uses it. Never list anything for it.

## Android and downloads

- **What the car's Android project needs** goes under `smartify_os: android:` in
  `pubspec.yaml`, and the CLI writes it into the car's `android/` folder: `minSdk` (an API
  level, only when something needs more than Flutter's own) and `permissions` the code asks
  the driver for (`android.permission.RECORD_AUDIO`). Never tell the owner to edit
  `android/` by hand.
- **Anything big downloaded onto the car** (models, maps) is listed in a JSON file named by
  `smartify_os: downloads:`, so the CLI can put it on the car with the app (the format is
  "Downloads" in EXTENSIONS.md). Each item is a folder of its own under
  `smartify-os/<id>/...` in the data folder (`~/.local/share` on Linux), made complete as
  `<folder>.part` and renamed, and a folder that is there is treated as whole. When the
  same list is in the code, a test writes the file from it.

## Style

- **Never use em dashes or en dashes**, anywhere: not in UI strings, doc comments,
  comments or markdown. Use a comma, parentheses, or a separate sentence.
- **Everything public has a `///` doc.** Say what it is for before what it does, address
  the reader as "you", and use plain words ("the car", "the phone", not "the host
  device"). Something a car's app is not meant to use still gets a `///` doc, starting
  with `Internal:`. Put a short runnable ` ```dart ` example on anything that needs
  setting up. Comments explain why, not what the next line does.
- **Texts the driver reads** are short and plain: "Connected over Wi-Fi", not "Wireless
  session established".
- **Fields go above the constructor** in every class and widget, never below it.
- **Plain value classes use `freezed`** (`@freezed abstract class X with _$X`), never a
  hand written `copyWith`, `==` or `hashCode`. Classes that hold a subscription, a
  timer or a controller stay plain.
- **Names that carry the project's name spell it out**: `SmartifyOs...`,
  `smartify_os_...`, never `Smartify` alone.
- **A static facade is named after what it works on**: `SmartifyOsVoiceAssistant.startRecording()`,
  not a bare `start()`, so the call says what it does.

## Keeping this file up to date

Update this file when something here stops being true, or when something new is worth
knowing for every later session on this package. Keep it to what cannot be worked out
quickly from the code; one off explanations belong in `///` docs.

This file started as a copy of `smartify_os_extension_template/AGENTS.md` in the
SmartifyOS repository, where the rules for all extensions are kept. When SmartifyOS
releases a new version, or when asked to update the extension rules, compare that file
(https://github.com/Mauznemo/smartify_os_flutter_test/blob/main/smartify_os_extension_template/AGENTS.md)
with this one, and bring over whatever changed in its Rules, Dependencies and Style
sections, keeping anything written here that is specific to this extension. That copy
is written for a placeholder feature; read its names as this extension's.
