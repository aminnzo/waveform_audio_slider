import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:waveform_audio_slider/waveform_audio_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Waveform Audio Slider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const seconds = 160;
  Duration elapsedTime = const Duration(seconds: 0);
  Duration maxDuration = const Duration(seconds: seconds);

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final source = AudioWaveSource(samples: getTestSamples(seconds));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            timeCounter(),
            const SizedBox(height: 40),
            WaveformSlider(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.7,
              scalingAlgorithmType: ScalingAlgorithmType.average,
              source: source,
              maxSamples: source.samples.length,
              maxDuration: maxDuration,
              elapsedDuration: elapsedTime,
              waveformStyle: WaveformStyle(
                activeColor: Colors.purple,
                inactiveColor: Colors.grey,
              ),
              elapsedIsChanged: (d) {
                setState(() {
                  elapsedTime = d;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget timeCounter() {
    return Text(
      timeFromDuration(elapsedTime),
      // elapsedTime.inSeconds.toString(),
      style: const TextStyle(
          fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if ((elapsedTime.inSeconds + oneSec.inSeconds) < maxDuration.inSeconds) {
        setState(() {
          elapsedTime += oneSec;
        });
      } else {
        elapsedTime = Duration.zero;
      }
    });
  }

  List<double> getTestSamples(int length) {
    final testSamples = [10.61, 17.4, 21.64, 32.6, 27.1, 21.6, 32.67, 21.64, 32.67, 13.15, 16.55, 8.49, 13.15, 32.67, 21.64, 27.16, 29.28, 13.58, 16.55, 18.69, 10.61, 17.4, 21.64, 32.67, 27.16, 21.64, 32.67, 21.64, 10.61];
    var random = Random();
    var list = List<double>.generate(
        length, (_) => testSamples[random.nextInt(testSamples.length)]);
    return list;
  }

  static String timeFromDuration(Duration duration) {
    final totalHours = duration.inHours;
    final leftMinutes = duration.inMinutes % 60;
    final leftSeconds = duration.inSeconds % 60;
    String time = '';

    if (totalHours > 0) {
      time += '$totalHours:';
    }
    time += '${leftMinutes >= 10 ? leftMinutes : '0$leftMinutes'}:';
    time += '${leftSeconds >= 10 ? leftSeconds : '0$leftSeconds'}';

    return time;
  }
}
