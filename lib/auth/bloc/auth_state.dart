import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:game_manager/game_manager.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super();
}

class Uninitialized extends AuthState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthState {
  final UserDto user;

  Authenticated(this.user) : super([user]);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthState {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Unauthenticated';
}