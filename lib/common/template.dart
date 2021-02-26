import 'package:connect_four/common/container_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Template extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final bool overscroll;

  Template({this.child, this.title = '', this.showBackButton = false, this.overscroll = true});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return ContainerWrapper(
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight, left: 10.0, right: 10.0),
          child: child,
        )
    );
  }

  Widget scaffold({Key key, bool withAppBar = true}) {
    return Scaffold(
      key: key,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: withAppBar ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: TextStyle(fontSize: 30.0)).tr(),
        centerTitle: true,
      ) : null,
      body: this,
    );
  }
}
