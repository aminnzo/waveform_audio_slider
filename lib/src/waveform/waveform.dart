import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/src/core/audio_waveform_factory.dart';
import 'package:waveform_audio_slider/src/data/waveform_style.dart';
import 'package:waveform_audio_slider/src/waveform/active_waveform_painter.dart';
import 'package:waveform_audio_slider/src/waveform/inactive_waveform_painter.dart';

class Waveform extends StatelessWidget {
  const Waveform(
      {super.key,
      this.waveformStyle,
      required this.height,
      required this.width,
      required this.elapsedDuration,
      required this.maxDuration,
      this.samples});

  final WaveformStyle? waveformStyle;
  final double height;
  final double width;
  final Duration maxDuration;
  final Duration elapsedDuration;
  final List<double>? samples;

  @override
  Widget build(BuildContext context) {
    return _AudioWaveformBuilder(
      height: height,
      width: width,
      inactiveColor: waveformStyle?.inactiveColor ?? Colors.black38,
      activeColor: waveformStyle?.activeColor ?? Colors.purple,
      elapsedDuration: elapsedDuration,
      maxDuration: maxDuration,
      samples: samples,
    );
  }
}

class _AudioWaveformBuilder extends AudioWaveformFactory {
  _AudioWaveformBuilder({
    required super.samples,
    required super.height,
    required super.width,
    super.maxDuration,
    super.elapsedDuration,
    this.activeColor = Colors.purple,
    this.inactiveColor = Colors.black38,
  });

  /// The color of the active waveform.
  final Color activeColor;

  /// The color of the inactive waveform.
  final Color inactiveColor;

  /// If true then rectangles are centered along the Y-axis with respect to
  /// their center along their height.

  @override
  AudioWaveformState<_AudioWaveformBuilder> createState() =>
      _AudioWaveformBuilderState();
}

class _AudioWaveformBuilderState
    extends AudioWaveformState<_AudioWaveformBuilder> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples!.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeSamples = this.activeSamples;
    final sampleWidth = this.sampleWidth;

    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            isComplex: true,
            painter: InActiveWaveformPainter(
              samples: processedSamples,
              color: widget.inactiveColor,
              sampleWidth: sampleWidth,
            ),
          ),
        ),
        CustomPaint(
          size: Size(widget.width, widget.height),
          isComplex: true,
          painter: ActiveWaveformPainter(
            color: widget.activeColor,
            activeSamples: activeSamples,
            sampleWidth: sampleWidth,
          ),
        )
      ],
    );
  }
}
