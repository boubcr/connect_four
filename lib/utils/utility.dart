import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_manager/game_manager.dart';
import 'package:easy_localization/easy_localization.dart';

//https://connectfour-2dad8.firebaseapp.com/__/auth/handler

class Utility {

  static Locale getLocale(BuildContext context, String langCode) {
    return context.supportedLocales.firstWhere(
            (locale) => locale.languageCode == langCode,
        orElse: () => context.locale);
  }

  static Widget countryIcon(String code) =>
      Image.asset('icons/flags/png/2.5x/${code}.png',
          package: 'country_icons', height: 24, width: 24);

  static bool timeOut(CountDownController controller) {
    return controller.getTime() == '00:00';
  }

  static T anyOf<T>(List<T> list) {
    return list[Random().nextInt(list.length)];
  }

  static BoxDecoration dotDecoration({Color color, DotShape shape}) {
    if (shape == DotShape.CIRCLE)
      return BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      );

    if (shape == DotShape.RECTANGLE)
      return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: color,
      );

    return BoxDecoration(
      borderRadius: BorderRadius.circular(Constants.DOT_RADIUS),
      shape: BoxShape.rectangle,
      color: color,
    );
  }

  static OutlinedBorder dotBorder({DotShape shape, bool small = false}) {
    if (shape == DotShape.CIRCLE) return StadiumBorder(side: dotBorderSide());

    if (shape == DotShape.RECTANGLE) {
      return BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      );
    }

    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(small ? 2.0 : Constants.DOT_RADIUS),
        side: dotBorderSide());
  }

  static BorderSide dotBorderSide() {
    return BorderSide(
      color: Colors.transparent, // AppTheme.board.dotBorderColor,
      width: 0.0,
    );
  }

  static Size getSizes(GlobalKey key) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    //print("$key SIZE: $sizeRed");
    return sizeRed;
  }

  static Offset getPositions(GlobalKey key) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();

    //final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset topLeft =
        renderBoxRed.size.topLeft(renderBoxRed.localToGlobal(Offset.zero));

    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    //print("${key.toString()} POSITION 1: $positionRed ");
    //print("${key.toString()} POSITION 2: $topLeft ");
    return positionRed;
    //return topLeft;
  }

  /*Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }*/

  static Offset psoss(GlobalKey localKey, GlobalKey parentKey) {
    final RenderBox child = localKey.currentContext.findRenderObject();
    Offset childOffset = child.localToGlobal(Offset.zero);
    //convert
    RenderBox parent = parentKey.currentContext.findRenderObject();
    Offset childRelativeToParent = parent.globalToLocal(childOffset);
    return childRelativeToParent;
  }

  static void test() {
    /*
    RenderBox child = childKey.currentContext.findRenderObject();
    Offset childOffset = child.localToGlobal(Offset.zero);
    //convert
    RenderBox parent = parentKey.currentContext.findRenderObject();
    Offset childRelativeToParent = parent.globalToLocal(childOffset);
    */
  }

  // Takes a key, and in 1 frame, returns the size of the context attached to the key
  static void getFutureSizeFromGlobalKey(
      GlobalKey key, Function(Size size) callback) {
    Future.microtask(() {
      Size size = getSizeFromContext(key.currentContext);
      if (size != null) {
        callback(size);
      }
    });
  }

  // Shortcut to get the renderBox size from a context
  static Size getSizeFromContext(BuildContext context) {
    RenderBox rb = context.findRenderObject() as RenderBox;
    return rb?.size ?? Size.zero;
  }

  // Shortcut to get the global position of a context
  static Offset getOffsetFromContext(BuildContext context,
      [Offset offset = null]) {
    RenderBox rb = context.findRenderObject() as RenderBox;
    return rb?.localToGlobal(offset ?? Offset.zero);
  }

  static BoxDecoration gradient_1() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment(-0.4, -0.8),
        stops: [0.0, 0.5, 0.5, 1],
        colors: [
          Colors.red,
          Colors.red,
          Colors.orange,
          Colors.orange,
        ],
        tileMode: TileMode.repeated,
      ),
    );
  }

  static BoxDecoration gradient_2() {
    return BoxDecoration(
      gradient: RadialGradient(
        colors: [Colors.green, Colors.blue, Colors.orange, Colors.pink],
        stops: [0.2, 0.5, 0.7, 1],
        center: Alignment(0.1, 0.3),
        focal: Alignment(-0.1, 0.6),
        focalRadius: 2,
      ),
    );
  }

  static BoxDecoration gradient_3() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.3, 0.7, 1],
            colors: [Colors.green, Colors.blue, Colors.orange, Colors.pink]));
  }

  static BoxDecoration gradient_4(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.yellow[800],
          Colors.yellow[700],
          Colors.yellow[600],
          Colors.yellow[400],
        ],
      ),
    );
  }

  static BoxDecoration gradient_5() {
    return BoxDecoration(
      gradient: SweepGradient(
        center: FractionalOffset.center,
        startAngle: 0.0,
        endAngle: pi * 2,
        colors: const <Color>[
          Color(0xFF4285F4), // blue
          Color(0xFF34A853), // green
          Color(0xFFFBBC05), // yellow
          Color(0xFFEA4335), // red
          Color(0xFF4285F4), // blue again to seamlessly transition to the start
        ],
        stops: const <double>[0.0, 0.25, 0.5, 0.75, 1.0],
      ),
    );
  }

  static BoxDecoration gradientWithTheme({ThemeData theme, Color color}) {
    return BoxDecoration(
      //borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      gradient: new LinearGradient(
          colors: [
            theme.primaryColorLight,
            color,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    );
  }

  static BoxDecoration gradientWithTheme2({ThemeData theme}) {
    return BoxDecoration(
      gradient: new LinearGradient(
          colors: [
            theme.primaryColorDark,
            theme.primaryColorLight,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    );
  }
}
