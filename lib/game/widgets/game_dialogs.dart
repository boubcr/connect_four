import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:connect_four/common/country_item.dart';
import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/common/painted_button.dart';
import 'package:connect_four/common/simple_card.dart';
import 'package:connect_four/game/widgets/board_settings_widget.dart';
import 'package:connect_four/game/widgets/color_picker_item.dart';
import 'package:connect_four/game/widgets/slider_widget.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

Decoration _dialogDecoration(BuildContext context) {
  return BoxDecoration(
    border: Border.all(width: 2, color: Theme.of(context).primaryColorLight),
    color: Theme.of(context).primaryColorLight,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
  );
}

YYDialog gameOverDialog(
    {BuildContext context, GameManager manager, String time = ''}) {
  Widget _buildDialogTitle() {
    String title = '';
    String subtitle = '';

    switch (manager.gameStatus()) {
      case GameStatus.WINNER:
        CustomAudioPlayer.playWinning();
        title = 'end.winning.title';
        subtitle = 'end.winning.subtitle';
        break;
      case GameStatus.LOSER:
        CustomAudioPlayer.playLosing();
        title = 'end.losing.title';
        subtitle = 'end.losing.subtitle';
        break;
      default:
        CustomAudioPlayer.playDrawing();
        title = 'end.drawing.title';
        subtitle = 'end.drawing.subtitle';
        break;
    }

    if (time == '00:00') {
      subtitle = title;
      title = 'end.timeOut';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
        ).tr()),
        subtitle: Center(
            child: Text(
          subtitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ).tr()),
      ),
    );
  }

  Widget _buildResults() {
    Widget _buildTitle(String title) {
      return Center(child: Text(title, style: TextStyle(fontSize: 20)).tr());
    }

    Widget _buildText(String text) {
      return Container(
          width: 24,
          child: Text('$text',
              style: TextStyle(fontSize: 18), textAlign: TextAlign.center));
    }

    Widget _buildMark(Player pl) {
      return Container(
          width: 24,
          child: Icon(
            Icons.circle,
            color: Color(pl.color),
            size: 24,
          ));
    }

    Widget _buildScore(Player pl) {
      return _buildText('${pl.score.value}');
    }

    Widget _buildMoves(Player pl) {
      return _buildText(
          '${manager.moves.where((move) => move.madeBy == pl.id).length}');
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5.0),
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),*/
      child: Column(
        children: ListTile.divideTiles(context: context, tiles: [
          ListTile(
            leading: _buildMark(manager.player),
            title: _buildTitle('game.player'),
            trailing: _buildMark(manager.opponent),
          ),
          ListTile(
            leading: _buildScore(manager.player),
            title: _buildTitle('game.score'),
            trailing: _buildScore(manager.opponent),
          ),
          ListTile(
            leading: _buildMoves(manager.player),
            title: _buildTitle('game.moves'),
            trailing: _buildMoves(manager.opponent),
          ),
          ListTile(
            leading: Icon(Icons.timer_rounded),
            title: Text('game.time.remaining', style: TextStyle(fontSize: 20))
                .tr(),
            trailing: Text(time, style: TextStyle(fontSize: 18)),
          ),
        ]).toList(),
      ),
    );
  }

  void _onNewGamePressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home, (Route<dynamic> route) => route.isFirst);
  }

  void _onSharePressed() {
    //TODO to be implemented
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home, (Route<dynamic> route) => route.isFirst);
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: PaintedButton(
              label: 'new',
              height: 40,
              widthScale: .7,
              onPressed: _onNewGamePressed,
            ),
          ),
          Expanded(
            child: PaintedButton(
                label: 'share',
                height: 40,
                widthScale: .7,
                onPressed: _onSharePressed),
          )
        ],
      ),
    );
  }

  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Theme.of(context).primaryColorLight
    ..barrierDismissible = true
    //..barrierColor = Colors.transparent
    ..decoration = _dialogDecoration(context)
    ..widget(_buildDialogTitle())
    ..widget(_buildResults())
    ..divider(height: 15.0, color: Theme.of(context).dividerColor)
    ..widget(_buildActionButtons())
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
}

YYDialog gamePauseDialog(
    {BuildContext context, CountDownController controller}) {
  Widget _buildDialogTitle() {
    //TODO Add Ads here
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Center(
            child: Text(
          'pause',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ).tr()),
      ),
    );
  }

  Widget _buildDialogBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        leading: Icon(Icons.timer_rounded),
        title: Text('game.time.remaining').tr(),
        trailing: Text(controller.getTime()),
      ),
    );
  }

  void _onNewGamePressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home, (Route<dynamic> route) => route.isFirst);
  }

  void _onContinuePressed() {
    Navigator.of(context).pop();
    controller.resume();
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: PaintedButton(
                label: 'continue',
                height: 40,
                widthScale: .7,
                onPressed: _onContinuePressed),
          ),
          Expanded(
            child: PaintedButton(
              label: 'new',
              height: 40,
              widthScale: .7,
              onPressed: _onNewGamePressed,
            ),
          ),
        ],
      ),
    );
  }

  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Theme.of(context).primaryColorLight
    ..barrierDismissible = false
    ..decoration = _dialogDecoration(context)
    ..widget(_buildDialogTitle())
    ..widget(_buildDialogBody())
    ..divider(height: 15.0, color: Theme.of(context).dividerColor)
    ..widget(_buildActionButtons())
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
}

