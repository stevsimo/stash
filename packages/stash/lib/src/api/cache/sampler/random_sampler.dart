import 'dart:math';

import 'package:stash/src/api/cache/sampler/base_sampler.dart';

/// A sampler that picks random elements from the list
class RandomSampler extends BaseSampler {
  /// The random generator
  final Random _random;

  /// Builds a new [RandomSampler]
  ///
  /// * [factor]: The sampling factor
  /// * [random]: The random generator
  RandomSampler(double factor, {Random? random})
      : _random = random ?? Random(),
        super(factor: factor);

  @override
  Iterable<String> sampleEntries(Iterable<String> entries, int sampleSize) {
    final elements = List<String>.from(entries);
    final sample = <String>[];
    while (sample.length < sampleSize) {
      int index = _random.nextInt(elements.length);
      sample.add(elements[index]);
    }

    return sample;
  }
}
