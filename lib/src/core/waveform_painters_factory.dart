import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/src/util/check_samples_equality.dart';

/// A Painter class that all the types of Waveform Painters extend to.
/// The members of this class are essential to paint any type of waveform.
abstract class WaveformPaintersFactory extends CustomPainter {
  /// Constructor for the WaveformPainter.
  WaveformPaintersFactory({
    required this.samples,
    required this.color,
    required this.sampleWidth,
    required this.style,
  });

  /// Samples that are used to paint the waveform.
  final List<double> samples;

  /// Color of the waveform.
  final Color color;

  /// Width of each sample.
  final double sampleWidth;

  /// The style of the waveform.
  final PaintingStyle style;
}

/// A Painter class that all other ActiveWaveform Painters extend to.
/// The members declared in this class are essential to draw ActiveWaveforms.
/// This types of waveform painters draws the active part of the waveform of
/// the audio being played.

abstract class ActiveWaveformPainter extends WaveformPaintersFactory {
  ActiveWaveformPainter({
    required super.color,
    required super.sampleWidth,
    required this.activeSamples,
    super.style = PaintingStyle.fill,
    this.borderWidth = 0.0,
    this.borderColor = Colors.black26,
  }) : super(
          samples: [],
        );

  ///The active samples used to paint the waveform.
  final List<double> activeSamples;

  /// Stroke/Border Width
  final double borderWidth;

  /// Stroke/Border Width
  final Color borderColor;

  /// Get shouldRepaintValue
  bool getShouldRepaintValue(covariant ActiveWaveformPainter oldDelegate) {
    return !checkForSamplesEquality(activeSamples, oldDelegate.activeSamples) ||
        color != oldDelegate.color ||
        sampleWidth != oldDelegate.sampleWidth ||
        style != oldDelegate.style ||
        borderWidth != oldDelegate.borderWidth ||
        borderColor != oldDelegate.borderColor;
  }

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant ActiveWaveformPainter oldDelegate) {
    return getShouldRepaintValue(oldDelegate);
  }
}

/// A Painter class that all other InActiveWaveform Painters extend to.
/// This types of waveform painters draws the whole waveform of the audio
/// being played.
abstract class InActiveWaveformPainter extends WaveformPaintersFactory {
  InActiveWaveformPainter({
    required super.color,
    required super.samples,
    required super.sampleWidth,
    super.style = PaintingStyle.fill,
    this.borderWidth = 0.0,
    this.borderColor = Colors.black26,
  });

  /// Stroke/Border Width
  final double borderWidth;

  /// Stroke/Border Width
  final Color borderColor;

  /// Get shouldRepaintValue
  bool getShouldRepaintValue(covariant InActiveWaveformPainter oldDelegate) {
    return !checkForSamplesEquality(samples, oldDelegate.samples) ||
        color != oldDelegate.color ||
        sampleWidth != oldDelegate.sampleWidth ||
        style != oldDelegate.style ||
        borderWidth != oldDelegate.borderWidth ||
        borderColor != oldDelegate.borderColor;
  }

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant InActiveWaveformPainter oldDelegate) {
    return getShouldRepaintValue(oldDelegate);
  }
}

/// A Painter class that all other ActiveInActiveWaveform Painters extend to.
/// The members of this class are essential to draw any waveform that manages
/// the painting of both active and inActive waveform within itself.
abstract class ActiveInActiveWaveformPainter extends WaveformPaintersFactory {
  ActiveInActiveWaveformPainter({
    required this.activeColor,
    required super.samples,
    required super.sampleWidth,
    required this.inactiveColor,
    required this.activeRatio,
    super.style = PaintingStyle.fill,
    required this.strokeWidth,
  }) : super(
          color: inactiveColor,
        );

  ///The color of the active waveform.
  final Color inactiveColor;

  ///The color of the inactive waveform.
  final Color activeColor;

  ///The ratio of the elapsedDuration to the maxDuration.
  final double activeRatio;

  /// Stroke Width
  final double strokeWidth;

  /// Get shouldRepaintValue
  bool getShouldRepaintValue(
    covariant ActiveInActiveWaveformPainter oldDelegate,
  ) {
    return activeRatio != oldDelegate.activeRatio ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        !checkForSamplesEquality(samples, oldDelegate.samples) ||
        color != oldDelegate.color ||
        sampleWidth != oldDelegate.sampleWidth ||
        strokeWidth != oldDelegate.strokeWidth ||
        style != oldDelegate.style;
  }

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant ActiveInActiveWaveformPainter oldDelegate) {
    return getShouldRepaintValue(oldDelegate);
  }
}
