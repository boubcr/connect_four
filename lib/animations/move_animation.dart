import 'dart:math';

import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/animations/particle_animation.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/models/models.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimationType { RIPPLE, EXPLOSION, CONFETTI }

enum AniProps {
  x,
  y,
  scale,
  offset,
  width,
  height,
  bgColor,
  color,
  explosion,
  hasEnded
}

class MoveAnimation extends StatelessWidget {
  MoveAnimation(
      {this.dot, this.fabOffset, this.dotOffset, this.onEnd, this.saValue});
  final Dot dot;
  final Offset fabOffset;
  final Offset dotOffset;
  final ScoreAnimationValue saValue;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    TimelineTween<AniProps> tween = _createTween();
    Color color = Color(this.dot.style.color);

    return Card(
        //color: Colors.white,
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Center(
            child: PlayAnimation<TimelineValue<AniProps>>(
                tween: tween,
                duration: tween.duration,
                builder: (context, child, value) {
                  if (value.get(AniProps.hasEnded) == 1) {
                    this.onEnd();
                  }

                  if (value.get(AniProps.offset) == Offset.zero)
                    CustomAudioPlayer.playMove();

                  Widget widget = _buildFixText(value.get(AniProps.color));
                  //Widget widget = _buildFixText(value.get(AniProps.textColor));
                  if (value.get(AniProps.explosion) == 1) {
                    CustomAudioPlayer.playScoring();
                    widget = _buildParticlesStack();
                  }

                  Widget childWidget = Container(
                          width: value.get(AniProps.scale),
                          height: value.get(AniProps.scale),
                          decoration: Utility.dotDecoration(
                            color: value.get(AniProps.bgColor),
                            shape: dot.style?.shape
                          ),
                          child: widget);

                  return Transform.translate(
                    offset: value.get(AniProps.offset),
                    child: childWidget,
                  );
                })));
  }

  Color get dotColor => this.dot.hasStyle
      ? Color(this.dot.style.color)
      : Colors.transparent;

  Widget _buildFixText(Color color) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text('+${saValue.value}', style: TextStyle(color: color)),
    );
  }

  Widget _buildParticlesStack() {
    return Stack(
      children: particles,
    );
  }

  List<ParticleAnimation> get particles => Iterable.generate(10)
      .map((e) => ParticleAnimation(color: Color(this.dot.style.color)))
      .toList();

  TimelineTween<AniProps> _createTween() {
    //var tween = TimelineTween<AniProps>(curve: Curves.easeInOut);
    var tween = TimelineTween<AniProps>();

    double x = fabOffset.dx - dotOffset.dx;
    double y = fabOffset.dy - dotOffset.dy;
    Offset startOffset = Offset(x, y);

    Size size = Utility.getSizes(dot.dotKey);

    Color color = Color(this.dot.style.color);
    var colorScene = tween
        .addScene(begin: 0.seconds, duration: 1.microseconds)
        .animate(AniProps.bgColor, tween: Colors.transparent.tweenTo(color))
        .animate(AniProps.color, tween: Colors.transparent.tweenTo(color));

    var scaleIn = colorScene
        .addSubsequentScene(duration: 500.milliseconds)
        .animate(AniProps.scale, tween: 10.0.tweenTo(size.width))
        .animate(AniProps.offset, tween: startOffset.tweenTo(Offset.zero));

    var scene = scaleIn;
    if (this.saValue.value > 0) scene = _addScoreAnimationFor(scene);

    var endScene = scene
        .addSubsequentScene(duration: 1.microseconds)
        .animate(AniProps.hasEnded, tween: 0.tweenTo(1));

    return tween;
  }

  TimelineScene<AniProps> _addScoreAnimationFor(TimelineScene<AniProps> scene) {
    Color color = Color(this.dot.style.color);

    Offset offset = Utility.getPositions(saValue.dot.dotKey);
    Size size = Utility.getSizes(saValue.dot.dotKey);

    double overlayScale = size.width * 3.0;

    double x = offset.dx - dotOffset.dx;
    double y = offset.dy - dotOffset.dy;
    Offset startOffset = Offset(x, y);

    var initScene = scene
        .addSubsequentScene(duration: 1.microseconds)
        .animate(AniProps.offset, tween: Offset.zero.tweenTo(startOffset))
        .animate(AniProps.bgColor, tween: color.tweenTo(Colors.transparent))
        .animate(AniProps.color, tween: Colors.transparent.tweenTo(color));

    var scaleIn = initScene
        .addSubsequentScene(duration: 500.milliseconds)
        .animate(AniProps.scale,
            tween: 0.0.tweenTo(overlayScale), curve: Curves.bounceIn);

    var scaleOut = scaleIn
        .addSubsequentScene(duration: 500.milliseconds)
        .animate(AniProps.explosion, tween: 0.tweenTo(1))
        .animate(AniProps.scale, tween: overlayScale.tweenTo(0.0));

    return scaleOut;
  }
}
