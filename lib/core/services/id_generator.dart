// Implements the Figma 00 Flows replaceable local ID abstraction.
import 'dart:math';

abstract interface class IdGenerator {
  String nextId();
}

class RandomIdGenerator implements IdGenerator {
  RandomIdGenerator({Random? random}) : _random = random ?? Random.secure();

  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final Random _random;

  @override
  String nextId() => List.generate(
    20,
    (_) => _alphabet[_random.nextInt(_alphabet.length)],
  ).join();
}
