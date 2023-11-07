import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/src/core/waveform_painters_factory.dart';

class ActiveWaveformPainter extends ActivePainterFactory {
  ActiveWaveformPainter({
    required super.color,
    required super.activeSamples,
    required super.sampleWidth,
    super.style = PaintingStyle.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeTrackPaint = Paint()
      ..style = style
      ..color = color;

    final alignPosition = size.height / 2;

    drawRoundedRectangles(canvas, alignPosition, activeTrackPaint);
  }

  void drawRoundedRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
  ) {
    final radius = Radius.circular(sampleWidth);
    final sampleWidthWithPadding = sampleWidth - (sampleWidth * 0.34);
    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i] * 2;
      final positionFromTop = alignPosition - y / 2;
      final rectangle =
          Rect.fromLTWH(x, positionFromTop, sampleWidthWithPadding, y);
      canvas.drawRRect(RRect.fromRectAndRadius(rectangle, radius), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ActiveWaveformPainter oldDelegate) {
    return getShouldRepaintValue(oldDelegate);
  }
}
