import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/wake_word_teacher.dart';

void main() {
  group('how much it sounds like the wake word', () {
    test('the same, or a letter off, is close', () {
      expect(wakeWordSimilarity('Hey Miata.', 'Hey Miata'), 1);
      expect(wakeWordSimilarity('Hey Miyata!', 'Hey Miata'), greaterThan(0.8));
      expect(wakeWordSimilarity('Hey Miata, what time is it', 'Hey Miata'), 1);
    });

    test('something else is not', () {
      expect(
        wakeWordSimilarity('The weather is nice', 'Hey Miata'),
        lessThan(soundsLikeWakeWord),
      );
      expect(wakeWordSimilarity('', 'Hey Miata'), 0);
    });
  });

  group('candidate spellings', () {
    test('what was heard, and its long words split in two', () {
      final candidates = candidateSpellings('Hey Miata', [
        'Hey Miyata.',
        'Hey, Miyata!',
      ]);
      expect(candidates.first, 'hey miyata');
      expect(
        candidates,
        containsAll(['hey mi yata', 'hey miy ata', 'hey miya ta']),
      );
      // The same thing heard twice is tried once.
      expect(candidates.where((c) => c == 'hey miyata'), hasLength(1));
    });

    test('leaves out what is always listened for anyway', () {
      expect(
        candidateSpellings('Hey Miata', ['Hey Miata'], known: ['Hey Miata']),
        isNot(contains('hey miata')),
      );
    });

    test('leaves out what does not sound like the wake word', () {
      expect(
        candidateSpellings('Hey Miata', ['Turn the radio on please']),
        isEmpty,
      );
    });
  });

  group('picking spellings', () {
    test('the one that hears the most of what is missing, first', () {
      final picked = pickSpellings(
        [true, false, false, false],
        [
          [true, true, false, false],
          [false, true, true, true],
          [true, false, false, true],
        ],
        max: 5,
      );
      expect(picked, [1]);
    });

    test('stops once nothing more is heard', () {
      expect(
        pickSpellings(
          [true, true],
          [
            [true, true],
          ],
          max: 5,
        ),
        isEmpty,
      );
    });

    test('one that only hears a single recording is not kept', () {
      expect(
        pickSpellings(
          [false, false, false],
          [
            [true, false, false],
          ],
          max: 5,
        ),
        isEmpty,
      );
    });

    test('keeps no more than it is allowed', () {
      final picked = pickSpellings(List.filled(6, false), [
        [true, true, false, false, false, false],
        [false, false, true, true, false, false],
        [false, false, false, false, true, true],
      ], max: 2);
      expect(picked, hasLength(2));
    });
  });
}
