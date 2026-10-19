import 'dart:typed_data';

/// Internal: [samples] (from -1 to 1) as a 16 bit mono WAV file.
Uint8List encodeWav(Float32List samples, int sampleRate) {
  const header = 44;
  final data = samples.length * 2;
  final bytes = ByteData(header + data);

  void text(int at, String value) {
    for (var i = 0; i < value.length; i++) {
      bytes.setUint8(at + i, value.codeUnitAt(i));
    }
  }

  text(0, 'RIFF');
  bytes.setUint32(4, header - 8 + data, Endian.little);
  text(8, 'WAVE');
  text(12, 'fmt ');
  bytes
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little) // PCM
    ..setUint16(22, 1, Endian.little) // mono
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, sampleRate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little);
  text(36, 'data');
  bytes.setUint32(40, data, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    final sample = (samples[i].clamp(-1.0, 1.0) * 32767).round();
    bytes.setInt16(header + i * 2, sample, Endian.little);
  }
  return bytes.buffer.asUint8List();
}
