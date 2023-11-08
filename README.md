<img src="https://raw.githubusercontent.com/aminnzo/waveform_audio_slider/main/example/assets/Logo.jpg">

<p align="center">
	<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
</p>


A UI library for easily adding audio waveforms to your apps, with several customization options.
This package is a minimal customization of the [flutter_audio_waveforms](https://pub.dev/packages/flutter_audio_waveforms) package available on pub.dev.
<img src="https://raw.githubusercontent.com/aminnzo/waveform_audio_slider/main/example/assets/example-image.gif">
Web Demo - [Flutter Audio Waveforms Web Demo](https://aminnzo.github.io/waveform_audio_slider/)

# Getting started

The package is a UI library for waveforms with an additional ability to show active track for playing audio.

So it relies on you to provide the necessary audio data which it needs to draw the waveform.
The data we need is basically a list of points/samples that represents that audio.

You can use this [audiowaveform program](https://github.com/bbc/audiowaveform) to get the [audio json file](https://gist.github.com/rutvik110/946ee0f3036a18da1297e57c547ae241) which will provide us the samples.
After installing this program on your machine, generate the json file for an audio by using this command in your terminal.
```dart
audiowaveform -i test.mp3 -o test.json
```

The generated data needs to be processed following some rules which are necessary to get the waveforms drawn properly. To process the data use [this processor](https://gist.github.com/rutvik110/31a588244d288e89368e8704c1437d34).

Once you have the processed data points list then you can just pass it down to any of the waveforms available and get started using them.

> Check out [this article](https://medium.com/@TakRutvik/how-to-add-audiowaveforms-to-your-flutter-apps-c948c205d2c7) for detailed introduction on this section.


# Usage

```dart
 WaveformSlider(
    height: 60,
    width: MediaQuery.of(context).size.width * 0.7,
    scalingAlgorithmType: ScalingAlgorithmType.average,
    source: [],
    maxSamples: source.length,
    maxDuration: maxDuration,
    elapsedDuration: elapsedTime,
    waveformStyle: WaveformStyle(
      activeColor: Colors.blueAccent,
      inactiveColor: Colors.grey,
    ),
    elapsedIsChanged: (d) {
      setState(() {
      elapsedTime = d;
      });
    },
  )
 ```

> Find detailed [example here](https://github.com/aminnzo/waveform_audio_slider/blob/main/example/lib/main.dart).

# Properties

**maxDuration**:

Maximum duration of the audio.

**elapsedDuration**:

Elapsed Duration of the audio.

**samples**:

List of the audio data samples.
> Check the **Getting Started** section on how to generate this.

**height** :

Waveform height.

**width** :

Waveform width.


## Customization Options

**inactiveColor** :

Color of the inactive waveform.

**activeColor** :

Color of the active waveform.

### **More customization options coming soon!**