import 'package:connect_four/common/display_timeline_tween.dart';
import 'package:connect_four/common/loading_indicator.dart';
import 'package:connect_four/common/shaped_card.dart';
import 'package:connect_four/common/template.dart';
import 'package:connect_four/common/game_dialogs.dart';
import 'package:connect_four/settings/bloc/bloc.dart';
import 'package:connect_four/utils/routes.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:logging/logging.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsHome extends StatefulWidget {
  const SettingsHome({Key key}) : super(key: key);

  @override
  _SettingsHomeState createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  static final _log = Logger('SettingsHome');

  SettingsOption options;
  YYDialog _themeDialog;
  YYDialog _languageDialog;

  @override
  Widget build(BuildContext context) {
    //YYDialog.init(context);
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is LoadSuccess) {
        options = state.options;
        _log.info(options);
        return _buildContents();
      }

      return LoadingIndicator();
    });
  }

  Widget _buildContents() {
    TimelineTween<DisplayProps> _tween = DisplayTimelineTween.tweenOf(context);

    return Template(
        title: 'settings.title',
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: PlayAnimation<TimelineValue<DisplayProps>>(
              tween: _tween,
              duration: _tween.duration,
              builder: (context, child, value) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Transform.translate(
                          offset: value.get(DisplayProps.offset1),
                          child: ShapedCard(
                            height: 80,
                            child: ListTile(
                              leading: Icon(Icons.wb_sunny),
                              title: _buildText('settings.theme'),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Theme.of(context).primaryColor),
                              onTap: _openThemeDialog,
                            ),
                          )),
                      Transform.translate(
                          offset: value.get(DisplayProps.offset2),
                          child: ShapedCard(
                            child: ListTile(
                              title: _buildText('settings.highlight'),
                              leading: Icon(Icons.highlight),
                              trailing: Icon(
                                  options.lastMove
                                      ? Icons.check_circle
                                      : Icons.radio_button_off_rounded,
                                  color: Theme.of(context).primaryColor),
                              onTap: _onHighlightLastMoveChange,
                            ),
                          )),
                      Transform.translate(
                          offset: value.get(DisplayProps.offset3),
                          child: ShapedCard(
                            child: ListTile(
                              title: _buildText('settings.sounds'),
                              leading: Icon(Icons.volume_up),
                              trailing: Icon(
                                  options.soundOn
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: Theme.of(context).primaryColor),
                              onTap: _onTurnOnSoundChange,
                            ),
                          )),
                      Transform.translate(
                          offset: value.get(DisplayProps.offset4),
                          child: ShapedCard(
                            child: ListTile(
                              title: _buildText('settings.lang'),
                              leading: Icon(Icons.language),
                              trailing: Container(
                                //color: Colors.red,
                                width: 60,
                                child: Row(
                                  children: [
                                    Utility.countryIcon(context
                                        .locale.countryCode
                                        .toLowerCase()),
                                    SizedBox(width: 10.0),
                                    Icon(Icons.keyboard_arrow_right,
                                        color: Theme.of(context).primaryColor)
                                  ],
                                ),
                              ),
                              onTap: _openLanguagePicker,
                            ),
                          )),
                      Transform.translate(
                          offset: value.get(DisplayProps.offset5),
                          child: ShapedCard(
                            child: ListTile(
                              title: _buildText('account.title'),
                              leading: Icon(Icons.account_box),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Theme.of(context).primaryColor),
                              onTap: _openAccountScreen,
                            ),
                          )),
                    ]);
              }),
        )).scaffold();
  }

  Widget _buildText(String text) {
    return Text(text, style: TextStyle(fontSize: 18)).tr();
  }

  void _openLanguagePicker() {
    languageDialog(
        context: context,
        selected: options.language,
        onSave: _onLanguageChange);
  }

  void _onLanguageChange(String language) {
    //_languageDialog?.dismiss();
    _log.info('Language changed to $language');
    EasyLocalization.of(context).deleteSaveLocale();
    context.locale = Utility.getLocale(context, language);
    //EasyLocalization.of(context).locale = Utility.getLocale(context, language);
    BlocProvider.of<SettingsBloc>(context).add(ChooseLanguage(language));
  }

  void _openAccountScreen() {
    Navigator.pushNamed(context, AppRoutes.account);
  }

  void _openThemeDialog() {
    _themeDialog = themeDialog(
        context: context,
        selectedIndex: options.theme.index,
        onSave: _onThemeChange);
  }

  void _onThemeChange(int value) {
    _themeDialog?.dismiss();
    BlocProvider.of<SettingsBloc>(context).add(ChooseTheme(value));
  }

  void _onHighlightLastMoveChange() {
    BlocProvider.of<SettingsBloc>(context)
        .add(LastMoveChange(!options.lastMove));
  }

  void _onTurnOnSoundChange() {
    BlocProvider.of<SettingsBloc>(context).add(SoundChange(!options.soundOn));
  }
}
