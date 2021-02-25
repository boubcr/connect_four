import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HeaderTitle extends StatelessWidget {
  final String _title = '4Dots'; //'Connect Four';
  final double widthScale;
  HeaderTitle({this.widthScale = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Card(
            margin: EdgeInsets.zero,
            color: Colors.transparent,
            elevation: 0,
            child: Container(
                height: 200,
                width: 200, //size.width * widthScale,
                //child: Text('ddd'),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: AlignmentDirectional.center,
                        //image: AssetImage('assets/img/logo_transparent_001.png'),
                        //image: AssetImage('assets/img/logo_transparent_002.png'),
                        //image: AssetImage('assets/img/logo_transparent_003.png'),
                        image:
                            AssetImage('assets/img/logo_transparent_004.png'),
                        fit: BoxFit.fill)))),
      ),
    );

    /*return Container(
      color: Theme.of(context).primaryColorLight,
      //width: size.width * widthScale,
      width: 100,
      child: Container(
        height: 200,
        width: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: AlignmentDirectional.center,
                //image: AssetImage('assets/img/logo_transparent_001.png'),
                //image: AssetImage('assets/img/logo_transparent_002.png'),
                //image: AssetImage('assets/img/logo_transparent_003.png'),
                image: AssetImage('assets/img/logo_transparent_004.png'),
                fit: BoxFit.fill)),
      ),
    );*/

    return Container(
      //color: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: _shadowedTitle(color: theme.primaryColor),
      /*child: Card(
        //margin: EdgeInsets.all(10.0),
        //color: Colors.white,
        //color: Colors.transparent,
        //elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.blue,
              width: 5.0,
            )),
        child: Container(
          color: Colors.transparent,
          height: 85,
          padding: EdgeInsets.only(bottom: 0),
          child: Center(
            //child: Text('Connect Four', style: _textStyle1()),
            child: _shadowedTitle(),
          ),
        )
      ),*/
    );

    //Text('Connect Four', style: _textStyle1())
    //_shadowedTitle()
  }

  Widget _shadowedTitle({Color color = Colors.brown}) {
    return Text(_title,
        style: TextStyle(
            fontSize: 70,
            //fontFamily: 'Robus',
            //fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: color,
                blurRadius: 5.0,
                offset: Offset(5.0, 5.0),
              ),
              Shadow(
                color: color,
                blurRadius: 5.0,
                offset: Offset(-5.0, 5.0),
              ),
            ],
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.blue[50]));
  }

  Widget _otherText1() {
    return Text('Connect Four',
        style: TextStyle(
          fontSize: 50,
          shadows: [
            Shadow(
              color: Colors.blue,
              blurRadius: 5.0,
              offset: Offset(5.0, 5.0),
            ),
            Shadow(
              color: Colors.brown,
              blurRadius: 5.0,
              offset: Offset(-5.0, 5.0),
            ),
          ],
        ));
  }

  TextStyle _textStyle1() {
    return TextStyle(
        fontFamily: 'BigSpace', //'Tsa'
        fontSize: 40,
        foreground: Paint()
          ..shader = ui.Gradient.linear(
            const Offset(0, 20),
            const Offset(150, 20),
            <Color>[
              Colors.red,
              Colors.blue,
            ],
          ));
  }

  TextStyle _textStyle2() {
    return TextStyle(
      //color: Colors.brown,
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.blue[700],
    );
  }
}
