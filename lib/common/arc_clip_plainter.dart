import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

class ArcClipPainter extends CustomClipper<Path> {
  ArcClipPainter({this.type = DotType.VERTICAL});
  final DotType type;

  @override
  Path getClip(Size size) {
    Path path = Path();

    double radius = size.width ;
    double padding = size.width / 5;

    switch(type) {
      case DotType.VERTICAL:
        path.moveTo(padding, 0.0);
        path.lineTo(size.width - padding, 0.0);
        path.arcToPoint(Offset(size.width + radius, size.height), clockwise: false, radius: Radius.circular(1));
        path.lineTo(padding, size.height);
        path.arcToPoint(Offset(-radius, 0.0), clockwise: false, radius: Radius.circular(1));
        break;
      case DotType.HORIZONTAL:
        path.moveTo(0.0, padding);
        path.arcToPoint(Offset(size.width, 0.0 - radius), clockwise: false, radius: Radius.circular(1));
        path.lineTo(size.width, size.height - padding);
        path.arcToPoint(Offset(0.0, size.height + radius - padding), clockwise: false, radius: Radius.circular(1));
        path.lineTo(0.0, padding);
        break;
      default: break;
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}