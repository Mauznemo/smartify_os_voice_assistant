import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// How a [VoiceWave] moves.
enum VoiceWaveMood {
  /// Lying almost flat, waiting.
  resting,

  /// Following [VoiceWave.level]: the driver talking, or the answer.
  following,

  /// A slow pulse running along it, while it works something out.
  working,
}

/// Glowing waves in the theme's accent colour that move with a sound level.
///
/// Three blurred layers in neighbouring colours, each its own speed and
/// width, so it looks alive rather than like a meter. The level is followed
/// smoothly, so a level that only changes ten times a second still moves at
/// the screen's full rate.
///
/// Internal: drawn by the voice assistant's panel.
class VoiceWave extends StatefulWidget {
  /// How loud it is, from 0 to 1.
  final ValueListenable<double> level;
  final VoiceWaveMood mood;
  final double height;

  const VoiceWave({
    super.key,
    required this.level,
    required this.mood,
    this.height = 64,
  });

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _frame = ValueNotifier<_WaveFrame>(const _WaveFrame(0, 0, 0));

  Duration _last = Duration.zero;
  double _time = 0;
  double _amplitude = 0;
  double _working = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = math.min((elapsed - _last).inMicroseconds / 1e6, 0.05);
    _last = elapsed;

    final target = switch (widget.mood) {
      VoiceWaveMood.resting => 0.06,
      VoiceWaveMood.working => 0.22,
      VoiceWaveMood.following => 0.1 + widget.level.value * 0.9,
    };
    // Quick to rise, slower to fall, the way a level meter is easiest on the
    // eye.
    final rate = target > _amplitude ? 14.0 : 5.0;
    _amplitude += (target - _amplitude) * math.min(1, rate * dt);

    final workingTarget = widget.mood == VoiceWaveMood.working ? 1.0 : 0.0;
    _working += (workingTarget - _working) * math.min(1, 4 * dt);

    _time += dt * (1 + _amplitude * 2.5);
    _frame.value = _WaveFrame(_time, _amplitude, _working);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    final hsl = HSLColor.fromColor(theme.colorScheme.primary);
    // On a light background the waves are mixed like ink, darker than the
    // accent, rather than added like light, which would wash them out to
    // white.
    Color shifted(double hue) {
      final color = hsl
          .withHue((hsl.hue + hue) % 360)
          .withSaturation(math.max(hsl.saturation, 0.55));
      return (light
              ? color.withLightness(math.min(color.lightness, 0.45))
              : color)
          .toColor();
    }

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(
          painter: _WavePainter(
            frame: _frame,
            colors: [shifted(-38), shifted(0), shifted(42)],
            light: light,
            thread: light ? theme.colorScheme.onSurface : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _WaveFrame {
  final double time;
  final double amplitude;
  final double working;

  const _WaveFrame(this.time, this.amplitude, this.working);
}

class _WavePainter extends CustomPainter {
  final ValueListenable<_WaveFrame> frame;
  final List<Color> colors;

  /// Drawn over a light background, see [VoiceWave].
  final bool light;

  /// The colour of the line through the middle.
  final Color thread;

  _WavePainter({
    required this.frame,
    required this.colors,
    required this.light,
    required this.thread,
  }) : super(repaint: frame);

  /// Each layer's own speed, how many crests it has and how tall it is.
  static const _layers = [(1.3, 1.6, 0.85), (-0.9, 2.3, 1.0), (1.9, 3.1, 0.7)];

  @override
  void paint(Canvas canvas, Size size) {
    final now = frame.value;
    final middle = size.height / 2;
    final steps = math.max(24, size.width ~/ 6);

    for (var layer = 0; layer < _layers.length; layer++) {
      final (speed, crests, height) = _layers[layer];
      final top = Path();
      final bottom = <Offset>[];
      for (var i = 0; i <= steps; i++) {
        final x = size.width * i / steps;
        final across = i / steps * 2 - 1;
        // Tapers to nothing at both ends, so it floats rather than being cut
        // off.
        final taper = math.pow(1 - across * across, 2).toDouble();
        // While working, a bump runs along it instead of the whole thing
        // breathing.
        final pulse = math.exp(
          -math.pow((across - math.sin(now.time * 1.4) * 0.8) * 2.2, 2),
        );
        final shape = taper * (1 - now.working + now.working * pulse);
        final wave = math.sin(
          across * math.pi * crests + now.time * speed * 2.4 + layer,
        );
        final y =
            middle * now.amplitude * height * shape * (0.55 + 0.45 * wave);
        if (i == 0) {
          top.moveTo(x, middle - y);
        } else {
          top.lineTo(x, middle - y);
        }
        bottom.add(Offset(x, middle + y));
      }
      for (final point in bottom.reversed) {
        top.lineTo(point.dx, point.dy);
      }
      top.close();

      final color = colors[layer];
      canvas.drawPath(
        top,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, middle),
            Offset(size.width, middle),
            [
              color.withValues(alpha: 0),
              color.withValues(alpha: light ? 0.65 : 0.55),
              color.withValues(alpha: 0),
            ],
            const [0, 0.5, 1],
          )
          ..blendMode = light ? BlendMode.multiply : BlendMode.plus
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
    }

    // A thread through the middle, so it reads as a line even when it is
    // quiet: bright on a dark background, dark on a light one.
    canvas.drawLine(
      Offset(size.width * 0.08, middle),
      Offset(size.width * 0.92, middle),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, middle),
          Offset(size.width, middle),
          [
            colors[1].withValues(alpha: 0),
            thread.withValues(alpha: 0.5),
            colors[1].withValues(alpha: 0),
          ],
          const [0, 0.5, 1],
        )
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.frame != frame ||
      oldDelegate.light != light ||
      oldDelegate.thread != thread ||
      !listEquals(oldDelegate.colors, colors);
}
