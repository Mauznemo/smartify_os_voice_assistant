import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/sentence_piece.dart';

/// A sentencepiece model written out by hand: just its pieces and their
/// scores, in the protobuf the real `bpe.model` files use.
Uint8List model(Map<String, double> pieces, {bool bpe = false}) {
  final out = BytesBuilder();

  void varint(int value) {
    while (value >= 0x80) {
      out.addByte((value & 0x7F) | 0x80);
      value >>= 7;
    }
    out.addByte(value);
  }

  for (final MapEntry(key: piece, value: score) in pieces.entries) {
    final inner = BytesBuilder();
    final text = utf8.encode(piece);
    inner
      ..addByte(1 << 3 | 2)
      ..addByte(text.length)
      ..add(text)
      ..addByte(2 << 3 | 5)
      ..add(
        (ByteData(4)..setFloat32(0, score, Endian.little)).buffer.asUint8List(),
      );
    final bytes = inner.takeBytes();
    varint(1 << 3 | 2);
    varint(bytes.length);
    out.add(bytes);
  }
  // trainer_spec { model_type }
  out.add([2 << 3 | 2, 2, 3 << 3 | 0, bpe ? 2 : 1]);
  return out.takeBytes();
}

void main() {
  test('a unigram model splits by the best total score', () {
    final sp = SentencePiece.fromModel(
      model({
        '▁HE': -2,
        '▁H': -3,
        'E': -3,
        'Y': -2,
        'LL': -2,
        'L': -4,
        'O': -2,
        '▁': -5,
        'H': -4,
        'EY': -5,
      }),
    );
    expect(sp.encode('Hey'), ['▁HE', 'Y']);
    expect(sp.encode('hello'), ['▁HE', 'LL', 'O']);
  });

  test('a letter the model has no piece for cannot be listened for', () {
    final sp = SentencePiece.fromModel(model({'▁A': -1}));
    expect(sp.encode('B'), isNull);
  });

  test('a BPE model merges the best scoring pair first', () {
    final sp = SentencePiece.fromModel(
      model({
        '▁': 0,
        'A': 0,
        'B': 0,
        'C': 0,
        'AB': -1,
        'BC': -2,
        '▁AB': -3,
      }, bpe: true),
    );
    expect(sp.encode('abc'), ['▁AB', 'C']);
  });

  test('variants are the best scoring splits, best first', () {
    final sp = SentencePiece.fromModel(
      model({
        '▁HE': -2,
        '▁H': -3,
        'E': -3,
        'Y': -2,
        'EY': -4,
        '▁': -5,
        'H': -4,
      }),
    );
    final variants = sp.encodeVariants('Hey', 3);
    expect(variants.first, sp.encode('Hey'));
    expect(variants, [
      ['▁HE', 'Y'],
      ['▁H', 'EY'],
      ['▁H', 'E', 'Y'],
    ]);
  });
}
