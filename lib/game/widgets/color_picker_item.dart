import 'package:flutter/material.dart';

typedef OnChangeCallback = Function(Color color);

class ColorPickerItemWidget extends StatefulWidget {
  final Color selected;
  final OnChangeCallback onChange;
  final List<Color> colors;

  const ColorPickerItemWidget(
      {Key key, @required this.colors, this.selected, this.onChange})
      : super(key: key);

  @override
  _ColorPickerItemWidgetState createState() => _ColorPickerItemWidgetState();
}

class _ColorPickerItemWidgetState extends State<ColorPickerItemWidget> {
  Color _currentValue;
  //final dataKey = new GlobalKey();
  final _controller = ScrollController();


  @override
  void initState() {
    super.initState();
    _currentValue = this.widget.selected;
    //_animateToIndex(12);
  }

  @override
  Widget build(BuildContext context) {
    //_currentValue = this.widget.selected;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToIndex(this.widget.colors.indexOf(_currentValue));
    });

    return Container(
        //margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        height: 50.0,
        //color: Colors.tealAccent,
        child: ListView.builder(
          controller: _controller,
          itemCount: this.widget.colors.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) => _colorCard(this.widget.colors.elementAt(i)),
        ),
    );
  }

  _animateToIndex(i) => _controller.animateTo((50.0 * i) - 130, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);


  Widget _colorCard(Color color) {
    bool isSelected = _currentValue.value == color.value;
    return Container(
      width: 50.0,
      height: 50.0,
      child: InkWell(
        customBorder: CircleBorder(),
        splashColor: Colors.teal,
        onTap: () {
          print('On color ${color.value} TAP');
          setState(() {
            _currentValue = color;
            this.widget.onChange(color);
          });
        },
        child: Card(
          margin: EdgeInsets.all(isSelected ? 5 : 12),
          elevation: 2,
          color: color,
          shape: CircleBorder(
              side: BorderSide(
            color: isSelected ? Colors.white : color,
            width: 3.0,
          )),
        ),
      ),
    );
  }
}
