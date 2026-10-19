import 'dart:convert';
import 'dart:typed_data';

/// Internal: splits text into the pieces a sentencepiece model (`bpe.model`)
/// knows, the way sentencepiece itself does, so a wake word can be any phrase
/// without a Python tool to prepare it first.
///
/// The wake word model only listens for sequences of its own pieces, and it
/// was trained on text split one particular way. A phrase split differently
/// would still be made of valid pieces but be heard far less reliably, which
/// is why this follows sentencepiece exactly: the best scoring split for a
/// unigram model, merges in order of score for a BPE one.
class SentencePiece {
  static const _wordStart = '▁';

  final Map<String, double> _scores;
  final bool _bpe;
  final int _longestPiece;

  SentencePiece._(this._scores, this._bpe)
    : _longestPiece = _scores.keys.fold(
        0,
        (longest, piece) => piece.length > longest ? piece.length : longest,
      );

  /// Reads a `bpe.model` file's bytes.
  factory SentencePiece.fromModel(Uint8List bytes) {
    final scores = <String, double>{};
    var bpe = false;

    final model = _ProtoReader(bytes);
    while (!model.done) {
      final (field, type) = model.readKey();
      if (field == 1 && type == 2) {
        final piece = _ProtoReader(model.readBytes());
        String? text;
        var score = 0.0;
        var kind = 1;
        while (!piece.done) {
          final (field, type) = piece.readKey();
          switch ((field, type)) {
            case (1, 2):
              text = utf8.decode(piece.readBytes());
            case (2, 5):
              score = piece.readFloat();
            case (3, 0):
              kind = piece.readVarint();
            default:
              piece.skip(type);
          }
        }
        // Only normal and user defined pieces are ever produced from text.
        if (text != null && (kind == 1 || kind == 4)) scores[text] = score;
      } else if (field == 2 && type == 2) {
        final trainer = _ProtoReader(model.readBytes());
        while (!trainer.done) {
          final (field, type) = trainer.readKey();
          if (field == 3 && type == 0) {
            bpe = trainer.readVarint() == 2;
          } else {
            trainer.skip(type);
          }
        }
      } else {
        model.skip(type);
      }
    }
    return SentencePiece._(scores, bpe);
  }

  /// [text] in pieces, upper case, the way the wake word model's own
  /// examples are written: "HELLO WORLD" is `▁HE LL O ▁WORLD`. `null` when
  /// some letter in it cannot be written with the model's pieces.
  List<String>? encode(String text) {
    final words = text.toUpperCase().trim().split(RegExp(r'\s+'));
    final pieces = <String>[];
    for (final word in words) {
      if (word.isEmpty) continue;
      final encoded = _bpe
          ? _encodeBpe('$_wordStart$word')
          : _encodeUnigram('$_wordStart$word');
      if (encoded == null) return null;
      pieces.addAll(encoded);
    }
    return pieces.isEmpty ? null : pieces;
  }

  /// The [count] best scoring splits of [text], the best one first, for a
  /// unigram model. A BPE model only ever has the one [encode] gives.
  ///
  /// The wake word model does not always hear a word as the pieces it would
  /// be written with, so listening for a few likely splits of the same phrase
  /// catches it more often.
  List<List<String>> encodeVariants(String text, int count) {
    final best = encode(text);
    if (best == null) return const [];
    if (_bpe || count <= 1) return [best];

    var phrases = <(List<String>, double)>[(const [], 0)];
    for (final word in text.toUpperCase().trim().split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      final splits = _allSplits('$_wordStart$word');
      phrases = [
        for (final (pieces, score) in phrases)
          for (final (more, extra) in splits)
            ([...pieces, ...more], score + extra),
      ]..sort((a, b) => b.$2.compareTo(a.$2));
      if (phrases.length > count) phrases = phrases.sublist(0, count);
    }
    return [for (final (pieces, _) in phrases) pieces];
  }

  /// Every way of writing [word] with the model's pieces, with its score.
  /// Words are short, so there are never more than a few hundred.
  List<(List<String>, double)> _allSplits(String word) {
    final splits = <(List<String>, double)>[];
    void walk(int at, List<String> pieces, double score) {
      if (at == word.length) {
        splits.add((List.of(pieces), score));
        return;
      }
      for (var end = at + 1; end <= word.length; end++) {
        if (end - at > _longestPiece) break;
        final piece = word.substring(at, end);
        final pieceScore = _scores[piece];
        if (pieceScore == null) continue;
        pieces.add(piece);
        walk(end, pieces, score + pieceScore);
        pieces.removeLast();
      }
    }

    walk(0, [], 0);
    return splits..sort((a, b) => b.$2.compareTo(a.$2));
  }

  /// The split with the best total score, found one character at a time.
  List<String>? _encodeUnigram(String word) {
    final length = word.length;
    final best = List<double>.filled(length + 1, double.negativeInfinity);
    final from = List<int>.filled(length + 1, -1);
    best[0] = 0;
    for (var end = 1; end <= length; end++) {
      final start = end - _longestPiece < 0 ? 0 : end - _longestPiece;
      for (var begin = start; begin < end; begin++) {
        if (best[begin] == double.negativeInfinity) continue;
        final score = _scores[word.substring(begin, end)];
        if (score == null) continue;
        final total = best[begin] + score;
        if (total > best[end]) {
          best[end] = total;
          from[end] = begin;
        }
      }
    }
    if (from[length] < 0) return null;

    final pieces = <String>[];
    for (var end = length; end > 0; end = from[end]) {
      pieces.add(word.substring(from[end], end));
    }
    return pieces.reversed.toList();
  }

  /// Merges neighbouring pieces, the best scoring merge first, until none is
  /// left.
  List<String>? _encodeBpe(String word) {
    final pieces = [for (final char in word.split('')) char];
    while (true) {
      var bestIndex = -1;
      var bestScore = double.negativeInfinity;
      for (var i = 0; i + 1 < pieces.length; i++) {
        final score = _scores[pieces[i] + pieces[i + 1]];
        if (score != null && score > bestScore) {
          bestScore = score;
          bestIndex = i;
        }
      }
      if (bestIndex < 0) break;
      pieces.replaceRange(bestIndex, bestIndex + 2, [
        pieces[bestIndex] + pieces[bestIndex + 1],
      ]);
    }
    return pieces.every(_scores.containsKey) ? pieces : null;
  }
}

/// Reads the protobuf a sentencepiece model is stored in, as far as needed.
class _ProtoReader {
  final Uint8List _bytes;
  int _at = 0;

  _ProtoReader(List<int> bytes)
    : _bytes = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);

  bool get done => _at >= _bytes.length;

  (int field, int type) readKey() {
    final key = readVarint();
    return (key >> 3, key & 7);
  }

  int readVarint() {
    var result = 0;
    var shift = 0;
    while (true) {
      final byte = _bytes[_at++];
      result |= (byte & 0x7F) << shift;
      if (byte < 0x80) return result;
      shift += 7;
    }
  }

  Uint8List readBytes() {
    final length = readVarint();
    final bytes = Uint8List.sublistView(_bytes, _at, _at + length);
    _at += length;
    return bytes;
  }

  double readFloat() {
    final value = ByteData.sublistView(
      _bytes,
      _at,
      _at + 4,
    ).getFloat32(0, Endian.little);
    _at += 4;
    return value;
  }

  void skip(int type) {
    switch (type) {
      case 0:
        readVarint();
      case 1:
        _at += 8;
      case 2:
        readBytes();
      case 5:
        _at += 4;
      default:
        throw FormatException('Unknown protobuf wire type $type');
    }
  }
}
