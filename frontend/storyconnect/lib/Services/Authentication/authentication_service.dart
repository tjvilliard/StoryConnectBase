import 'package:firebase_auth/firebase_auth.dart';

/// Wrapper singleton for the firebase authentication singleton
/// and the Functions that go with it.
class AuthenticationService {
  // Firebase Authentication State Singleton
  late final FirebaseAuth _firebaseAuth;

  // The Static single instance of the class.
  static final AuthenticationService _instance =
      AuthenticationService._internal();

  // Success return message.
  static const String SUCCESS = "Success";

  // Getter for firebase authentication state
  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  ///
  /// Sign In to the app with a standard email and password
  /// Returns an exception message or a success message.
  Future<String?> signIn(String email, String password) async {
    try {
      await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  ///
  /// Sign Up with the app with a standard email and password
  /// Returns an exception message or a success message.
  Future<String?> signUp(String email, String password) async {
    try {
      await this
          ._firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  ///
  /// Sign Out of the app
  /// Returns an exception message or a success message.
  Future<String?> signOut() async {
    try {
      this._firebaseAuth.signOut();
      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  ///
  /// Anonymous sign-in, for administrators only.
  Future<String?> signInAnon() async {
    try {
      await this._firebaseAuth.signInAnonymously();

      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
