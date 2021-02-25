import 'package:connect_four/settings/bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class LoadInProgress extends SettingsState {}

class LoadSuccess extends SettingsState {
  final SettingsOption options;
  LoadSuccess({this.options}) : super();

  @override
  List<Object> get props => [options];

  @override
  String toString() {
    return 'LoadSuccess { options: $options }';
  }
}
