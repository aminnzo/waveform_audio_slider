import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/src/util/check_samples_equality.dart';

/// [AudioWaveformFactory] is a custom StatefulWidget that other Waveform classes
/// extend to.
///
/// This class handles the common functionality, properties and provides the
/// most common waveform details to the subclasses. This details then can be
/// used by the [WaveformPainter] to paint the waveform.
///
/// Anything that can be shared and used across all waveforms should
/// be handled by this class.
///

bool debugMaxAndElapsedDuration(
    Duration? maxDuration,
    Duration? elapsedDuration,
    ) {
  return maxDuration != null || elapsedDuration != null
      ? elapsedDuration != null && maxDuration != null
      : true;
}

abstract class AudioWaveformFactory extends StatefulWidget {
  /// Constructor for [AudioWaveformFactory]
  AudioWaveformFactory({
    super.key,
    this.samples,
    required this.height,
    required this.width,
    this.maxDuration,
    this.elapsedDuration,
  })  : assert(
  debugMaxAndElapsedDuration(
    maxDuration,
    elapsedDuration,
  ),
  'Both maxDuration and elapsedDuration must be provided.',
  ),
        assert(
        maxDuration == null ? true : maxDuration.inMilliseconds > 0,
        'maxDuration must be greater than 0',
        ),
        assert(
        elapsedDuration == null ? true : elapsedDuration.inMilliseconds >= 0,
        'maxDuration must be greater than 0',
        ),
        assert(
        elapsedDuration == null || maxDuration == null
            ? true
            : elapsedDuration.inMilliseconds <= maxDuration.inMilliseconds,
        'elapsedDuration must be less than or equal to maxDuration',
        );

  /// Audio samples raw input.
  /// This raw samples are processed before being used to paint the waveform.
  final List<double>? samples;

  /// Height of the canvas on which the waveform will be drawn.
  final double height;

  /// Width of the canvas on which the waveform will be drawn.
  final double width;

  /// Maximum duration of the audio.
  final Duration? maxDuration;

  /// Elapsed duration of the audio.
  final Duration? elapsedDuration;

  @override
  AudioWaveformState<AudioWaveformFactory> createState();
}

/// State of the [AudioWaveformFactory]
abstract class AudioWaveformState<T extends AudioWaveformFactory> extends State<T> {
  /// Samples after processing.
  /// This are used to paint the waveform.
  late List<double> _processedSamples;

  ///Getter for processed samples.
  List<double> get processedSamples => _processedSamples;

  late double _sampleWidth;

  ///Getter for sample width.
  double get sampleWidth => _sampleWidth;

  ///Method for subclass to update the processed samples
  @protected
  void updateProcessedSamples(List<double> updatedSamples) {
    _processedSamples = updatedSamples;
  }

  /// Active index of the sample in the raw samples.
  ///
  /// Used to obtain the [activeSamples] for the audio as the
  /// audio progresses.
  /// This is calculated based on the [elapsedDuration], [maxDuration] and the
  /// raw samples.
  ///
  /// final elapsedTimeRatio = elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;
  /// _activeIndex = (widget.samples.length * elapsedTimeRatio).round();
  late int _activeIndex;

  /// Active samples that are used to draw the ActiveWaveform.
  /// This are calculated using [_activeIndex] and are subList of the
  /// [_processedSamples] at any given time.
  late List<double> _activeSamples;

  ///Getter for active samples.
  List<double> get activeSamples => _activeSamples;

  ///Getter for maxDuration
  Duration? get maxDuration => widget.maxDuration;

  ///getter for elapsedDuration
  Duration? get elapsedDuration => widget.elapsedDuration;

  /// Raw samples are processed before used following some
  /// techniques. This is to have consistent samples that can be used to draw
  /// the waveform properly.
  @protected
  void processSamples() {
    final rawSamples = widget.samples;

    _processedSamples = rawSamples!.map((e) => e * widget.height).toList();

    final maxNum =
    _processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));

    if (maxNum > 0) {
      final multiplier = math.pow(maxNum, -1).toDouble();
      final finalHeight = widget.height / 2;
      final finalMultiplier = multiplier * finalHeight;

      _processedSamples =
          _processedSamples.map((e) => e * finalMultiplier).toList();
    }
  }

  /// Calculates the width that each sample would take.
  /// This is later used in the Painters to calculate the Offset along x-axis
  /// from the start for any sample while painting.
  void _calculateSampleWidth() {
    _sampleWidth = widget.width / (_processedSamples.length);
  }

  /// Updates the [_activeIndex] whenever the duration changes.
  @protected
  void _updateActiveIndex() {
    if (maxDuration != null && elapsedDuration != null) {
      final elapsedTimeRatio =
          elapsedDuration!.inMilliseconds / maxDuration!.inMilliseconds;

      _activeIndex = (widget.samples!.length * elapsedTimeRatio).round();
    }
  }

  /// Updates [_activeSamples] based on the [_activeIndex].
  @protected
  void _updateActiveSamples() {
    _activeSamples = _processedSamples.sublist(0, _activeIndex);
  }

  /// Gets the ratio of elapsedDuration to maxDuration.
  /// Used by waveforms that show active track with help of stops in gradient while painting.
  /// eg. CurvedPolygonWaveform, SquigglyWaveform

  double get activeRatio => _calculateActiveRatio();

  double _calculateActiveRatio() {
    if (maxDuration != null && elapsedDuration != null) {
      return elapsedDuration!.inMilliseconds / maxDuration!.inMilliseconds;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();

    _processedSamples = widget.samples ?? [];
    _activeIndex = 0;
    _activeSamples = [];
    _sampleWidth = 0;

    if (_processedSamples.isNotEmpty) {
      processSamples();
      _calculateSampleWidth();
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!checkForSamplesEquality(
        widget.samples ?? [], oldWidget.samples ?? []) &&
        widget.samples!.isNotEmpty) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveIndex();
      _updateActiveSamples();
    }

    if (widget.elapsedDuration != oldWidget.elapsedDuration) {
      _updateActiveIndex();
      _updateActiveSamples();
    }
    if (widget.height != oldWidget.height || widget.width != oldWidget.width) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveSamples();
    }
  }
}
