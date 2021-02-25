import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../login.dart';

enum ButtonType {
  Email,
  Google,
  Facebook,
}

class SignInButton extends StatelessWidget {
  final ButtonType type;
  SignInButton({this.type});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry _margin;
    VoidCallback _onPressed = () {};
    Icon _icon;
    Color _backgroundColor;
    String _title;

    switch (this.type) {
      case ButtonType.Facebook:
        _title = 'Facebook';
        _icon = Icon(FontAwesomeIcons.facebookSquare, color: Colors.white);
        _backgroundColor = Colors.blue;
        _margin = EdgeInsets.only(right: 5.0);
        _onPressed = () {
          BlocProvider.of<LoginBloc>(context).add(
            LoginWithFacebookPressed(),
          );
        };
        break;
      case ButtonType.Google:
        _title = 'Google';
        _icon = Icon(FontAwesomeIcons.google, color: Colors.white);
        _backgroundColor = Colors.redAccent;
        _margin = EdgeInsets.only(left: 5.0);
        _onPressed = () {
          BlocProvider.of<LoginBloc>(context).add(
            LoginWithGooglePressed(),
          );
        };
        break;
      default:
        break;
    }

    return Container(
      margin: _margin,
      child: FlatButton(
        textColor: Colors.white,
        height: 50.0,
        color: _backgroundColor,
        onPressed: _onPressed,
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: _icon,
            ),
            Text(_title)
          ],
        ),
      ),
    );
  }
}
