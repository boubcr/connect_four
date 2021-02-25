import 'package:connect_four/common/country_item.dart';
import 'package:connect_four/common/theme_option.dart';
import 'package:connect_four/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/models/models.dart';

class Constants {
  /// GRID CONSTANTS
  static const int MIN_ROWS = 4;
  static const int MAX_ROWS = 15;
  static const int DEFAULT_ROWS = 5;

  static const int MIN_COLUMNS = 4;
  static const int MAX_COLUMNS = 8; //10;
  static const int DEFAULT_COLUMNS = 5;

  static const Color DEFAULT_PLAYER_COLOR = Colors.red;
  static const Color DEFAULT_OPPONENT_COLOR = Colors.blue;
  static const Color DEFAULT_BOARD_COLOR = Colors.orange;
  static const GameLevel DEFAULT_LEVEL = GameLevel.EASY;
  static const DotShape DEFAULT_DOT_STYLE = DotShape.CIRCLE;

  static const List<int> THINK_TIMES = [1, 2, 5, 10, 15];
  static const int DEFAULT_THINK_TIME = 2;

  static const double padding = 20;
  static const double avatarRadius = 35;
  static const String DEFAULT_AVATAR =
      'noavatar.jpg'; //'noavatar.png';//'no_avatar.png';
  static const double DOT_RADIUS = 10.0;

  static  List<CountryItem> get languages => [
    CountryItem(code: 'us', lang: 'en', name: 'English'),
    CountryItem(code: 'fr', lang: 'fr', name: 'Français'),
  ];

  /// THEME SETTINGS
  static List<ThemeOption> get allThemes => [
        ThemeOption(index: 0, theme: brownTheme, title: 'Brown'),
        ThemeOption(index: 1, theme: orangeTheme, title: 'Orange'),
        ThemeOption(index: 2, theme: cyanTheme, title: 'Cyan'),
        ThemeOption(index: 3, theme: indigoTheme, title: 'Indigo'),
        ThemeOption(index: 4, theme: blueGreyTheme, title: 'Blue Grey'),
      ];

  static List<Color> boardBackgroundColors = [
    Colors.white,
    Colors.grey,
    Colors.red,
    Colors.red[200],
    Colors.yellow,
    Colors.yellow[200],
    Colors.green,
    Colors.green[200],
    Colors.blue,
    Colors.blue[200],
    Colors.orange,
    Colors.brown,
    Colors.cyan,
  ];

  static List<Color> playerColors = [
    Colors.red,
    Colors.purple,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.blueGrey,
    Colors.grey,
    Colors.white,
  ];
}
