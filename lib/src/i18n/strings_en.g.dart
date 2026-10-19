///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$voice_assistant$en voice_assistant = Translations$voice_assistant$en.internal(_root);
	late final Translations$status$en status = Translations$status$en.internal(_root);
	late final Translations$replies$en replies = Translations$replies$en.internal(_root);
	late final Translations$commands$en commands = Translations$commands$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$models$en models = Translations$models$en.internal(_root);
	late final Translations$teach$en teach = Translations$teach$en.internal(_root);
}

// Path: voice_assistant
class Translations$voice_assistant$en {
	Translations$voice_assistant$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Voice assistant'
	String get title => 'Voice assistant';

	/// en: 'Ask'
	String get app_title => 'Ask';

	/// en: 'Stop'
	String get stop => 'Stop';
}

// Path: status
class Translations$status$en {
	Translations$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Getting ready'
	String get getting_ready => 'Getting ready';

	/// en: 'Listening'
	String get listening => 'Listening';

	/// en: 'Say what you want'
	String get listening_hint => 'Say what you want';

	/// en: 'Understanding'
	String get understanding => 'Understanding';

	/// en: 'Thinking'
	String get thinking => 'Thinking';

	/// en: 'Asking the AI server'
	String get asking_server => 'Asking the AI server';

	/// en: 'Answering'
	String get speaking => 'Answering';

	/// en: 'Done'
	String get done => 'Done';
}

// Path: replies
class Translations$replies$en {
	Translations$replies$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sorry, I don't know how to help with that yet.'
	String get not_understood => 'Sorry, I don\'t know how to help with that yet.';

	/// en: 'I didn't catch anything.'
	String get nothing_heard => 'I didn\'t catch anything.';

	/// en: 'I couldn't reach the AI server, and I don't know that one myself.'
	String get server_unreachable => 'I couldn\'t reach the AI server, and I don\'t know that one myself.';

	/// en: 'I can't listen yet, the speech models still need downloading. You can do that in Settings, Voice assistant.'
	String get model_missing => 'I can\'t listen yet, the speech models still need downloading. You can do that in Settings, Voice assistant.';

	/// en: 'I can't listen yet, the speech models still need downloading. I've opened the page for that.'
	String get model_missing_opened => 'I can\'t listen yet, the speech models still need downloading. I\'ve opened the page for that.';

	/// en: 'I can't get to the microphone.'
	String get no_microphone => 'I can\'t get to the microphone.';

	/// en: 'Sorry, something went wrong there.'
	String get something_went_wrong => 'Sorry, something went wrong there.';

	/// en: 'I've turned it up a bit.'
	String get volume_up => 'I\'ve turned it up a bit.';

	/// en: 'I've turned it down a bit.'
	String get volume_down => 'I\'ve turned it down a bit.';

	/// en: 'The sound is back on.'
	String get unmuted => 'The sound is back on.';

	/// en: 'It's $time.'
	String time({required Object time}) => 'It\'s ${time}.';

	/// en: 'Sure, here's $name.'
	String opening({required Object name}) => 'Sure, here\'s ${name}.';

	/// en: '$name is already open.'
	String already_open({required Object name}) => '${name} is already open.';

	/// en: 'I couldn't find an app called $name.'
	String app_not_found({required Object name}) => 'I couldn\'t find an app called ${name}.';

	/// en: 'There's no phone connected for me to play from.'
	String get no_phone => 'There\'s no phone connected for me to play from.';
}

// Path: commands
class Translations$commands$en {
	Translations$commands$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$commands$volume_up$en volume_up = Translations$commands$volume_up$en.internal(_root);
	late final Translations$commands$volume_down$en volume_down = Translations$commands$volume_down$en.internal(_root);
	late final Translations$commands$mute$en mute = Translations$commands$mute$en.internal(_root);
	late final Translations$commands$unmute$en unmute = Translations$commands$unmute$en.internal(_root);
	late final Translations$commands$go_home$en go_home = Translations$commands$go_home$en.internal(_root);
	late final Translations$commands$open_app$en open_app = Translations$commands$open_app$en.internal(_root);
	late final Translations$commands$play_music$en play_music = Translations$commands$play_music$en.internal(_root);
	late final Translations$commands$pause_music$en pause_music = Translations$commands$pause_music$en.internal(_root);
	late final Translations$commands$next_track$en next_track = Translations$commands$next_track$en.internal(_root);
	late final Translations$commands$previous_track$en previous_track = Translations$commands$previous_track$en.internal(_root);
	late final Translations$commands$time$en time = Translations$commands$time$en.internal(_root);
	late final Translations$commands$cancel$en cancel = Translations$commands$cancel$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Get ready to listen'
	String get setup => 'Get ready to listen';

