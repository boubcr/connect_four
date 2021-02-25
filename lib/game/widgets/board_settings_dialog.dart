import 'dart:ui';
import 'package:connect_four/common/simple_card.dart';
import 'package:connect_four/game/widgets/color_picker_item.dart';
import 'package:connect_four/game/widgets/slider_widget.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

typedef OnBoardSettingsSaveCallback = Function(
    int currentRowsValue, int currentColumnsValue, Color selectedColor);

class BoardSettingsDialog extends StatefulWidget {
  final String title;
  final int rows;
  final int columns;
  final Color color;
  final OnBoardSettingsSaveCallback onSave;

  const BoardSettingsDialog(
      {Key key, this.title, this.rows, this.columns, this.color, this.onSave})
      : super(key: key);

  @override
  _BoardSettingsDialogState createState() => _BoardSettingsDialogState();
}

class _BoardSettingsDialogState extends State<BoardSettingsDialog> {
  int _currentRowsValue;
  int _currentColumnsValue;
  Color _selectedColor;

  @override
  void initState() {
    _currentRowsValue = this.widget.rows;
    _currentColumnsValue = this.widget.columns;
    _selectedColor = this.widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildContents(context),
    );
  }

  Widget _buildDialogContents(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ).tr(),
        SizedBox(height: 15),
        SimpleCard(
          title: 'game.board.rows',
          child: SliderWidget(
              min: Constants.MIN_ROWS,
              max: Constants.MAX_ROWS,
              fullWidth: true,
              value: _currentRowsValue,
              onChanged: (value) {
                setState(() {
                  _currentRowsValue = value.toInt();
                });
              }),
        ),
        //DimensionSliders(),
        SizedBox(height: 15),
        SimpleCard(
          title: 'game.board.columns',
          child: SliderWidget(
              min: Constants.MIN_COLUMNS,
              max: Constants.MAX_COLUMNS,
              fullWidth: true,
              value: _currentColumnsValue,
              onChanged: (value) {
                setState(() {
                  _currentColumnsValue = value.toInt();
                });
              }),
        ),
        SizedBox(height: 20),
        Text(
          'game.board.background',
          style: TextStyle(fontSize: 20),
        ).tr(),
        SizedBox(height: 15),
        ColorPickerItemWidget(
            colors: Constants.boardBackgroundColors,
            selected: _selectedColor,
            onChange: onChange),
        SizedBox(height: 22),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
              onPressed: () {
                this.widget.onSave(
                    _currentRowsValue, _currentColumnsValue, _selectedColor);
                Navigator.of(context).pop();
              },
              child: Text(
                'game.board.submit',
                style: TextStyle(fontSize: 18),
              ).tr()),
        ),
      ],
    );
  }

  /*
  void onSave(int currentRowsValue, int currentColumnsValue, Color selectedColor) {
    print('On board settings changed');
    BlocProvider.of<GamesBloc>(context).add(GameBoardChanged(
        rows: currentRowsValue,
        columns: _currentColumnsValue,
        color: _selectedColor.value));
    Navigator.of(context).pop();
  }*/

  void onChange(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Widget _buildContents(context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: theme.primaryColorLight,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 30),
                ]),
            child: _buildDialogContents(context)),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            //backgroundColor: Colors.blue,
            backgroundColor: theme.primaryColor,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Icon(Icons.games) // Image.asset("assets/model.jpeg")
                ),
          ),
        ),
      ],
    );
  }
}
