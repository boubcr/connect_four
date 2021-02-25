import 'package:connect_four/common/background_painter.dart';
import 'package:flutter/material.dart';

class ContainerWrapper extends StatelessWidget {
  final Widget child;
  final double widthScale;
  final double heightScale;

  ContainerWrapper(
      {@required this.child, this.widthScale = 1, this.heightScale = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Container(
        width: size.width * widthScale,
        height: size.height * heightScale,
        child: CustomPaint(
          painter: BackgroundPainter(
              density: .04,
              displacement: const Offset(0.0, 200.0),
              color: theme.primaryColor),
          child: child,
        ));
  }
}