	/// en: 'Download everything it needs in one go'
	String get setup_subtitle => 'Download everything it needs in one go';

	/// en: '$size still to download'
	String setup_missing({required Object size}) => '${size} still to download';

	/// en: 'Everything is downloaded. Press the button or say the wake word to start.'
	String get setup_ready => 'Everything is downloaded. Press the button or say the wake word to start.';

	/// en: 'Needed for what you picked'
	String get setup_needed => 'Needed for what you picked';

	/// en: 'Download all ($size)'
	String setup_download({required Object size}) => 'Download all (${size})';

	/// en: 'Stop downloading'
	String get setup_cancel => 'Stop downloading';

	/// en: '$done of $total'
	String setup_progress({required Object done, required Object total}) => '${done} of ${total}';

	/// en: 'Something didn't download. Check the connection and try again.'
	String get setup_failed => 'Something didn\'t download. Check the connection and try again.';

	/// en: 'Listening'
	String get listening => 'Listening';

	/// en: 'Wake word'
	String get wake_word => 'Wake word';

	/// en: 'Say "$phrase" to start'
	String wake_word_subtitle({required Object phrase}) => 'Say "${phrase}" to start';

	/// en: 'Download the wake word model first'
	String get wake_word_needs_model => 'Download the wake word model first';

	/// en: 'Wake word sensitivity'
	String get sensitivity => 'Wake word sensitivity';

	/// en: 'Low'
	String get sensitivity_low => 'Low';

	/// en: 'Starts less often by mistake'
	String get sensitivity_low_subtitle => 'Starts less often by mistake';

	/// en: 'Normal'
	String get sensitivity_normal => 'Normal';

	/// en: 'High'
	String get sensitivity_high => 'High';

	/// en: 'Hears it from further away'
	String get sensitivity_high_subtitle => 'Hears it from further away';

	/// en: 'Speech recognition'
	String get recognition => 'Speech recognition';

	/// en: 'Recognition model'
	String get recognizer => 'Recognition model';

	/// en: 'Answers'
	String get answers => 'Answers';

	/// en: 'Answer out loud'
	String get speak_answers => 'Answer out loud';

	/// en: 'Voice'
	String get voice => 'Voice';

	/// en: 'Speech server'
	String get voice_server => 'Speech server';

	/// en: 'Falls back to the voice on the car without a connection'
	String get voice_server_subtitle => 'Falls back to the voice on the car without a connection';

	/// en: 'AI server'
	String get ai => 'AI server';

	/// en: 'Use the AI server'
	String get use_ai => 'Use the AI server';

	/// en: 'Understands anything you say, needs a connection'
	String get use_ai_subtitle => 'Understands anything you say, needs a connection';

	/// en: 'What you can say'
	String get commands => 'What you can say';

	/// en: 'Everything the assistant understands without a server'
	String get commands_subtitle => 'Everything the assistant understands without a server';

	/// en: 'Downloaded models'
	String get models => 'Downloaded models';

	/// en: 'Download them once, and they work without a connection'
	String get models_subtitle => 'Download them once, and they work without a connection';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Downloading $percent%'
	String downloading({required Object percent}) => 'Downloading ${percent}%';

	/// en: 'Downloaded'
	String get downloaded => 'Downloaded';

	/// en: 'Not downloaded'
	String get not_downloaded => 'Not downloaded';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Download failed'
	String get download_failed => 'Download failed';

	/// en: 'In use'
	String get in_use => 'In use';

	/// en: '$size MB'
	String size({required Object size}) => '${size} MB';

	/// en: 'Speech recognition'
	String get kind_recognizer => 'Speech recognition';

	/// en: 'Voices'
	String get kind_voice => 'Voices';

	/// en: 'Wake word'
	String get kind_wake_word => 'Wake word';

	/// en: 'Voice detection'
	String get kind_voice_detection => 'Voice detection';

	/// en: 'Try a sentence'
	String get try_sentence => 'Try a sentence';

	/// en: 'Runs it as if you had said it'
	String get try_sentence_subtitle => 'Runs it as if you had said it';

