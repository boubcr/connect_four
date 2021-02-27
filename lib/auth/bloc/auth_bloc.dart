import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:game_manager/game_manager.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class AuthBloc
    extends Bloc<AuthEvent, AuthState> {
  static final _log = Logger('AuthBloc');
  final UserRepository userRepository;

  AuthBloc({@required this.userRepository})
      : super(Uninitialized()) {
      //: super(Unauthenticated()) {
    assert(userRepository != null);
  }

  /*
  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        userRepository = userRepository;
  */

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is DeleteAccount) {
      yield* _mapDeleteAccountToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await userRepository.isAuthenticated();
      _log.info('isSignedIn: $isSignedIn');
      if (isSignedIn) {
        final UserDto user = await userRepository.getUser();
        _log.info('user: $user');
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield Authenticated(await userRepository.getUser());
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    userRepository.signOut();
  }

  Stream<AuthState> _mapDeleteAccountToState() async* {
    UserDto userDto = await userRepository.deleteUser();
    print("_mapDeleteAccountToState");
    print(userDto);
    if (userDto.message == "SUCCESS") yield Unauthenticated();
    else yield Authenticated(userDto);
  }
}
