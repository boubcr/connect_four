import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  BottomNavItem({this.icon, this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Icon(icon, size: 33),
      ),
    );
  }
}
