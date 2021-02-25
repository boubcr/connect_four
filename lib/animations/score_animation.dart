import 'dart:math';

import 'package:connect_four/utils/app_keys.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// Create enum that defines the animated properties
enum AniProps { scale }

class ScoreAnimation extends StatelessWidget {
  ScoreAnimation({this.color = Colors.white, this.onEnd});
  final Color color;
  final VoidCallback onEnd;

  TimelineTween<AniProps> _createComplexTween() {
    //var tween = TimelineTween<Prop>(curve: Curves.easeInOut);
    var tween = TimelineTween<AniProps>();

    var scaleIn = tween.addScene(begin: 0.seconds, duration: 500.milliseconds).animate(
        AniProps.scale,
        tween: 1.0.tweenTo(400),
        curve: Curves.bounceIn);

    var scaleOut = scaleIn
        .addSubsequentScene(duration: 500.milliseconds) // right after fadeIn
        .animate(AniProps.scale,
            tween: 400.0.tweenTo(0.0), curve: Curves.bounceOut);

    return tween;
  }

  @override
  Widget build(BuildContext context) {
    TimelineTween<AniProps> tween = _createComplexTween();

    return Card(
      //color: Colors.green,
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Center(
        child: PlayAnimation<TimelineValue<AniProps>>(
          tween: tween,
          duration: tween.duration,
          builder: (context, child, value) {
            if (value.get(AniProps.scale) == 0.0) {
              if (this.onEnd != null)
                this.onEnd();
            }

            return Container(
                width: value.get(AniProps.scale), // Get animated width value
                height: value.get(AniProps.scale), // Get animated height value
                padding: EdgeInsets.all(5.0),
                //color: Colors.yellow,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text('+1'),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: this.color, // Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    //boxShadow: [BoxShadow(offset: Offset(0, 0), blurRadius: 10),]
                ));
          },
        ),
      ),
    );
  }
}
