import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connect_four/common/mp3.dart';
import 'package:logging/logging.dart';

class CustomAudioPlayer {
  static final _log = Logger('CustomAudioPlayer');
  static CustomAudioPlayer _instance;
  static AudioCache _bcmPlayer;
  static AudioCache _audioCache;
  static AudioCache _endingPlayer;

  static bool soundOn;

  CustomAudioPlayer._internal(bool sound) {
    _log.info('sound is on: $sound');
    soundOn = sound;
    String prefix = 'assets/sounds/';

    //AudioPlayer audioPlayerInstance = AudioPlayer()..setReleaseMode(ReleaseMode.STOP);
    _bcmPlayer = AudioCache(prefix: prefix, fixedPlayer: AudioPlayer());
    _bcmPlayer.loadAll([Mp3.homeBGM, Mp3.playingBGM]);

    _audioCache = AudioCache(prefix: prefix, fixedPlayer: AudioPlayer());
    _audioCache.loadAll([
      ...Mp3.moves,
      ...Mp3.scorings,
      ...Mp3.failings,
      ...Mp3.readies,
      ...Mp3.winnings,
      ...Mp3.losings,
      ...Mp3.drawings,
    ]);

    _endingPlayer = AudioCache(prefix: prefix, fixedPlayer: AudioPlayer());
    _endingPlayer.loadAll([
      ...Mp3.winnings,
      ...Mp3.losings,
      ...Mp3.drawings,
    ]);

    AudioPlayer.logEnabled = false;
    _instance = this;
  }

  factory CustomAudioPlayer({bool sound}) =>
      _instance ?? CustomAudioPlayer._internal(sound);

  static double get volume => soundOn ? 1.0 : 0.0;

  static void playMove() async {
    await _audioCache.play(Mp3.moveSFX);
  }

  static void playScoring() async {
    await _audioCache.play(Mp3.scoringSFX);
  }

  static void playWinning() async {
    playHomeBGM();
    await _endingPlayer.play(Mp3.winningSFX, volume: volume);
  }

  static void playLosing() async {
    playHomeBGM();
    await _endingPlayer.play(Mp3.losingSFX, volume: volume);
  }

  static void playDrawing() async {
    playHomeBGM();
    await _endingPlayer.play(Mp3.drawingSFX, volume: volume);
  }

  static void playHomeBGM() async {
    //_bcmPlayer.loop(Mp3.homeBGM, volume: .10);
    await _bcmPlayer.play(Mp3.homeBGM, volume: 1);
  }

  static void playPlayingBGM() async {
    //_bcmPlayer.loop(Mp3.playingBGM, volume: .10);
    await _bcmPlayer.play(Mp3.playingBGM, volume: 1);
  }
}

class CustomAudioPlayerOld {
  static CustomAudioPlayerOld _instance;
  static AudioCache _audioCache;
  static AudioCache _movePlayer;
  static AudioCache _endingPlayer;

  static bool soundOn;

  CustomAudioPlayerOld._internal(bool sound) {
    print('CustomAudioPlayer _internal');
    soundOn = sound;
    PlayerMode mode = PlayerMode.MEDIA_PLAYER;
    String prefix = 'assets/sounds/';

    _audioCache =
        AudioCache(prefix: prefix, fixedPlayer: AudioPlayer(mode: mode));
    //_audioCache = AudioCache(prefix: 'assets/sounds/');

    _audioCache.loadAll([
      Mp3.WELCOME,
      Mp3.BOARD_READY,
      Mp3.SCORING,
      //Mp3.PLAYING,
      'score2.mp3',
      'score2.mp3',
      'ready2.mp3',
    ]);

    _endingPlayer =
        AudioCache(prefix: prefix, fixedPlayer: AudioPlayer(mode: mode));
    _endingPlayer.loadAll([Mp3.WINNING, Mp3.LOSING, Mp3.DRAWING]);

    _movePlayer =
        AudioCache(prefix: prefix, fixedPlayer: AudioPlayer(mode: mode));
    _movePlayer.loadAll([Mp3.PLAYING]);

    AudioPlayer.logEnabled = false;
    _instance = this;
  }

  factory CustomAudioPlayerOld({bool sound}) =>
      _instance ?? CustomAudioPlayerOld._internal(sound);

  static double get volume => soundOn ? 1.0 : 0.0;

  static AudioCache get player => _audioCache;

  static void playWelcomeSound() async {
    await _audioCache.fixedPlayer.seek(Duration.zero);
    await _audioCache.play(Mp3.WELCOME, volume: volume);
  }

  static void playBoardReadySound() async {
    await _audioCache.fixedPlayer.seek(Duration.zero);
    await _audioCache.play(Mp3.BOARD_READY, volume: volume);
  }

  static void playPlayingSound() async {
    await _movePlayer.fixedPlayer.seek(Duration.zero);
    await _movePlayer.play(Mp3.PLAYING, volume: volume);
  }

  static void playScoringSound() async {
    await _audioCache.fixedPlayer.seek(Duration.zero);
    await _audioCache.play(Mp3.SCORING, volume: volume);
  }

  static void playWinningSound() async {
    playWelcomeSound();

    await _endingPlayer.fixedPlayer.seek(Duration.zero);
    await _endingPlayer.play(Mp3.WINNING, volume: volume);
  }

  static void playLosingSound() async {
    playWelcomeSound();

    await _endingPlayer.fixedPlayer.seek(Duration.zero);
    await _endingPlayer.play(Mp3.LOSING, volume: volume);
  }

  static void playDrawingSound() async {
    playWelcomeSound();

    await _endingPlayer.fixedPlayer.seek(Duration.zero);
    await _endingPlayer.play(Mp3.DRAWING, volume: volume);
  }
}
