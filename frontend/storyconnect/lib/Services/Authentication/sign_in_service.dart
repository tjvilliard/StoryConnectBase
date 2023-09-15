import 'package:firebase_auth/firebase_auth.dart';

/// Singleton Class encapsulating Firebase Sign-In Functionality
class SignInService {
  // Firebase Authentication State Singleton
  late final FirebaseAuth _firebaseAuth;

  // Keeps the static single instance of the class
  static final SignInService _instance = SignInService._internal();

  // Creates the single instance of the Sign-In-Service
  SignInService._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  // Success return message.
  final String SUCCESS = "Success";

  // Getter for Firebase Authentication State
  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  /// Gets the Sign-In-Service Singleton
  factory SignInService() {
    return _instance;
  }

  /// Sign In to the app with a standard email and password
  /// Returns an exception message or a success message.
  Future<String?> signIn(String email, String password) async {
    try {
      await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return SUCCESS;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }
}
