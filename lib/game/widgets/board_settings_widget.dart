import 'package:connect_four/common/text_icon.dart';
import 'package:connect_four/game/bloc/bloc.dart';
import 'package:connect_four/game/widgets/board_settings_dialog.dart';
import 'package:connect_four/common/game_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

typedef OnBoardSettingsSaveCallback = Function(
    int currentRowsValue, int currentColumnsValue, Color selectedColor);

class BoardSettingsWidget extends StatefulWidget {
  final OnBoardSettingsSaveCallback onSave;
  final int currentRowsValue;
  final int currentColumnsValue;
  final Color selectedColor;
  const BoardSettingsWidget(
      {Key key,
      this.currentRowsValue,
      this.currentColumnsValue,
      this.selectedColor,
      this.onSave})
      : super(key: key);

  @override
  _BoardSettingsWidgetState createState() => _BoardSettingsWidgetState();
}

class _BoardSettingsWidgetState extends State<BoardSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildCardWrapper();
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
                selectedColor: this.widget.selectedColor,
                currentColumnsValue: this.widget.currentColumnsValue,
                currentRowsValue: this.widget.currentRowsValue,
                onSave: this.widget.onSave);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextIcon(
                  title: '${this.widget.currentRowsValue}',
                  icon: Icons.table_rows_rounded,
                ),
                TextIcon(
                  title: '${this.widget.currentColumnsValue}',
                  icon: Icons.view_column_rounded,
                ),
                TextIcon(
                  color: this.widget.selectedColor,
                  icon: Icons.format_color_fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
