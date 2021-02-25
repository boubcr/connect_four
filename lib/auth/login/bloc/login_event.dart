import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super();
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({@required this.email}) : super([email]);

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'LoginEmailChanged { email :$email }';
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({@required this.password}) : super([password]);

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'LoginPasswordChanged { password: $password }';
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginSubmitted { email: $email, password: $password }';
  }
}

class LoginWithGooglePressed extends LoginEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginWithGooglePressed';
}

class LoginWithFacebookPressed extends LoginEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginWithFacebookPressed';
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({@required this.email, @required this.password})
      : super([email, password]);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}