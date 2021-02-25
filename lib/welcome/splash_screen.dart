import 'package:connect_four/common/header_title.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      //body: Center(child: Text('Splash Screen')),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        //decoration: Utility.gradient_2(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderTitle(),
            SizedBox(height: 40),
            Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}