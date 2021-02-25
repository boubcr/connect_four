import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum DisplayProps { offset1, offset2, offset3, offset4, offset5 }

class DisplayList {
  DisplayList({this.widget, this.props});
  final DisplayProps props;
  final Widget widget;
}

class DisplayTimelineTween {
  static TimelineTween<DisplayProps> tweenOf(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final begin = Offset(size.width, 0.0);

    return TimelineTween<DisplayProps>(curve: Curves.ease)
      ..addScene(begin: 0.milliseconds, duration: 300.milliseconds)
          .animate(DisplayProps.offset1, tween: begin.tweenTo(Offset.zero))
      ..addScene(begin: 200.milliseconds, end: 500.milliseconds)
          .animate(DisplayProps.offset2, tween: begin.tweenTo(Offset.zero))
      ..addScene(begin: 400.milliseconds, end: 700.milliseconds)
          .animate(DisplayProps.offset3, tween: begin.tweenTo(Offset.zero))
      ..addScene(begin: 600.milliseconds, end: 900.milliseconds)
          .animate(DisplayProps.offset4, tween: begin.tweenTo(Offset.zero))
      ..addScene(begin: 800.milliseconds, end: 1100.milliseconds)
          .animate(DisplayProps.offset5, tween: begin.tweenTo(Offset.zero));
  }
}