import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:connect_four/ads/ad_ids.dart';
import 'package:flutter/material.dart';

class InterstitialAd {

  AdmobInterstitial _interstitialAd;
  AdIds _adIds = AdIds();

  void load() {
    Admob.requestTrackingAuthorization();
    _interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) _interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    _interstitialAd.load();
  }
  void dispose() {
    _interstitialAd.dispose();
  }

  void show() async {
    if (await _interstitialAd.isLoaded) {
      _interstitialAd.show();
    } else {
      print('Interstitial ad is still loading...');
    }
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      default:
    }
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }
}
