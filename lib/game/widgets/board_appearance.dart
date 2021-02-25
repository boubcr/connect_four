import 'package:connect_four/game/widgets/board_min_card.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

typedef OnChangeCallback = Function(DotShape value);

class BoardAppearance extends StatelessWidget {
  final DotShape selectedDotStyle;
  final OnChangeCallback onChange;
  final Color color;
  BoardAppearance({Key key, this.selectedDotStyle, this.color, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BoardMinCard(
              dotStyle: DotShape.SQUARE,
              onChange: onChange,
              color: color,
              isSelected: selectedDotStyle== DotShape.SQUARE),
          BoardMinCard(
              dotStyle: DotShape.CIRCLE,
              onChange: onChange,
              color: color,
              isSelected: selectedDotStyle == DotShape.CIRCLE),
          BoardMinCard(
            dotStyle: DotShape.RECTANGLE,
            onChange: onChange,
            color: color,
            isSelected: selectedDotStyle == DotShape.RECTANGLE,
          ),
        ],
      ),
    );
  }

}