	/// en: 'What it hears'
	String get debug_wake_word => 'What it hears';

	/// en: 'Listening for "$phrase"'
	String debug_on({required Object phrase}) => 'Listening for "${phrase}"';

	/// en: 'The wake word is off, only what you say is shown'
	String get debug_off => 'The wake word is off, only what you say is shown';

	/// en: 'While this page is open, everything the microphone hears is written down here, and each time it heard the wake word.'
	String get debug_hint => 'While this page is open, everything the microphone hears is written down here, and each time it heard the wake word.';

	/// en: 'Wake word, heard as "$spelling"'
	String debug_heard_wake_word({required Object spelling}) => 'Wake word, heard as "${spelling}"';

	/// en: 'Nothing heard yet. Say something.'
	String get debug_nothing_yet => 'Nothing heard yet. Say something.';

	/// en: 'Download the speech models first'
	String get debug_needs_model => 'Download the speech models first';
}

// Path: models
class Translations$models$en {
	Translations$models$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Parakeet'
	String get parakeet_v3 => 'Parakeet';

	/// en: 'Most accurate, 25 European languages'
	String get parakeet_v3_about => 'Most accurate, 25 European languages';

	/// en: 'Whisper base'
	String get whisper_base => 'Whisper base';

	/// en: 'Good balance, almost every language'
	String get whisper_base_about => 'Good balance, almost every language';

	/// en: 'Whisper tiny'
	String get whisper_tiny => 'Whisper tiny';

	/// en: 'Fastest with many languages, less accurate'
	String get whisper_tiny_about => 'Fastest with many languages, less accurate';

	/// en: 'Moonshine'
	String get moonshine_base_en => 'Moonshine';

	/// en: 'Fast and accurate, English only'
	String get moonshine_base_en_about => 'Fast and accurate, English only';

	/// en: 'Moonshine tiny'
	String get moonshine_tiny_en => 'Moonshine tiny';

	/// en: 'Fastest, English only'
	String get moonshine_tiny_en_about => 'Fastest, English only';

	/// en: 'Fable'
	String get kokoro_fable => 'Fable';

	/// en: 'British English, natural sounding'
	String get kokoro_fable_about => 'British English, natural sounding';

	/// en: 'Alan'
	String get piper_alan => 'Alan';

	/// en: 'British English, light enough for a Raspberry Pi'
	String get piper_alan_about => 'British English, light enough for a Raspberry Pi';

	/// en: 'Thorsten'
	String get piper_thorsten => 'Thorsten';

	/// en: 'German'
	String get piper_thorsten_about => 'German';

	/// en: 'Wake word'
	String get wake_word => 'Wake word';

	/// en: 'Listens for the wake word, very small'
	String get wake_word_about => 'Listens for the wake word, very small';

	/// en: 'Voice detection'
	String get voice_detection => 'Voice detection';

	/// en: 'Notices when you stop talking, very small'
	String get voice_detection_about => 'Notices when you stop talking, very small';
}

// Path: teach
class Translations$teach$en {
	Translations$teach$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Teach it your voice'
	String get title => 'Teach it your voice';

	/// en: 'Say the wake word a few times, and it learns how you say it'
	String get subtitle => 'Say the wake word a few times, and it learns how you say it';

	/// en: 'Say "$phrase" $count times, the way you would in the car, with a short pause after each. It works out how you say it and listens for that from then on.'
	String intro({required Object phrase, required Object count}) => 'Say "${phrase}" ${count} times, the way you would in the car, with a short pause after each. It works out how you say it and listens for that from then on.';

	/// en: 'Start'
	String get start => 'Start';

	/// en: 'Teach it again'
	String get again => 'Teach it again';

	/// en: 'Stop'
	String get cancel => 'Stop';

	/// en: 'Say "$phrase"'
	String say_it({required Object phrase}) => 'Say "${phrase}"';

	/// en: '$done of $total'
	String recorded({required Object done, required Object total}) => '${done} of ${total}';

	/// en: 'Heard "$text"'
	String heard({required Object text}) => 'Heard "${text}"';

	/// en: 'Heard "$text", which doesn't sound like it. Try again.'
	String left_out({required Object text}) => 'Heard "${text}", which doesn\'t sound like it. Try again.';

	/// en: 'Working out how you say it'
	String get working => 'Working out how you say it';

	/// en: 'Tried $done of $total spellings'
	String tried({required Object done, required Object total}) => 'Tried ${done} of ${total} spellings';

