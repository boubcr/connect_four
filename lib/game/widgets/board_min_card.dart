import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

typedef OnChangeCallback = Function(DotShape dotStyle);

class BoardMinCard extends StatelessWidget {
  final DotShape dotStyle;
  final bool isSelected;
  final OnChangeCallback onChange;
  final Color color;
  final double height;
  final double width;
  BoardMinCard(
      {this.dotStyle,
      this.color = Colors.white,
      this.isSelected = false,
      this.onChange,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: height ?? (isSelected ? 80 : 70),
      height: width ?? (isSelected ? 80 : 70),
      padding: EdgeInsets.all(5.0),
      child: Card(
        color: color,
        elevation: isSelected ? 20 : 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color:
                  isSelected ? theme.primaryColor : theme.secondaryHeaderColor,
              width: 3.0,
            )),
        //child: _buildBoardGrid(),
        child: InkWell(
          onTap: onChange != null
              ? () {
                  print('On tap');
                  onChange(dotStyle);
                }
              : null,
          child: _buildBoardGrid(),
        ),
      ),
    );
  }

  Widget _buildBoardGrid() {
    return GridView.count(
      padding: EdgeInsets.all(5.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        _coloredCard(),
        _coloredCard(),
        _coloredCard(),
        _coloredCard(),
      ],
    );
  }

  Widget _coloredCard() {
    return Card(
        margin: EdgeInsets.all(5),
        elevation: 0,
        color: Colors.black,
        shape: Utility.dotBorder(shape: dotStyle, small: true) // _cardBorder(),
        );
  }
}
