import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_command_matcher.dart';
import 'package:smartify_os_voice_assistant/voice_assistant.dart';

VoiceCommand command(
  String id, {
  List<String> phrases = const [],
  List<List<String>> words = const [],
}) => VoiceCommand(
  id: id,
  title: id,
  phrases: phrases,
  words: words,
  onRun: (_) => null,
);

String? matched(String text, List<VoiceCommand> commands) =>
    VoiceCommandMatcher.match(text, commands)?.command.id;

void main() {
  group('a phrase', () {
    final windows = command('windows_up', phrases: ['close the windows']);

    test('matches with words around it and any punctuation', () {
      expect(matched('Close the windows.', [windows]), 'windows_up');
      expect(matched('please close the windows now', [windows]), 'windows_up');
      expect(matched('Close, the window!', [windows]), 'windows_up');
    });

    test('does not match with a word missing', () {
      expect(matched('close windows', [windows]), isNull);
    });

    test('fills its gaps', () {
      final temperature = command(
        'temperature',
        phrases: ['set the temperature to {degrees}'],
      );
      final match = VoiceCommandMatcher.match(
        'Please set the temperature to 21.5 degrees',
        [temperature],
      )!;
      expect(match.values['degrees'], '21.5 degrees');
      expect(
        VoiceCommandRun(text: '', values: match.values).number('degrees'),
        21.5,
      );
    });

    test('a gap in the middle takes only what it needs', () {
      final call = command('call', phrases: ['call {name} on mobile']);
      final match = VoiceCommandMatcher.match('call anna maria on mobile', [
        call,
      ])!;
      expect(match.values['name'], 'anna maria');
    });

    test('works in other languages', () {
      final fenster = command('fenster', phrases: ['Fenster schließen']);
      expect(matched('Bitte die Fenster schließen', [fenster]), 'fenster');
    });
  });

  group('words', () {
    final up = command(
      'windows_up',
      words: [
        ['window', 'windows'],
        ['up', 'raise', 'close'],
      ],
    );
    final down = command(
      'windows_down',
      words: [
        ['window', 'windows'],
        ['down', 'lower', 'open'],
      ],
    );

    test('needs a word from every list, in any order', () {
      expect(
        matched('could you raise the window please', [up, down]),
        'windows_up',
      );
      expect(matched('windows down', [up, down]), 'windows_down');
      expect(matched('open the windows', [up, down]), 'windows_down');
      expect(matched('raise it', [up, down]), isNull);
    });

    test('short words have to match exactly', () {
      expect(matched('window upper', [up]), isNull);
    });

    test('an entry can be several words', () {
      final louder = command(
        'louder',
        words: [
          ['turn up', 'louder'],
        ],
      );
      expect(matched('turn up the radio', [louder]), 'louder');
      expect(matched('turn the radio', [louder]), isNull);
    });
  });

  group('picking between commands', () {
    test('the one that matched more words wins', () {
      final openApp = command('open_app', phrases: ['open {app}']);
      final windows = command(
        'windows_down',
        words: [
          ['window', 'windows'],
          ['open'],
        ],
      );
      expect(matched('open the windows', [openApp, windows]), 'windows_down');
      expect(matched('open settings', [openApp, windows]), 'open_app');
    });

    test('a tie goes to the one added last', () {
      final first = command('first', phrases: ['next']);
      final last = command('last', phrases: ['next']);
      expect(matched('next', [first, last]), 'last');
    });

    test("the car's own beat the built-in ones, however well they match", () {
      final goHome = command('go_home', phrases: ['close the window']);
      final windows = command(
        'windows_up',
        words: [
          ['windows'],
          ['close'],
        ],
      );
      final match = VoiceCommandMatcher.match(
        'close the windows',
        [goHome, windows],
        fallbacks: {goHome},
      );
      expect(match?.command.id, 'windows_up');
      expect(
        VoiceCommandMatcher.match(
          'close the window please',
          [goHome],
          fallbacks: {goHome},
        )?.command.id,
        'go_home',
      );
    });

    test('a phrase that is the whole sentence beats one inside it', () {
      final stop = command('stop', phrases: ['stop the music']);
      final cancel = command('cancel', phrases: ['stop']);
      expect(matched('stop the music', [cancel, stop]), 'stop');
      expect(matched('stop', [stop, cancel]), 'cancel');
    });

    test('nothing said, nothing matched', () {
      expect(
        matched('  ', [
          command('a', phrases: ['a']),
        ]),
        isNull,
      );
    });
  });

  test('tokenize keeps numbers whole and drops punctuation', () {
    expect(VoiceCommandMatcher.tokenize("What's the time? It's 21,5."), [
      'whats',
      'the',
      'time',
      'its',
      '21.5',
    ]);
  });
}
