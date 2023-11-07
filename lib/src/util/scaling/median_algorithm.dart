import 'scaling_algorithm_factory.dart';

/// [MedianAlgorithm] finds the median value of each block of samples to make a list of [maxSample] doubles.
class MedianAlgorithm extends ScalingAlgorithmFactory {
  @override
  List<double> execute() {
    List<double> newSamples = [];
    int scaleFactor = (samples.length / maxSample).round();
    for (int i = 0; i < samples.length; i += scaleFactor) {
      ///Find median value in samples.sublist(i,i*maxSample)
      if (samples.length - i < scaleFactor) scaleFactor = samples.length - i;
      var block = samples.sublist(i, i + scaleFactor);
      block.sort();
      var median = block.elementAt(scaleFactor ~/ 2);
      newSamples.add(median);
    }
    return newSamples;
  }

  MedianAlgorithm({required super.samples, required super.maxSample});
}
