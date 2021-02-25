abstract class SettingsEvent {}

class SettingsLoading extends SettingsEvent {}

class ChooseLanguage extends SettingsEvent {
  final String language;
  ChooseLanguage(this.language);

  @override
  String toString() => 'ChooseLanguage: {language: $language}';
}

class ChooseTheme extends SettingsEvent {
  final int option;
  ChooseTheme(this.option);

  @override
  String toString() => 'ChooseTheme: {option: $option}';
}

class SoundChange extends SettingsEvent {
  final bool value;
  SoundChange(this.value);

  @override
  String toString() => 'SoundChange: {value: $value}';
}

class LastMoveChange extends SettingsEvent {
  final bool value;
  LastMoveChange(this.value);

  @override
  String toString() => 'LastMoveChange: {value: $value}';
}
