import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int> onChanged;
  final List<bool> selections;

  TimeSelector(
      {@required this.items, @required this.value, this.onChanged})
      : this.selections = items.map((e) => value == e).toList();

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: LayoutBuilder(
          builder: (context, constraints) => ToggleButtons(
              constraints: BoxConstraints.expand(
                  width:
                      constraints.maxWidth / (this.widget.items.length + 0.5)),
              children:
                  this.widget.items.map((e) => _buildToggleButton(e)).toList(),
              isSelected: this.widget.selections,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < this.widget.selections.length; i++) {
                    this.widget.selections[i] = i == index;
                  }
                  this.widget.onChanged(this.widget.items[index]);
                });
              })),
    );
  }

  Widget _buildToggleButton(int item) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text('$item',
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center));
  }
}
