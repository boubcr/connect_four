import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super();
}

class AppStarted extends AuthEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggedOut';
}

class DeleteAccount extends AuthEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DeleteAccount';
}