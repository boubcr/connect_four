import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:game_manager/game_manager.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  static final _log = Logger('RegisterBloc');
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.empty());

  /*
  @override
  Stream<RegisterState> transform(
      Stream<RegisterEvent> events,
      Stream<RegisterState> Function(RegisterEvent event) next,
      ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }
  */

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    _log.info('Changing email to $email');
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(Submitted event) async* {
    _log.info('Submitting $event');
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
          email: event.email,
          password: event.password,
          username: event.username);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
