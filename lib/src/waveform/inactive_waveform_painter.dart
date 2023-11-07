import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/src/core/waveform_painters_factory.dart';

class InActiveWaveformPainter extends InActivePainterFactory {
  InActiveWaveformPainter({
    super.color = Colors.white,
    required super.samples,
    required super.sampleWidth,
    super.style = PaintingStyle.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color;

    final alignPosition = size.height / 2;

    drawRoundedRectangles(canvas, alignPosition, paint);
  }

  void drawRoundedRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
  ) {
    final radius = Radius.circular(sampleWidth);
    final sampleWidthWithPadding = sampleWidth - (sampleWidth * 0.34);
    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = samples[i] * 2;
      final positionFromTop = alignPosition - y / 2;
      final rectangle =
          Rect.fromLTWH(x, positionFromTop, sampleWidthWithPadding, y);
      canvas.drawRRect(RRect.fromRectAndRadius(rectangle, radius), paint);
    }
  }

  @override
  bool shouldRepaint(covariant InActiveWaveformPainter oldDelegate) {
    return getShouldRepaintValue(oldDelegate);
  }
}
