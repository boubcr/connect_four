import 'package:flutter/material.dart';

class ThemeOption {
  final int index;
  final String title;
  final ThemeData theme;
  ThemeOption({this.index, this.theme, this.title});

  @override
  String toString() => 'ThemeOption { '
      'index: $index, '
      'title: $title, '
      'theme: ${theme.primaryColor} }';
}
