import 'package:connect_four/game/widgets/widgets.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({this.manager, this.onPauseTap});
  final GameManager manager;
  final VoidCallback onPauseTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        child: Container(
            color: Colors.transparent,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BottomNavItem(
                      icon: Icons.home_outlined,
                      onTap: () => _onMenuButtonTap(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScoreCard(player: manager.player),
                      SizedBox(width: 60),
                      ScoreCard(player: manager.opponent, reversed: true)
                    ],
                  ),
                  BottomNavItem(icon: Icons.pause, onTap: onPauseTap)
                ],
              ),
            )));
  }

  void _onMenuButtonTap(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.home);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (Route<dynamic> route) => false);
    //Navigator.of(context).popUntil(ModalRoute.withName('/root'));
  }


}
