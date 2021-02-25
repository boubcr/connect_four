import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class BackgroundSingleton {
  static final _log = Logger('BackgroundSingleton');
  static BackgroundSingleton _instance;
  static const appName = 'my_app';
  static final List<Offset> _offsets = [];
  static final List<Offset> _buttonOffsets = [];


  static final rnd = Random();
  static Offset randomOffset(Size size) {
    return Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
  }

  BackgroundSingleton._internal(Size size) {
    _log.info(size);
    var fillRect = Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero));
    double count = fillRect.width * fillRect.height * 2.0;

    int len = count.ceil();
    _log.info('count: $count');

    _offsets.addAll(List<Offset>.generate(len, (int i) => randomOffset(size)));

    double count2 = fillRect.width * fillRect.height * .1;
    int len2 = count2.ceil();
    print('BackgroundSingleton len2: $len2');
    _buttonOffsets.addAll(List<Offset>.generate(len2, (int i) => randomOffset(size)));

    _instance = this;
  }

  factory BackgroundSingleton(Size size) => _instance ?? BackgroundSingleton._internal(size);

  static List<Offset> get offsets => _offsets;
  static List<Offset> get buttonOffsets => _buttonOffsets;
}

class BackgroundPainter extends CustomPainter {
  final fillPaint;

  /// Defines how many lines per unit of area we want
  final double density;
  final Offset displacement;
  final Color color;

  /// Expose to outside, allowing to override default value
  BackgroundPainter(
      {this.density = .1,
        this.displacement = const Offset(0.0, 20.0), // 2.0, 200.0 // 2.0, 20.0
        this.color = Colors.brown
      }) : this.fillPaint = Paint()..color = color;

  static final rnd = Random(10);
  static Offset randomOffset(Size size) {
    return Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
  }

  final linePaint = Paint()..color = Colors.white24;

  @override
  void paint(Canvas canvas, Size size) {
    var fillRect = Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero));
    double count = fillRect.width * fillRect.height * density;
    canvas.drawRect(fillRect, fillPaint);
    canvas.save();
    canvas.clipRect(fillRect);

    List<Offset> offsets = BackgroundSingleton.offsets;

    for (double i = 0; i < count; i++) {
      var start = offsets[i.toInt()] - (displacement * .5);
      var end = start + displacement;

      canvas.drawLine(start, end, linePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)  {
    return false;
  }
}
