import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SimpleCard extends StatelessWidget {
  final String title;
  final double height;
  final Widget child;

  const SimpleCard({Key key, this.title, @required this.height, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> widgets = [];
    if (title != null) {
      widgets.add(Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ).tr());

      widgets.add(SizedBox(height: 5.0));
    }

    widgets.add(child);

    return Container(
      height: height,
      color: Colors.transparent,
      //width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: widgets),
    );
  }
}
