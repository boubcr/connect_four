import 'package:connect_four/common/custom_slider_thumb_rectangle.dart';
import 'package:flutter/material.dart';
import '../../common/custom_slider_thumb_circle.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;
  final int value;
  final ValueChanged onChanged;
  final bool withCircleThumb;
  final bool withSign;

  SliderWidget(
      {this.sliderHeight = 48,
      this.max = 20,
      this.min = 5,
      this.fullWidth = false,
      this.value = 10,
      this.onChanged,
      this.withCircleThumb = false,
      this.withSign = true});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _sliderValue = 5;

  @override
  void initState() {
    super.initState();
    _sliderValue = this.widget.value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              theme.primaryColorLight,
              theme.primaryColorDark
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            _sliderSide(iconData: Icons.remove_circle, label: '${this.widget.min}'),
            _buildSlider(),
            _sliderSide(iconData: Icons.add_circle, label: '${this.widget.max}', isRight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Expanded(
      child: Center(
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white.withOpacity(1),
            inactiveTrackColor: Colors.white.withOpacity(.5),
            trackHeight: 4.0,
            thumbShape: this.widget.withCircleThumb
                ? CustomSliderThumbCircle(
                    thumbRadius: this.widget.sliderHeight * .4,
                    min: this.widget.min,
                    max: this.widget.max,
                  )
                : CustomSliderThumbRect(
                    thumbHeight: 40,
                    thumbRadius: this.widget.sliderHeight * .4,
                    min: this.widget.min,
                    max: this.widget.max,
                  ),
            overlayColor: Colors.white.withOpacity(this.widget.withCircleThumb ? 0.4 : 0),
          ),
          child: Slider(
            min: this.widget.min.toDouble(),
            max: this.widget.max.toDouble(),
            //value: this.widget.value.toDouble(),
            value: _sliderValue,
            //onChanged: this.widget.onChanged,
            onChanged: _onValueChanged,
          ),
        ),
      ),
    );
  }

  void _onValueChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
    this.widget.onChanged(value.toInt());
  }


  Widget _sliderSide({IconData iconData, String label, bool isRight = false}) {
    if (this.widget.withSign)
      return IconButton(
        icon: Icon(iconData, size: 30),
        splashColor: Colors.blue,
        alignment: Alignment.center,
        padding: new EdgeInsets.all(0.0),
        //color: Colors.green,
        onPressed: () {
          double newValue = _sliderValue + (isRight ? 1 : -1);
          if (newValue <= this.widget.max && newValue >= this.widget.min) {
            _onValueChanged(newValue);
          }

          //if (newValue <= this.widget.max && newValue >= this.widget.min)
          //  this.widget.onChanged(newValue);
        },
      );


    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: this.widget.sliderHeight * .3,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
