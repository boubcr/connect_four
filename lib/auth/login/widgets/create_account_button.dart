import 'package:connect_four/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('login.createAccount').tr(),
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.register);
      },
    );
  }
}
