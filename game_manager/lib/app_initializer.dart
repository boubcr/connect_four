import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:game_manager/utils/ad_manager.dart';
import 'package:logging/logging.dart';
import 'logger.dart';

class AppInitializer {
  static Future<FirebaseApp> init() async {
    print('init game app repos');
    Future<FirebaseApp> initApp = Firebase.initializeApp();
    _initAdMob();
    //_initLogger();
    initRootLogger();
    return initApp;
  }

  static Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  /*
  static void _initLogger() {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print(
          '${record.time}: ${record.loggerName}: ${record.level.name}:  ${record.message}');
    });
  }*/


}
