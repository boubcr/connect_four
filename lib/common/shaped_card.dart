import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ShapedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Widget child;
  final MainAxisAlignment mainAxisAlignment;

  const ShapedCard(
      {Key key,
      this.title,
      this.subtitle = '',
      @required this.height,
      this.child,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> widgets = [];
    if (title != null) {
      widgets.add(Text(
        '${title.tr().toUpperCase()} ${subtitle.tr()}',
        style: TextStyle(fontSize: 20.0),
      ));

      widgets.add(SizedBox(height: 5.0));
    }

    widgets.add(child);

    return Container(
      height: height,
      //width: double.infinity,
      child: Card(
        color: theme.primaryColorLight,
        //color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: theme.secondaryHeaderColor,
              width: 5.0,
            )),
        child: Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.max,
            children: widgets),
      ),
    );
  }
}
