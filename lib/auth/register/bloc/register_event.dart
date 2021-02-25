import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super();
}
/*
class UsernameChanged extends RegisterEvent {
  final String username;

  UsernameChanged({@required this.username}) : super([username]);

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'UsernameChanged { username :$username }';
}*/

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  Submitted({@required this.email, @required this.password, @required this.username})
      : super([email, password, username]);

  @override
  List<Object> get props => [email, password, username];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password, username: $username }';
  }
}