import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_manager/models/models.dart';

abstract class UserRepository {
  Future<bool> isAuthenticated();

  Future<void> authenticate();

  Future<void> signUp({String username, String email, String password});

  Future<void> signOut();

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<void> signInWithCredentials(String email, String password);

  Future<String> getUserId();

  Future<UserDto> getUser();

  //Future<void> addUser();

  Future<void> deleteUser();
}
