import 'package:firebase_auth/firebase_auth.dart';

class SignUpService {
  // Firebase Authentication State Singleton
  late final FirebaseAuth _firebaseAuth;

  // Keeps the static single instance of the class
  static final SignUpService _instance = SignUpService._internal();

  // Creates the single instance of the Sign-In-Service
  SignUpService._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  // Success return message.
  final String success = "Success";

  // Getter for Firebase Authentication State
  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  /// Gets the Sign-In-Service Singleton
  factory SignUpService() {
    return _instance;
  }

  /// Sign In to the app with a standard email and password
  /// Returns an exception message or a success message.
  Future<String?> signUp(String email, String password) async {
    try {
      await this._firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return success;
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }
}
