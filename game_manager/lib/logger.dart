import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

void initRootLogger() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
        '${record.time}: ${record.loggerName}: ${record.level.name}:  ${record.message}');
  });
}

void initRootLoggerColors() {
  // only enable logging for debug mode
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.OFF;
  }
  hierarchicalLoggingEnabled = true;

  // specify the levels for lower level loggers, if desired
  // Logger('SiteInfoService').level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    if (!kDebugMode) {
      return;
    }

    var start = '\x1b[90m';
    const end = '\x1b[0m';
    const white = '\x1b[37m';

    switch (record.level.name) {
      case 'INFO':
        start = '\x1b[37m';
        break;
      case 'WARNING':
        start = '\x1b[93m';
        break;
      case 'SEVERE':
        start = '\x1b[103m\x1b[31m';
        break;
      case 'SHOUT':
        start = '\x1b[41m\x1b[93m';
        break;
    }

    final message =
        '$white${record.time}:$end$start${record.level.name}: ${record.message}$end';
    developer.log(
      message,
      name: record.loggerName.padRight(25),
      level: record.level.value,
      time: record.time,
    );
  });
}
