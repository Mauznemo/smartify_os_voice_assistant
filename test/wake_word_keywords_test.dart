import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/sentence_piece.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';
import 'package:smartify_os_voice_assistant/voice_assistant.dart';

/// A sentencepiece model of a few pieces, see sentence_piece_test.dart.
SentencePiece model(Map<String, double> pieces) {
  final out = BytesBuilder();
  for (final MapEntry(key: piece, value: score) in pieces.entries) {
    final text = utf8.encode(piece);
    final inner = [
      1 << 3 | 2,
      text.length,
      ...text,
      2 << 3 | 5,
      ...(ByteData(
        4,
      )..setFloat32(0, score, Endian.little)).buffer.asUint8List(),
    ];
    out
      ..add([1 << 3 | 2, inner.length])
      ..add(inner);
  }
  out.add([2 << 3 | 2, 2, 3 << 3 | 0, 1]);
  return SentencePiece.fromModel(out.takeBytes());
}

void main() {
  final pieces = model({
    '▁HE': -2,
    '▁H': -3,
    'E': -3,
    'Y': -2,
    'EY': -4,
    '▁MI': -2,
    '▁M': -3,
    'I': -3,
    'A': -2,
    '▁A': -3,
  });

  test('every spelling in its best splits, tagged with the spelling', () {
    final lines = wakeWordKeywords(
      pieces,
      ['Hey Mia', 'Hey Mi a'],
      WakeWordSensitivity.normal,
      splits: 2,
    ).split('\n');

    expect(lines, hasLength(4));
    expect(lines.first, '▁HE Y ▁MI A :2.5 #0.1 @HEY_MIA');
    expect(lines.where((line) => line.endsWith('@HEY_MI_A')), hasLength(2));
  });

  test('a spelling the model cannot write is left out', () {
    expect(
      wakeWordKeywords(pieces, ['Zzz'], WakeWordSensitivity.normal),
      isEmpty,
    );
  });

  test('higher sensitivity starts more easily', () {
    expect(
      WakeWordSensitivity.high.threshold,
      lessThan(WakeWordSensitivity.low.threshold),
    );
    expect(
      WakeWordSensitivity.high.boost,
      greaterThan(WakeWordSensitivity.low.boost),
    );
  });
}
