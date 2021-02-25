import 'package:connect_four/common/theme_option.dart';
import 'package:connect_four/settings/bloc/bloc.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(LoadInProgress());

  static final _log = Logger('SettingsBloc');

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsLoading) {
      yield* _mapSettingsLoadingToState();
    } else if (event is ChooseTheme) {
      yield* _mapChooseThemeToState(event);
    } else if (event is SoundChange) {
      yield* _mapSoundChangeToState(event);
    } else if (event is LastMoveChange) {
      yield* _mapLastMoveChangeToState(event);
    } else if (event is ChooseLanguage) {
      yield* _mapChooseLanguageToState(event);
    }
  }

  Stream<SettingsState> _mapSettingsLoadingToState() async* {
    final SettingsOption options = await _getOptions();
    yield LoadSuccess(options: options);
  }

  Stream<SettingsState> _mapChooseLanguageToState(ChooseLanguage event) async* {
    if (state is LoadSuccess) {
      SettingsOption options = (state as LoadSuccess)
          .options
          .copyWith(language: event.language);
      yield LoadSuccess(options: options);
      _saveOptions(options);
    }
  }

  Stream<SettingsState> _mapChooseThemeToState(ChooseTheme event) async* {
    if (state is LoadSuccess) {
      SettingsOption options = (state as LoadSuccess)
          .options
          .copyWith(theme: _getTheme(event.option));
      yield LoadSuccess(options: options);
      _saveOptions(options);
    }
  }

  Stream<SettingsState> _mapSoundChangeToState(SoundChange event) async* {
    if (state is LoadSuccess) {
      SettingsOption options =
          (state as LoadSuccess).options.copyWith(soundOn: event.value);
      yield LoadSuccess(options: options);
      _saveOptions(options);
    }
  }

  Stream<SettingsState> _mapLastMoveChangeToState(LastMoveChange event) async* {
    if (state is LoadSuccess) {
      SettingsOption options =
          (state as LoadSuccess).options.copyWith(lastMove: event.value);
      yield LoadSuccess(options: options);
      _saveOptions(options);
    }
  }

  ThemeOption _getTheme(int index) => ThemeOption(
      index: index,
      theme: Constants.allThemes.firstWhere((p) => p.index == index).theme);

  Future<void> _saveOptions(SettingsOption options) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (options.theme != null)
        preferences.setInt('theme_option', options.theme.index);

      if (options.soundOn != null)
        preferences.setBool('sound_on', options.soundOn);

      if (options.language != null)
        preferences.setString('language', options.language);

      if (options.lastMove != null)
        preferences.setBool('last_move', options.lastMove);

      _log.info('Saving $options successfully');
    } catch (_) {
      throw Exception("Could not persist change");
    }
  }

  Future<SettingsOption> _getOptions() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return SettingsOption(
      theme: _getTheme(preferences.get('theme_option') ?? 1),
      soundOn: preferences.get('sound_on') ?? true,
      lastMove: preferences.get('last_move') ?? true,
      language: preferences.get('language'),
    );
  }
}

class SettingsOption {
  SettingsOption({this.theme, this.soundOn, this.lastMove, this.language});
  final ThemeOption theme;
  final bool soundOn;
  final bool lastMove;
  final String language;

  SettingsOption copyWith(
      {ThemeOption theme, bool soundOn, bool lastMove, String language}) {
    return SettingsOption(
        theme: theme ?? this.theme,
        soundOn: soundOn ?? this.soundOn,
        lastMove: lastMove ?? this.lastMove,
        language: language ?? this.language);
  }

  @override
  String toString() =>
      'SettingsOption: {theme: $theme, language: $language, soundOn: $soundOn, lastMove: $lastMove }';
}
