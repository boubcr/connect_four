import 'package:connect_four/common/display_timeline_tween.dart';
import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/common/header_title.dart';
import 'package:connect_four/common/template.dart';
import 'package:connect_four/game/widgets/social_share_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/common/painted_button.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/services.dart';
import 'package:game_manager/game_manager.dart';
import 'package:simple_animations/simple_animations.dart';

class GameHome extends StatefulWidget {
  final GameMode mode;
  const GameHome({Key key, this.mode}) : super(key: key);

  @override
  _GameHomeState createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  AdManager _adManager = AdManager();
  //InterstitialAd _interstitialAd;
  //BannerAd _bannerAd;

  // TODO: Implement _loadBannerAd()
  void _loadBannerAd() {
    /*_bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);*/
    //AdManager(banner: _bannerAd).buildBannerAd()..load();
    /*_bannerAd
      ..load()
      ..show();*/
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //CustomAudioPlayer.playWelcomeSound();
    CustomAudioPlayer.playHomeBGM();
    super.initState();
    //_adManager.bannerAd.load();
    //_adManager.interstitialAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adManager.bannerAd.hide();
    _adManager.interstitialAd.hide();
  }

  @override
  Widget build(BuildContext context) {
    TimelineTween<DisplayProps> _tween = DisplayTimelineTween.tweenOf(context);

    return Template(
        child: ListView(
      children: [
        SizedBox(height: 20),
        HeaderTitle(widthScale: .7),
        PlayAnimation<TimelineValue<DisplayProps>>(
            tween: _tween,
            duration: _tween.duration,
            builder: (context, child, value) {
              return Container(
                //color: Colors.limeAccent,
                //height: 800,
                child: Column(
                  children: [
                    Transform.translate(
                      offset: value.get(DisplayProps.offset1),
                      child: PaintedButton(
                        label: 'onePlayer',
                        icon: Icons.person,
                        widthScale: .7,
                        onPressed: () {
                          //_bannerAd?.dispose();
                          print('One Player clicked');
                          Navigator.pushNamed(context, AppRoutes.newGame,
                              arguments: GameMode.ONE_PLAYER);
                          _adManager.bannerAd.hide();
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset2),
                      child: PaintedButton(
                        label: 'twoPlayers',
                        icon: Icons.group,
                        widthScale: .7,
                        onPressed: () {
                          print('Two Players clicked');
                          Navigator.pushNamed(context, AppRoutes.newGame,
                              arguments: GameMode.TWO_PLAYERS);
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset3),
                      child: PaintedButton(
                        label: 'rules.title',
                        icon: Icons.rule,
                        widthScale: .7,
                        onPressed: () {
                          print('Rules screen');
                          Navigator.pushNamed(context, AppRoutes.rules);
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset4),
                      child: PaintedButton(
                        label: 'options',
                        icon: Icons.settings,
                        widthScale: .7,
                        onPressed: () {
                          print('Options screen');
                          _adManager.bannerAd.hide();
                          Navigator.pushNamed(context, AppRoutes.settings);
                          /*Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: GameHome(),
                                  enterPage: SettingsHome()));*/
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset5),
                      child: SocialShareButton(),
                    ),
                  ],
                ),
              );
            })
      ],
    )).scaffold(withAppBar: false);
  }

  @override
  Widget buildOld(BuildContext context) {
    TimelineTween<DisplayProps> _tween = DisplayTimelineTween.tweenOf(context);
    //YYDialog.init(context);

    return Template(
        child: Column(
      children: <Widget>[
        SizedBox(height: 29),
        HeaderTitle(),
        Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: IntrinsicWidth(
            child: PlayAnimation<TimelineValue<DisplayProps>>(
              tween: _tween,
              duration: _tween.duration,
              builder: (context, child, value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Transform.translate(
                      offset: value.get(DisplayProps.offset1),
                      child: PaintedButton(
                        label: 'One Player',
                        icon: Icons.person,
                        widthScale: .7,
                        onPressed: () {
                          //_bannerAd?.dispose();
                          print('One Player clicked');
                          Navigator.pushNamed(context, AppRoutes.newGame,
                              arguments: GameMode.ONE_PLAYER);
                          _adManager.bannerAd.hide();
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset2),
                      child: PaintedButton(
                        label: 'Two Players',
                        icon: Icons.group,
                        widthScale: .7,
                        onPressed: () {
                          print('Two Players clicked');
                          Navigator.pushNamed(context, AppRoutes.newGame,
                              arguments: GameMode.TWO_PLAYERS);
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset3),
                      child: PaintedButton(
                        label: 'Rules',
                        icon: Icons.rule,
                        widthScale: .7,
                        onPressed: () {
                          print('Rules screen');
                          Navigator.pushNamed(context, AppRoutes.rules);
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset4),
                      child: PaintedButton(
                        label: 'Options',
                        icon: Icons.settings,
                        widthScale: .7,
                        onPressed: () {
                          print('Options screen');
                          _adManager.bannerAd.hide();
                          Navigator.pushNamed(context, AppRoutes.settings);
                          /*Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: GameHome(),
                                  enterPage: SettingsHome()));*/
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: value.get(DisplayProps.offset5),
                      child: SocialShareButton(),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    )).scaffold(withAppBar: false);
  }
}
