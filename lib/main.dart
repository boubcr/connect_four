import 'package:connect_four/connect_four_app.dart';
import 'package:connect_four/utils/simple_bloc_observer.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/game_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';


void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  //CustomAudioPlayer();

  List<Locale> supportedLocales = [Locale('en', 'US'), Locale('fr', 'FR')];

  //runApp(ConnectFourApp());
  runApp(
    EasyLocalization(
        saveLocale: false,
        supportedLocales: supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        assetLoader: YamlAssetLoader(),
        child: ConnectFourApp()
    ),
  );
}