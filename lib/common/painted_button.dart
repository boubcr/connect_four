import 'dart:math';
import 'package:connect_four/common/FitText.dart';
import 'package:connect_four/common/background_painter.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class PaintedButton extends StatelessWidget {
  //final Widget child;
  final double widthScale;
  final double heightScale;
  final String label;
  final VoidCallback onPressed;
  final double height;
  final IconData icon;

  PaintedButton(
      {@required this.label,
      this.icon,
      this.onPressed,
      this.height = 45.0,
      this.widthScale = 1,
      this.heightScale = 1});

  @override
  Widget build(BuildContext context) {
    //return _buildSimpleButton(context);
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    List<Widget> widgets = [];
    if (icon != null) {
      widgets.add(Icon(icon, size: 40));
    }

    widgets.add(Expanded(
      child: Center(
        //child: Text(label.tr().toUpperCase(), style: TextStyle(fontSize: 22)),
        child: FitText(title: label.tr().toUpperCase()),
      ),
    ));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: InkWell(
        onTap: this.onPressed,
        child: Container(
            width: size.width * widthScale,
            height: height,
            child: CustomPaint(
              painter: ButtonPainter(
                  //density: 1,
                  density: .2,
                  //displacement: const Offset(0.0, 10.0),
                  displacement: Offset(18.0, 0.0),
                  color: theme.primaryColor),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widgets,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildSimpleButton(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: InkWell(
        onTap: this.onPressed,
        child: Container(
            width: size.width * widthScale,
            height: height,
            child: CustomPaint(
              painter: ButtonPainter(
                  density: .8,
                  displacement: const Offset(2.0, 2.0),
                  color: theme.primaryColor),
              child: Center(
                child:
                    Text(label.toUpperCase(), style: TextStyle(fontSize: 20)),
              ),
            )),
      ),
    );
  }
}

class ButtonPainter extends CustomPainter {
  /// Defines how many lines per unit of area we want
  final double density;
  final Offset displacement;
  final Color color;
  final linePaint;
  final fillPaint;

  /// Expose to outside, allowing to override default value
  ButtonPainter({this.density, this.displacement, this.color = Colors.brown})
      : this.linePaint = Paint()..color = Colors.white24,
        this.fillPaint = Paint()..color = color;

  static final rnd = Random();
  static Offset randomOffset(Size size) {
    return Offset(
        rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var fillRect = Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero));
    double count = fillRect.width * fillRect.height * density;
    canvas.drawRect(fillRect, fillPaint);
    buildBorder(canvas, size);
    canvas.save();
    canvas.clipRect(fillRect);

    List<Offset> offsets = BackgroundSingleton.buttonOffsets;

    for (double i = 0; i < count; i++) {
      var start = offsets[i.toInt()] - (displacement * .5);
      //var start = randomOffset(size) - (displacement * .5);
      var end = start + displacement;

      //Aligned
      //canvas.drawLine(start, end, linePaint);

      final List<Paint> linePaints = [
        Paint()..color = Colors.white10,
        Paint()..color = Colors.white12,
        Paint()..color = Colors.white24,
        Paint()..color = Colors.white30,
      ];

      canvas.drawLine(start, end, Utility.anyOf(linePaints));

    }

    canvas.restore();
  }

  void buildBorder(Canvas canvas, Size size) {
    final double _kRadius = 5;
    final double _kBorderWidth = 3;

    final rrectBorder =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(_kRadius));
    final rrectShadow =
        RRect.fromRectAndRadius(Offset(0, 0) & size, Radius.circular(_kRadius));
    final shadowPaint = Paint()
      ..strokeWidth = _kBorderWidth
      ..color = Colors.white //Colors.black
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    final borderPaint = Paint()
      ..strokeWidth = _kBorderWidth
      ..color = color //Colors.brown[800]
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrectShadow, shadowPaint);
    canvas.drawRRect(rrectBorder, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
/*
class ButtonPainterOffsets {
  static ButtonPainterOffsets _instance;
  static final List<Offset> _offsets = [];

  static final rnd = Random();
  static Offset randomOffset(Size size) {
    return Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
  }

  ButtonPainterOffsets._internal(Size size, double density) {
    var fillRect = Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero));
    double count = fillRect.width * fillRect.height * density;
    int len = count.ceil() * 2;

    _offsets.addAll(List<Offset>.generate(len, (int i) => randomOffset(size)));
    _instance = this;
  }

  factory ButtonPainterOffsets(Size size, double density) => _instance ?? ButtonPainterOffsets._internal(size, density);

  static List<Offset> get offsets => _offsets;
}
*/
