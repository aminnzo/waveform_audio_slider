class AudioWaveSource {
  AudioWaveSource({required this.samples});

  final List<double> samples;

  Future<List<double>> evaluate() async {
    return samples;
  }
}