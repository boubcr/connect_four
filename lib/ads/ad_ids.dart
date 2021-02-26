import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdIds {
  final bool testing;
  AdIds({this.testing = true});

  //String get appId => testing ? AdTestIds.appId : AppAdIds.appId;
  String get bannerAdUnitId =>
      testing ? AdmobBanner.testAdUnitId : AppAdIds.bannerAdUnitId;

  String get interstitialAdUnitId =>
      testing ? AdmobInterstitial.testAdUnitId : AppAdIds.interstitialAdUnitId;

  String get rewardedAdUnitId =>
      testing ? AdmobReward.testAdUnitId : AppAdIds.rewardedAdUnitId;
}

class AppAdIds {
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
