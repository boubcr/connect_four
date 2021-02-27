import 'package:connect_four/auth/auth.dart';
import 'package:connect_four/common/display_timeline_tween.dart';
import 'package:connect_four/common/game_dialogs.dart';
import 'package:connect_four/common/loading_indicator.dart';
import 'package:connect_four/common/shaped_card.dart';
import 'package:connect_four/common/template.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:game_manager/game_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserDto player;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        player = state.user;
        return _buildContents();
      } else if (state is Unauthenticated)
        executeAfterBuild();
        //Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));

      return LoadingIndicator();
    });
  }

  Widget _buildContents() {
    TimelineTween<DisplayProps> _tween = DisplayTimelineTween.tweenOf(context);

    Widget photoWidget = Image.asset("assets/img/${Constants.DEFAULT_AVATAR}");
    if (player != null && player.hasPhoto)
      photoWidget = FadeInImage.assetNetwork(
        placeholder: "assets/img/${Constants.DEFAULT_AVATAR}",
        image: player.photoURL,
      );

    return Template(
        title: 'account.title',
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: PlayAnimation<TimelineValue<DisplayProps>>(
              tween: _tween,
              duration: _tween.duration,
              builder: (context, child, value) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Transform.translate(
                          offset: value.get(DisplayProps.offset1),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Constants.avatarRadius),
                                  width: double.infinity,
                                  child: ShapedCard(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: Constants.avatarRadius + 5.0,
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 5.0),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Text(player.displayName ?? 'No Name',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                          ListTile(
                                            leading: Icon(Icons.email),
                                            title: Text(player.email),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: Constants.padding,
                                  right: Constants.padding,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    radius: Constants.avatarRadius,
                                    child: CircleAvatar(
                                      radius: Constants.avatarRadius - 5.0,
                                      child: ClipRRect(
                                          child: photoWidget,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Constants.avatarRadius))),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: value.get(DisplayProps.offset2),
                          child: ShapedCard(
                            height: 140,
                            child: Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(10.0),
                                children: ListTile.divideTiles(
                                    context: context,
                                    tiles: [
                                      ListTile(
                                        leading: Icon(Icons.logout),
                                        title: Text('account.logout').tr(),
                                        onTap: _onLogout,
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('account.delete').tr(),
                                        onTap: _onDeleteAccount,
                                      )
                                    ]).toList(),
                              ),
                            ),
                          ),
                        ),
                        Text(player.hasMessage ? player.message : '', style: TextStyle(fontSize: 22, color: Colors.red), textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                );
              }),
        )).scaffold();
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(this.player);
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
    });
  }

  void _onLogout() {
    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
  }

  void _onDeleteAccount() {
    confirmDeleteDialog(context: context);
  }
}
