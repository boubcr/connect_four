import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { x, y, radius }

class ParticleAnimation extends StatelessWidget {
  final Color color;

  ParticleAnimation({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    TimelineTween<AniProps> _tween = _createTween();

    return Center(
      child: PlayAnimation<TimelineValue<AniProps>>(
        tween: _tween,
        duration: _tween.duration,
        builder: (context, child, value) {
          return Transform.translate(
            offset: Offset(value.get(AniProps.x), value.get(AniProps.y)),
            child: CircleAvatar(
              backgroundColor: color,
              radius: value.get(AniProps.radius),
            ),
          );
        },
      ),
    );
  }

  TimelineTween<AniProps> _createTween() {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    return TimelineTween<AniProps>()
      ..addScene(begin: 0.milliseconds, duration: 500.milliseconds)
          .animate(AniProps.x, tween: (0.0).tweenTo(x))
          .animate(AniProps.y, tween: (0.0).tweenTo(y))
      ..addScene(begin: 0.milliseconds, end: 500.milliseconds)
          .animate(AniProps.radius, tween: 20.0.tweenTo(0.0));
  }
}
