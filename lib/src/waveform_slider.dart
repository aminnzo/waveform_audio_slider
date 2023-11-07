import 'package:flutter/material.dart';
import 'dart:async';

import 'data/audio_wave_source.dart';
import 'data/scaling_algorithm_type.dart';
import 'data/waveform_style.dart';
import 'util/scaling/average_algorithm.dart';
import 'util/scaling/median_algorithm.dart';
import 'waveform/waveform.dart';

//ignore: must_be_immutable
class WaveformSlider extends StatefulWidget {
  final ScalingAlgorithmType scalingAlgorithmType;
  final WaveformStyle? waveformStyle;
  final AudioWaveSource source;
  final int? maxSamples;
  final double? height;
  final double? width;
  final Duration maxDuration;
  final Duration elapsedDuration;
  Function(Duration) elapsedIsChanged;

  WaveformSlider({
    super.key,
    this.scalingAlgorithmType = ScalingAlgorithmType.average,
    required this.source,
    this.maxSamples = 100,
    this.height,
    this.width,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.elapsedIsChanged,
    this.waveformStyle,
  });

  @override
  State<WaveformSlider> createState() => _WaveformSliderState();
}

class _WaveformSliderState extends State<WaveformSlider> {
  List<double>? samples;

  @override
  void initState() {
    setSamples();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.sizeOf(context).width * 0.5,
      height: widget.height ?? 50,
      child: (samples != null)
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Waveform(
                  width: widget.width ?? MediaQuery.sizeOf(context).width * 0.5,
                  height: widget.height ?? 50,
                  elapsedDuration: widget.elapsedDuration,
                  maxDuration: widget.maxDuration,
                  waveformStyle: widget.waveformStyle,
                  samples: samples,
                ),
                _unVisibleSlider(),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _unVisibleSlider() {
    return Theme(
      data: ThemeData(
        sliderTheme: SliderThemeData(
            thumbShape: SliderComponentShape.noOverlay,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            overlayShape: SliderComponentShape.noThumb),
      ),
      child: Slider(
          value: ((widget.elapsedDuration).inMilliseconds).toDouble(),
          max: ((widget.maxDuration).inMilliseconds).toDouble(),
          onChanged: (double value) =>
              widget.elapsedIsChanged(Duration(milliseconds: value.toInt()))),
    );
  }

  Future<void> setSamples() async {
    List<double> tempSamples = await widget.source.evaluate();
    switch (widget.scalingAlgorithmType) {
      case ScalingAlgorithmType.none:
        samples = tempSamples;
        break;
      case ScalingAlgorithmType.average:
        samples = AverageAlgorithm(
          samples: tempSamples,
          maxSample: widget.maxSamples ?? 100,
        ).execute();
        break;
      case ScalingAlgorithmType.median:
        samples = MedianAlgorithm(
          samples: tempSamples,
          maxSample: widget.maxSamples ?? 100,
        ).execute();
        break;
    }
  }
}
