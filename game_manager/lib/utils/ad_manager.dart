import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdManager {
  BannerAdHandler bannerAd = BannerAdHandler();
  LargeBannerAdHandler largeBannerAd = LargeBannerAdHandler();
  InterstitialAdAdHandler interstitialAd = InterstitialAdAdHandler();

  /*
  bool isBannerAdReady = false;

  BannerAd _largeBannerAd;
  InterstitialAd _interstitialAd;

  AdManager({this.size});
  final Size size;

  BannerAd buildBannerAd() {
    BannerAd banner =
        BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.banner);

    banner.listener = (MobileAdEvent event) {
      print(event);
      if (event == MobileAdEvent.loaded) {
        banner..show(anchorType: AnchorType.bottom, anchorOffset: 20.0);
      }
    };

    return banner;
  }

  BannerAd buildLargeBannerAd() {
    BannerAd banner =
        BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.largeBanner);

    banner.listener = (MobileAdEvent event) {
      print(event);
      if (event == MobileAdEvent.loaded) {
        banner
          ..show(
              anchorType: AnchorType.top,
              anchorOffset: this.size.height * 0.15);
      }
    };

    return banner;
  }

  static InterstitialAd buildInterstitialAd() {
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
    );

    interstitialAd.listener = (MobileAdEvent event) {
      if (event == MobileAdEvent.failedToLoad) {
        interstitialAd..load();
      } else if (event == MobileAdEvent.closed) {
        interstitialAd = buildInterstitialAd()..load();
      }
      print(event);
    };

    return interstitialAd;
  }
  */

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~4354546703";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8865242552";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/7049598008";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

class InterstitialAdAdHandler {
  InterstitialAd _interstitialAd;
  bool _isAdReady = false;

  void load() {
    _interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: _onAdEvent,
    );
    _interstitialAd..load();
    //_interstitialAd.listener = _onAdEvent;
  }

  void show({double offset = 20.0, AnchorType anchor = AnchorType.bottom}) {
    if (_isAdReady)
      _interstitialAd..show(anchorType: anchor, anchorOffset: offset);
  }

  void hide() {
    if (_isAdReady) _interstitialAd.dispose();
  }

  void _onAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print('InterstitialAd Ad loaded');
        _isAdReady = true;
        //_interstitialAd..show(anchorType: AnchorType.bottom, anchorOffset: 20.0);
        break;
      case MobileAdEvent.failedToLoad:
        _isAdReady = false;
        _interstitialAd..load();
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _isAdReady = false;
        this.load();
        //interstitialAd = buildInterstitialAd()..load();
        //_moveToHome();
        break;
      default:
    }
  }
}

class LargeBannerAdHandler {
  BannerAd _largeBannerAd;
  bool _isAdReady = false;

  void load() {
    _largeBannerAd =
        BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.largeBanner);
    _largeBannerAd..load();
    _largeBannerAd.listener = _onAdEvent;
  }

  void show({double offset = 20.0, AnchorType anchor = AnchorType.bottom}) {
    if (_isAdReady)
      _largeBannerAd..show(anchorType: anchor, anchorOffset: offset);
  }

  void hide() {
    if (_isAdReady) _largeBannerAd.dispose();
  }

  void _onAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print('Banner Ad loaded');
        _isAdReady = true;
        _largeBannerAd..show(anchorType: AnchorType.bottom, anchorOffset: 20.0);
        break;
      case MobileAdEvent.failedToLoad:
        _isAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _isAdReady = false;
        this.load();
        //_moveToHome();
        break;
      default:
    }
  }
}

class BannerAdHandler {
  BannerAd _bannerAd;
  bool _isAdReady = false;

  void load() {
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      //listener: _onAdEvent
    );
    _bannerAd..load();
    _bannerAd.listener = _onAdEvent;
    /*_bannerAd.listener = (MobileAdEvent event) {
      print(event);
      if (event == MobileAdEvent.loaded) {
        _bannerAd..show(anchorType: AnchorType.bottom, anchorOffset: 20.0);
      }
    };*/
  }

  void show({double offset = 20.0, AnchorType anchor = AnchorType.bottom}) {
    if (_isAdReady) _bannerAd..show(anchorType: anchor, anchorOffset: offset);
  }

  void hide() {
    _bannerAd.isLoaded();
    if (_isAdReady && _bannerAd != null) _bannerAd.dispose();
  }

  void _onAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print('Banner Ad loaded');
        _isAdReady = true;
        _bannerAd..show(anchorType: AnchorType.bottom, anchorOffset: 20.0);
        break;
      case MobileAdEvent.failedToLoad:
        _isAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _isAdReady = false;
        this.load();
        //_moveToHome();
        break;
      default:
      // do nothing
    }
  }
}