	/// en: 'It heard you $before of $total times before, and $after of $total times now.'
	String result({required Object before, required Object total, required Object after}) => 'It heard you ${before} of ${total} times before, and ${after} of ${total} times now.';

	/// en: 'What it learned'
	String get learned => 'What it learned';

	/// en: 'Heard $count of $total'
	String learned_heard({required Object count, required Object total}) => 'Heard ${count} of ${total}';

	/// en: 'It already knew how you say it, so there was nothing new to learn.'
	String get nothing_learned => 'It already knew how you say it, so there was nothing new to learn.';

	/// en: 'Forget what it learned'
	String get forget => 'Forget what it learned';

	/// en: 'It forgot what it learned.'
	String get forgotten => 'It forgot what it learned.';

	/// en: 'Download the speech models and the wake word first, in Get ready to listen.'
	String get needs_models => 'Download the speech models and the wake word first, in Get ready to listen.';

	/// en: 'It can't get to the microphone.'
	String get no_microphone => 'It can\'t get to the microphone.';

	/// en: 'Something went wrong while working it out. Try again.'
	String get failed => 'Something went wrong while working it out. Try again.';
}

// Path: commands.volume_up
class Translations$commands$volume_up$en {
	Translations$commands$volume_up$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Turn the volume up'
	String get title => 'Turn the volume up';

	List<String> get phrases => [
		'louder',
		'volume up',
		'turn it up',
		'turn the volume up',
		'turn up the volume',
		'increase the volume',
		'raise the volume',
	];
}

// Path: commands.volume_down
class Translations$commands$volume_down$en {
	Translations$commands$volume_down$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Turn the volume down'
	String get title => 'Turn the volume down';

	List<String> get phrases => [
		'quieter',
		'softer',
		'volume down',
		'turn it down',
		'turn the volume down',
		'turn down the volume',
		'decrease the volume',
		'lower the volume',
	];
}

// Path: commands.mute
class Translations$commands$mute$en {
	Translations$commands$mute$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mute the sound'
	String get title => 'Mute the sound';

	List<String> get phrases => [
		'mute',
		'be quiet',
		'silence',
		'turn the sound off',
	];
}

// Path: commands.unmute
class Translations$commands$unmute$en {
	Translations$commands$unmute$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Turn the sound back on'
	String get title => 'Turn the sound back on';

	List<String> get phrases => [
		'unmute',
		'sound on',
		'turn the sound on',
		'turn the sound back on',
	];
}

// Path: commands.go_home
class Translations$commands$go_home$en {
	Translations$commands$go_home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Go to the home screen'
	String get title => 'Go to the home screen';

	List<String> get phrases => [
		'go home',
		'home screen',
		'go to the home screen',
		'back to the home screen',
	];
}

// Path: commands.open_app
class Translations$commands$open_app$en {
	Translations$commands$open_app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open an app'
	String get title => 'Open an app';

	List<String> get phrases => [
		'open {app}',
		'show {app}',
		'start {app}',
		'launch {app}',
		'go to {app}',
	];

	/// en: 'The name of the app, as it is written in the app list'
	String get app => 'The name of the app, as it is written in the app list';
}

// Path: commands.play_music
class Translations$commands$play_music$en {
	Translations$commands$play_music$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Play the music'
	String get title => 'Play the music';

	List<String> get phrases => [
		'play',
		'play music',
		'play the music',
		'resume',
		'continue playing',
	];
}

// Path: commands.pause_music
class Translations$commands$pause_music$en {
	Translations$commands$pause_music$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pause the music'
	String get title => 'Pause the music';

	List<String> get phrases => [
		'pause',
		'pause the music',
		'stop the music',
		'stop playing',
	];
}

// Path: commands.next_track
class Translations$commands$next_track$en {
	Translations$commands$next_track$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip to the next song'
	String get title => 'Skip to the next song';

	List<String> get phrases => [
		'next',
		'next song',
		'next track',
		'skip',
		'skip this song',
		'skip the song',
	];
}

// Path: commands.previous_track
class Translations$commands$previous_track$en {
	Translations$commands$previous_track$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Go back to the previous song'
	String get title => 'Go back to the previous song';

	List<String> get phrases => [
		'previous',
		'previous song',
		'previous track',
		'last song',
		'go back a song',
	];
}

// Path: commands.time
class Translations$commands$time$en {
	Translations$commands$time$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Say what time it is'
	String get title => 'Say what time it is';

