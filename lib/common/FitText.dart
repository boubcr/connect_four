import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FitText extends StatelessWidget {
  final String title;
  final TextStyle style;

  FitText({Key key, this.title, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(title, style: style ?? TextStyle(fontSize: 22)));
  }
}
