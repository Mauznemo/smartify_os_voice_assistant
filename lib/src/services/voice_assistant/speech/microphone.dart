import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/speech_worker.dart';

/// Internal: the car's microphone, as 16 kHz mono audio and how loud it is.
///
/// Only open while something listens: the recorder is made when it opens and
/// thrown away when it closes, so a closed microphone holds nothing (on Linux
/// that is a `parecord` process, which is gone too).
class Microphone {
  static const _tag = 'VoiceAssistant.Microphone';

  AudioRecorder? _recorder;
  StreamSubscription<Uint8List>? _audio;
  Future<void>? _closing;

  /// A byte left over from a chunk that ended in the middle of a sample.
  int? _carry;

  /// Whether it is open.
  bool get isOpen => _recorder != null;

  /// Starts listening, handing every bit of audio to [onAudio] and how loud
  /// it is (0 to 1) to [onLevel]. Returns `false` when there is no
  /// microphone, or it may not be used. Never throws.
  Future<bool> open({
    required void Function(Float32List samples) onAudio,
    required void Function(double level) onLevel,
  }) async {
    await _closing;
    if (_recorder != null) return true;
    final recorder = AudioRecorder();
    _recorder = recorder;
    try {
      if (!await recorder.hasPermission()) {
        SmartifyOsLog.warning(_tag, 'Not allowed to use the microphone');
        await _close();
        return false;
      }
      final stream = await recorder.startStream(
        RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: SpeechWorker.sampleRate,
          numChannels: 1,
          androidConfig: const AndroidRecordConfig(
            audioSource: AndroidAudioSource.voiceRecognition,
            // The car's own microphone, not a phone's that happens to be on
            // Bluetooth.
            manageBluetooth: false,
          ),
        ),
      );
      _carry = null;
      _audio = stream.listen(
        (bytes) {
          final samples = _toSamples(bytes);
          if (samples.isEmpty) return;
          onLevel(levelOf(samples));
          onAudio(samples);
        },
        onError: (Object error) {
          SmartifyOsLog.warning(_tag, 'The microphone stopped', error);
        },
      );
      SmartifyOsLog.debug(_tag, 'Open');
      return true;
    } on Object catch (error) {
      SmartifyOsLog.warning(
        _tag,
        'Could not open the microphone${Platform.isLinux ? ' (is parecord '
                  'installed? It comes with pulseaudio-utils)' : ''}',
        error,
      );
      await _close();
      return false;
    }
  }

  /// Stops listening and lets go of the microphone.
  Future<void> close() => _closing ??= _close().whenComplete(() {
    _closing = null;
  });

  Future<void> _close() async {
    final recorder = _recorder;
    _recorder = null;
    await _audio?.cancel();
    _audio = null;
    if (recorder == null) return;
    try {
      await recorder.stop();
      await recorder.dispose();
      SmartifyOsLog.debug(_tag, 'Closed');
    } on Object catch (error) {
      SmartifyOsLog.debug(_tag, 'Could not close the microphone: $error');
    }
  }

  Float32List _toSamples(Uint8List bytes) {
    var data = bytes;
    final carry = _carry;
    if (carry != null) {
      data = Uint8List(bytes.length + 1)
        ..[0] = carry
        ..setAll(1, bytes);
      _carry = null;
    }
    if (data.length.isOdd) {
      _carry = data.last;
      data = Uint8List.sublistView(data, 0, data.length - 1);
    }
    final view = ByteData.sublistView(data);
    final samples = Float32List(data.length ~/ 2);
    for (var i = 0; i < samples.length; i++) {
      samples[i] = view.getInt16(i * 2, Endian.little) / 32768;
    }
    return samples;
  }

  /// How loud [samples] are, from 0 (silence) to 1 (shouting into it), on a
  /// scale that follows how loud it sounds rather than the raw numbers.
  static double levelOf(Float32List samples) {
    if (samples.isEmpty) return 0;
    var sum = 0.0;
    for (final sample in samples) {
      sum += sample * sample;
    }
    final rms = math.sqrt(sum / samples.length);
    if (rms <= 0) return 0;
    final decibels = 20 * math.log(rms) / math.ln10;
    // -55 dB is a quiet car, -10 dB is loud talking right at the microphone.
    return ((decibels + 55) / 45).clamp(0.0, 1.0);
  }
}
