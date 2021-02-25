import 'dart:ui';
import 'dart:math' as math;

import 'package:connect_four/game/game.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> indicator(int size) => List<Widget>.generate(
      size,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Color(0XFF256075)
                    : Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final _pageViewController = new PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> slides = getSlides();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() {
                  setState(() {
                    currentPage = _pageViewController.page;
                  });
                });
                return slides[index];
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 70.0),
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(slides.length),
                  ),
                )
                //  ),
                )
            // )
          ],
        ),
      ),
    );
  }

  List<Widget> getSlides() {
    List items = [
      {
        "header": 'onboarding.ai.header',
        "description": 'onboarding.ai.description',
        "image": "assets/images/2.png",
        "showStart": false
      },
      {
        "header": 'onboarding.friends.header',
        "description": 'onboarding.friends.description',
        "image": "assets/images/3.png",
        "showStart": false
      },
      {
        "header": 'onboarding.customize.header',
        "description": 'onboarding.customize.description',
        "image": "assets/images/1.png",
        "showStart": true
      },
    ];

    return items
        .map((item) => Container(
                //padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    //color: Theme.of(context).primaryColor,
                    //padding: EdgeInsets.only(top: 100.0),
                    alignment: Alignment.bottomCenter,
                    child: buildImageWidget_01(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 55.0,
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(item['header'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Color(0XFF3F3D56)))
                                  .tr()),
                        ),
                        Text(
                          item['description'],
                          style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 1.2,
                              fontSize: 16.0,
                              height: 1.3),
                          textAlign: TextAlign.center,
                        ).tr(),
                        item['showStart'] ? StartGameButton() : Container()
                      ],
                    ),
                  ),
                )
              ],
            )))
        .toList();
  }

  Widget buildImageWidget_01() {
    return Container(
      //height: 450,
      //width: 350,
      //color: Colors.white,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(40.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Transform.rotate(
            angle: .1,
            child: Center(
              child: buildRotatedCard(Colors.green),
            ),
          ),
          Transform.rotate(
            angle: -.1,
            child: Center(
              child: buildRotatedCard(Colors.blue),
            ),
          ),
          buildImageCard(),
        ],
      ),
    );
  }

  Widget buildImageCard() {
    return Center(
      child: new Container(
        //color: Colors.white,
        child: new Container(
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                  style: BorderStyle.solid),
              borderRadius: new BorderRadius.circular(1.0),
              image: new DecorationImage(
                  alignment: Alignment.topCenter,
                  image: new AssetImage('assets/screenshots/screenshot_01.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget buildRotatedCard(Color color) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          //color: Theme.of(context).primaryColorLight,
          border: Border.all(
              //color: color,
            color: Theme.of(context).primaryColor,
              width: 10.0,
              style: BorderStyle.solid
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
        ));
  }

  Widget buildImageWidget_002() {
    return Container(
      //height: 200,
      //width: double.maxFinite,
      height: double.infinity,
      //color: Colors.green,
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Theme.of(context).primaryColor,
            offset: new Offset(0.0, 0.0),
            blurRadius: 20.0,
          )
        ],
        image: DecorationImage(
          image: ExactAssetImage("assets/screenshots/screenshot_01.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Text(
              "PLAY WITH AI",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget_001() {
    return Center(
      child: new Container(
        //width: double.infinity,
        //height: double.infinity,
        //color: Colors.white,
        child: new Container(
          width: 200,
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: Colors.green, width: 5.0, style: BorderStyle.solid),
              borderRadius: new BorderRadius.vertical(
                top: new Radius.circular(20.0),
                //bottom: new Radius.circular(20.0),
              ),
              boxShadow: [
                new BoxShadow(
                  color: Colors.red,
                  offset: new Offset(20.0, 10.0),
                  blurRadius: 20.0,
                )
              ],
              image: new DecorationImage(
                  alignment: Alignment.topCenter,
                  image:
                      ExactAssetImage("assets/screenshots/screenshot_01.png"),
                  fit: BoxFit.fitWidth)),
        ),
      ),
    );
  }

  Widget buildImageWidget_02() {
    return Container(
      height: 200,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage("assets/screenshots/screenshot_01.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Text(
              "CHOCOLATE",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget_03() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      color: Colors.white30,
      /*decoration: BoxDecoration(
                      //shape: BoxShape.rectangle,
                      //color: Theme.of(context).primaryColorLight,
                      //borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 2, color: Theme.of(context).primaryColorLight),
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 30),
                      ]),*/
      child: Container(
        //height: 200,
        width: 200,
        //color: Colors.red
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            image: DecorationImage(
                alignment: AlignmentDirectional.center,
                image: AssetImage('assets/screenshots/screenshot_01.png'),
                fit: BoxFit.fitHeight)),
      ),
    );
  }

  BoxBorder imageBorder() {
    BorderSide borderSide = BorderSide(color: Colors.grey, width: 40.0);
    return Border(top: borderSide, left: borderSide, right: borderSide);
  }

  Widget _buildImage(String name) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Container(
        height: 200,
        width: 200,
        //color: Colors.red
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: AlignmentDirectional.center,
                image: AssetImage('assets/img/$name'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
