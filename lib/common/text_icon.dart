import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const TextIcon({Key key, this.title, this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 10),
          _buildTrailing(),
        ],
      ),
    );
  }

  Widget _buildTrailing() {
    if (color != null) {
      return Container(
        width: 30,
        height: 30,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      );
    }

    return Text(title, style: TextStyle(fontSize: 18));
  }
}