	List<String> get phrases => [
		'what time is it',
		'what\'s the time',
		'tell me the time',
		'current time',
	];
}

// Path: commands.cancel
class Translations$commands$cancel$en {
	Translations$commands$cancel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close the assistant'
	String get title => 'Close the assistant';

	List<String> get phrases => [
		'cancel',
		'never mind',
		'nevermind',
		'forget it',
		'nothing',
		'stop',
	];
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'voice_assistant.title' => 'Voice assistant',
			'voice_assistant.app_title' => 'Ask',
			'voice_assistant.stop' => 'Stop',
			'status.getting_ready' => 'Getting ready',
			'status.listening' => 'Listening',
			'status.listening_hint' => 'Say what you want',
			'status.understanding' => 'Understanding',
			'status.thinking' => 'Thinking',
			'status.asking_server' => 'Asking the AI server',
			'status.speaking' => 'Answering',
			'status.done' => 'Done',
			'replies.not_understood' => 'Sorry, I don\'t know how to help with that yet.',
			'replies.nothing_heard' => 'I didn\'t catch anything.',
			'replies.server_unreachable' => 'I couldn\'t reach the AI server, and I don\'t know that one myself.',
			'replies.model_missing' => 'I can\'t listen yet, the speech models still need downloading. You can do that in Settings, Voice assistant.',
			'replies.model_missing_opened' => 'I can\'t listen yet, the speech models still need downloading. I\'ve opened the page for that.',
			'replies.no_microphone' => 'I can\'t get to the microphone.',
			'replies.something_went_wrong' => 'Sorry, something went wrong there.',
			'replies.volume_up' => 'I\'ve turned it up a bit.',
			'replies.volume_down' => 'I\'ve turned it down a bit.',
			'replies.unmuted' => 'The sound is back on.',
			'replies.time' => ({required Object time}) => 'It\'s ${time}.',
			'replies.opening' => ({required Object name}) => 'Sure, here\'s ${name}.',
			'replies.already_open' => ({required Object name}) => '${name} is already open.',
			'replies.app_not_found' => ({required Object name}) => 'I couldn\'t find an app called ${name}.',
			'replies.no_phone' => 'There\'s no phone connected for me to play from.',
			'commands.volume_up.title' => 'Turn the volume up',
			'commands.volume_up.phrases.0' => 'louder',
			'commands.volume_up.phrases.1' => 'volume up',
			'commands.volume_up.phrases.2' => 'turn it up',
			'commands.volume_up.phrases.3' => 'turn the volume up',
			'commands.volume_up.phrases.4' => 'turn up the volume',
			'commands.volume_up.phrases.5' => 'increase the volume',
			'commands.volume_up.phrases.6' => 'raise the volume',
			'commands.volume_down.title' => 'Turn the volume down',
			'commands.volume_down.phrases.0' => 'quieter',
			'commands.volume_down.phrases.1' => 'softer',
			'commands.volume_down.phrases.2' => 'volume down',
			'commands.volume_down.phrases.3' => 'turn it down',
			'commands.volume_down.phrases.4' => 'turn the volume down',
			'commands.volume_down.phrases.5' => 'turn down the volume',
			'commands.volume_down.phrases.6' => 'decrease the volume',
			'commands.volume_down.phrases.7' => 'lower the volume',
			'commands.mute.title' => 'Mute the sound',
			'commands.mute.phrases.0' => 'mute',
			'commands.mute.phrases.1' => 'be quiet',
			'commands.mute.phrases.2' => 'silence',
			'commands.mute.phrases.3' => 'turn the sound off',
			'commands.unmute.title' => 'Turn the sound back on',
			'commands.unmute.phrases.0' => 'unmute',
			'commands.unmute.phrases.1' => 'sound on',
			'commands.unmute.phrases.2' => 'turn the sound on',
			'commands.unmute.phrases.3' => 'turn the sound back on',
			'commands.go_home.title' => 'Go to the home screen',
			'commands.go_home.phrases.0' => 'go home',
			'commands.go_home.phrases.1' => 'home screen',
			'commands.go_home.phrases.2' => 'go to the home screen',
			'commands.go_home.phrases.3' => 'back to the home screen',
			'commands.open_app.title' => 'Open an app',
			'commands.open_app.phrases.0' => 'open {app}',
			'commands.open_app.phrases.1' => 'show {app}',
			'commands.open_app.phrases.2' => 'start {app}',
			'commands.open_app.phrases.3' => 'launch {app}',
			'commands.open_app.phrases.4' => 'go to {app}',
			'commands.open_app.app' => 'The name of the app, as it is written in the app list',
			'commands.play_music.title' => 'Play the music',
			'commands.play_music.phrases.0' => 'play',
			'commands.play_music.phrases.1' => 'play music',
			'commands.play_music.phrases.2' => 'play the music',
			'commands.play_music.phrases.3' => 'resume',
			'commands.play_music.phrases.4' => 'continue playing',
			'commands.pause_music.title' => 'Pause the music',
			'commands.pause_music.phrases.0' => 'pause',
			'commands.pause_music.phrases.1' => 'pause the music',
			'commands.pause_music.phrases.2' => 'stop the music',
			'commands.pause_music.phrases.3' => 'stop playing',
			'commands.next_track.title' => 'Skip to the next song',
			'commands.next_track.phrases.0' => 'next',
			'commands.next_track.phrases.1' => 'next song',
			'commands.next_track.phrases.2' => 'next track',
			'commands.next_track.phrases.3' => 'skip',
			'commands.next_track.phrases.4' => 'skip this song',
			'commands.next_track.phrases.5' => 'skip the song',
			'commands.previous_track.title' => 'Go back to the previous song',
			'commands.previous_track.phrases.0' => 'previous',
			'commands.previous_track.phrases.1' => 'previous song',
			'commands.previous_track.phrases.2' => 'previous track',
			'commands.previous_track.phrases.3' => 'last song',
			'commands.previous_track.phrases.4' => 'go back a song',
			'commands.time.title' => 'Say what time it is',
			'commands.time.phrases.0' => 'what time is it',
			'commands.time.phrases.1' => 'what\'s the time',
			'commands.time.phrases.2' => 'tell me the time',
			'commands.time.phrases.3' => 'current time',
			'commands.cancel.title' => 'Close the assistant',
			'commands.cancel.phrases.0' => 'cancel',
			'commands.cancel.phrases.1' => 'never mind',
			'commands.cancel.phrases.2' => 'nevermind',
			'commands.cancel.phrases.3' => 'forget it',
			'commands.cancel.phrases.4' => 'nothing',
			'commands.cancel.phrases.5' => 'stop',
			'settings.setup' => 'Get ready to listen',
			'settings.setup_subtitle' => 'Download everything it needs in one go',
			'settings.setup_missing' => ({required Object size}) => '${size} still to download',
			'settings.setup_ready' => 'Everything is downloaded. Press the button or say the wake word to start.',
			'settings.setup_needed' => 'Needed for what you picked',
			'settings.setup_download' => ({required Object size}) => 'Download all (${size})',
			'settings.setup_cancel' => 'Stop downloading',
			'settings.setup_progress' => ({required Object done, required Object total}) => '${done} of ${total}',
			'settings.setup_failed' => 'Something didn\'t download. Check the connection and try again.',
			'settings.listening' => 'Listening',
			'settings.wake_word' => 'Wake word',
			'settings.wake_word_subtitle' => ({required Object phrase}) => 'Say "${phrase}" to start',
			'settings.wake_word_needs_model' => 'Download the wake word model first',
			'settings.sensitivity' => 'Wake word sensitivity',
			'settings.sensitivity_low' => 'Low',
			'settings.sensitivity_low_subtitle' => 'Starts less often by mistake',
			'settings.sensitivity_normal' => 'Normal',
			'settings.sensitivity_high' => 'High',
			'settings.sensitivity_high_subtitle' => 'Hears it from further away',
			'settings.recognition' => 'Speech recognition',
			'settings.recognizer' => 'Recognition model',
			'settings.answers' => 'Answers',
			'settings.speak_answers' => 'Answer out loud',
			'settings.voice' => 'Voice',
			'settings.voice_server' => 'Speech server',
			'settings.voice_server_subtitle' => 'Falls back to the voice on the car without a connection',
			'settings.ai' => 'AI server',
			'settings.use_ai' => 'Use the AI server',
			'settings.use_ai_subtitle' => 'Understands anything you say, needs a connection',
			'settings.commands' => 'What you can say',
			'settings.commands_subtitle' => 'Everything the assistant understands without a server',
			'settings.models' => 'Downloaded models',
			'settings.models_subtitle' => 'Download them once, and they work without a connection',
			'settings.download' => 'Download',
			'settings.downloading' => ({required Object percent}) => 'Downloading ${percent}%',
			'settings.downloaded' => 'Downloaded',
			'settings.not_downloaded' => 'Not downloaded',
			'settings.delete' => 'Delete',
			'settings.download_failed' => 'Download failed',
			'settings.in_use' => 'In use',
			'settings.size' => ({required Object size}) => '${size} MB',
			'settings.kind_recognizer' => 'Speech recognition',
			'settings.kind_voice' => 'Voices',
			'settings.kind_wake_word' => 'Wake word',
			'settings.kind_voice_detection' => 'Voice detection',
			'settings.try_sentence' => 'Try a sentence',
			'settings.try_sentence_subtitle' => 'Runs it as if you had said it',
			'settings.debug_wake_word' => 'What it hears',
			'settings.debug_on' => ({required Object phrase}) => 'Listening for "${phrase}"',
			'settings.debug_off' => 'The wake word is off, only what you say is shown',
			'settings.debug_hint' => 'While this page is open, everything the microphone hears is written down here, and each time it heard the wake word.',
			'settings.debug_heard_wake_word' => ({required Object spelling}) => 'Wake word, heard as "${spelling}"',
			'settings.debug_nothing_yet' => 'Nothing heard yet. Say something.',
			'settings.debug_needs_model' => 'Download the speech models first',
			'models.parakeet_v3' => 'Parakeet',
			'models.parakeet_v3_about' => 'Most accurate, 25 European languages',
			'models.whisper_base' => 'Whisper base',
			'models.whisper_base_about' => 'Good balance, almost every language',
			'models.whisper_tiny' => 'Whisper tiny',
			'models.whisper_tiny_about' => 'Fastest with many languages, less accurate',
			'models.moonshine_base_en' => 'Moonshine',
			'models.moonshine_base_en_about' => 'Fast and accurate, English only',
			'models.moonshine_tiny_en' => 'Moonshine tiny',
			'models.moonshine_tiny_en_about' => 'Fastest, English only',
			'models.kokoro_fable' => 'Fable',
			'models.kokoro_fable_about' => 'British English, natural sounding',
			'models.piper_alan' => 'Alan',
			'models.piper_alan_about' => 'British English, light enough for a Raspberry Pi',
			'models.piper_thorsten' => 'Thorsten',
			'models.piper_thorsten_about' => 'German',
			'models.wake_word' => 'Wake word',
			'models.wake_word_about' => 'Listens for the wake word, very small',
			'models.voice_detection' => 'Voice detection',
			'models.voice_detection_about' => 'Notices when you stop talking, very small',
			'teach.title' => 'Teach it your voice',
			'teach.subtitle' => 'Say the wake word a few times, and it learns how you say it',
			'teach.intro' => ({required Object phrase, required Object count}) => 'Say "${phrase}" ${count} times, the way you would in the car, with a short pause after each. It works out how you say it and listens for that from then on.',
			'teach.start' => 'Start',
			'teach.again' => 'Teach it again',
			'teach.cancel' => 'Stop',
			'teach.say_it' => ({required Object phrase}) => 'Say "${phrase}"',
			'teach.recorded' => ({required Object done, required Object total}) => '${done} of ${total}',
			'teach.heard' => ({required Object text}) => 'Heard "${text}"',
			'teach.left_out' => ({required Object text}) => 'Heard "${text}", which doesn\'t sound like it. Try again.',
			'teach.working' => 'Working out how you say it',
			'teach.tried' => ({required Object done, required Object total}) => 'Tried ${done} of ${total} spellings',
			'teach.result' => ({required Object before, required Object total, required Object after}) => 'It heard you ${before} of ${total} times before, and ${after} of ${total} times now.',
			'teach.learned' => 'What it learned',
			'teach.learned_heard' => ({required Object count, required Object total}) => 'Heard ${count} of ${total}',
			'teach.nothing_learned' => 'It already knew how you say it, so there was nothing new to learn.',
			'teach.forget' => 'Forget what it learned',
			'teach.forgotten' => 'It forgot what it learned.',
			'teach.needs_models' => 'Download the speech models and the wake word first, in Get ready to listen.',
			'teach.no_microphone' => 'It can\'t get to the microphone.',
			'teach.failed' => 'Something went wrong while working it out. Try again.',
			_ => null,
		};
	}
}
