import 'dart:math';

class Utils {
  static String dotKey(int row, int column) => '$row-$column';
  static String dotId(String key) => key.replaceAll('-', '');
  //static Duration getDuration(DateTime time) => DateTime.now().difference(time);
  static String getDuration(DateTime time, {String title}) {
    //return '${title ?? '' } Duration = ${DateTime.now().difference(time).inMicroseconds} micros';
    return '${title ?? '' } Duration = ${DateTime.now().difference(time)}';
  }

}

class Enum {
  static String getValue<T>(T value) => value.toString().split('.').last;

  static T getEnum<T>(List<T> values, String value) {
    return values.firstWhere((v) => getValue(v) == value,
        orElse: () => null);
  }
}


/// A UUID generator, useful for generating unique IDs for your Todos.
/// Shamelessly extracted from the Flutter source code.
///
/// This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// ### Example
///
///     final String id = Uuid().generateV4();
class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}