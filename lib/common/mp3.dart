import 'package:connect_four/utils/utility.dart';

class Mp3 {
  static String get homeBGM => 'bgm/home.mp3';
  static String get playingBGM => 'bgm/playing.mp3';

  static String get moveSFX => Utility.anyOf(moves);
  static String get scoringSFX => Utility.anyOf(scorings);
  static String get failingSFX => Utility.anyOf(failings);
  static String get readySFX => Utility.anyOf(readies);
  static String get winningSFX => Utility.anyOf(winnings);
  static String get losingSFX => Utility.anyOf(losings);
  static String get drawingSFX => Utility.anyOf(drawings);

  static List<String> moves = [
    'sfx/move1.mp3',
  ];

  static List<String> scorings = [
    'sfx/score1.mp3',
    'sfx/score2.mp3',
    'sfx/score3.mp3'
  ];

  static List<String> failings = [
    'sfx/haha1.mp3',
    'sfx/haha2.mp3',
  ];

  static List<String> readies = [
    'sfx/ready1.mp3',
    'sfx/ready2.mp3',
  ];

  static List<String> winnings = [
    'sfx/winning1.mp3',
  ];

  static List<String> losings = [
    'sfx/haha2.mp3',
  ];

  static List<String> drawings = [
    'sfx/haha2.mp3',
  ];

  static const String WELCOME = 'home.mp3';
  static const String BOARD_READY = 'ready1.mp3';
  static const String SCORING = 'score1.mp3';
  static const String PLAYING = 'move1.mp3';
  static const String WINNING = 'winning1.mp3';
  static const String LOSING = 'haha1.mp3';
  static const String DRAWING = 'haha2.mp3';
}
