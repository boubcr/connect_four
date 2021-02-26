import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:connect_four/ads/ad_ids.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

enum BannerAdType {SMALL, NORMAL, MEDIUM, LARGE}

class BannerAd extends StatefulWidget {
  const BannerAd({Key key, this.type = BannerAdType.SMALL}) : super(key: key);
  final BannerAdType type;

  @override
  _BannerAdState createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAd> {
  static final _log = Logger('BannerAd');
  bool isReady = false;
  AdmobBannerSize _bannerSize;
  AdIds _adIds = AdIds();

  @override
  void initState() {
    Admob.requestTrackingAuthorization();
    switch(this.widget.type) {
      case BannerAdType.SMALL:
        //_bannerSize = AdmobBannerSize.SMART_BANNER(context);
        _bannerSize = AdmobBannerSize.BANNER;
        break;
      case BannerAdType.NORMAL:
        _bannerSize = AdmobBannerSize.BANNER;
        break;
      case BannerAdType.MEDIUM:
        _bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
        break;
      case BannerAdType.LARGE:
        _bannerSize = AdmobBannerSize.LARGE_BANNER;
        break;
      default:
        _bannerSize = AdmobBannerSize.BANNER;
        break;
    }

    //dmobBannerSize.LARGE_BANNER
    //AdmobBannerSize.MEDIUM_RECTANGLE
    //AdmobBannerSize.FULL_BANNER
    //AdmobBannerSize.LEADERBOARD ...
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100,
      //color: Colors.red,
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: AdmobBanner(
        adUnitId: getBannerAdUnitId(), //  _adIds.appId,
        adSize: _bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        },
        onBannerCreated: (AdmobBannerController controller) {
          // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
          // Normally you don't need to worry about disposing this yourself, it's handled.
          // If you need direct access to dispose, this is your guy!
          // controller.dispose();
        },
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        _log.info('New Admob $adType Ad loaded!');
        setState(() {
          isReady = true;
        });
        break;
      case AdmobAdEvent.opened:
        _log.info('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        _log.info('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        _log.info('Admob $adType failed to load. :(');
        setState(() {
          isReady = false;
        });
        break;
      default:
    }
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }
}
