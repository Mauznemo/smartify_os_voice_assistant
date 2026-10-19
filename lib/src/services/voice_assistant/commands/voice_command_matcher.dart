import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';

/// Internal: a command that matched what was said, and how well.
class VoiceCommandMatch {
  final VoiceCommand command;

  /// The values said for the command's `{name}` gaps.
  final Map<String, String> values;

  /// How many of the command's own words were found in what was said, so a
  /// command that matched more of the sentence wins. A match that covers the
  /// whole sentence gets half a word on top.
  final double score;

  const VoiceCommandMatch({
    required this.command,
    required this.values,
    required this.score,
  });
}

/// Internal: finds the command that best fits a sentence, by the phrases and
/// words each command lists.
///
/// Both sides are compared without case or punctuation, and a word matches
/// the same word with a short ending added ("window" matches "windows",
/// "Fenster" matches "Fenstern"), since speech recognition and people both
/// get endings wrong. Words of three letters or fewer have to match exactly,
/// so "up" never matches "upper".
abstract final class VoiceCommandMatcher {
  /// The best match among [commands], or `null` when none of them fits.
  ///
  /// The commands in [fallbacks] (the built-in ones) only get a turn when
  /// none of the others matched, so a car's own "close the windows" is never
  /// taken for something built in. Otherwise the one that matched the most
  /// words wins, and where two match equally well, the one later in
  /// [commands].
  static VoiceCommandMatch? match(
    String text,
    List<VoiceCommand> commands, {
    Set<VoiceCommand> fallbacks = const {},
  }) {
    final said = tokenize(text);
    if (said.isEmpty) return null;

    VoiceCommandMatch? best;
    var bestIsFallback = true;
    for (final command in commands) {
      final match = matchCommand(said, command);
      if (match == null) continue;
      final isFallback = fallbacks.contains(command);
      final better = switch ((best, isFallback, bestIsFallback)) {
        (null, _, _) => true,
        (_, false, true) => true,
        (_, true, false) => false,
        (final best?, _, _) => match.score >= best.score,
      };
      if (better) {
        best = match;
        bestIsFallback = isFallback;
      }
    }
    return best;
  }

  /// How well [command] fits the words in [said], or `null` when it does
  /// not.
  static VoiceCommandMatch? matchCommand(
    List<String> said,
    VoiceCommand command,
  ) {
    VoiceCommandMatch? best;
    for (final phrase in command.phrases) {
      final match = _matchPhrase(said, phrase);
      if (match == null) continue;
      if (best == null || match.$2 > best.score) {
        best = VoiceCommandMatch(
          command: command,
          values: match.$1,
          score: match.$2,
        );
      }
    }

    final words = _matchWords(said, command.words);
    if (words != null && (best == null || words > best.score)) {
      best = VoiceCommandMatch(
        command: command,
        values: const {},
        score: words,
      );
    }
    return best;
  }

  /// Lower case, without punctuation, split into words. A decimal point
  /// between two digits stays, so "21.5" is still one number.
  static List<String> tokenize(String text) {
    final cleaned = text
        .toLowerCase()
        .replaceAll(RegExp("['’`´]"), '')
        .replaceAllMapped(_decimal, (match) => '${match[1]}.${match[2]}')
        .replaceAll(_notWord, ' ')
        .replaceAll(_strayDot, ' ');
    return [
      for (final word in cleaned.split(_spaces))
        if (word.isNotEmpty) word,
    ];
  }

  /// Whether a word the command lists fits a word that was said.
  static bool sameWord(String listed, String said) {
    if (listed == said) return true;
    if (listed.length < 4 || said.length < 4) return false;
    final (short, long) = listed.length <= said.length
        ? (listed, said)
        : (said, listed);
    return long.length - short.length <= 2 && long.startsWith(short);
  }

  static final _decimal = RegExp(r'(\d)[.,](\d)');
  static final _notWord = RegExp(r'[^\p{L}\p{N}.\s]', unicode: true);
  static final _strayDot = RegExp(r'(?<!\d)\.|\.(?!\d)');
  static final _spaces = RegExp(r'\s+');
  static final _slot = RegExp(r'\{(\w+)\}');

  /// Matches [phrase] anywhere in [said]. Returns the values of its gaps and
  /// its score.
  static (Map<String, String>, double)? _matchPhrase(
    List<String> said,
    String phrase,
  ) {
    final pattern = _parsePhrase(phrase);
    final literals = pattern.whereType<_Literal>().length;
    if (pattern.isEmpty) return null;

    for (var start = 0; start < said.length; start++) {
      final values = <String, String>{};
      final end = _matchFrom(pattern, 0, said, start, values);
      if (end == null) continue;
      final whole = start == 0 && end == said.length;
      return (values, literals + (whole ? 0.5 : 0));
    }
    return null;
  }

  /// Where in [said] the rest of [pattern] ends when it starts at [at], or
  /// `null` when it does not fit there. A gap takes as few words as it can,
  /// unless it is the last thing in the phrase, where it takes the rest.
  static int? _matchFrom(
    List<_PhrasePart> pattern,
    int part,
    List<String> said,
    int at,
    Map<String, String> values,
  ) {
    if (part == pattern.length) return at;
    if (at >= said.length) return null;

    switch (pattern[part]) {
      case _Literal(:final word):
        if (!sameWord(word, said[at])) return null;
        return _matchFrom(pattern, part + 1, said, at + 1, values);
      case _Slot(:final name):
        if (part == pattern.length - 1) {
          values[name] = said.sublist(at).join(' ');
          return said.length;
        }
        for (var end = at + 1; end < said.length; end++) {
          final matched = _matchFrom(pattern, part + 1, said, end, values);
          if (matched == null) continue;
          values[name] = said.sublist(at, end).join(' ');
          return matched;
        }
        return null;
    }
  }

  static List<_PhrasePart> _parsePhrase(String phrase) {
    final parts = <_PhrasePart>[];
    var last = 0;
    for (final match in _slot.allMatches(phrase)) {
      for (final word in tokenize(phrase.substring(last, match.start))) {
        parts.add(_Literal(word));
      }
      parts.add(_Slot(match.group(1)!));
      last = match.end;
    }
    for (final word in tokenize(phrase.substring(last))) {
      parts.add(_Literal(word));
    }
    return parts;
  }

  /// Whether [said] has an entry of every list in [groups], and how many
  /// words those entries were.
  static double? _matchWords(List<String> said, List<List<String>> groups) {
    if (groups.isEmpty) return null;
    var score = 0.0;
    for (final group in groups) {
      var found = 0;
      for (final entry in group) {
        final words = tokenize(entry);
        if (words.isEmpty || words.length <= found) continue;
        if (_contains(said, words)) found = words.length;
      }
      if (found == 0) return null;
      score += found;
    }
    return score;
  }

  static bool _contains(List<String> said, List<String> words) {
    for (var start = 0; start + words.length <= said.length; start++) {
      var all = true;
      for (var i = 0; i < words.length; i++) {
        if (!sameWord(words[i], said[start + i])) {
          all = false;
          break;
        }
      }
      if (all) return true;
    }
    return false;
  }
}

sealed class _PhrasePart {
  const _PhrasePart();
}

class _Literal extends _PhrasePart {
  final String word;

  const _Literal(this.word);
}

class _Slot extends _PhrasePart {
  final String name;

  const _Slot(this.name);
}
