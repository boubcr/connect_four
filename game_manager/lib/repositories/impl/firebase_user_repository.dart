import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_manager/game_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logging/logging.dart';

class FirebaseUserRepository implements UserRepository {
  static final _log = Logger('FirebaseUserRepository');
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final GameRepository _gameRepository = FirebaseGameRepository(
      playerRepository: FirebasePlayerRepository(),
      moveRepository: FirebaseMoveRepository());
  final collection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      FacebookAuth facebookAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<UserDto> getUser() async {
    User user = _firebaseAuth.currentUser;
    _log.info('User: ${user.email}');
    if (user == null) return null;

    return UserDto(
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
        providerId: user.providerData[0].providerId);
  }

  @override
  Future<String> getUserId() async {
    return (_firebaseAuth.currentUser).uid;
  }

  @override
  Future<void> authenticate() {
    return _firebaseAuth.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn?.signOut(),
      _facebookAuth?.logOut(),
    ]);
  }

  @override
  Future<void> signUp({String username, String email, String password}) async {
    _log.info('Sign up with $email');
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      user.updateProfile(displayName: username);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _log.severe('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _log.severe('The account already exists for that email.');
      } else {
        _log.severe('Something Went Wrong.');
        _log.severe(e);
        return "Something Went Wrong.";
      }
    } catch (e) {
      _log.severe(e);
    }
  }

  @override
  Future<User> signInWithGoogle({AuthCredential pending}) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign the user in with the credential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      _log.info('Google sign in: ${_firebaseAuth.currentUser.email}');

      if (pending != null) {
        // Link the pending credential with the existing account
        await userCredential.user.linkWithCredential(pending);
      }

      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthExceptionHandler(e);
    } catch (e) {
      _log.severe('Unhandled exception');
      _log.severe(e);
      throw e;
    } finally {}
  }

  @override
  Future<User> signInWithFacebook({AuthCredential pending}) async {
    try {
      final AccessToken accessToken = await _facebookAuth.login();
      final FacebookAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.token,
      );

      // Sign the user in with the credential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      _log.info('Facebook sign in: ${_firebaseAuth.currentUser.email}');

      if (pending != null) {
        // Link the pending credential with the existing account
        await userCredential.user.linkWithCredential(pending);
      }

      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthExceptionHandler(e);
    } catch (e) {
      _log.severe('Unhandled exception');
      throw e;
    } finally {}
  }

  Future<User> firebaseAuthExceptionHandler(FirebaseAuthException e) async {
    _log.severe('Failed with error code: ${e.code}');
    if (e.code == 'account-exists-with-different-credential') {
      // The account already exists with a different credential
      String email = e.email;
      AuthCredential pendingCredential = e.credential;

      // Fetch a list of what sign-in methods exist for the conflicting user
      List<String> userSignInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      // If the user has several sign-in methods,
      // the first method in the list will be the "recommended" method to use.
      String firstProvider = userSignInMethods.first;
      switch (firstProvider) {
        case 'password':
          //TODO handle this case
          /*// Prompt the user to enter their password
          String password = '...';
          // Sign the user in to their account with the password
          UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
          */
          break;
        case 'facebook.com':
          return signInWithFacebook(pending: pendingCredential);
        case 'google.com':
          return signInWithGoogle(pending: pendingCredential);
        default:
          throw e;
      }
    }

    throw e;
  }

  @override
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> deleteUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      await _gameRepository.deleteUserGames(user.email);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _log.severe(
            'The user must reauthenticate before this operation can be executed.');
      }
      //throw e;
    } catch (e) {
      _log.severe(e);
      //throw e;
    }
  }

  /*
  @override
  Future<void> addUser() {
    return collection.doc(dto.userId).set(dto.toEntity().toDocument())
        .then((value) => print("Player Added"))
        .catchError((error) => print("Failed to add Player: $error"));
  }

  @override
  Future<void> deletePlayer(Player dto) async {
    return collection.doc(dto.userId)
        .delete()
        .then((value) => print("Player Deleted"))
        .catchError((error) => print("Failed to delete game: $error"));
  }
  */
}
