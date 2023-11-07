/// There are different ways to scale list of waves from target audio file to our desired length.
/// Here we implemented some of these.
/// [ScalingAlgorithmFactory] is the base Strategy . To Use each algorithm you can add an object of your desired Strategy of below options.
///
abstract class ScalingAlgorithmFactory {
  /// list of samples before normalization
  final List<double> samples;

  /// to reduce number of samples to your desired length
  final int maxSample;

  ScalingAlgorithmFactory({required this.samples, required this.maxSample});

  List<double> execute();
}
