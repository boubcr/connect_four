import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum ScoreProps { scale }

class ScoreCard extends StatelessWidget {
  ScoreCard({this.player, this.reversed = false});
  final bool reversed;
  final Player player;
  final double scaleValue = 30.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      CircleAvatar(backgroundColor: Color(player.color), radius: 8),
      _buildScoreText(),
    ];

    if (reversed) {
      widgets = widgets.reversed.toList();
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 70,
        //color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ));
  }

  Widget _buildScoreText() {
    if (!player.score.increased) return displayText(this.scaleValue);

    TimelineTween<ScoreProps> _tween = _createTween();
    return PlayAnimation<TimelineValue<ScoreProps>>(
        tween: _tween,
        duration: _tween.duration,
        builder: (context, child, value) {
          return displayText(value.get(ScoreProps.scale));
        });
  }

  Widget displayText(double scale) {
    return Container(
      width: scale,
      height: scale,
      //color: Colors.white,
      //decoration: Utility.dotDecoration(Color(player.color)),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text('${player.score.value}'),
      ),
    );
  }

  TimelineTween<ScoreProps> _createTween() {
    var _tween = TimelineTween<ScoreProps>(curve: Curves.bounceInOut)
      ..addScene(begin: 0.milliseconds, duration: 800.milliseconds)
          .animate(ScoreProps.scale, tween: scaleValue.tweenTo(45.0))
      ..addScene(begin: 800.milliseconds, duration: 1000.milliseconds)
          .animate(ScoreProps.scale, tween: 45.0.tweenTo(scaleValue));

    return _tween;
  }
}
