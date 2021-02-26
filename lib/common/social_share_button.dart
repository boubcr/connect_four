import 'package:connect_four/common/painted_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:share/share.dart';

class SocialShareButton extends StatelessWidget {
  SocialShareButton({Key key}) : super(key: key);
  static final _log = Logger('SocialShareButton');
  final String _text = 'https://medium.com/@suryadevsingh24032000';
  final String _subject = 'follow me';

  @override
  Widget build(BuildContext context) {
    return PaintedButton(
      label: 'share',
      icon: Icons.share,
      widthScale: .7,
      onPressed: () {
        _onShare(context);
      },
    );
  }

  void _onShare(BuildContext context) {
    _log.info('Text: $_text');
    _log.info('Subject: $_subject');

    final RenderBox box = context.findRenderObject();
    Share.share(_text,
        subject: _subject,
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) & box.size);
  }
}