YYDialog themeDialog(
    {BuildContext context, int selectedIndex, ValueChanged<int> onSave}) {
  Widget _buildDialogBody() {
    return Column(
        children: ListTile.divideTiles(
                context: context,
                tiles: Constants.allThemes
                    .map(
                      (option) => ListTile(
                        selectedTileColor: Theme.of(context).selectedRowColor,
                        leading: Icon(Icons.circle,
                            color: option.theme.primaryColor),
                        title: Text(option.title),
                        trailing: Icon(
                            option.index == selectedIndex
                                ? Icons.radio_button_on
                                : Icons.radio_button_off,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          onSave(option.index);
                        },
                      ),
                    )
                    .toList())
            .toList());
  }

  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Theme.of(context).primaryColorLight
    ..barrierDismissible = true
    ..decoration = _dialogDecoration(context)
    ..widget(SizedBox(height: 10.0))
    ..widget(Center(
        child: Text(
      'pickTheme',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ).tr()))
    ..widget(_buildDialogBody())
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
}

YYDialog languageDialog(
    {BuildContext context, String selected, ValueChanged<String> onSave}) {
  YYDialog yyDialog = YYDialog();

  Widget _buildDialogBody() {
    return Column(
        children: ListTile.divideTiles(
                context: context,
                tiles: Constants.languages
                    .map(
                      (item) => ListTile(
                        selectedTileColor: Theme.of(context).selectedRowColor,
                        leading: Utility.countryIcon(item.code),
                        title: Text(item.name),
                        trailing: Icon(
                            item.lang ==
                                    (selected == null
                                        ? context.locale.languageCode
                                        : selected)
                                ? Icons.radio_button_on
                                : Icons.radio_button_off,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          //context.locale = Utility.getLocale(context, item.lang);
                          yyDialog.dismiss();
                          onSave(item.lang);
                        },
                      ),
                    )
                    .toList())
            .toList());
  }

  yyDialog.build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Theme.of(context).primaryColorLight
    ..barrierDismissible = true
    ..decoration = _dialogDecoration(context)
    ..widget(SizedBox(height: 10.0))
    ..widget(Center(
        child: Text(
      'settings.lang',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ).tr()))
    ..widget(_buildDialogBody())
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();

  return yyDialog;
}

YYDialog boardSettingsDialog(
    {BuildContext context,
    int currentRowsValue,
    int currentColumnsValue,
    Color selectedColor,
    OnBoardSettingsSaveCallback onSave}) {
  var yyDialog = YYDialog();

  yyDialog.build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Theme.of(context).primaryColorLight
    ..barrierDismissible = true
    ..decoration = _dialogDecoration(context)
    ..widget(SizedBox(height: 10.0))
    ..widget(Center(
        child: Text(
      'game.board.settings',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ).tr()))
    ..widget(SimpleCard(
      title: 'game.board.rows',
      child: SliderWidget(
          min: Constants.MIN_ROWS,
          max: Constants.MAX_ROWS,
          fullWidth: true,
          value: currentRowsValue,
          onChanged: (value) {
            currentRowsValue = value;
          }),
    ))
    ..widget(SimpleCard(
      title: 'game.board.columns',
      child: SliderWidget(
          min: Constants.MIN_COLUMNS,
          max: Constants.MAX_COLUMNS,
          fullWidth: true,
          value: currentColumnsValue,
          onChanged: (value) {
            currentColumnsValue = value;
          }),
    ))
    ..widget(SizedBox(height: 5.0))
    ..widget(Text(
      'game.board.background',
      style: TextStyle(fontSize: 20),
    ).tr())
    ..widget(ColorPickerItemWidget(
        colors: Constants.boardBackgroundColors,
        selected: selectedColor,
        onChange: (value) {
          selectedColor = value;
        }))
    ..dismissCallBack = () {
      print("dismissCallBack invoke");
    }
    ..widget(SizedBox(height: 10.0))
    ..widget(PaintedButton(
      label: 'game.board.submit',
      height: 35,
      widthScale: .7,
      onPressed: () {
        onSave(currentRowsValue, currentColumnsValue, selectedColor);
        yyDialog.dismiss();
      },
    ))
    ..widget(SizedBox(height: 10.0))
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();

  return yyDialog;
}
