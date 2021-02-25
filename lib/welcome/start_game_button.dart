import 'dart:collection';

import 'package:connect_four/auth/auth.dart';
import 'package:connect_four/common/painted_button.dart';
import 'package:connect_four/game/screens/screens.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/game/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartGameButton extends StatelessWidget {
  StartGameButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: PaintedButton(
          label: 'getStarted',
          widthScale: .7,
          height: 35,
          onPressed: () {
            //BlocProvider.of<AuthBloc>(context).add(AppStarted());
            Navigator.pushNamed(context, AppRoutes.login);
          },
        ));
    /*return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 100,
        color: Colors.red,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text('Let\'s go'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                //return ChooseGameMode();
                return NewGameScreen();
              }),
            );
          },
        ),
      ),
    );*/
  }
}
