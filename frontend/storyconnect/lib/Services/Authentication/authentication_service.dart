import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  static const String SUCCESS = "Success";

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credential = await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      String idToken = await credential.user!.getIdToken(true) as String;

      String uid = this._firebaseAuth.currentUser!.uid;

      print(idToken.toString());

      http.put(Uri.parse("http://storyconnect.app/api/users/" + uid + "/"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token " + idToken
          });

=======

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
>>>>>>> develop
      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

<<<<<<< HEAD
=======
  ///
  /// Sign Up with the app with a standard email and password
  /// Returns an exception message or a success message.
>>>>>>> develop
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

<<<<<<< HEAD
=======
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
>>>>>>> develop
  Future<String?> signInAnon() async {
    try {
      await this._firebaseAuth.signInAnonymously();

      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
