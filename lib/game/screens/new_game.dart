import 'package:connect_four/auth/auth.dart';
import 'package:connect_four/common/display_timeline_tween.dart';
import 'package:connect_four/common/painted_button.dart';
import 'package:connect_four/common/shaped_card.dart';
import 'package:connect_four/common/template.dart';
import 'package:connect_four/common/text_icon.dart';
import 'package:connect_four/game/widgets/board_appearance.dart';
import 'package:connect_four/game/widgets/color_picker_item.dart';
import 'package:connect_four/game/widgets/game_dialogs.dart';
import 'package:connect_four/game/widgets/time_selector.dart';
import 'package:connect_four/game/widgets/board_settings_widget.dart';
import 'package:connect_four/players/bloc/bloc.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/game/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/game_manager.dart';
import 'package:logging/logging.dart';
import 'package:simple_animations/simple_animations.dart';

class NewGameScreen extends StatefulWidget {
  final GameMode mode;
  const NewGameScreen({Key key, this.mode}) : super(key: key);

  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  static final _log = Logger('NewGameScreen');

  int _currentRowsValue = Constants.DEFAULT_ROWS;
  int _currentColumnsValue = Constants.DEFAULT_COLUMNS;
  Color _selectedColor = Constants.DEFAULT_BOARD_COLOR;
  Color _participantColor = Constants.DEFAULT_PLAYER_COLOR;
  Color _opponentColor = Constants.DEFAULT_OPPONENT_COLOR;
  GameLevel _currentLevel = Constants.DEFAULT_LEVEL;
  DotShape _currentDotStyle = Constants.DEFAULT_DOT_STYLE;
  int _currentThinkTime = Constants.DEFAULT_THINK_TIME;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();

    return Template(
            title: this.widget.mode == GameMode.ONE_PLAYER
                ? 'onePlayer'
                : 'twoPlayers',
            child: _buildContents())
        .scaffold();
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedColor.value == _participantColor.value)
        this.onColorChange(this.playerColors(_opponentColor).first);

      if (_selectedColor.value == _opponentColor.value)
        this.onOpponentColorChange(this.playerColors(_participantColor).first);
    });
  }

  Widget _buildPageContents(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayersState>(builder: (context, state) {
      return _buildContents();
    });
  }

  Widget _buildContents() {
    TimelineTween<DisplayProps> _tween = DisplayTimelineTween.tweenOf(context);

    Widget boardWidget = ShapedCard(
      title: 'game.board.title',
      height: 195,
      child: Column(
        children: [
          BoardAppearance(
              selectedDotStyle: _currentDotStyle,
              color: _selectedColor,
              onChange: onBoardAppearanceChange),
          _buildCardWrapper()
        ],
      ),
    );

    Widget playerColorWidget = ShapedCard(
      title: 'game.playAs',
      height: 110,
      child: ColorPickerItemWidget(
          colors: playerColors(_opponentColor),
          selected: _participantColor,
          onChange: onColorChange),
    );

    Widget oppColorWidget = ShapedCard(
      title: 'game.opponentAs',
      height: 110,
      child: ColorPickerItemWidget(
          colors: playerColors(_participantColor),
          selected: _opponentColor,
          onChange: onOpponentColorChange),
    );

    Widget timeWidget = ShapedCard(
      title: 'game.time.title',
      subtitle: 'game.time.subtitle',
      height: 100,
      child: TimeSelector(
          items: Constants.THINK_TIMES,
          value: _currentThinkTime,
          onChanged: onThinkTimeChange),
    );

    Widget startButton = PaintedButton(
        label: 'game.submit',
        onPressed: () {
          onSave();
        });

    List<DisplayList> displayList = [
      DisplayList(props: DisplayProps.offset1, widget: boardWidget),
      DisplayList(props: DisplayProps.offset2, widget: playerColorWidget),
    ];

    if (this.widget.mode == GameMode.ONE_PLAYER) {
      displayList.addAll([
        DisplayList(props: DisplayProps.offset3, widget: timeWidget),
        DisplayList(props: DisplayProps.offset4, widget: startButton),
      ]);
    } else {
      displayList.addAll([
        DisplayList(props: DisplayProps.offset3, widget: oppColorWidget),
        DisplayList(props: DisplayProps.offset4, widget: timeWidget),
        DisplayList(props: DisplayProps.offset5, widget: startButton),
      ]);
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      //child: Container(color: Colors.red),
      child: PlayAnimation<TimelineValue<DisplayProps>>(
          tween: _tween,
          duration: _tween.duration,
          builder: (context, child, value) {
            return Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(shrinkWrap: true, children: [
                  ...displayList
                      .map((e) => Transform.translate(
                            offset: value.get(e.props),
                            child: e.widget,
                          ))
                      .toList()
                ]),
              ),
            );
          }),
    );
  }

  Widget _buildCardWrapper() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        color: theme.primaryColorLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: theme.secondaryHeaderColor,
              width: 5.0,
            )),
        child: InkWell(
          onTap: () {
            boardSettingsDialog(
                context: context,
                selectedColor: _selectedColor,
                currentColumnsValue: _currentColumnsValue,
                currentRowsValue: _currentRowsValue,
                onSave: onBoardSettingsSave);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextIcon(
                  title: '$_currentRowsValue',
                  icon: Icons.table_rows_rounded,
                ),
                TextIcon(
                  title: '$_currentColumnsValue',
                  icon: Icons.view_column_rounded,
                ),
                TextIcon(
                  color: _selectedColor,
                  icon: Icons.format_color_fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> playerColors(Color color) => Constants.playerColors
      .where((e) => ![
            color.value,
            Theme.of(context).primaryColor.value,
            _selectedColor.value
          ].contains(e.value))
      .toList();

  void onSave() {
    Authenticated authState =
        (BlocProvider.of<AuthBloc>(context).state as Authenticated);

    BoardSettings settings = BoardSettings(
        rows: _currentRowsValue,
        columns: _currentColumnsValue,
        backgroundColor: _selectedColor.value,
        style: DotStyle(shape: _currentDotStyle));

    BlocProvider.of<GamesBloc>(context).add(
      GameAdded(
          userId: authState.user.email,
          dimension: settings,
          level: _currentLevel,
          mode: this.widget.mode,
          thinkTime: _currentThinkTime,
          opponentColor: _opponentColor.value,
          playerColor: _participantColor.value),
    );

    Navigator.pushNamed(context, AppRoutes.gameScreen);
  }

  void onBoardSettingsSave(
      int currentRowsValue, int currentColumnsValue, Color selectedColor) {
    print('On board settings changed');
    setState(() {
      _currentRowsValue = currentRowsValue;
      _currentColumnsValue = currentColumnsValue;
      _selectedColor = selectedColor;
    });
  }

  void onBoardAppearanceChange(DotShape dotStyle) {
    print('New Game => on board change');
    setState(() {
      _currentDotStyle = dotStyle;
    });
  }

  void onThinkTimeChange(int value) {
    _log.info('Think time changed to $value');
    setState(() {
      _currentThinkTime = value;
    });
  }

  void onLevelChange(String value) {
    print('New Game => on level change');
    setState(() {
      _currentLevel = Enum.getEnum(GameLevel.values, value);
    });
  }

  void onColorChange(Color color) {
    print('New Game => on color change');
    setState(() {
      _participantColor = color;
    });
  }

  void onOpponentColorChange(Color color) {
    print('New Game => on color change');
    setState(() {
      _opponentColor = color;
    });
  }
}
