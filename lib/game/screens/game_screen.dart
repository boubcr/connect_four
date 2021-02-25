import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:connect_four/common/loading_indicator.dart';
import 'package:connect_four/game/screens/screens.dart';
import 'package:connect_four/utils/app_keys.dart';
import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/game/widgets/game_dialogs.dart';
import 'package:connect_four/game/widgets/widgets.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_four/game/game.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:game_manager/game_manager.dart';
import 'package:logging/logging.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static final _log = Logger('GameScreen');
  final LayerLink _layerLink = LayerLink();
  YYDialog _gameOverDialog;
  YYDialog _gamePauseDialog;
  OverlayEntry _overlayEntry;
  CountDownController _controller = CountDownController();
  ConfettiController _controllerCenter;
  GameManager manager;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    CustomAudioPlayer.playPlayingBGM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(builder: (context, state) {
      if (state is GameLoadedSuccess) {
        manager = state.manager;
        executeAfterBuild();

        return _buildScaffold();
      }

      //TODO replace all LoadingIndicator by Splash Screen
      return LoadingIndicator();
    });
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      //resizeToAvoidBottomPadding: false,
      body: _buildBoardScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          key: AppKeys.fabTimerKey, child: _countdownWidget()),
      bottomNavigationBar:
          BottomNavBar(manager: manager, onPauseTap: _onPauseButtonTap),
    );
  }

  Widget _buildBoardScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: Utility.gradientWithTheme(
              theme: Theme.of(context),
              color: Color(manager.settings.backgroundColor)),
          child: BoardScreen(
              manager: manager, onDotTap: onDotTap, layerLink: this._layerLink),
        ),
      ),
    );
  }

  Widget _countdownWidget() {
    _log.info('manager.thinkTime: ${manager.thinkTime}');
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(1.0),
      child: Center(
          child: CircularCountDownTimer(
        duration: (manager.thinkTime * 60) + 1,
        controller: _controller,
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        color: Theme.of(context).primaryColorLight,
        fillColor: Theme.of(context).primaryColor,
        backgroundColor: Color(manager.current.color),
        strokeWidth: 5.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: false,
        onStart: () {},
        onComplete: _openGameOverDialog,
      )),
    );
  }

  void onAnimationEnd(Dot dot) {
    BlocProvider.of<GamesBloc>(context).add(AddMove(dot));
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (manager.moves.isEmpty) {
        _controller.start();
      }

      _nextActivity();
    });
  }

  void onDotTap(Dot dot) {
    _log.info('On dot ${dot.id} tap');
    _playedDotOverlayEntry(dot: dot);
  }

  void _removeOverlay() {
    this._overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _nextActivity() {
    _removeOverlay();

    if (manager.gameStatus() != GameStatus.NO_WINNER_YET) {
      _log.info('Game over: show dialog');
      _controller.pause();
      _openGameOverDialog();
    } else {
      if (manager.current.isAi) {
        _log.info('AI ${manager.current.name} is playing');
        _log.info('Made moves 1: ${manager.moveIds}');
        Future<Move> aiPlay = aiMove(manager);
        aiPlay.then((move) {
          _log.info('Made moves 2: ${manager.moveIds}');
          _log.info('AI found move: ${move.id}');
          if (Utility.timeOut(_controller)) {
            _log.info('Timeout - Don\'t play the found move');
            return;
          }
          onDotTap(manager.board.dots.firstWhere((e) => e.id == move.id));
        }).whenComplete(() {
          _log.info('AI ${manager.current.name} completed playing');
        });
      }
    }
  }

  void _openGameOverDialog() {
    if (_gameOverDialog == null || !_gameOverDialog.isShowing) {
      _gameOverDialog = gameOverDialog(
          context: context, manager: manager, time: _controller.getTime());

      _removeOverlay();
      _playConfettiAnimation();
    }
  }

  Future<Move> aiMove(GameManager manager) async {
    _log.info('aiMove start');
    Move bestMove = await compute(findBestMove, manager);
    _log.info('aiMove end with ${bestMove.id}');
    return bestMove;
  }

  static Future<Move> findBestMove(GameManager manager) async {
    BestScore bestScore = await manager.current.strategy.think(manager);
    return bestScore.move;
  }

  void _playedDotOverlayEntry({Dot dot, AnimationType type}) {
    var screenSize = MediaQuery.of(context).size;
    double overlayWidth = screenSize.width;
    double overlayHeight = screenSize.height; // double.infinity;
    Offset offset = Offset.zero;

    Offset fabOffset = Utility.getPositions(AppKeys.fabTimerKey);
    Widget followerChild;

    if (type == AnimationType.CONFETTI) {
      followerChild = _buildCongratsConfetti();
    } else {
      Size size = Utility.getSizes(dot.dotKey);
      Offset dotOffset = Utility.getPositions(dot.dotKey);

      overlayWidth = size.width * 3.0;
      overlayHeight = size.height * 3.0;

      double x = dotOffset.dx - size.width;
      double y = dotOffset.dy - size.height;
      offset = Offset(x, y);

      followerChild = MoveAnimation(
          dot: dot.copyWith(color: this.manager.current.color),
          fabOffset: fabOffset,
          dotOffset: dotOffset,
          saValue: this.manager.scoreAnimationPosition(dot), //testDots,
          onEnd: () => onAnimationEnd(dot));
    }

    /// Remove last animation entry before creating new one
    _overlayEntry?.remove();

    this._overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              width: overlayWidth,
              height: overlayHeight,
              child: CompositedTransformFollower(
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  offset: offset,
                  child: followerChild
                  /*child: MoveAnimation(
                    dot: dot.copyWith(color: this.manager.current.color),
                    fabOffset: fabOffset,
                    dotOffset: dotOffset,
                    saValue:
                        this.manager.scoreAnimationPosition(dot), //testDots,
                    onEnd: () => onAnimationEnd(dot)),*/
                  ),
            ));

    Overlay.of(context).insert(this._overlayEntry);
  }

  void _onPauseButtonTap() {
    _removeOverlay();
    if (_gamePauseDialog == null || !_gamePauseDialog.isShowing) {
      _controller.pause();
      _gamePauseDialog =
          gamePauseDialog(context: context, controller: _controller);
    }
  }

  void _playConfettiAnimation() {
    if (manager.gameStatus() == GameStatus.WINNER) {
    _playedDotOverlayEntry(type: AnimationType.CONFETTI);
    _controllerCenter.play();
    }
  }

  Widget _buildCongratsConfetti() => Container(
        //color: Colors.red,
        child: Align(
          //alignment: Alignment.center,
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            numberOfParticles: 20,
            emissionFrequency: 0.04,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
      );

  @override
  void dispose() {
    //_gameOverDialog?.dismiss();
    //_gamePauseDialog?.dismiss();
    this._controllerCenter?.dispose();
    super.dispose();
  }
}
